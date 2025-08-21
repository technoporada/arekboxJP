#!/bin/bash
if [ -z "$1" ]; then
    echo "Użycie: $0 [opcje] <plik_audio>"
    exit 1
fi
source ~/arekbox/venvs/whisper/bin/activate
whisper "$@" || true
deactivate
