#!/bin/bash
# arekbox_linux_builder.sh - Zbuduj swoją dystrybucję Linuksa ze skryptów!
# Wymaga: debootstrap, squashfs-tools, xorriso
# Zasada: "Twoje skrypty = Twoja dystrybucja!"
# Autor: Arek + AI Assistant

# Konfiguracja (zmień tylko tu!)
BUILD_DIR="/tmp/arekbox-build"
ISO_DIR="$BUILD_DIR/iso"
LIVE_DIR="$BUILD_DIR/live"
FS_DIR="$BUILD_DIR/filesystem"
CUSTOM_SCRIPTS_DIR="$HOME/arekbox"  # Gdzie są Twoje skrypty?
OUTPUT_ISO="$HOME/arekbox-linux-$(date +%Y%m%d).iso"

# Kolory (Twoje ulubione!)
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Funkcja: Sprawdź zależności
check_dependencies() {
    echo -e "${CYAN}🔧 Sprawdzam zależności...${NC}"
    
    local deps=("debootstrap" "squashfs-tools" "xorriso" "syslinux-utils")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${RED}❌ Brak: $dep. Instaluję...${NC}"
            sudo apt install -y "$dep"
        else
            echo -e "${GREEN}✅ $dep jest zainstalowany${NC}"
        fi
    done
}

# Funkcja: Stwórz bazowy system (minimalny Debian)
create_base_system() {
    echo -e "${CYAN}🏗️ Tworzę bazowy system (minimalny Debian)...${NC}"
    
    mkdir -p "$FS_DIR"
    sudo debootstrap \
        --arch=amd64 \
        --variant=minbase \
        stable \
        "$FS_DIR" \
        http://deb.debian.org/debian/
    
    echo -e "${GREEN}✅ Bazowy system gotowy!${NC}"
}

# Funkcja: Dodaj Twoje skrypty do systemu
add_custom_scripts() {
    echo -e "${CYAN}📜 Dodaję Twoje skrypty do systemu...${NC}"
    
    # Katalog na Twoje skrypty
    mkdir -p "$FS_DIR/opt/arekbox"
    cp -r "$CUSTOM_SCRIPTS_DIR"/* "$FS_DIR/opt/arekbox/"
    
    # Dodaj uprawnienia
    chmod +x "$FS_DIR/opt/arekbox"/*.sh
    
    # Stwórz link w /usr/local/bin
    ln -s "$FS_DIR/opt/arekbox/arekbox_linux_builder.sh" "$FS_DIR/usr/local/bin/arekbox"
    
    echo -e "${GREEN}✅ Skrypty dodane!${NC}"
}

# Funkcja: Skonfiguruj system (użytkownik, autostart itp.)
configure_system() {
    echo -e "${CYAN}⚙️ Konfiguruję system...${NC}"
    
    # Chroot do systemu
    sudo chroot "$FS_DIR" /bin/bash <<EOF
    # Ustawienia regionalne
    echo "arekbox" > /etc/hostname
    echo "127.0.0.1 localhost arekbox" > /etc/hosts
    
    # Użytkownik
    useradd -m -s /bin/bash arek
    echo "arek:arekbox" | chpasswd
    usermod -aG sudo arek
    
    # Aktualizuj system
    apt update
    apt install -y sudo systemctl
    
    # Usługa (uruchamiająca ArekBox przy starcie)
    cat > /etc/systemd/system/arekbox.service << 'SERVICE'
[Unit]
Description=ArekBox Service
After=network.target

[Service]
Type=oneshot
User=arek
WorkingDirectory=/opt/arekbox
ExecStart=/opt/arekbox/arekbox_linux_builder.sh start
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SERVICE
    
    systemctl enable arekbox.service
EOF
    
    # Czystość
    apt clean
    history -c
EOF
    
    echo -e "${GREEN}✅ System skonfigurowany!${NC}"
}

# Funkcja: Stwórz system Live (bootowalny)
create_live_system() {
    echo -e "${CYAN}🔥 Tworzę system Live...${NC}"
    
    mkdir -p "$LIVE_DIR"
    
    # Stwórz squashfs (skompresowany system plików)
    sudo mksquashfs \
        "$FS_DIR" \
        "$LIVE_DIR/filesystem.squashfs" \
        -noappend \
        -no-exports \
        -no-xattrs
    
    echo -e "${GREEN}✅ System Live gotowy!${NC}"
}

# Funkcja: Stwórz strukturę ISO
create_iso_structure() {
    echo -e "${CYAN}📁 Tworzę strukturę ISO...${NC}"
    
    mkdir -p "$ISO_DIR/{isolinux,boot/grub}"
    
    # Skopiuj jądro i initrd
    cp "$FS_DIR/boot/vmlinuz-"* "$ISO_DIR/boot/vmlinuz"
    cp "$FS_DIR/boot/initrd.img-"* "$ISO_DIR/boot/initrd"
    
    # Konfiguracja GRUB
    cat > "$ISO_DIR/boot/grub/grub.cfg" << 'GRUB'
set timeout=5
set default=0

menuentry "ArekBox Linux" {
    linux /boot/vmlinuz boot=live components quiet splash
    initrd /boot/initrd
}
GRUB
    
    # Konfiguracja isolinux (dla starszych systemów)
    cat > "$ISO_DIR/isolinux/isolinux.cfg" << 'ISOLINUX'
default ArekBox
label ArekBox
    kernel /boot/vmlinuz
    append initrd=/boot/initrd boot=live components
ISOLINUX
    
    echo -e "${GREEN}✅ Struktura ISO gotowa!${NC}"
}

# Funkcja: Stwórz finalny obraz ISO
create_iso_image() {
    echo -e "${CYAN}💿 Tworzę obraz ISO...${NC}"
    
    xorriso \
        -as mkisofs \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "ArekBox Linux" \
        -eltorito-boot \
        -eltorito-boot-catalog /boot.catalog \
        -eltorito-boot-load-size 4 \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -output "$OUTPUT_ISO" \
        "$ISO_DIR"
    
    echo -e "${GREEN}✅ Obraz ISO utworzony: $OUTPUT_ISO${NC}"
    echo -e "${YELLOW}📁 Rozmiar: $(du -h "$OUTPUT_ISO" | cut -f1)${NC}"
}

# Funkcja: Testuj ISO w QEMU
test_iso() {
    echo -e "${CYAN}🧪 Testuję ISO w QEMU...${NC}"
    
    if command -v qemu-system-x86_64 &> /dev/null; then
        qemu-system-x86_64 \
            -cdrom "$OUTPUT_ISO" \
            -m 2G \
            -boot d &
    else
        echo -e "${RED}❌ QEMU nie jest zainstalowane. Instaluję...${NC}"
        sudo apt install -y qemu-system-x86
        qemu-system-x86_64 \
            -cdrom "$OUTPUT_ISO" \
            -m 2G \
            -boot d &
    fi
}

# Główne menu
echo -e "${CYAN}=== AREKBOX LINUX BUILDER ===${NC}"
echo "1) Sprawdź zależności"
echo "2) Zbuduj bazowy system"
echo "3) Dodaj moje skrypty"
echo "4) Skonfiguruj system"
echo "5) Stwórz system Live"
echo "6) Stwórz strukturę ISO"
echo "7) Stwórz obraz ISO"
echo "8) Testuj ISO w QEMU"
echo "9) Zbuduj wszystko (krok po kroku)"
echo "0) Wyjście"
read -p "Wybierz opcję: " choice

case $choice in
    1) check_dependencies ;;
    2) create_base_system ;;
    3) add_custom_scripts ;;
    4) configure_system ;;
    5) create_live_system ;;
    6) create_iso_structure ;;
    7) create_iso_image ;;
    8) test_iso ;;
    9)
        check_dependencies
        create_base_system
        add_custom_scripts
        configure_system
        create_live_system
        create_iso_structure
        create_iso_image
        echo -e "${GREEN}🎉 Całość zbudowana!${NC}"
        ;;
    0)
        exit 0
        ;;
    *)
        echo -e "${RED}Nieznana opcja!${NC}"
        ;;
esac
