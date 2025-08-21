#!/bin/bash
# arekbox_media_manager.sh - Zarządzaj legalnymi źródłami multimediów
# Wspiera: Kodi, Plex, darmowe platformy VOD

# Konfiguracja
MEDIA_DIR="$HOME/arekbox_media"
SOURCES_FILE="$MEDIA_DIR/sources.txt"

# Funkcja: Dodaj legalne źródło
add_source() {
    echo "Dostępne legalne źródła:"
    echo "1) Kodi (dodatki legalne)"
    echo "2) Plex (własna biblioteka)"
    echo "3) Darmowe platformy (Tubi, Pluto TV)"
    echo "4) Biblioteki publiczne"
    
    read -p "Wybierz źródło: " choice
    case $choice in
        1) echo "kodi" >> "$SOURCES_FILE" ;;
        2) echo "plex" >> "$SOURCES_FILE" ;;
        3) echo "tubi" >> "$SOURCES_FILE" ;;
        4) echo "publiczne" >> "$SOURCES_FILE" ;;
    esac
}
# Funkcja: Organizuj pliki z legalnych źródeł
organize_media() {
    find "$MEDIA_DIR" -name "*.mkv" -o -name "*.mp4" | while read file; do
        # Tworzenie struktury folderów
        genre=$(ffprobe -v error -show_entries format_tags=genre "$file" 2>/dev/null | grep genre | cut -d= -f2)
        mkdir -p "$MEDIA_DIR/$genre"
        mv "$file" "$MEDIA_DIR/$genre/"
    done
}
# Funkcja: Instaluj legalne dodatki Kodi
install_kodi_addons() {
    echo "Instaluję legalne dodatki Kodi..."
    # Oficjalne repozytoria
    kodi --addon-repository install repository.kodi.tv
    kodi --addon-repository install repository.sandmann79.plugins
    
    # Darmowe dodatki
    kodi --addon-install plugin.video.youtube
    kodi --addon-install plugin.audio.soundcloud
}
