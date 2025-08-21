#!/bin/bash
# arekbox_blind_mode.sh - Działa jak stary ekran: nie widać, ale działa!
# Zasada: Zero wizualnego feedbacku, tylko logi i dźwięk

# Krok 1: Sprawdź, czy system w ogóle działa (bez ekranu!)
if [[ $(ping -c 1 google.com | grep "1 received") ]]; then
    echo "$(date): System działa! 🎉" >> /var/log/arekbox.log
    aplay /usr/share/sounds/success.wav  # Dźwięk potwierdzenia
else
    echo "$(date): Cos jest spierdzielone! 🔧" >> /var/log/arekbox.log
    aplay /usr/share/sounds/error.wav
fi

# Krok 2: Uruchom narzędzie (np. Ollama) "na ślepo"
ollama serve > /dev/null 2>&1 &  # Nie pokazuj outputu
echo "$(date): Ollama uruchomiona (mam nadzieję!)" >> /var/log/arekbox.log
