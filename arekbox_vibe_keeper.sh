#!/bin/bash
# arekbox_vibe_keeper.sh - Legalne odkrywanie japońskiej sceny gier!
# Wspiera: visual novel, gry oparte na mandze, indie japońskie
# Zasada: "Szukaj legalnie, szanuj twórców, zachowaj vibe!"
# Autor: Arek + AI Assistant

# Konfiguracja
JAPANESE_GAMES_DIR="$HOME/japanese_vibe_games"
CATALOG_FILE="$JAPANESE_GAMES_DIR/vibe_catalog.json"
LEGAL_SOURCES_FILE="$JAPANESE_GAMES_DIR/legal_sources.txt"
WEB_ROOT="$JAPANESE_GAMES_DIR/web_root"

# Kolory (Twoje ulubione!)
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'  # Kolor dla japońskiego vibe!
NC='\033[0m'

# Inicjalizacja
mkdir -p "$JAPANESE_GAMES_DIR"/{visual_novel,manga_games,indie,web_root}
touch "$CATALOG_FILE" "$LEGAL_SOURCES_FILE"

# Funkcja: Dodaj legalne źródła japońskich gier
add_legal_sources() {
    echo -e "${PURPLE}🎌 Dodaję legalne źródła japońskich gier...${NC}"
    
    cat >> "$LEGAL_SOURCES_FILE" << 'EOF'
# LEGALNE ŹRÓDŁA JAPONSKICH GIER
# Platformy:
- DLsite (dlsite.com) - Visual novel, indie
- Itch.io (japońscy deweloperzy)
- Steam (sekcja japońska)
- Playism (playism.com)
- Sekai Project (sekaiproject.com)
- MangaGamer (mangagamer.org)

# Darmowe tytuły:
- DDLC (Doki Doki Literature Club) - darmowa visual novel
- Katawa Shoujo - darmowa visual novel
- The Letter - horror visual novel
EOF
    
    echo -e "${GREEN}✅ Źródła dodane!${NC}"
}

# Funkcja: Szukaj gier na legalnych platformach
search_legal_games() {
    echo -e "${PURPLE}🔍 Szukam japońskich gier na legalnych platformach...${NC}"
    
    echo "Wybierz kategorię:"
    echo "1) Visual novel"
    echo "2) Gry oparte na mandze"
    echo "3) Indie japońskie"
    echo "4) Darmowe tytuły"
    read -p "Wybierz: " category
    
    case $category in
        1)
            echo -e "${CYAN}📚 Polecane visual novel:${NC}"
            echo "- Steins;Gate (na Steam)"
            "- Clannad (na Steam)"
            "- Muv-Luv (na Steam)"
            "- Higurashi (na Steam)"
            ;;
        2)
            echo -e "${CYAN}📖 Gry oparte na mandze:${NC}"
            echo "- Dragon Ball FighterZ (na Steam)"
            "- One Piece: Pirate Warriors (na Steam)"
            "- Naruto Shippuden (na Steam)"
            "- Attack on Titan (na Steam)"
            ;;
        3)
            echo -e "${CYAN}🎮 Indie japońskie:${NC}"
            echo "- To The Moon (na Steam)"
            "- Celeste (na Steam)"
            "- Hollow Knight (na Steam)"
            "- Cuphead (na Steam)"
            ;;
        4)
            echo -e "${CYAN}🆓 Darmowe tytuły:${NC}"
            echo "- DDLC (Doki Doki Literature Club)"
            "- Katawa Shoujo"
            "- The Letter"
            "- Yume Nikki"
            ;;
    esac
}

# Funkcja: Organizuj bibliotekę japońskich gier
organize_vibe_library() {
    echo -e "${PURPLE}📁 Organizuję bibliotekę japońskiego vibe...${NC}"
    
    # Twórz struktury folderów
    mkdir -p "$JAPANESE_GAMES_DIR"/{visual_novel/{romance,mystery,horror},manga_games/{shonen,shojo},indie/{pixel,3d}}
    
    # Dodaj przykładowe wpisy do katalogu
    cat >> "$CATALOG_FILE" << 'EOF'
[
  {"name":"Steins;Gate","type":"visual_novel","genre":"romance","source":"Steam","legal":true},
  {"name":"Clannad","type":"visual_novel","genre":"romance","source":"Steam","legal":true},
  {"name":"DDLC","type":"visual_novel","genre":"psychological","source":"darmowe","legal":true},
  {"name":"To The Moon","type":"indie","genre":"pixel","source":"Steam","legal":true}
]
EOF
    
    echo -e "${GREEN}✅ Biblioteka zorganizowana!${NC}"
}

# Funkcja: Generuj japońską stronę WWW
generate_vibe_website() {
    echo -e "${PURPLE}🌐 Generuję stronę z japońskim vibe...${NC}"
    
    cat > "$WEB_ROOT/index.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>🎌 ArekBox Japanese Vibe Games</title>
    <style>
        body { 
            font-family: 'Arial', sans-serif; 
            background: linear-gradient(135deg, #1a1a2e, #16213e); 
            color: #fff; 
            padding: 20px;
        }
        .game-card { 
            background: rgba(255,255,255,0.1); 
            margin: 10px; 
            padding: 15px; 
            border-radius: 10px; 
            border-left: 4px solid #e94560;
        }
        .vibe-header { 
            text-align: center; 
            font-size: 2.5em; 
            margin-bottom: 30px;
            color: #e94560;
        }
    </style>
</head>
<body>
    <div class="vibe-header">🎌 Japanese Vibe Games 🎌</div>
    <h2>Legalna kolekcja japońskich gier i visual novel</h2>
    
    <div class="game-card">
        <h3>📚 Visual Novel</h3>
        <p>Gatunek oparty na interaktywnych historiach, popularny w Japonii.</p>
        <p><strong>Polecane:</strong> Steins;Gate, Clannad, Higurashi</p>
    </div>
    
    <div class="game-card">
        <h3>📖 Gry oparte na mandze</h3>
        <p>Gry znane z serii anime i mangi.</p>
        <p><strong>Przykłady:</strong> Dragon Ball, One Piece, Naruto</p>
    </div>
    
    <div class="game-card">
        <h3>🎮 Indie Japońskie</h3>
        <p>Niezależne gry od japońskich deweloperów.</p>
        <p><strong>Polecane:</strong> To The Moon, Celeste, Hollow Knight</p>
    </div>
    
    <h3>🆓 Darmowe Tytuły</h3>
    <ul>
        <li>DDLC (Doki Doki Literature Club)</li>
        <li>Katawa Shoujo</li>
        <li>The Letter</li>
        <li>Yume Nikki</li>
    </ul>
</body>
</html>
EOF
    
    echo -e "${GREEN}✅ Strona wygenerowana! Otwórz: $WEB_ROOT/index.html${NC}"
}

# Funkcja: Sprawdź status gry (legalność)
check_game_status() {
    echo -e "${PURPLE}🔍 Sprawdzam status gry...${NC}"
    
    read -p "Podaj nazwę gry: " game_name
    
    if grep -q "\"$game_name\"" "$CATALOG_FILE"; then
        local status=$(jq -r ".[] | select(.name==\"$game_name\") | .legal" "$CATALOG_FILE")
        if [[ "$status" == "true" ]]; then
            echo -e "${GREEN}✅ '$game_name' jest legalna! Źródło: $(jq -r '.[] | select(.name==\"$game_name\") | .source' "$CATALOG_FILE")${NC}"
        else
            echo -e "${RED}❌ '$game_name' ma status nielegalny!${NC}"
        fi
    else
        echo -e "${YELLOW}❓ '$game_name' nie znaleziona w katalogu${NC}"
    fi
}

# Funkcja: Pokaz japońskie "vibe" (losowa gra)
show_random_vibe() {
    echo -e "${PURPLE}🎲 Losowy japoński vibe:${NC}"
    
    local vibes=(
        "🌸 Sakura no Umi - visual novel o miłości w Kioto"
        "🥷 Shinobi Quest - gra stealth w feudalnej Japonii"
        "📚 Tokyo Stories - zbiór opowiadań interaktywnych"
        "🍜 Ramen Master - symulator gotowania ramenu"
        "🎌 Bushido Code - gra o samurajskim kodeksie honoru"
    )
    
    local random_vibe="${vibes[$RANDOM % ${#vibes[@]}]}"
    echo -e "${CYAN}$random_vibe${NC}"
}
# random losowanie 
generate_game_ideas() {
    echo -e "${PURPLE}💡 Generuję pomysły na gry w japońskim stylu...${NC}"
    
    local themes=("sakura" "samurai" "tokyo" "ryokan" "shinto" "sumo" "hanami")
    local genres=("visual novel" "rpg" "puzzle" "platformer" "simulator")
    
    local theme="${themes[$RANDOM % ${#themes[@]}]}"
    local genre="${genres[$RANDOM % ${#genres[@]}]}"
    
    echo -e "${CYAN}🎮 Pomysł: $theme $genre!${NC}"
    echo "   Opis: Gra osadzona w japońskim klimacie $theme"
}

# Główne menu
echo -e "${PURPLE}=== AREKBOX VIBE KEEPER 🎌 ===${NC}"
echo "1) Dodaj legalne źródła japońskich gier"
echo "2) Szukaj gier na legalnych platformach"
echo "3) Organizuj bibliotekę japońskiego vibe"
echo "4) Generuj stronę WWW"
echo "5) Sprawdź status gry"
echo "6) Pokaz losowy japoński vibe"
echo "7) Pokaz całą kolekcję"
echo "0) Wyjście"
read -p "Wybierz opcję: " choice

case $choice in
    1) add_legal_sources ;;
    2) search_legal_games ;;
    3) organize_vibe_library ;;
    4) generate_vibe_website ;;
    5) check_game_status ;;
    6) show_random_vibe ;;
    7)
        echo -e "${PURPLE}📚 Twoja kolekcja japońskiego vibe:${NC}"
        jq -r '.[] | "🎮 \(.name) (\(.type)) - Legalne: \(.legal)"' "$CATALOG_FILE"
        ;;
    0) exit 0 ;;
    *) echo -e "${RED}Nieznana opcja!${NC}" ;;
esac
