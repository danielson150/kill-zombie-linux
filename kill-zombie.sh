#!/bin/bash

# Exibe todos os processos zumbis
echo "Procurando processos zumbis..."

# Lista os PPIDs dos processos zumbis
zombies=$(ps -eo stat,ppid | awk '$1 == "Z" {print $2}' | sort -u)

# Verifica se encontrou algum processo zumbi
if [ -z "$zombies" ]; then
    echo "Nenhum processo zumbi encontrado."
    exit 0
fi

# Tenta finalizar os processos pais dos processos zumbis
for ppid in $zombies; do
    echo "Encontrado processo zumbi com PPID: $ppid"
    if sudo kill -9 "$ppid" 2>/dev/null; then
        echo "Processo pai $ppid finalizado com sucesso."
    else
        echo "Falha ao finalizar o processo pai $ppid ou ele já não está em execução."
    fi
done
