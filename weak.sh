#!/bin/bash
# =============================================
# Script para configurar ComfyUI-Manager (config.ini)
# Cambios solicitados: security_level=weak, network_mode=personal_cloud, verbose=True
# =============================================

CONFIG_FILE="/scripts/comfyui/user/__manager/config.ini"

echo "=== Configurando ComfyUI-Manager ==="
echo "Archivo: $CONFIG_FILE"

# Backup por si algo sale mal
cp "$CONFIG_FILE" "$CONFIG_FILE.bak.$(date +%Y%m%d_%H%M%S)"
echo "Backup creado: $CONFIG_FILE.bak.*"

# Aplicar cambios con sed (uno por línea)
sed -i 's/^security_level\s*=.*/security_level = weak/' "$CONFIG_FILE"
sed -i 's/^network_mode\s*=.*/network_mode = personal_cloud/' "$CONFIG_FILE"
sed -i 's/^verbose\s*=.*/verbose = True/' "$CONFIG_FILE"

# Si alguna clave no existía, la agregamos al final
grep -q "^security_level" "$CONFIG_FILE" || echo "security_level = weak" >> "$CONFIG_FILE"
grep -q "^network_mode" "$CONFIG_FILE" || echo "network_mode = personal_cloud" >> "$CONFIG_FILE"
grep -q "^verbose" "$CONFIG_FILE" || echo "verbose = True" >> "$CONFIG_FILE"

echo ""
echo "✅ Cambios aplicados correctamente:"
echo "   • security_level   → weak"
echo "   • network_mode     → personal_cloud"
echo "   • verbose          → True"
echo ""
echo "Contenido actual del config.ini:"
echo "--------------------------------"
cat "$CONFIG_FILE"
echo "--------------------------------"

echo ""
echo "Ahora reinicia ComfyUI para que los cambios surtan efecto:"
echo "   screen -S comfyui -X quit"
echo "   # Luego vuelve a ejecutar tu script de inicio o el comando manual"