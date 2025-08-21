#!/bin/bash
# arekbox_doc_downloader.sh - Pobieraj legalne dokumenty!
# Wymaga: yt-dlp, wget

download_documentary() {
    local url="$1"
    local title="$2"
    
    echo -e "${CYAN}📥 Pobieram: $title${NC}"
    
    # Użyj yt-dlp do legalnych źródeł
    yt-dlp -f "best" --output "$title.mp4" "$url"
    
    echo -e "${GREEN}✅ Pobrano! Plik: $title.mp4${NC}"
}

# Przykładowe użycie:
# download_documentary "https://www.youtube.com/watch?v=example" "Dokument o kosmosie"
