# Monitorar Uso de CPU e RAM

# Definir limites de alerta
LIMITE_CPU=80   # Porcentagem de uso da CPU para alerta
LIMITE_RAM=90   # Porcentagem de uso da RAM para alerta

# Obtém uso de CPU e RAM
USO_CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d. -f1)
USO_RAM=$(free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}')

# Verifica se o uso de CPU ultrapassou o limite
if [ "$USO_CPU" -gt "$LIMITE_CPU" ]; then
    MESSAGE="⚠️ *ALERTA: CPU Alta*\nUso: ${USO_CPU}% 🚀"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
         -d "chat_id=$CHAT_ID" \
         -d "text=$MESSAGE" \
         -d "parse_mode=MarkdownV2"
fi

# Verifica se o uso de RAM ultrapassou o limite
if [ "$USO_RAM" -gt "$LIMITE_RAM" ]; then
    MESSAGE="⚠️ *ALERTA: RAM Alta*\nUso: ${USO_RAM}% 🖥️"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
         -d "chat_id=$CHAT_ID" \
         -d "text=$MESSAGE" \
         -d "parse_mode=MarkdownV2"
fi
