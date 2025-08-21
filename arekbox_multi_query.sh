#!/bin/bash
# arekbox_multi_query.sh - Zapytaj wiele narzędzi, zdobądź wiele odpowiedzi!
# Zasada: "Nie dostaniesz jednej dobrej odpowiedzi? Idź szukaj dalej!"
# Autor: Arek + AI Assistant (inspirowane Twoją mądrością!)

# Konfiguracja (zmień tylko tu!)
QUERY_LOG_DIR="$HOME/.arekbox_queries"  # Gdzie logować zapytania?
SOLUTIONS_LIB="$QUERY_LOG_DIR/solutions_library.json"  # Biblioteka rozwiązań
CURRENT_QUERY="$QUERY_LOG_DIR/current_query.txt"  # Obecne zapytanie

# Kolory (Twoje ulubione!)
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Inicjalizacja
mkdir -p "$QUERY_LOG_DIR"
touch "$SOLUTIONS_LIB" "$CURRENT_QUERY"

# Funkcja: Zapytaj wiele narzędzi (Twoja metoda!)
multi_query() {
    local query="$1"
    echo -e "${CYAN}🔍 Zapytanie: '$query'${NC}"
    echo "$(date): === NOWE ZAPYTANIE ===" >> "$CURRENT_QUERY"
    echo "Zapytanie: $query" >> "$CURRENT_QUERY"
    
    # Lista narzędzi do zapytania (dostosuj do swoich!)
    local tools=(
        "chatgpt"
        "claudeai"
        "ollama_local"
        "perplexity"
        "wikipedia"
    )
    
    # Zapytaj każde narzędzie
    for tool in "${tools[@]}"; do
        echo -e "${YELLOW}🛠️  Pytam $tool...${NC}"
        local response=$(query_tool "$tool" "$query")
        
        # Zapisz odpowiedź
        echo "=== ODPOWIEDŹ Z: $tool ===" >> "$CURRENT_QUERY"
        echo "$response" >> "$CURRENT_QUERY"
        echo "" >> "$CURRENT_QUERY"
        
        # Pokaż podsumowanie
        echo -e "${GREEN}✅ Otrzymano odpowiedź z $tool${NC}"
    done
}

# Funkcja: Symulacja zapytania do narzędzia (dostosuj do swoich!)
query_tool() {
    local tool="$1"
    local query="$2"
    
    case "$tool" in
        "chatgpt")
            echo "ChatGPT: Użyj komendy 'sudo apt install'"
            ;;
        "claudeai")
            echo "ClaudeAI: Spróbuj z curl, lepiej działa offline"
            ;;
        "ollama_local")
            echo "Ollama (lokalny): Możesz użyć modelu mistral"
            ;;
        "perplexity")
            echo "Perplexity: Sprawdź dokumentację narzędzia"
            ;;
        "wikipedia")
            echo "Wikipedia: Zobacz artykuł o narzędziu"
            ;;
    esac
}

# Funkcja: "Idź szukaj dalej" (losowe sugestie!)
go_further() {
    echo -e "${CYAN}🔎 IDŹ SZUKAJ DALEJ!${NC}"
    echo -e "${YELLOW}💡 Dodatkowe sugestie:${NC}"
    
    # Losowe sugestie (jak Twoje "gadanie oczekiwaniem")
    local suggestions=(
        "A jakby połączyć to z Archiwistą w tle?"
        "Może dodać japoński interfejs?"
        "Sprawdź stare logi w ~/.arekbox_logs/"
        "Użyj dual Ollamy na różnych portach"
        "Przetestuj z modelem tiny zamiast base"
        "Zapytaj o to na forum Linuksa"
    )
    
    # Wyświetl 3 losowe sugestie
    for i in {1..3}; do
        local random_suggestion="${suggestions[$RANDOM % ${#suggestions[@]}]}"
        echo "  - $random_suggestion"
    done
}

# Funkcja: Stwórz "kilka wyjść" (hybrydowe rozwiązania)
create_exits() {
    echo -e "${CYAN}🚪 TWORZĘ KILKA WYJŚĆ...${NC}"
    
    # Przeczytaj obecne zapytanie i odpowiedzi
    local query=$(grep "Zapytanie:" "$CURRENT_QUERY" | head -1 | cut -d: -f2-)
    
    echo -e "${YELLOW}📋 Na podstawie '$query' proponuję:${NC}"
    
    # Wyjście 1: Hybryda ChatGPT + ClaudeAI
    echo "1) ${GREEN}Hybryda ChatGPT + ClaudeAI${NC}"
    echo "   Użyj komendy ChatGPT, ale dodaj sugestie ClaudeAI o offline"
    
    # Wyjście 2: Lokalne rozwiązanie
    echo "2) ${GREEN}Lokalne rozwiązanie (Ollama)${NC}"
    echo "   Użyj lokalnego modelu Ollama z curl"
    
    # Wyjście 3: Dokumentacja + Forum
    echo "3) ${GREEN}Dokumentacja + Społeczność${NC}"
    echo "   Sprawdź dokumentację i zapytaj na forum"
    
    # Wyjście 4: Twoje "gadanie oczekiwaniem"
    echo "4) ${YELLOW}Twoja metoda: 'Idź szukaj dalej'${NC}"
    go_further
}

# Funkcja: Zapisz do biblioteki rozwiązań
save_to_library() {
    local query="$1"
    local solution="$2"
    
    echo "{\"query\":\"$query\", \"solution\":\"$solution\", \"timestamp\":\"$(date)\"}" >> "$SOLUTIONS_LIB"
    echo -e "${GREEN}✅ Zapisano do biblioteki rozwiązań!${NC}"
}

# Główne menu
echo -e "${CYAN}=== MULTI-TOOL QUERY MANAGER ===${NC}"
echo "1) Zapytaj wiele narzędzi"
echo "2) Idź szukaj dalej (losowe sugestie)"
echo "3) Stwórz kilka wyjść"
echo "4) Pokaż bibliotekę rozwiązań"
echo "0) Wyjście"
read -p "Wybierz opcję: " choice

case $choice in
    1)
        echo "Podaj zapytanie:"
        read query
        multi_query "$query"
        ;;
    2)
        go_further
        ;;
    3)
        create_exits
        ;;
    4)
        echo -e "${CYAN}📚 Biblioteka rozwiązań:${NC}"
        cat "$SOLUTIONS_LIB" | jq . 2>/dev/null || cat "$SOLUTIONS_LIB"
        ;;
    0)
        exit 0
        ;;
    *)
        echo -e "${RED}Nieznana opcja!${NC}"
        ;;
esac
