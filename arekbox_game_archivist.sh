#!/bin/bash
# arekbox_game_archivist.sh - Archiwizacja i organizacja gier .io!
# Zasada: "Ratuj to, co ginie! Organizuj to, co masz!"
# Autor: Arek + AI Assistant

# Konfiguracja (zmień tylko tu!)
GAME_ARCHIVE_DIR="/home/arekbox/game_archive"  # Gdzie przechowujesz gry?
CATALOG_FILE="$GAME_ARCHIVE_DIR/catalog.json"  # Katalog gier
MISSING_GAMES_LOG="$GAME_ARCHIVE_DIR/missing_games.log"  # Logi brakujących gier
WEB_ROOT="$GAME_ARCHIVE_DIR/web_root"  # Katalog na prostą stronę WWW

# Kolory (Twoje ulubione!)
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Inicjalizacja
mkdir -p "$GAME_ARCHIVE_DIR"/{raw_games,catalog,web_root}
touch "$CATALOG_FILE" "$MISSING_GAMES_LOG"

# Funkcja: Skanuj katalog z grami
scan_games() {
    echo -e "${CYAN}🔍 Skanuję katalog z grami...${NC}"
    
    local game_count=0
    find "$GAME_ARCHIVE_DIR/raw_games" -name "*.io" -o -name "*.html" -o -name "*.swf" | while read -r game; do
        # Wyodrębnij nazwę gry z pliku
        local game_name=$(basename "$game" | sed 's/\.[^.]*$//')
        
        # Sprawdź, czy już jest w katalogu
        if ! grep -q "\"$game_name\"" "$CATALOG_FILE"; then
            # Dodaj do katalogu
            local entry="{\"name\":\"$game_name\",\"path\":\"$game\",\"status\":\"archived\",\"date_added\":\"$(date +%Y-%m-%d)\"}"
            echo "$entry" >> "$CATALOG_FILE"
            ((game_count++))
        fi
    done
    
    echo -e "${GREEN}✅ Znaleziono $game_count nowych gier!${NC}"
}

# Funkcja: Organizuj gry w kategorie
organize_games() {
    echo -e "${CYAN}📁 Organizuję gry w kategorie...${NC}"
    
    # Twórz kategorie
    mkdir -p "$GAME_ARCHIVE_DIR/catalog"/{action,puzzle,arcade,strategy,sports,shooter}
    
    # Przenoszenie gier do odpowiednich kategorii
    jq -r '.[] | select(.status=="archived") | "\(.name) \(.path)"' "$CATALOG_FILE" | while read -r name path; do
        # Prosta detekcja kategorii (można rozbudować!)
        if [[ "$name" =~ (shoot|war|battle) ]]; then
            category="shooter"
        elif [[ "$name" =~ (puzzle|match|brain) ]]; then
            category="puzzle"
        elif [[ "$name" =~ (io|multi) ]]; then
            category="arcade"
        else
            category="action"
        fi
        
        # Twórz link symboliczny
        ln -sf "$path" "$GAME_ARCHIVE_DIR/catalog/$category/"
    done
    
    echo -e "${GREEN}✅ Gry zorganizowane w kategorie!${NC}"
}

# Funkcja: Generuj statystyki kolekcji
generate_stats() {
    echo -e "${CYAN}📊 Generuję statystyki kolekcji...${NC}"
    
    local total_games=$(jq '. | length' "$CATALOG_FILE")
    local archived_games=$(jq '.[] | select(.status=="archived") | length' "$CATALOG_FILE")
    local missing_games=$(wc -l < "$MISSING_GAMES_LOG")
    
    echo -e "${YELLOW}📈 Statystyki kolekcji:${NC}"
    echo "  🎮 Łącznie gier: $total_games"
    echo "  ✅ Archiwizowane: $archived_games"
    echo "  ❌ Brakujące: $missing_games"
    echo "  📅 Ostatnia aktualizacja: $(date)"
}

# Funkcja: Generuj prostą stronę WWW
generate_website() {
    echo -e "${CYAN}🌐 Generuję stronę WWW z kolekcją...${NC}"
    
    cat > "$WEB_ROOT/index.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>ArekBox Game Archive</title>
    <style>
        body { font-family: Arial, sans-serif; background: #1a1a1a; color: #fff; }
        .game { margin: 10px; padding: 10px; background: #2a2a2a; border-radius: 5px; }
        .missing { color: #ff6b6b; }
    </style>
</head>
<body>
    <h1>🎮 ArekBox Game Archive</h1>
    <h2>Zachowane dziedzictwo gier .io</h2>
    <p>Kolekcja: 17,000+ gier, które zniknęły z sieci</p>
EOF
    
    # Dodaj listę gier
    jq -r '.[] | "<div class=\"game\">🎮 \(.name) - <em>\(.status)</em></div>"' "$CATALOG_FILE" >> "$WEB_ROOT/index.html"
    
    # Dodaj brakujące gry
    if [[ -s "$MISSING_GAMES_LOG" ]]; then
        echo "<h3>Brakujące gry:</h3>" >> "$WEB_ROOT/index.html"
        sed 's/^/<div class="game missing">🎮 /' "$MISSING_GAMES_LOG" >> "$WEB_ROOT/index.html"
    fi
    
    cat >> "$WEB_ROOT/index.html" << 'EOF'
</body>
</html>
EOF
    
    echo -e "${GREEN}✅ Strona WWW wygenerowana: $WEB_ROOT/index.html${NC}"
}

# Funkcja: Szukaj brakujących gier (w sieci)
find_missing_games() {
    echo -e "${CYAN}🔍 Szukam brakujących gier...${NC}"
    
    # Lista znanych gier .io (można rozbudować!)
    local known_games=(
        "agar.io"
        "slither.io"
        "diep.io"
        "mope.io"
        "paper.io"
        "bonk.io"
        "deeeep.io"
        "zombs.io"
        "spinz.io"
    )
    
    for game in "${known_games[@]}"; do
        if ! grep -q "\"$game\"" "$CATALOG_FILE"; then
            echo "$game" >> "$MISSING_GAMES_LOG"
            echo -e "${YELLOW}⚠️  Brakuje: $game${NC}"
        fi
    done
}

# Funkcja: Testuj gry (uruchom w przeglądarce)
test_game() {
    echo -e "${CYAN}🎮 Testuję gry...${NC}"
    
    # Prosty serwer WWW do testowania
    if ! pgrep "python3 -m http.server" > /dev/null; then
        cd "$WEB_ROOT"
        python3 -m http.server 8000 &
        echo -e "${GREEN}✅ Serwer WWW uruchomiony: http://localhost:8000${NC}"
        echo -e "${YELLOW}📝 Otwórz w przeglądarce i testuj gry!${NC}"
    else
        echo -e "${YELLOW}ℹ️  Serwer już działa!${NC}"
    fi
}
# Funkcja: Analiza popularności gier
analyze_popularity() {
    echo -e "${CYAN}📈 Analizuję popularność gier...${NC}"
    
    # Liczba uruchomień (można zaimplementować)
    jq -r '.[] | .name' "$CATALOG_FILE" | sort | uniq -c | sort -nr | head -10
}

# Funkcja: Sprawdzanie integralności gier
check_integrity() {
    echo -e "${CYAN}🔍 Sprawdzam integralność gier...${NC}"
    
    jq -r '.[] | "\(.path)"' "$CATALOG_FILE" | while read -r path; do
        if [[ ! -f "$path" ]]; then
            echo -e "${RED}❌ Brakuje: $path${NC}"
            echo "$path" >> "$MISSING_GAMES_LOG"
        fi
    done
}
# Główne menu
echo -e "${CYAN}=== AREKBOX GAME ARCHIVIST ===${NC}"
echo "1) Skanuj katalog z grami"
echo "2) Organizuj gry w kategorie"
echo "3) Generuj statystyki"
echo "4) Generuj stronę WWW"
echo "5) Szukaj brakujących gier"
echo "6) Testuj gry"
echo "7) Pokaż całą kolekcję"
echo "0) Wyjście"
read -p "Wybierz opcję: " choice

case $choice in
    1) scan_games ;;
    2) organize_games ;;
    3) generate_stats ;;
    4) generate_website ;;
    5) find_missing_games ;;
    6) test_game ;;
    7)
        echo -e "${CYAN}🎮 Twoja kolekcja:${NC}"
        jq -r '.[] | "🎮 \(.name) - \(.status)"' "$CATALOG_FILE"
        ;;
    0) exit 0 ;;
    *) echo -e "${RED}Nieznana opcja!${NC}" ;;
esac
