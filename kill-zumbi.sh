#!/bin/bash

# Exibe todos os processos zumbis
echo "Procurando processos zumbis..."

# Lista os processos zumbis e seus PPIDs
zombies=$(ps -eo stat,ppid | grep -w 'Z' | awk '{print $2}' | sort | uniq)

# Verifica se encontrou algum processo zumbi
if [ -z "$zombies" ]; then
    echo "Nenhum processo zumbi encontrado."
    exit 0
fi

# Para cada PPID encontrado, tenta finalizar o processo pai
for ppid in $zombies; do
    echo "Encontrado processo zumbi com PPID: $ppid"
    echo "Tentando matar o processo pai: $ppid"

    # Verifica se o processo pai ainda existe
    if ps -p $ppid > /dev/null; then
        # Tenta matar o processo pai
        sudo kill -9 $ppid
        if [ $? -eq 0 ]; then
            echo "Processo pai $ppid finalizado com sucesso."
        else
            echo "Falha ao finalizar o processo pai $ppid."
        fi
    else
        echo "O processo pai $ppid não está mais em execução."
    fi
done
