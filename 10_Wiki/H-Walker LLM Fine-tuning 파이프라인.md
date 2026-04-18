# H-Walker LLM Fine-tuning Pipeline

RTX 5090을 활용한 Gemma4 특화 학습 시스템.
피드백과 테스트 케이스를 데이터로 → LoRA 학습 → Ollama 배포.

## 🎯 목적

- Base `gemma4:e4b` → 특화된 `gemma4-hwalker:latest`
- H-Walker CSV 분석 요청을 더 정확하고 빠르게 파싱
- 목표 정확도: baseline 92% → 98%+

## 🗂 구조

```
tools/llm_training/
├── scripts/
│   ├── build_dataset.py      # seeds + feedback → JSONL
│   ├── augment.py            # Gemma4로 질의 변형 생성
│   ├── lora_train.py         # 5090에서 LoRA 학습
│   ├── convert_to_ollama.py  # LoRA → GGUF → Ollama
│   └── compare_models.py     # baseline vs finetuned eval
├── configs/
├── data/
└── docs/
    └── 5090-SETUP.md          # 서버 설정 전체 가이드

Related (외부):
~/.hw_graph/training/
├── datasets/
│   ├── dataset.jsonl          # 학습 데이터 (Mac에서 생성)
│   ├── val.jsonl
│   └── synthetic.jsonl        # Gemma4로 합성된 변형
├── checkpoints/              # LoRA 학습 결과 (5090에서)
└── models/                   # GGUF 파일 (배포용)
```

## 🚀 전체 파이프라인

### 단계 1: Mac에서 데이터 준비 (30분)
```bash
cd tools/llm_training

# A. 테스트 케이스 + 피드백 → JSONL (빠름)
python3 scripts/build_dataset.py
# → ~/.hw_graph/training/datasets/dataset.jsonl (~100 samples)

# B. 합성 데이터 증강 (Gemma4 사용, 시간 걸림)
python3 scripts/augment.py --n-per-seed 15
# → ~/.hw_graph/training/datasets/synthetic.jsonl (~1000-1500 samples)

# C. 최종 데이터셋 재빌드 (합성 포함)
python3 scripts/build_dataset.py \
    --synthetic ~/.hw_graph/training/datasets/synthetic.jsonl
# → dataset.jsonl (~1500-2000 samples), val.jsonl (~150)
```

### 단계 2: 5090로 전송 (5분)
```bash
SERVER=user@5090-server.ac.kr
ssh $SERVER "mkdir -p ~/hwalker-training"
scp -r ~/.hw_graph/training/datasets/ $SERVER:~/hwalker-training/
scp -r scripts/ $SERVER:~/hwalker-training/
```

### 단계 3: 5090에서 학습 (2-4시간)
```bash
# SSH into 5090
ssh $SERVER
cd ~/hwalker-training

# 첫 설치 (최초 1회만, docs/5090-SETUP.md 참조)
conda activate hwalker-ft

# 학습 시작
python scripts/lora_train.py \
    --dataset ~/hwalker-training/datasets/dataset.jsonl \
    --val-dataset ~/hwalker-training/datasets/val.jsonl \
    --output ~/hwalker-training/checkpoints/gemma4-hwalker-v1 \
    --epochs 3
# VRAM ~18GB, 시간 2-4h on 5090
```

### 단계 4: GGUF 변환 (30분)
```bash
# 5090에서 계속
python scripts/convert_to_ollama.py \
    --lora-dir ~/hwalker-training/checkpoints/gemma4-hwalker-v1 \
    --model-name gemma4-hwalker \
    --quant Q4_K_M
# → ~/hwalker-training/models/gemma4-hwalker.Q4_K_M.gguf (~2.5GB)
```

### 단계 5: Mac에 배포 (10분)
```bash
# Mac 쪽
mkdir -p ~/.hw_graph/training/models
scp $SERVER:~/hwalker-training/models/*.gguf ~/.hw_graph/training/models/

# Modelfile + Ollama 등록
cat > /tmp/Modelfile <<'EOF'
FROM ~/.hw_graph/training/models/gemma4-hwalker.Q4_K_M.gguf
TEMPLATE """<start_of_turn>user
{{ if .System }}{{ .System }}

{{ end }}{{ .Prompt }}<end_of_turn>
<start_of_turn>model
{{ .Response }}<end_of_turn>
"""
PARAMETER temperature 0
PARAMETER num_ctx 4096
PARAMETER stop "<end_of_turn>"
EOF
ollama create gemma4-hwalker -f /tmp/Modelfile

# 테스트
ollama run gemma4-hwalker "Force 그래프 보여줘"
```

### 단계 6: 비교 평가 (30분)
```bash
cd tools/llm_training
python3 scripts/compare_models.py \
    --baseline gemma4:e4b \
    --finetuned gemma4-hwalker:latest
# 출력: accuracy delta, latency delta, improved/regressed cases
```

### 단계 7: graph_app에서 새 모델 사용
```bash
# 환경변수 설정 후 재시작
export OLLAMA_MODEL=gemma4-hwalker
cd tools/graph_app
python3 run.py
```

## 🔁 정기 재학습 (월 1회)

실사용 중 쌓인 피드백을 반영하여 모델 업데이트:
```bash
# 1. 새 데이터 빌드 (feedback 자동 포함)
python3 scripts/build_dataset.py
python3 scripts/augment.py --n-per-seed 20

# 2. 이전 체크포인트 위에 계속 학습
python scripts/lora_train.py \
    --base-model ./checkpoints/gemma4-hwalker-v1 \
    --output ./checkpoints/gemma4-hwalker-v2 \
    --epochs 2

# 3-6단계 동일
```

## 📊 성공 지표

| 지표 | Baseline | Target |
|---|---|---|
| 정확도 (전체) | 92% | 98%+ |
| Ambiguous 처리 | 100% (in-context) | 100% (고정) |
| 응답 시간 | 14s | 5s (양자화 덕분) |
| 모델 크기 | 3.5GB | 2.5GB (Q4 양자화) |

## 🛠 트러블슈팅
`docs/5090-SETUP.md` 참조
