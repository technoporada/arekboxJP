#!/bin/bash
# check_common_errors.sh - Sprawdź typowe "ArekBox'owe błędy"
# Bo wiesz, że zawsze ten sam błąd powraca!

# Błąd 1: Brak uprawnień sudo
if ! sudo -n true; then
    echo "🔴 Brak sudo! Fix: sudo !!"
fi

# Błąd 2: Zła ścieżka do pliku
if [[ ! -f "$1" ]]; then
    echo "🔴 Plik $1 nie istnieje! Fix: ls -la"
fi

# Błąd 3: Usługa nie działa
if ! systemctl is-active --quiet "$2"; then
    echo "🔴 Usługa $2 nie działa! Fix: sudo systemctl restart $2"
fi
