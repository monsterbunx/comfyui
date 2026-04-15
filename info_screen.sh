#!/bin/bash

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