#!/bin/bash
# arekbox_chat_archiver.sh - Przeglądaj 150 plików .md z rozmowami!
# Zasada: Zero porządku, 100% Twojego stylu!
# Autor: Arek + AI Assistant

# Konfiguracja (zmień tylko tu!)
CHAT_DIR="/drugi/dysk/rozmowy"  # Gdzie są Twoje pliki .md?
OUTPUT_DIR="$HOME/arekbox_chat_archive"  # Gdzie zapisywać "kroniki"?
MAX_FILES=150  # Ile plików masz?

# Kolory (Twoje ulubione!)
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Funkcja: Znajdź wszystkie pliki .md w katalogu
find_chats() {
    find "$CHAT_DIR" -name "*.md" -type f | head -n "$MAX_FILES"
}

# Funkcja: Wyświetl "kronikę" (losowe fragmenty)
show_kronika() {
    echo -e "${CYAN}=== KRONIKA ROZMÓW (Losowe fragmenty) ===${NC}"
    echo ""
    
    # Wybierz losowe 5 plików
    random_files=$(find_chats | shuf -n 5)
    
    for file in $random_files; do
        echo -e "${YELLOW}📄 Plik: $(basename "$file")${NC}"
        # Wyświetl losowe 3 linie z pliku
        shuf -n 3 "$file" | sed 's/^/  /'
        echo ""
    done
}

# Funkcja: Szukaj konkretnego tematu (np. "ollama", "błąd", "śmiech")
search_topic() {
    local topic="$1"
    echo -e "${CYAN}=== SZUKAJ: '$topic' ===${NC}"
    echo ""
    
    find_chats | while read -r file; do
        if grep -qi "$topic" "$file"; then
            echo -e "${YELLOW}📄 Znaleziono w: $(basename "$file")${NC}"
            grep -i "$topic" "$file" | head -n 2 | sed 's/^/  /'
            echo ""
        fi
    done
}

# Funkcja: Stwórz "podsumowanie dnia" (najciekawsze cytaty)
daily_summary() {
    echo -e "${CYAN}=== PODSUMOWANIE DNIA (Najciekawsze cytaty) ===${NC}"
    echo ""
    
    find_chats | while read -r file; do
        # Szukaj śmiechu, załamania, "kurwa"
        if grep -qiE "(smiech|załamanie|kurwa|haha)" "$file"; then
            echo -e "${YELLOW}📄 $(basename "$file"):${NC}"
            grep -iE "(smiech|załamanie|kurwa|haha)" "$file" | head -n 1 | sed 's/^/  /'
            echo ""
        fi
    done
}

# Funkcja: Eksportuj do jednego pliku (do czytania)
export_all() {
    local output_file="$OUTPUT_DIR/pełna_kronika_$(date +%Y%m%d).md"
    mkdir -p "$OUTPUT_DIR"
    
    echo "# Kronika Rozmów ArekBox" > "$output_file"
    echo "Wygenerowano: $(date)" >> "$output_file"
    echo "" >> "$output_file"
    
    find_chats | while read -r file; do
        echo "## $(basename "$file")" >> "$output_file"
        cat "$file" >> "$output_file"
        echo "" >> "$output_file"
    done
    
    echo -e "${GREEN}✅ Eksportowano do: $output_file${NC}"
}

# Główne menu
echo -e "${CYAN}=== ARCHIWUM ROZMÓW AREKBOX ===${NC}"
echo "1) Pokaż losowe fragmenty (kronika)"
echo "2) Szukaj tematu (np. 'ollama', 'błąd')"
echo "3) Podsumowanie dnia (śmiech, załamania)"
echo "4) Eksportuj wszystko do jednego pliku"
echo "0) Wyjście"
read -p "Wybierz opcję: " choice

case $choice in
    1) show_kronika ;;
    2) 
       read -p "Podaj temat do wyszukania: " topic
       search_topic "$topic"
       ;;
    3) daily_summary ;;
    4) export_all ;;
    0) exit 0 ;;
    *) echo -e "${RED}Nieznana opcja!${NC}" ;;
esac
