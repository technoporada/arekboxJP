#!/bin/bash
# arek_translator.sh - Polski → Japoński (z angielskim pośrednikiem)
echo "Nagrywaj 5 sekund (po polsku)..."
arecord -d 5 test.wav  

# Krok 1: Whisper (polski → tekst)
whisper test.wav --model tiny --language pl > tekst.txt  

# Krok 2: Tłumacz (polski → angielski)
pol=$(cat tekst.txt)  
eng=$(trans -b :en "$pol")  

# Krok 3: Angielski → japoński  
jap=$(trans -b :ja "$eng")  

# Krok 4: Odtwórz japoński (TTS)
echo "$jap" | espeak -v ja  
