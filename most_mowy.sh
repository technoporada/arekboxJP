#!/bin/bash
# most_mowy.sh - Google Docs + Asystent Głosowy = Twoje komendy!
echo "Nagrywaj komendę (max 10 sekund)..."
arecord -d 10 komenda.wav

# Krok 1: Wyślij do Google Docs (rozpoznawanie mowy)
# Użyj gdrive (narzędzie do Google Drive)
gdrive upload komenda.wav --share

# Krok 2: Pobierz rozpoznany tekst (Google Docs automatycznie transkrybuje!)
# (Tu potrzebujesz API Google Docs - uproszczony przykład)
tekst=$(gdrive list --query "name contains 'komenda.wav'" --format "json" | jq -r '.[].name')

# Krok 3: Przekaż do asystenta głosowego (np. Google Assistant)
# Użyj `google-assistant` SDK
google-assistant --command "$tekst"

# Krok 4: Wykonaj komendę (jeśli to np. "spotDL [URL]")
if [[ "$tekst" == *"spotDL"* ]]; then
    url=$(echo "$tekst" | awk '{print $2}')
    spotDL "$url"
fi
# Jeśli Google Docs zawiedzie...
if [[ -z "$tekst" ]]; then
    tekst=$(whisper komenda.wav --language pl --model tiny)
fi
# Odpowiedź w japońskim
echo "$tekst" | espeak -v ja

echo "$(date): $tekst" >> ~/most_mowy.log
