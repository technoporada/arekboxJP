	

echo "Nagrywaj komendę (max 5 sekund)..."
arecord -d 5 komenda.wav

# Krok 1: Rozpoznaj mowę LOKALNIE (Whisper)
tekst=$(whisper komenda.wav --model tiny --language pl --output_format txt)

# Krok 2: Przekaż do asystenta LOKALNEGO (Vosk)
# (Tu Vosk analizuje intencję komendy)
intencja=$(echo "$tekst" | python3 vosk_analizuj.py)

# Krok 3: Wykonaj komendę (Twoje skrypty!)
case "$intencja" in
    "muzyka") 
        url=$(echo "$tekst" | grep -oP 'https?://\S+')
        spotDL "$url"
        ;;
    "temperatura") 
        sensors | grep 'Core 0'
        ;;
    "czyszczenie") 
        sudo apt autoremove -y
        ;;
    *) echo "Nie rozumiem: $tekst" ;;
esac

# Krok 4: Odpowiedź głosem (eSpeak)
echo "Wykonano: $tekst" | espeak -v pl
