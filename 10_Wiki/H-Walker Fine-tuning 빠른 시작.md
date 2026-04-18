# H-Walker Fine-tuning 빠른 시작

## 🎯 목표
Gemma4-e4b를 H-Walker 특화 모델로 만들기. 목표 정확도: 92% → 98%+

## ⏱ 예상 시간

| 단계 | 시간 | 장소 |
|---|---|---|
| 데이터 증강 | 2~4시간 | Mac |
| 5090 설정 (최초) | 30분 | 5090 |
| 데이터 전송 | 5분 | Mac→5090 |
| LoRA 학습 | 2~4시간 | 5090 |
| GGUF 변환 | 30분 | 5090 |
| 배포 | 10분 | 5090→Mac |
| 평가 | 30분 | Mac |
| **총계** | **~10시간** (대부분 자동) | |

## 🚀 원클릭 실행 (Mac 쪽)

```bash
cd /Users/chobyeongjun/h-walker-ws/tools/llm_training

# [1] 합성 데이터 생성 (오래 걸림, 백그라운드 돌려도 됨)
python3 scripts/augment.py --n-per-strategy 8
# → 100 seeds × 8 strategies × 8 vars = ~6000 samples 기대

# [2] 최종 데이터셋 빌드
python3 scripts/build_dataset.py \
    --synthetic ~/.hw_graph/training/datasets/synthetic.jsonl

# [3] 5090로 전송 (SSH 정보 입력)
./scripts/sync_to_5090.sh user@5090-host
```

## 🏋️ 5090에서 학습 (SSH 접속 후)

```bash
ssh user@5090-host
cd ~/hwalker-training
conda activate hwalker-ft  # 첫 실행이면 docs/5090-SETUP.md의 설치 단계 먼저

# 학습 실행
python scripts/lora_train.py \
    --dataset ~/hwalker-training/datasets/dataset.jsonl \
    --val-dataset ~/hwalker-training/datasets/val.jsonl \
    --output ~/hwalker-training/checkpoints/gemma4-hwalker-v1 \
    --epochs 3

# GGUF 변환
python scripts/convert_to_ollama.py \
    --lora-dir ~/hwalker-training/checkpoints/gemma4-hwalker-v1 \
    --quant Q4_K_M
```

## 📥 Mac에 배포

```bash
# GGUF 가져오기
scp 5090-host:~/hwalker-training/models/*.gguf ~/.hw_graph/training/models/

# Ollama 등록
cat > /tmp/Modelfile <<EOF
FROM $HOME/.hw_graph/training/models/gemma4-hwalker.Q4_K_M.gguf
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
```

## 📊 비교 평가

```bash
python3 scripts/compare_models.py
# 기대: baseline 88% → finetuned 95%+
```

## 🔄 graph_app에서 사용

```bash
export OLLAMA_MODEL=gemma4-hwalker
cd ../graph_app
python3 run.py
```
