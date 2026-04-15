#!/bin/bash

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
