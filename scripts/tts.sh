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
