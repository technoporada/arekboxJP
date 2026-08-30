#!/bin/bash
# arekbox_privacy_guardian.sh - Zatrzymaj wyciek i śledzenie!
# Wymaga: Pi-hole, uBlock Origin, hosts

echo -e "${RED}🛡️ ZABLOKUJ WYCIEK I ŚLEDZENIE!${NC}"
echo ""
echo "1️⃣ **Poziom sieciowy (dla całej sieci):**"
echo "   - Pi-hole (blokuje reklamy i śledzenie na poziomie DNS)"
echo "   - Instalacja: curl -sSL https://install.pi-hole.net | bash"
echo "   - Konfiguracja: http://pi.hole/admin"
echo ""
echo "2️⃣ Poziom przeglądarki (dla Ciebie):"
echo "   - uBlock Origin (blokuje reklamy, skrypty śledzące)"
echo "   - Privacy Badger (blokuje śledzenie)"
echo "   - Decentraleyes (blokuje wyciek do firm trzecich)"
echo ""
echo "3️⃣ Poziom systemowy (dla zaawansowanych):"
echo "   - /etc/hosts (blokuje serwery reklamowe)"
echo "   - Dnscrypt-proxy (domyślny DNS)"
echo "   - Firewall (blokuje połączenia do znanych serwerów śledzących)"
echo ""
echo -e "${GREEN}✅ Efekt: Cisza, prywatność, zero wycieku!${NC}"
