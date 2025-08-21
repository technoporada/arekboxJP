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
