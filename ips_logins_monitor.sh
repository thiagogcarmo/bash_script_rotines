#!/bin/bash

#Monitorar Mudança de IP
# Pega as credenciais das variáveis de ambiente
BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
CHAT_ID="$TELEGRAM_CHAT_ID"
IP_FILE="/tmp/ultimo_ip.txt"

# Obtém o IP externo
IP_ATUAL=$(curl -s ifconfig.me)

# Verifica se o arquivo existe e lê o IP salvo
if [ -f "$IP_FILE" ]; then
    IP_ANTIGO=$(cat "$IP_FILE")
else
    IP_ANTIGO=""
fi

# Se o IP mudou, atualiza o arquivo e envia notificação
if [ "$IP_ATUAL" != "$IP_ANTIGO" ]; then
    echo "$IP_ATUAL" > "$IP_FILE"
    MESSAGE="📡 *IP do Servidor Alterado*:\nNovo IP: \`$IP_ATUAL\`"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
         -d "chat_id=$CHAT_ID" \
         -d "text=$MESSAGE" \
         -d "parse_mode=MarkdownV2"
fi
