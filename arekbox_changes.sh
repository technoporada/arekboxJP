#!/bin/bash
# arekbox_changes.sh - Zapisuj zmiany po Twojemu
# Działa jak prosty dziennik

LOG_DIR="$HOME/.arekbox_logs"
mkdir -p "$LOG_DIR"

echo "$(date): Zmieniam koncept $1" >> "$LOG_DIR/changes.log"
echo "$(date): Testuję narzędzie: $2" >> "$LOG_DIR/tests.log"
echo "$(date): Żart: $3" >> "$LOG_DIR/jokes.log"  # Bo żarty też są ważne!
