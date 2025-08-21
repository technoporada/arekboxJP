#!/bin/bash
# arekbox_dance_helper.sh - Automatyzacja Twojej metody!
# Zasada: Kopiuj błąd -> Gadaj o innych rzeczach -> Powróć -> Zbierz pomysły

# Krok 1: Skopiuj błąd do schowka
copy_error() {
    local error="$1"
    echo "$error" >> /tmp/arekbox_error.txt
    echo -e "${YELLOW}📋 Błąd skopiowany do schowka!${NC}"
}

# Krok 2: "Zabij czas" (losowe pomysły z Twoich notatek)
kill_time() {
    echo -e "${CYAN}💭 Czekam na AI... czas na pomysły!${NC}"
    
    # Losowe pomysły z Twoich notatek
    ideas=(
        "Może dodać japoński? Otsukare-sama!"
        "A jakby połączyć z Archiwistą w tle?"
        "Przecież mam 150 plików z rozmowami!"
        "Whisper ma też model tiny!"
        "Dual Ollama na różnych portach!"
    )
    
    # Wyświetl losowy pomysł
    random_idea="${ideas[$RANDOM % ${#ideas[@]}]}"
    echo -e "${GREEN}💡 Pomysł na czas oczekiwania: $random_idea${NC}"
}

# Krok 3: Powrót do tematu (zebrane pomysły)
return_with_ideas() {
    echo -e "${CYAN}🔙 Powrót do tematu... z nowymi pomysłami!${NC}"
    echo -e "${YELLOW}📝 Zebrane pomysły:${NC}"
    cat /tmp/arekbox_ideas.txt
}

# Użycie (przykład)
echo "Podaj błąd do skopiowania:"
read error
copy_error "$error"
kill_time
# [Tutaj wysyłasz błąd do AI]
return_with_ideas
