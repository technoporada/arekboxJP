#!/bin/bash
# arekbox_dual_ollama.sh - Uruchom 2 Ollamy na różnych portach!
# Zasada: "Kurwa, działa!" + japońska dyscyplina portów
# Autor: Arek + AI Assistant

# Kolory (Twoje ulubione!)
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Konfiguracja (zmień tylko tu!)
OLLAMA1_PORT=11434  # Pierwsza Ollama (domyślna)
OLLAMA2_PORT=11435  # Druga Ollama (nowy port!)
OLLAMA1_DIR="$HOME/.ollama1"  # Katalog dla instancji 1
OLLAMA2_DIR="$HOME/.ollama2"  # Katalog dla instancji 2

# Funkcja: Sprawdź, czy port jest wolny
check_port() {
    local port="$1"
    if lsof -i :"$port" > /dev/null; then
        echo -e "${RED}❌ Port $port jest zajęty!${NC}"
        return 1
    else
        echo -e "${GREEN}✅ Port $port jest wolny!${NC}"
        return 0
    fi
}

# Funkcja: Uruchom Ollamę na konkretnym porcie
start_ollama() {
    local port="$1"
    local dir="$2"
    
    echo -e "${CYAN}Uruchamiam Ollamę na porcie $port (katalog: $dir)...${NC}"
    
    # Stwórz katalog, jeśli nie istnieje
    mkdir -p "$dir"
    
    # Ustaw zmienną środowiskową OLLAMA_HOST
    export OLLAMA_HOST="0.0.0.0:$port"
    
    # Uruchom Ollamę w tle
    nohup ollama serve > "$dir/ollama.log" 2>&1 &
    
    # Poczekaj chwilę i sprawdź
    sleep 3
    if lsof -i :"$port" > /dev/null; then
        echo -e "${GREEN}✅ Ollama na porcie $port działa! (PID: $!)${NC}"
        echo "Logi: $dir/ollama.log"
    else
        echo -e "${RED}❌ Nie udało się uruchomić Ollamy na porcie $port!${NC}"
        echo "Sprawdź logi: cat $dir/ollama.log"
    fi
}

# Główne menu
echo -e "${CYAN}=== AREKBOX DUAL OLLAMA ===${NC}"
echo "1) Uruchom obie Ollamy (porty $OLLAMA1_PORT i $OLLAMA2_PORT)"
echo "2) Sprawdź status portów"
echo "3) Zatrzymaj obie Ollamy"
echo "0) Wyjście"
read -p "Wybierz opcję: " choice

case $choice in
    1)
        # Sprawdź porty
        check_port "$OLLAMA1_PORT" || exit 1
        check_port "$OLLAMA2_PORT" || exit 1
        
        # Uruchom obie instancje
        start_ollama "$OLLAMA1_PORT" "$OLLAMA1_DIR"
        start_ollama "$OLLAMA2_PORT" "$OLLAMA2_DIR"
        
        echo -e "${CYAN}🌸 Otsukare-sama! Dwie Ollamy działają! 🌸${NC}"
        ;;
    2)
        echo -e "${CYAN}Status portów:${NC}"
        check_port "$OLLAMA1_PORT"
        check_port "$OLLAMA2_PORT"
        ;;
    3)
        echo -e "${CYAN}Zatrzymuję obie Ollamy...${NC}"
        pkill -f "ollama serve"
        echo -e "${GREEN}✅ Zatrzymano!${NC}"
        ;;
    0)
        echo "Do widzenia!"
        exit 0
        ;;
    *)
        echo -e "${RED}Nieznana opcja!${NC}"
        exit 1
        ;;
esac
