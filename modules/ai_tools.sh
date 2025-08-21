#!/usr/bin/env bash
# AI Tools Module - Poprawiony (część funkcji używa funkcji z arekbox.sh jak log_action i pause)

ai_tools_menu() {
  while true; do
    clear
    echo -e "${CYAN}=== AI TOOLS MENU ===${NC}"
    echo "1) Zainstaluj Ollama"
    echo "2) Zarządzaj modelami Ollama"
    echo "3) Uruchom interfejs webowy Ollama"
    echo "4) Zainstaluj Open WebUI (Docker)"
    echo "5) TTS Tools (espeak, festival, pyttsx3, gTTS)"
    echo "6) Zainstaluj Whisper (OpenAI)"
    echo "7) OSINT Tools"
    echo "8) Chatbot lokalny (Python + Ollama API)"
    echo "9) Status usług AI"
    echo "10) Benchmark modeli (Ollama API)"
    echo "0) Powrót do menu głównego"
    read -r -p "Wybierz opcję: " choice
    case "$choice" in
      1) install_ollama ;;
      2) manage_ollama_models ;;
      3) run_ollama_webui ;;
      4) install_open_webui ;;
      5) install_tts_tools ;;
      6) install_whisper ;;
      7) osint_tools_menu ;;
      8) run_local_chatbot ;;
      9) check_ai_services ;;
      10) benchmark_models ;;
      0) return ;;
      *) echo -e "${RED}Niepoprawna opcja!${NC}"; pause ;;
    esac
  done
}

install_ollama() {
  echo -e "${CYAN}Instalacja Ollama...${NC}"
  log_action "Rozpoczęto instalację Ollama"
  if command -v ollama &> /dev/null; then
    echo -e "${YELLOW}Ollama jest już zainstalowana.${NC}"
    ollama --version 2>/dev/null || true
    pause
    return
  fi
  if curl -fsSL https://ollama.com/install.sh | sh; then
    echo -e "${GREEN}Ollama zainstalowana pomyślnie!${NC}"
    log_action "Ollama zainstalowana"
  else
    echo -e "${RED}Błąd instalacji Ollama${NC}"
    log_action "Błąd instalacji Ollama"
    pause
    return
  fi
  # Opcjonalne włączenie usługi, jeśli istnieje
  if command -v systemctl &> /dev/null; then
    sudo systemctl enable --now ollama 2>/dev/null || true
  fi
  pause
}

manage_ollama_models() {
  while true; do
    clear
    echo -e "${CYAN}=== ZARZĄDZANIE MODELAMI OLLAMA ===${NC}"
    echo "1) Lista zainstalowanych modeli"
    echo "2) Pobierz nowy model"
    echo "3) Usuń model"
    echo "4) Uruchom model interaktywnie"
    echo "5) Popularne modele do pobrania"
    echo "6) Aktualizuj model"
    echo "7) Informacje o modelu"
    echo "0) Powrót"
    read -r -p "Wybierz opcję: " choice
    case "$choice" in
      1) echo -e "${CYAN}Zainstalowane modele:${NC}"; ollama list 2>/dev/null || echo "Brak wyników"; pause ;;
      2) read -r -p "Nazwa modelu (np. llama3.2:1b): " model; [[ -n "$model" ]] && (ollama pull "$model" && log_action "Pobrano model: $model") || true; pause ;;
      3) ollama list 2>/dev/null; read -r -p "Nazwa modelu do usunięcia: " model; if [[ -n "$model" ]]; then read -r -p "Czy na pewno usunąć $model? (y/N): " confirm; if [[ "$confirm" =~ ^[Yy]$ ]]; then ollama rm "$model" && log_action "Usunięto model: $model"; fi; fi; pause ;;
      4) ollama list 2>/dev/null; read -r -p "Nazwa modelu do uruchomienia: " model; [[ -n "$model" ]] && ollama run "$model";;
      5) echo -e "${YELLOW}Popularne modele:${NC}"; echo "- llama3.2:1b, phi3:mini, qwen2.5:0.5b, llama3.2:3b, mistral:7b"; pause ;;
      6) ollama list 2>/dev/null; read -r -p "Nazwa modelu do aktualizacji: " model; [[ -n "$model" ]] && (ollama pull "$model" && log_action "Zaktualizowano model: $model"); pause ;;
      7) ollama list 2>/dev/null; read -r -p "Nazwa modelu: " model; [[ -n "$model" ]] && ollama show "$model" || true; pause ;;
      0) return ;;
      *) echo "Niepoprawna opcja"; pause ;;
    esac
  done
}

run_ollama_webui() {
  echo -e "${CYAN}Informacje o interfejsie webowym Ollama:${NC}"
  echo "Ollama API: http://localhost:11434"
  if curl -s --connect-timeout 3 http://localhost:11434/api/tags > /dev/null; then
    echo -e "${GREEN}✓ API Ollama jest dostępne!${NC}"
  else
    echo -e "${RED}✗ API Ollama nie jest dostępne!${NC}"
    echo "Sprawdź: systemctl status ollama"
  fi
  pause
}

install_open_webui() {
  echo -e "${CYAN}Instalacja Open WebUI (Docker)...${NC}"
  if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker nie jest zainstalowany. Instaluję...${NC}"
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker "$USER" 2>/dev/null || true
    echo -e "${YELLOW}Docker zainstalowany. Wyloguj się i zaloguj ponownie, aby zmiany w grupie docker zaczęły działać.${NC}"
    pause
    return
  fi
  if docker ps -a --format '{{.Names}}' | grep -q open-webui; then
    echo -e "${YELLOW}Open WebUI już istnieje. Uruchamiam...${NC}"
    docker start open-webui || true
  else
    echo -e "${CYAN}Pobieranie i uruchamianie Open WebUI...${NC}"
    docker run -d \
      -p 3000:8080 \
      --add-host=host.docker.internal:host-gateway \
      -v open-webui:/app/backend/data \
      --name open-webui \
      --restart always \
      ghcr.io/open-webui/open-webui:main || true
  fi
  sleep 5
  if docker ps --format '{{.Names}}' | grep -q open-webui; then
    echo -e "${GREEN}✓ Open WebUI uruchomione na http://localhost:3000${NC}"
    log_action "Open WebUI uruchomione"
  else
    echo -e "${RED}✗ Błąd uruchamiania Open WebUI${NC}"
    docker logs open-webui 2>/dev/null || true
  fi
  pause
}

install_tts_tools() {
  echo -e "${CYAN}Instalacja narzędzi TTS...${NC}"
  sudo apt update
  sudo apt install -y espeak festival espeak-ng-data mpv || true
  pip3 install --user pyttsx3 gTTS || true

  # Skrypt pomocniczy pyttsx3
  cat > ~/arekbox/scripts/tts_test.py <<'PYEOF'
#!/usr/bin/env python3
import pyttsx3, sys, os

def speak_text(text, rate=150):
    try:
        engine = pyttsx3.init()
        engine.setProperty('rate', rate)
        voices = engine.getProperty('voices')
        for voice in voices:
            if 'pl' in voice.id.lower() or 'polish' in voice.name.lower():
                engine.setProperty('voice', voice.id)
                break
        engine.say(text)
        engine.runAndWait()
        return True
    except Exception as e:
        print(f"Blad TTS: {e}")
        return False

def main():
    if len(sys.argv) > 1:
        text = " ".join(sys.argv[1:])
    else:
        text = "Witaj w ArekBox TTS"
    print(f"Wypowiadam: {text}")
    if not speak_text(text):
        os.system(f"echo '{text}' | espeak -v pl")

if __name__ == "__main__":
    main()
PYEOF
  chmod +x ~/arekbox/scripts/tts_test.py

  # Skrypt bashowy TTS
  cat > ~/arekbox/scripts/tts.sh <<'TTSEOF'
#!/bin/bash
if [ -z "$1" ]; then
    echo "Użycie: $0 [opcje] 'tekst'"
    exit 1
fi
ENGINE="espeak"
SPEED=150
VERBOSE=false
TEXT=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -e) ENGINE="espeak"; shift ;;
        -f) ENGINE="festival"; shift ;;
        -p) ENGINE="pyttsx3"; shift ;;
        -g) ENGINE="gtts"; shift ;;
        -s) SPEED="$2"; shift 2 ;;
        -v) VERBOSE=true; shift ;;
        *) TEXT="$*"; break ;;
    esac
done
if [[ "$VERBOSE" == true ]]; then
    echo "Silnik: $ENGINE"
    echo "Prędkość: $SPEED"
    echo "Tekst: $TEXT"
fi
case $ENGINE in
    espeak)
        echo "$TEXT" | espeak -s "$SPEED" -v pl
        ;;
    festival)
        echo "$TEXT" | festival --tts
        ;;
    pyttsx3)
        python3 ~/arekbox/scripts/tts_test.py "$TEXT"
        ;;
    gtts)
        python3 - <<'PYG'
from gtts import gTTS
import os, tempfile, sys
text = sys.argv[1]
tts = gTTS(text=text, lang='pl')
with tempfile.NamedTemporaryFile(suffix='.mp3', delete=False) as tmp:
    tts.save(tmp.name)
    os.system(f'mpv --really-quiet {tmp.name}')
    os.unlink(tmp.name)
PYG
        ;;
esac
TTSEOF
  chmod +x ~/arekbox/scripts/tts.sh

  echo -e "${GREEN}TTS Tools zainstalowane (częściowo).${NC}"
  log_action "TTS Tools zainstalowane"
  pause
}

install_whisper() {
  echo -e "${CYAN}Instalacja Whisper (OpenAI) w wenv...${NC}"
  python3 -m venv ~/arekbox/venvs/whisper || true
  # Aktywacja i instalacja
  # shellcheck disable=SC1090
  source ~/arekbox/venvs/whisper/bin/activate 2>/dev/null || true
  pip install --upgrade pip || true
  pip install openai-whisper || true
  read -r -p "Zainstalować też faster-whisper? (y/N): " install_faster
  if [[ "$install_faster" =~ ^[Yy]$ ]]; then
    pip install faster-whisper || true
  fi
  deactivate 2>/dev/null || true

  # Wrapper script
  cat > ~/arekbox/scripts/whisper.sh <<'WHEOF'
#!/bin/bash
if [ -z "$1" ]; then
    echo "Użycie: $0 [opcje] <plik_audio>"
    exit 1
fi
source ~/arekbox/venvs/whisper/bin/activate
whisper "$@" || true
deactivate
WHEOF
  chmod +x ~/arekbox/scripts/whisper.sh

  echo -e "${GREEN}Whisper (w venv) przygotowany.${NC}"
  log_action "Whisper zainstalowany"
  pause
}

benchmark_models() {
  echo -e "${CYAN}Benchmark modeli Ollama...${NC}"
  if ! curl -s --connect-timeout 3 http://localhost:11434/api/tags > /dev/null; then
    echo -e "${RED}Ollama API niedostępne - uruchom Ollama najpierw.${NC}"
    pause
    return
  fi
  read -r -p "Podaj modele do testowania (oddzielone spacją): " models
  if [[ -z "$models" ]]; then echo -e "${RED}Brak modeli${NC}"; pause; return; fi
  TEST_PROMPT="Explain quantum computing in simple terms."
  for model in $models; do
    echo -e "${YELLOW}Test dla: $model${NC}"
    start_time=$(date +%s.%N)
    response=$(curl -s -X POST http://localhost:11434/api/generate -d "{\"model\":\"$model\",\"prompt\":\"$TEST_PROMPT\",\"stream\":false}" 2>/dev/null)
    end_time=$(date +%s.%N)
    duration=$(echo "$end_time - $start_time" | bc -l)
    if [[ -n "$response" ]]; then
      echo -e "${GREEN}✓ Odpowiedź otrzymana (czas: ${duration}s)${NC}"
      echo "$response" | jq -r '.response' 2>/dev/null | head -c 300 || echo "$response" | head -c 300
    else
      echo -e "${RED}✗ Brak odpowiedzi${NC}"
    fi
    echo "----"
  done
  pause
}

osint_tools_menu() {
  echo -e "${CYAN}OSINT Tools - placeholder${NC}"
  echo "Tu można dodać narzędzia OSINT (recon-ng, theHarvester, etc.)"
  pause
}

run_local_chatbot() {
  echo -e "${CYAN}Przygotowuję lokalnego chatbota (Python) korzystającego z Ollama API...${NC}"
  mkdir -p ~/arekbox/scripts
  cat > ~/arekbox/scripts/chatbot.py <<'PYCHAT'
#!/usr/bin/env python3
import requests, json, sys, time

API = "http://localhost:11434"

def get_available_models():
    try:
        r = requests.get(f"{API}/api/tags", timeout=5)
        r.raise_for_status()
        data = r.json()
        models = []
        # Różne formaty odpowiedzi - próbujemy wydobyć nazwy
        if isinstance(data, dict):
            if 'models' in data and isinstance(data['models'], list):
                for m in data['models']:
                    if isinstance(m, dict) and 'name' in m:
                        models.append(m['name'])
                    else:
                        models.append(str(m))
            else:
                for k, v in data.items():
                    models.append(str(k))
        elif isinstance(data, list):
            for item in data:
                if isinstance(item, dict) and 'name' in item:
                    models.append(item['name'])
                else:
                    models.append(str(item))
        return models
    except Exception as e:
        print(f"Blad pobierania modeli: {e}")
        return []

def chat_with_ollama(model, prompt, context=None):
    url = f"{API}/api/generate"
    payload = {"model": model, "prompt": prompt, "stream": False}
    if context:
        payload["context"] = context
    try:
        r = requests.post(url, json=payload, timeout=60)
        r.raise_for_status()
        data = r.json()
        # Próbujemy zwrócić sensowny fragment
        if isinstance(data, dict):
            if 'response' in data:
                return data.get('response',''), data.get('context', None)
            if 'choices' in data and len(data['choices'])>0:
                choice = data['choices'][0]
                if isinstance(choice, dict):
                    return choice.get('content', choice.get('text', '')), data.get('context', None)
        return json.dumps(data), None
    except requests.exceptions.Timeout:
        return "Timeout - model zbyt długo odpowiada", None
    except Exception as e:
        return f"Blad polaczenia: {e}", None

def main():
    print("=== ArekBox AI Chatbot ===")
    models = get_available_models()
    if not models:
        print("Brak dostępnych modeli. Upewnij się, że Ollama działa.")
        return
    print("Dostępne modele:")
    for i,m in enumerate(models):
        print(f"{i+1}. {m}")
    choice = input("Wybierz model (numer lub wpisz nazwę) [enter=1]: ").strip()
    if choice.isdigit():
        try:
            model = models[int(choice)-1]
        except Exception:
            model = models[0]
    elif choice == "":
        model = models[0]
    else:
        model = choice if choice in models else models[0]
    print(f"Używam modelu: {model}")
    print("Wpisz 'quit' / 'exit' / 'q' aby zakończyć. /help dla komend.")
    context = None
    while True:
        try:
            user_input = input("\nTy: ").strip()
            if user_input.lower() in ['quit','exit','q']:
                print("Do widzenia!")
                break
            if user_input == '/help':
                print("/help - pomoc\n/models - lista modeli\n/switch - zmień model\n/clear - wyczyść kontekst\n/context - pokaż kontekst")
                continue
            if user_input == '/models':
                models = get_available_models()
                print("Modele:")
                for i,m in enumerate(models):
                    print(f"{i+1}. {m}")
                continue
            if user_input == '/switch':
                models = get_available_models()
                for i,m in enumerate(models):
                    print(f"{i+1}. {m}")
                ch = input("Numer modelu: ").strip()
                try:
                    model = models[int(ch)-1]
                    context = None
                    print(f"Przełączono na: {model}")
                except Exception:
                    print("Nieprawidłowy wybór")
                continue
            if user_input == '/clear':
                context = None
                print("Kontekst wyczyszczony")
                continue
            if user_input == '/context':
                print(f"Kontekst: {context}")
                continue
            print("... czekam na odpowiedź modelu ...")
            resp, new_context = chat_with_ollama(model, user_input, context)
            print(f"\nModel: {resp}\n")
            if new_context is not None:
                context = new_context
        except KeyboardInterrupt:
            print("\nPrzerywam. Do widzenia!")
            break
        except Exception as e:
            print(f"Błąd: {e}")
            time.sleep(0.5)

if __name__ == "__main__":
    main()
PYCHAT
  chmod +x ~/arekbox/scripts/chatbot.py
  echo -e "${GREEN}Chatbot gotowy. Uruchamiam...${NC}"
  python3 ~/arekbox/scripts/chatbot.py
  pause
}

check_ai_services() {
  echo -e "${CYAN}Sprawdzanie usług AI (Ollama)...${NC}"
  if curl -s --connect-timeout 3 http://localhost:11434/api/tags > /dev/null; then
    echo -e "${GREEN}Ollama API dostępne${NC}"
  else
    echo -e "${RED}Ollama API niedostępne${NC}"
  fi
  pause
}
