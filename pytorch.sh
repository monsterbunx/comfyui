#!/bin/bash

# Instalar PyTorch
cuda121() {
echo "Instalando PyTorch con CUDA 12.1..."
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
}
cuda128() {
echo "Instalando PyTorch con CUDA 12.8..."
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
}

GPU_RAW=$(nvidia-smi | sed -nr '/\|[[:space:]]*[0-9]+[[:space:]]+NVIDIA/{s/.*[[:space:]]+(NVIDIA[^|]+)[[:space:]]+(On|Off).*/\1/p; q}')
GPU=$(echo "$GPU_RAW" | sed 's/[[:space:]]*$//')

echo "GPU detectada: '$GPU'"

case "$GPU" in
    "NVIDIA RTX A4000")
        cuda128
        ;;
    "NVIDIA GeForce GTX 1070")
        cuda121
        ;;
    "NVIDIA GeForce RTX 3070")
        cuda128
        ;;
    *)
        echo "Es otra tarjeta: '$GPU'";
        cuda128;
        ;;
esac


# Verificar instalación de PyTorch
echo "Verificando PyTorch..."
python3 -c "
import torch
print('='*50)
print(f'✓ Torch version: {torch.__version__}')
print(f'✓ CUDA disponible: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'✓ Versión CUDA: {torch.version.cuda}')
    print(f'✓ GPU: {torch.cuda.get_device_name(0)}')
    print(f'✓ VRAM total: {torch.cuda.get_device_properties(0).total_memory / 1024**3:.1f} GB')
print('='*50)
"