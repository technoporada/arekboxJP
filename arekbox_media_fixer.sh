#!/bin/bash
# arekbox_media_fixer.sh - Poprawa doświadczenia oglądania (dla Netflix i innych!)
# Symuluje idealne media center: rotacja intro, dźwięków, statystyki!
# Autor: Arek + AI Assistant

# Konfiguracja
MEDIA_DIR="$HOME/arekbox_media"
SETTINGS_FILE="$MEDIA_DIR/experience_settings.json"
STATS_FILE="$MEDIA_DIR/viewing_stats.json"
INTRO_PACKS_DIR="$MEDIA_DIR/intro_packs"

# Kolory (Twoje ulkie!)
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\1[33m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Inicjalizacja
mkdir -p "$MEDIA_DIR"/{intro_packs,stats,settings}
touch "$SETTINGS_FILE" "$STATS_FILE"

# Funkcja: Konfiguruj ustawienia doświadczenia
configure_experience() {
    echo -e "${PURPLE}⚙️ Konfiguruję ustawienia oglądania...${NC}"
    
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "audio_experience": {
    "intro_rotation": true,
    "max_intro_repeats": 3,
    "volume_reduction": 20,
    "smart_skip": true
  },
  "visual_experience": {
    "intro_rotation": true,
    "max_visual_repeats": 3,
    "refresh_frequency": "6_months",
    "user_fatigue_detection": true
  },
  "user_preferences": {
    "skip_intro": true,
    "auto_next_episode": true,
    "volume_normalization": true
  }
}
EOF
    
    echo -e "${GREEN}✅ Ustawienia skonfigurowane!${NC}"
}

# Funkcja: Twórz pakiety intro (różne wersje dźwiękowe)
create_intro_packs() {
    echo -e "${PURPLE}🎵 Tworzę pakiety intro (różne wersje dźwiękowe)...${NC}"
    
    mkdir -p "$INTRO_PACKS"/{netflix,hbo,max,amazon}
    
    # Przykładowe pakiety dźwiękowe (w rzeczywistości byłyby pliki audio)
    cat > "$INTRO_PACKS/netflix/intro_pack_1.txt" << 'EOF'
Netflix Intro Pack 1:
- "Ta-dum" (klasyczny)
- Wersja: 2024.1
- Częstotliwość: 440Hz
- Czas trwania: 5s
EOF
    
    cat > "$INTRO_PACKS/netflix/intro_pack_2.txt" << 'EOF'
Netflix Intro Pack 2:
- "Whoosh" (nowoczesny)
- Wersja: 2024.2
- Częstotliwość: 880Hz
- Czas trwania: 4s
EOF
    
    cat > "$INTRO_PACKS/netflix/intro_pack_3.txt" << 'EOF'
Netflix Intro Pack 3:
- "Chime" (delikatny)
- Wersja: 2024.3
- Częstotliwoń: 220Hz
- Czas trwania: 3s
EOF
    
    echo -e "${GREEN}✅ Pakiety intro stworzone!${NC}"
}

# Funkcja: Symulacja rotacji intro
simulate_intro_rotation() {
    echo -e "${PURPLE🔄 Symuluję rotację intro...${NC}"
    
    local intro_pack="$INTRO_PACKS/netflix/intro_pack_$((RANDOM % 3 + 1)).txt"
    local intro_count=$(jq '.audio_experience.intro_count // 1' "$STATS_FILE" 2>/dev/null || echo 0)
    
    echo -e "${CYAN}Aktualnie odtwarzam:${NC}"
    cat "$intro_pack"
    
    # Aktualizuj statystyki
    jq ".audio_experience.intro_count = $intro_count + 1" "$STATS_FILE" > "$STATS_FILE.tmp" && mv "$STATS_FILE.tmp" "$STATS_FILE"
    
    # Sprawdź zmęczenie użytkownika
    if (( intro_count > 3 )); then
        echo -e "${YELLOW}⚠️  Wykryto zmęczenie użytkownika! Ograniczam powtórzenia...${NC}"
        echo -e "${GREEN}✅ Włączam tryb cichy intro...${NC}"
    fi
}

# Funkcja: Symulacja odświeżania biblioteki
simulate_library_refresh() {
    echo -e "${PURPLE🔄 Symuluję odświeżanie biblioteki...${NC}"
    
    local last_refresh=$(jq '.last_refresh' "$STATS_FILE" 2>/dev/null || echo "2024-01-01")
    local current_date=$(date +%Y-%m-%d)
    
    # Oblicz miesiące od ostatniego odświeżenia
    local months_diff=$(( ( $(date -d "$current_date" +%s) - $(date -d "$last_refresh" +%s) ) / 2592000 ))
    
    if (( months_diff >= 6 )); then
        echo -e "${GREEN}✅ Czas na odświeżenie biblioteki!${NC}"
        echo -e "${CYAN}Aktualizuję pakiety intro i grafiki...${NC}"
        
        # Aktualizuj statystyki
        jq ".last_refresh = \"$current_date\"" "$STATS_FILE" > "$STATS_FILE.tmp" && mv "$STATS_FILE.tmp" "$STATS_FILE"
        
        # Symuluj pobieranie nowych pakietów
        echo -e "${CYAN}Pobieram nowe pakiety intro...${NC}"
        sleep 2
        echo -e "${CYAN}Aktualizuję demo grafiki...${NC}"
        sleep 2
        
        echo -e "${GREEN}✅ Biblioteka odświeżona!${NC}"
    else
        echo -e "${YELLOW}ℹ️  Następne odświeżanie za $((6 - months_diff)) miesięcy${NC}"
    fi
}

# Funkcja: Wykrywanie zmęczenia użytkownika
detect_user_fatigue() {
    echo -e "${PURPLE🧠 Wykrywam zmęczenie użytkownika...${NC}"
    
    local session_time=$(jq '.session_time_minutes // 1' "$STATS_FILE" 2>/dev/null || echo 0)
    local intro_repeats=$(jq '.audio_experience.intro_count // 1' "$STATS_FILE" 2>/dev/null || echo 0)
    
    echo -e "${CYAN}Czas sesji: $session_time minut${NC}"
    echo -e "${CYAN}Powtórzenia intro: $intro_repeats${NC}"
    
    if (( session_time > 120 && intro_repeats > 5 )); then
        echo -e "${RED}❌ Wykryto zmęczenie użytkownika!${NC}"
        echo -e "${YELLOW}💡 Sugestie:${NC}"
        echo -e "${YELLOW}  - Włącz tryb cichy intro${NC}"
        echo -e "${YELLOW}  - Automatyczne pomijanie intro${NC}"
        echo -e "${YELLOW}  - Przerwa na 5 minut${NC}"
        
        # Aktualizuj statystyki
        jq '.user_fatigue_detected = true' "$STATS_FILE" > "$STATS_FILE.tmp" && mv "$STATS_FILE.tmp" "$STATS_FILE"
    else
        echo -e "${GREEN}✅ Poziom zmęczenia akceptowalny${NC}"
    fi
}

# Funkcja: Generuj raport doświadczenia
generate_experience_report() {
    echo -e "${PURPLE📊 Generuję raport doświadczenia oglądania...${NC}"
    
    echo -e "${CYAN}=== RAPORT DOŚWIADCZENIA MEDIA ===${NC}"
    echo -e "${YELLOW}📈 Statystyki oglądania:${NC}"
    
    # Wczytaj statystyki
    local total_sessions=$(jq '.total_sessions // 1' "$STATS_FILE" 2>/dev/null || echo 1)
    local total_intro_repeats=$(jq '.audio_experience.intro_count // 1' "$STATS_FILE" 2>/dev/null || echo 1)
    local fatigue_detected=$(jq '.user_fatigue_detected // false' "$STATS_FILE" 2>/dev/null || echo false)
    
    echo -e "${GREEN}  Całkowitych sesji: $total_sessions${NC}"
    echo -e "${GREEN}  Powtórzenia intro: $total_intro_repeats${NC}"
    echo -e "${RED}  Zmęczenie wykryte: $fatigue_detected${NC}"
    
    echo -e "${YELLOW}💡 Rekomendacje:${NC}"
    echo -e "${YELLOW}  - Włącz rotację intro (zmniejszy powtórzenia)${NC}"
    echo -e "${YELLOW}  - Odświeżaj bibliotekę co 6 miesięcy${NC}"
    echo -e "${YELLOW}  - Monitoruj czas sesji (przerwy co 2h)${NC}"
    
    echo -e "${PURPLE}📝 Raport zapisany w: $STATS_FILE${NC}"
}

# Funkcja: Pokaż, jak powinno działać idealne media center
show_ideal_experience() {
    echo -e "${PURPLE🎬 Jak powinno działać IDEALNE media center:${NC}"
    echo ""
    echo -e "${GREEN}✅ Rotacja intro (dźwiękowej i wizualnej):${NC}"
    echo "  - 3-5 różnych wersji intro na serial"
    "  - Automatyczna zmiana przy każdym odcinku"
    "  - Możliwość wyboru ulubionej wersji"
    
    echo -e "${GREEN}✅ Inteligentne odświeżanie:${NC}"
    echo "  - Co 6 miesięcy: nowe pakiety audio/video"
    "  - Automatyczne pobieranie w tle"
    "  - Zachowuje ulubione ustawienia użytkownika"
    
    echo -e "${GREEN}✅ Ochrona przed zmęczeniem:${NC}"
    echo "  - Wykrywanie długich sesji"
    "  - Automatyczne wyciszanie po 2h"
    "  - Sugestie przerw"
    
    echo -e "${GREEN}✅ Personalizacja:${NC}"
    echo "  - Własne pakiety intro (możliwość dodania)"
    "  - Różne profile (dzieci, dorośli, nocny)"
    "  - Dostosowanie do urządzenia (TV, telefon, tablet)"
}

# Główne menu
echo -e "${PURPLE}=== AREKBOX MEDIA EXPERIENCE FIXER 🎬 ===${NC}"
echo "1) Konfiguruj ustawienia doświadczenia"
echo "2) Stwórz pakiety intro"
echo "3) Symuluj rotację intro"
echo "4) Symuluj odświeżanie biblioteki"
echo "5) Wykryj zmęczenie użytkownika"
echo "6) Generuj raport doświadczenia"
echo "7) Pokaż idealne media center"
echo "0) Wyjście"
read -p "Wybierz opcję: " choice

case $choice in
    1) configure_experience ;;
    2) create_intro_packs ;;
    3) simulate_intro_rotation ;;
    4) simulate_library_refresh ;;
    5) detect_user_fatigue ;;
    6) generate_experience_report ;;
    7) show_ideal_experience ;;
    0) exit 0 ;;
    *) echo -e "${RED}Nieznana opcja!${NC}" ;;
esac
