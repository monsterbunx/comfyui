#!/bin/bash

# preparando comfyui
. <(curl -fsSL https://monsterbunx.github.io/comfyui/comfy.sh)

# pytorch
. <(curl -fsSL https://monsterbunx.github.io/comfyui/pytorch.sh)

# Dependencias de ComfyUI
. <(curl -fsSL https://monsterbunx.github.io/comfyui/depen.sh)

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

# Ejecutar en screen
screen -dmS comfyui bash -c "
    ./run_comfy.sh;
"

# Esperar un momento para que screen inicie
sleep 3

# Mostrar información de la sesión screen
./info_screen.sh