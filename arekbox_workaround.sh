#!/bin/bash
# arekbox_workaround.sh - Obejścia dla zepsutych systemów
# Przykład: Whisper działa tylko z modelem "tiny" (bo "base" zawiesza system)

# Zamiast: whisper --model base plik.wav
# Robisz: whisper --model tiny plik.wav --output_format txt

# Zamiast: sudo systemctl start ollama
# Robisz: ollama serve > /dev/null 2>&1 &  # Bez logów, bo crashują system

# Zamiast: apt install ollama
# Robisz: curl -fsSL https://ollama.com/install.sh | sh  # Bo repo jest zepsute
