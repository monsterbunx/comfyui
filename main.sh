#!/bin/bash

# Script para instalar y ejecutar ComfyUI con screen

echo "======================================="
echo "  Instalando y configurando ComfyUI"
echo "======================================="

# Ir al directorio de scripts
cd /scripts || { echo "Error: No se puede acceder a /scripts"; exit 1; }

# Clonar ComfyUI si no existe
if [ ! -d "comfyui" ]; then
    echo "Clonando ComfyUI..."
    git clone https://github.com/Comfy-Org/ComfyUI comfyui
else
    echo "ComfyUI ya existe, actualizando..."
    cd comfyui
    git pull
    cd ..
fi

# Entrar en directorio comfyui
cd comfyui || { echo "Error: No se puede acceder a comfyui"; exit 1; }

# Clonar Repo de comfyui-manager
cd custom_nodes/
git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager
cd ..

# Crear entorno virtual si no existe
if [ ! -d "venv" ]; then
    echo "Creando entorno virtual..."
    python3.12 -m venv venv
else
    echo "Entorno virtual ya existe"
fi

# Activar entorno virtual
echo "Activando entorno virtual..."
source venv/bin/activate

# Actualizar pip y uv dentro del venv
echo "Actualizando pip..."
python3 -m pip install --upgrade pip
#pip install uv

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

# Instalar dependencias de ComfyUI
echo "Instalando dependencias de ComfyUI..."
uv pip install -r requirements.txt

echo "Instalando dependencias de ComfyUI-Manager"
uv pip install -r manager_requirements.txt

echo "Instalando dependencias de ComfyUI-Manager"
uv pip install -r custom_nodes/comfyui-manager/requirements.txt

. <(curl -fsSL https://monsterbunx.github.io/comfyui/weak.sh)

# Ejecutar en screen
echo "======================================="
echo "  Iniciando ComfyUI en screen..."
echo "======================================="
echo "La interfaz estará disponible en:"
echo "  http://localhost:8388"
echo "  http://$(hostname -I | awk '{print $1}'):8388"
echo ""
echo "Para acceder a la sesión screen:"
echo "  screen -r comfyui"
echo "Para salir de screen (dejando corriendo): Ctrl+A luego D"
echo "======================================="

# Crear script de ejecución temporal
cat > run_comfyui.sh << 'EOF'
#!/bin/bash
source venv/bin/activate
python3 main.py --enable-manager --listen 0.0.0.0 --port 8388 --normalvram
EOF

chmod +x run_comfyui.sh

# Ejecutar en screen
screen -dmS comfyui bash -c "
    echo 'ComfyUI iniciando en screen sesión: comfyui';
    source venv/bin/activate;
    python3 main.py --enable-manager --listen 0.0.0.0 --port 8388 --normalvram;
    echo 'Presiona Ctrl+C para detener';
    read -p 'Presiona Enter para salir...'
"

# Esperar un momento para que screen inicie
sleep 3

# Mostrar información de la sesión screen
echo ""
echo "Sesiones screen activas:"
screen -ls

echo ""
echo "Para ver los logs en tiempo real:"
echo "  screen -r comfyui"
echo ""
echo "Para detener ComfyUI:"
echo "  1. screen -r comfyui"
echo "  2. Presionar Ctrl+C en la sesión"
echo "  3. Ctrl+A luego D para salir de screen"
echo ""
echo "Script completado! 🚀"
