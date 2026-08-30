#!/usr/bin/env bash

gradio_menu() {
  while true; do
    clear
    echo -e "${CYAN}=== GRADIO WEBUI ===${NC}"
    echo "1) Uruchom Ollama ChatUI"
    echo "2) Uruchom Custom UI"
    echo "3) Zainstaluj wymagania"
    echo "0) Powrót"
    read -r -p "Wybierz opcję: " choice
    case "$choice" in
      1) run_ollama_gradio ;;
      2) run_custom_gradio ;;
      3) install_gradio_deps ;;
      0) return ;;
      *) echo -e "${RED}Błąd!${NC}"; pause ;;
    esac
  done
}

install_gradio_deps() {
  pip3 install --user gradio ollama transformers
}

run_ollama_gradio() {
  python3 - <<'PYGR'
import gradio as gr
from ollama import Client

client = Client()

def chat(model, message):
    response = client.generate(model=model, prompt=message)
    return response['response']

iface = gr.Interface(
    fn=chat,
    inputs=["text", "text"],
    outputs="text",
    title="Ollama Gradio Chat"
)
iface.launch()
PYGR
}

run_custom_gradio() {
  echo "=== WŁASNE INTERFEJSY GRADIO ==="
  echo "Tu możesz dodać własne interfejsy Gradio."
  echo "Przykład: wywołaj swój skrypt npx/python i otwórz w przeglądarce."
  read -r -p "Naciśnij Enter, aby wrócić..."
}
