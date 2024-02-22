#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Uso: $0 <arquivo_de_urls>"
    exit 1
fi

url_file="$1"

if [ ! -f "$url_file" ]; then
    echo "O arquivo $url_file não existe."
    exit 1
fi
total_urls=$(wc -l < "$url_file")

processed_urls=0

while IFS= read -r url; do
    ((processed_urls++))

    if [ -n "$url" ]; then
        filename=$(basename "$url")
        filename="${filename//[^[:alnum:].-]/}"
        nuclei -u "$url" -t nuclei-templates/ -o "${filename}.xml" &
    fi
done < "$url_file"

# Aguarda a conclusão de todos os processos em segundo plano
wait

echo "Varredura concluída para todas as URLs."
