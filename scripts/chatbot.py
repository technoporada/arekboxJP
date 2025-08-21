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
