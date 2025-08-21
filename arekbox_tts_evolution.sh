#!/bin/bash
# arekbox_tts_evolution.sh - Automatyzacja Twojej metody testowania TTS!
# Zasada: Testuj → Pamiętaj → Ewoluuj → Używaj najlepszych!
# Autor: Arek + AI Assistant (inspirowane Twoimi sesjami!)

# Konfiguracja (zmień tylko tu!)
TTS_LOG_DIR="$HOME/.arekbox_tts_logs"  # Gdzie logować testy?
TTS_HISTORY="$TTS_LOG_DIR/tts_history.json"  # Historia prób
CURRENT_SESSION="$TTS_LOG_DIR/current_session.txt"  # Obecna sesja
BEST_VOICES="$TTS_LOG_DIR/best_voices.txt"  # Najlepsze głosy (Twoje odkrycia!)

# Kolory (Twoje ulubione!)
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Inicjalizacja (jeśli nie ma katalogów)
mkdir -p "$TTS_LOG_DIR"
touch "$TTS_HISTORY" "$CURRENT_SESSION" "$BEST_VOICES"

# Funkcja: Rozpocznij nową sesję testową
start_session() {
    echo "$(date): === NOWA SESJA TTS ===" >> "$CURRENT_SESSION"
    echo -e "${CYAN}🎤 Rozpoczynam nową sesję testową TTS...${NC}"
    echo -e "${YELLOW}💭 Czego testujemy dzisiaj?${NC}"
}

# Funkcja: Testuj głos (zapisz wynik)
test_voice() {
    local engine="$1"  # espeak, festival, itp.
    local voice="$2"    # konkretny głos
    local text="$3"     # tekst do przetestowania
    
    echo -e "${CYAN}🔧 Testuję: $engine ($voice)${NC}"
    
    # Uruchom TTS i zapisz wynik
    case "$engine" in
        "espeak")
            echo "$text" | espeak -v "$voice" 2>/dev/null
            ;;
        "festival")
            echo "$text" | festival --tts 2>/dev/null
            ;;
        # Dodaj więcej silników TTS!
    esac
    
    # Zapytaj o ocenę (Twoja subiektywna ocena!)
    echo -e "${YELLOW}👆 Jak to brzmiało? (1-5, 0=porażka)${NC}"
    read rating
    
    # Zapisz do historii
    local entry="{\"timestamp\":\"$(date)\", \"engine\":\"$engine\", \"voice\":\"$voice\", \"text\":\"$text\", \"rating\":$rating}"
    echo "$entry" >> "$HISTORY"
    
    # Jeśli ocena >=4, dodaj do najlepszych
    if [[ "$rating" -ge 4 ]]; then
        echo "$engine:$voice" >> "$BEST_VOICES"
        echo -e "${GREEN}✅ Dodano do najlepszych!${NC}"
    fi
    
    # Zapisz do obecnej sesji
    echo "Test: $engine ($voice) - Ocena: $rating" >> "$CURRENT_SESSION"
}

# Funkcja: "Regeneracja w głowie" (przeglądaj historię)
regeneration_time() {
    echo -e "${CYAN}🧠 Czas na regenerację w głowie...${NC}"
    echo -e "${YELLOW}📜 Przeglądam historię prób:${NC}"
    
    # Pokaż ostatnie 5 testów
    tail -n 5 "$HISTORY" | while read -r line; do
        echo "  $line"
    done
    
    echo -e "${YELLOW}💡 Najlepsze głosy dotychczas:${NC}"
    cat "$BEST_VOICES" | sort | uniq | head -n 3
}

# Funkcja: Następna sesja (z doświadczeniem)
next_session() {
    echo -e "${CYAN}🔄 Następna sesja (z doświadczeniem!)${NC}"
    
    # Pokaż wnioski z poprzedniej sesji
    echo -e "${YELLOW}📝 Wnioski z poprzedniej sesji:${NC}"
    tail -n 10 "$CURRENT_SESSION"
    
    # Czyść obecną sesję
    > "$CURRENT_SESSION"
    echo "$(date): === KONTYNUACJA SESJI (z doświadczeniem) ===" >> "$CURRENT_SESSION"
}

# Funkcja: Użyj najlepszych głosów
use_best_voices() {
    echo -e "${GREEN}🎤 Używam najlepszych głosów (Twoje odkrycia!)${NC}"
    
    if [[ ! -s "$BEST_VOICES" ]]; then
        echo -e "${RED}❌ Brak zapisanych głosów! Testuj najpierw.${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}📋 Dostępne najlepsze głosy:${NC}"
    cat "$BEST_VOICES" | nl
    
    echo -e "${CYAN}🔊 Wybierz głos (numer):${NC}"
    read choice
    
    local voice=$(sed "${choice}q;d" "$BEST_VOICES")
    echo -e "${GREEN}✅ Używam: $voice${NC}"
    
    # Tutaj dodaj logikę użycia głosu
    # np. echo "Testowy tekst" | odpowiedni_tts_engine
}

# Funkcja: Proponuj nowe głosy (inteligencja z historii)
suggest_voices() {
    echo -e "${CYAN}💡 Proponuję nowe głosy do testu:${NC}"
    
    # Analizuj historię i proponuj
    if grep -q "espeak" "$BEST_VOICES"; then
        echo "  - espeak (mbrola-pl2) - lepsza jakość!"
        echo "  - espeak (voice_pl) - bardziej naturalny!"
    fi
    
    if grep -q "festival" "$BEST_VOICES"; then
        echo "  - festival (voice_cmu_us_slt_arctic_hts) - żeński głos!"
    fi
    
    echo "  - pico2wave (pl) - lekki i naturalny!"
}

# Główne menu
echo -e "${CYAN}=== AREKBOX TTS EVOLUTION MANAGER ===${NC}"
echo "1) Rozpocznij nową sesję testową"
echo "2) Testuj głos"
echo "3) Czas na regenerację (przeglądaj historię)"
echo "4) Następna sesja (z doświadczeniem)"
echo "5) Użyj najlepszych głosów"
echo "0) Wyjście"
read -p "Wybierz opcję: " choice

case $choice in
    1) start_session ;;
    2) 
       echo "Podaj silnik (espeak/festival):"
       read engine
       echo "Podaj głos:"
       read voice
       echo "Podaj tekst do testu:"
       read text
       test_voice "$engine" "$voice" "$text"
       ;;
    3) regeneration_time ;;
    4) next_session ;;
    5) use_best_voices ;;
    0) exit 0 ;;
    *) echo -e "${RED}Nieznana opcja!${NC}" ;;
esac
