🎯 Jak to działa? (Twoje skrypty → Twoja dystrybucja)
Krok 1: Przygotowanie
bash

Line Wrapping

Collapse
Copy
1
2
3
# Uruchom narzędzie:
./arekbox_linux_builder.sh
# Wybierz "1" → Sprawdź zależności (zainstaluje brakujące pakiety)
Krok 2: Budowa systemu
bash

Line Wrapping

Collapse
Copy
1
2
3
# Wybierz "2" → Stwórz bazowy system (minimalny Debian)
# Wybierz "3" → Dodaj Twoje skrypty z /home/arekbox/
# Wybierz "4" → Skonfiguruj użytkownika, usługi
Krok 3: Tworzenie ISO
bash

Line Wrapping

Collapse
Copy
1
2
# Wybierz "5-7" → Stwórz system Live i obraz ISO
# Efekt: arekbox-linux-20250417.iso
Krok 4: Testowanie
bash

Line Wrapping

Collapse
Copy
1
2
# Wybierz "8" → Testuj ISO w QEMU (wirtualna maszyna)
# Możesz też nagrać ISO na pendrive i uruchomić na prawdziwym PC!
