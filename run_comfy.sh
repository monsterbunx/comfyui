#!/bin/bash

echo 'ComfyUI iniciando en screen sesión: comfyui'

source venv/bin/activate

python3 main.py --enable-manager --enable-manager-legacy-ui --listen 0.0.0.0 --port 8388 --normalvram

echo 'Presiona Ctrl+C para detener'
read -p 'Presiona Enter para salir...'