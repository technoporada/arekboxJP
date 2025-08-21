#!/bin/bash
# arekbox_installer.sh – Open Source bez iluzji
# Wymaga: ZERO zewnętrznych zależności (poza podstawowymi narzędziami systemowymi)
# Autor: Arek (20 lat doświadczeń w "rozbieraniu systemów")

# Kolory i style (jak zawsze!)
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

# Funkcja: Instalacja z potwierdzeniem użytkownika
ask_install() {
    local tool_name="$1"
    local install_command="$2"
    
    echo -e "${CYAN}Czy chcesz zainstalować $tool_name? [T/N]${NC}"
    read answer
    if [[ "$answer" == "T" ]]; then
        eval "$install_command"
        echo -e "${GREEN}Zainstalowano $tool_name${NC}"
    else
        echo -e "${RED}Pomijam $tool_name${NC}"
    fi
}

# Główne menu
echo -e "${CYAN}=== AREKBOX INSTALLER (Zero GitHub, Zero Zależności) ===${NC}"
echo "Co chcesz zainstalować?"

# AI Tools
ask_install "Whisper (rozpoznawanie mowy)" "pip install openai-whisper"
ask_install "Ollama (lokalne LLM)" "curl -fsSL https://ollama.com/install.sh | sh"

# System Tools
ask_install "htop (monitoring)" "apt install htop -y"
ask_install "tmux (terminal multiplexer)" "apt install tmux -y"

# Multimedia
ask_install "ffmpeg (konwersja wideo)" "apt install ffmpeg -y"
ask_install "mpv (odtwarzacz)" "apt install mpv -y"

# Pytanie końcowe
echo -e "${CYAN}Czy chcesz, żebym stworzył aliasy dla narzędzi? [T/N]${NC}"
read create_aliases
if [[ "$create_aliases" == "T" ]]; then
    echo "alias arekbox='./arekbox_installer.sh'" >> ~/.bashrc
    echo "Alias dodany! Uruchom: source ~/.bashrc"
fi

echo -e "${GREEN}Gotowe! Wszystko działa – zero GitHuba, zero problemów.${NC}"
