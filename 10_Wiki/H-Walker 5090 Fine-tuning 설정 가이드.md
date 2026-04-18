# RTX 5090 Fine-tuning 완전 가이드

## 개요
학교 서버 RTX 5090(32GB VRAM)에서 H-Walker 특화 Gemma LoRA를 학습.
학습 완료된 모델을 Mac의 Ollama에 배포하여 graph_app에서 사용.

---

## 🖥 사전 요구사항

### 5090 서버 쪽
- Ubuntu 20.04+ / CUDA 12.1+ / NVIDIA Driver 535+
- Python 3.11
- Conda 또는 Mamba 설치
- SSH 접속 가능
- 디스크 공간 50GB+ (base model 8GB + 학습 중간 데이터 + GGUF)

### Mac 쪽
- Ollama 설치됨
- `~/.hw_graph/` 디렉토리 존재
- 2단계에서 생성한 데이터셋 (`dataset.jsonl`)

---

## 🔧 5090 서버 초기 설정 (최초 1회)

### 1. Conda 환경
```bash
# On 5090 server
conda create -n hwalker-ft python=3.11 -y
conda activate hwalker-ft
```

### 2. Unsloth + PyTorch 설치
```bash
# CUDA 12.1 기준
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121

# Unsloth (2x 빠른 LoRA 학습)
pip install "unsloth[cu121] @ git+https://github.com/unslothai/unsloth.git"

# 추가 의존성
pip install --no-deps trl peft accelerate bitsandbytes
pip install datasets pyyaml

# GGUF 변환용
pip install llama-cpp-python  # optional, Unsloth가 대체 제공
```

### 3. 기본 모델 캐시 확인
```bash
# 첫 실행 시 HF에서 자동 다운로드 (~8GB)
python -c "from unsloth import FastModel; \
FastModel.from_pretrained('unsloth/gemma-3-4b-it', max_seq_length=2048, load_in_4bit=True)"
```

### 4. Ollama 설치 (학습 후 GGUF 테스트용, optional)
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

---

## 📦 데이터 전송 (Mac → 5090)

```bash
# Mac 쪽
SERVER=user@school-5090-server.ac.kr

# 데이터셋 생성 (Mac에서 이미 했다면 스킵)
cd /Users/chobyeongjun/h-walker-ws/tools/llm_training
python3 scripts/augment.py --n-per-seed 15 --limit 100
python3 scripts/build_dataset.py \
    --synthetic ~/.hw_graph/training/datasets/synthetic.jsonl

# 5090로 전송
ssh $SERVER "mkdir -p ~/hwalker-training"
scp -r ~/.hw_graph/training/datasets/ $SERVER:~/hwalker-training/
scp -r /Users/chobyeongjun/h-walker-ws/tools/llm_training/scripts/ $SERVER:~/hwalker-training/
```

---

## 🏋️ 학습 실행 (5090)

```bash
# SSH into 5090
ssh user@school-5090-server.ac.kr
cd ~/hwalker-training
conda activate hwalker-ft

# 학습 시작
python scripts/lora_train.py \
    --dataset ~/hwalker-training/datasets/dataset.jsonl \
    --val-dataset ~/hwalker-training/datasets/val.jsonl \
    --output ~/hwalker-training/checkpoints/gemma4-hwalker-v1 \
    --epochs 3 \
    --batch-size 4 \
    --grad-accum 4 \
    --lr 2e-4 \
    --lora-r 16

# 예상 소요 시간 (2000 samples, 3 epochs):
#   5090: ~2-3시간
#   VRAM: ~14-18GB (4bit + gradient checkpointing)
```

### 학습 중 모니터링
```bash
# 별도 터미널에서
watch -n 2 nvidia-smi

# 로그 확인
tail -f ~/hwalker-training/checkpoints/gemma4-hwalker-v1/trainer_state.json
```

---

## 🚀 GGUF 변환 + Ollama 배포

### 5090 서버에서
```bash
python scripts/convert_to_ollama.py \
    --lora-dir ~/hwalker-training/checkpoints/gemma4-hwalker-v1 \
    --model-name gemma4-hwalker \
    --quant Q4_K_M

# 결과:
#   ~/hwalker-training/models/gemma4-hwalker.Q4_K_M.gguf  (~2.5GB)
#   Ollama에 등록됨 (5090에서만 사용 가능)
```

### Mac으로 가져오기
```bash
# Mac 쪽
SERVER=user@school-5090-server.ac.kr

# GGUF 다운로드
mkdir -p ~/.hw_graph/training/models
scp $SERVER:~/hwalker-training/models/gemma4-hwalker.Q4_K_M.gguf \
    ~/.hw_graph/training/models/

# Modelfile 생성
cat > /tmp/Modelfile <<EOF
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

# Mac Ollama에 등록
ollama create gemma4-hwalker -f /tmp/Modelfile

# 테스트
ollama run gemma4-hwalker "Force 그래프 보여줘"
```

---

## 📊 학습 전후 비교 (Mac)

```bash
cd /Users/chobyeongjun/h-walker-ws/tools/llm_training
python3 scripts/compare_models.py \
    --baseline gemma4:e4b \
    --finetuned gemma4-hwalker:latest

# 기대 결과:
#   baseline accuracy:     ~92%
#   finetuned accuracy:    ~98%+
#   improved cases:        많음 (특히 애매한 케이스)
#   regressed cases:       거의 없음 (학습 데이터 커버)
```

---

## 🔄 graph_app에서 새 모델 사용

```bash
# .env 파일 또는 실행 시
export OLLAMA_MODEL=gemma4-hwalker
cd /Users/chobyeongjun/h-walker-ws/tools/graph_app
python3 run.py
```

또는 `~/.hw_graph/config.env`에 영구 저장:
```bash
echo "OLLAMA_MODEL=gemma4-hwalker" >> ~/.hw_graph/config.env
```

---

## 🔁 정기 재학습 파이프라인 (월 1회)

사용자가 계속 피드백 남기면 3~6개월 후 더 큰 데이터셋으로 재학습:

```bash
# Mac: 1. 최신 피드백 포함 데이터 생성
python3 scripts/augment.py --n-per-seed 20
python3 scripts/build_dataset.py

# 2. 5090로 전송 + 학습 (이전 LoRA 위에 계속)
ssh $SERVER
cd ~/hwalker-training
python scripts/lora_train.py \
    --base-model ./checkpoints/gemma4-hwalker-v1 \
    --output ./checkpoints/gemma4-hwalker-v2 \
    --epochs 2  # 짧게

# 3. 배포 + 비교
# (위 단계 반복)
```

---

## ⚠️ 문제 해결

### OOM 에러 (VRAM 부족)
```bash
# batch_size 줄이기
python scripts/lora_train.py --batch-size 2 --grad-accum 8
```

### 학습 loss 수렴 안 함
- lr 낮추기: `--lr 1e-4`
- epoch 늘리기: `--epochs 5`
- 데이터 더 많이: `augment.py --n-per-seed 20`

### GGUF 변환 실패
- `pip install --upgrade llama-cpp-python`
- 또는 `llama.cpp` repo 직접 클론해서 `convert_hf_to_gguf.py` 사용

### Ollama 로드 실패
- GGUF 파일 크기 확인 (1GB 미만이면 변환 실패)
- Modelfile 템플릿 확인 (Gemma 포맷 맞는지)

---

## 📈 성공 지표

- ✅ 학습 train loss < 0.5 (3 epoch 기준)
- ✅ Val accuracy > train accuracy (오버핏 아님)
- ✅ 비교 eval에서 accuracy +5%p 이상 상승
- ✅ Regressed 케이스 < improved 케이스의 20%
- ✅ 응답 시간 동일 또는 더 빠름 (양자화 덕분)
