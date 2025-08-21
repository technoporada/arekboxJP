#!/bin/bash
# clean_copies.sh - Czyść zbędne kopie (ale ostrożnie!)
# Zasada: Usuń tylko te, które są starsze niż 7 dni

find ~/Projects -name "*_kop*" -type f -mtime +7 -exec rm -v {} \;
find ~/Projects -name "*_backup*" -type d -mtime +7 -exec rm -rf {} \;

echo "🌸 Posprzątane! Otsukare-sama! 🌸"
