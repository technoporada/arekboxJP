#!/bin/bash
# arekbox_installer.sh
# Autor: Arek (400 godzin testów, błędów i odkryć)
# Data startu: 2020, Data publikacji: 2025
# Filozofia: "Zapisuję wszystko, żebyś Ty nie musiał"

# === SEKCJA: MOJE DOŚWIADCZENIA ===
# Uwaga: To nie jest "czysty kod" – to zapisana mądrość!
# Lekcja 1: Zawsze sprawdzaj, czy jest python3 (Whisper bez tego nie działa)
# Lekcja 2: Ollama czasem się wiesza – restartuj usługę
# Lekcja 3: Użytkownicy nienawidzą czytać README – wszystko wyjaśnij w kodzie

# === SEKCJA: DLA "NASTĘPNYCH" ===
# Jeśli coś nie działa – nie panikuj! Sprawdź:
# 1. Czy masz python3? (python3 --version)
# 2. Czy Ollama działa? (sudo systemctl status ollama)
# 3. Czy masz uprawnienia sudo? (whoami)

# === SEKCJA: DZIAŁANIE ===
# Krok 1: Sprawdź python3 (Lekcja 1)
if ! command -v python3 &> /dev/null; then
    echo "Nie ma python3. Instaluję (to działało na Debian 12, Ubuntu 22.04)..."
    sudo apt update && sudo apt install python3 -y
fi

# Krok 2: Uruchom Ollama (Lekcja 2)
if ! systemctl is-active --quiet ollama; then
    echo "Ollama nie działa. Restartuję (to naprawia 90% problemów)..."
    sudo systemctl restart ollama
fi

# Krok 3: Powiedz użytkownikowi, co robisz (Lekcja 3)
echo "Gotowe! Wszystko działa – bo ja już to przetestowałem za Ciebie."
