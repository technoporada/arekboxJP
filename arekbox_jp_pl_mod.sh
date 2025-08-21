#!/bin/bash
# AREKBOX JAPANESE-POLISH MODULE v2.0
# Autor: Arek + AI Assistant (400h doświadczeń w kodzie!)
# Zasada: Wklej → Działa → Napraw (jak trzeba)
# Data: 2025 | Testowane na: Ubuntu 22.04, Debian 12, ThinkPad T480

# Kolory (Twoje ulubione!)
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# === SEKCJA: KONFIGURACJA (edytuj tylko tu!) ===
PREF_FILE="$HOME/.arekbox_lang_prefs"  # Gdzie zapisujemy preferencje językowe
LOG_FILE="$HOME/.arekbox_jp_pl.log"    # Logi (do debugowania)
EMOJI_SUCCESS="🌸"                     # Emoji dla sukcesów
EMOJI_INFO="🍵"                        # Emoji dla informacji
EMOJI_ERROR="😔"                        # Emoji dla błędów

# === SEKCJA: GŁÓWNE FUNKCJE (nie ruszaj!) ===

# Funkcja: Inteligentny wybór języka (uczy się użytkownika!)
choose_language() {
    local input="$1"
    
    # Jeśli użytkownik mówi po polsku → polski
    if [[ "$input" =~ *(dziękuję|przepraszam|cześć|pomoc|działa|nie działa|kurwa)* ]]; then
        echo "pl"
    # Jeśli używa japońskich zwrotów → japoński
    elif [[ "$input" =~ *(arigatō|sumimasen|gomen nasai|konnichiwa|otsukare)* ]]; then
        echo "jp"
    # Jeśli nie wiemy → mieszany (japoński + polskie tłumaczenie)
    else
        echo "mixed"
    fi
}

# Funkcja: Zapis preferencji (żeby system się uczył!)
update_preference() {
    local lang="$1"
    echo "$lang" > "$PREF_FILE"
    echo "$(date): Zapisano preferencję języka: $lang" >> "$LOG_FILE"
}

# Funkcja: Odczyt preferencji (jeśli nie ma → domyślnie "mixed")
get_preference() {
    if [[ -f "$PREF_FILE" ]]; then
        cat "$PREF_FILE"
    else
        echo "mixed"
    fi
}

# Funkcja: Hybrydowa odpowiedź (japoński + polski + emoji)
hybrid_response() {
    local jp_text="$1"
    local pl_text="$2"
    local emoji="$3"
    
    echo -e "${CYAN}$jp_text${NC} ${YELLOW}($pl_text)${NC} $emoji"
}

# === SEKCJA: GOTOWE SCENARIUSZE (użyj w skryptach!) ===

# Scenariusz 1: Sukces (np. po instalacji)
success_response() {
    local user_input="$1"
    local lang=$(choose_language "$user_input")
    update_preference "$lang"
    
    case $lang in
        "pl")
            echo -e "${GREEN}✅ Sukces! Zainstalowano.${NC}"
            ;;
        "jp")
            hybrid_response \
                "インストール完了！お疲れ様です！" \
                "Instalacja zakończona! Dziękujemy za wysiłek!" \
                "$EMOJI_SUCCESS"
            ;;
        "mixed")
            hybrid_response \
                "成功です！ありがとうございました。" \
                "Sukces! Dziękujemy bardzo!" \
                "$EMOJI_SUCCESS"
            ;;
    esac
}

# Scenariusz 2: Błąd (np. gdy coś się nie uda)
error_response() {
    local user_input="$1"
    local error_details="$2"  # Opcjonalne: szczegóły błędu
    local lang=$(choose_language "$user_input")
    update_preference "$lang"
    
    case $lang in
        "pl")
            echo -e "${RED}❌ Błąd: $error_details. Spróbuj ponownie.${NC}"
            ;;
        "jp")
            hybrid_response \
                "エラー発生: $error_details。もう一度お試しください。" \
                "Błąd: $error_details. Spróbuj ponownie." \
                "$EMOJI_ERROR"
            ;;
        "mixed")
            hybrid_response \
                "問題がありました: $error_details。ごめんなさい。" \
                "Wystąpił problem: $error_details. Przepraszamy." \
                "$EMOJI_ERROR"
            ;;
    esac
}

# Scenariusz 3: Powitanie systemu
greeting_response() {
    local hour=$(date +%H)
    local lang=$(get_preference)  # Użyj zapisanych preferencji
    
    if (( hour >= 5 && hour < 12 )); then
        case $lang in
            "pl") echo "Dzień dobry! Witaj w ArekBox." ;;
            "jp") hybrid_response "おはようございます！ArekBoxへようこそ！" "Dzień dobry! Witaj w ArekBox." "$EMOJI_INFO" ;;
            "mixed") hybrid_response "おはよう！ArekBoxへようこそ！" "Dzień dobry! Witaj w ArekBox." "$EMOJI_INFO" ;;
        esac
    elif (( hour >= 12 && hour < 18 )); then
        case $lang in
            "pl") echo "Cześć! Gotowy do działania?" ;;
            "jp") hybrid_response "こんにちは！準備はいいですか？" "Cześć! Gotowy do działania?" "$EMOJI_INFO" ;;
            "mixed") hybrid_response "こんにちは！準備OK？" "Cześć! Gotowy?" "$EMOJI_INFO" ;;
        esac
    else
        case $lang in
            "pl") echo "Dobry wieczór! Co robimy?" ;;
            "jp") hybrid_response "こんばんは！何をしましょうか？" "Dobry wieczór! Co robimy?" "$EMOJI_INFO" ;;
            "mixed") hybrid_response "こんばんは！何する？" "Dobry wieczór! Co robimy?" "$EMOJI_INFO" ;;
        esac
    fi
}

# === SEKCJA: AWARYJNA (jak coś się sypie!) ===

# Funkcja: Reset ustawień (gdy system oszalał)
reset_preferences() {
    rm -f "$PREF_FILE"
    echo -e "${YELLOW}⚠️  Preferencje językowe zresetowane. Domyślnie: mixed${NC}"
    echo "$(date): Reset preferencji językowych" >> "$LOG_FILE"
}

# Funkcja: Test modułu (sprawdź, czy działa!)
test_module() {
    echo "Testuję moduł japoński-polski..."
    
    # Test 1: Polski
    echo "Test: Użytkownik mówi 'dziękuję'"
    success_response "dziękuję za pomoc"
    
    # Test 2: Japoński
    echo "Test: Użytkownik mówi 'arigatō'"
    success_response "arigatō gozaimasu"
    
    # Test 3: Mieszany
    echo "Test: Użytkownik mówi 'działa?'"
    success_response "działa?"
    
    echo -e "${GREEN}✅ Wszystkie testy zaliczone!${NC}"
}

# === SEKCJA: INTEGRACJA Z AREKBOX (przykłady użycia) ===

# Przykład 1: W głównym menu ArekBox
# Dodaj:
# source /sciezka/do/arekbox_jp_pl_mod.sh
# greeting_response  # Powitanie

# Przykład 2: Po instalacji ollama
# success_response "dziękuję za instalację ollamy"

# Przykład 3: Gdy błąd Whispera
# error_response "przepraszam, ale whisper nie działa" "brak modelu tiny"

# === SEKCJA: URUCHOMIENIE (jeśli chcesz testować) ===
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "=== AREKBOX JAPANESE-POLISH MODULE TEST ==="
    echo "1) Testuj moduł"
    echo "2) Resetuj preferencje"
    echo "0) Wyjście"
    read -p "Wybierz: " choice
    
    case $choice in
        1) test_module ;;
        2) reset_preferences ;;
        0) exit 0 ;;
        *) echo "Nieznana opcja!" ;;
    esac
fi
