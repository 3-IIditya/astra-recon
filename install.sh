#!/bin/bash

set -e

echo "[+] Starting A.S.T.R.A installer..."

# -------------------------------
# Colors
# -------------------------------
RED="\e[91m"
GREEN="\e[92m"
YELLOW="\e[93m"
NC="\e[0m"

# -------------------------------
# Check root
# -------------------------------
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[!] Please run as root: sudo ./install.sh${NC}"
   exit 1
fi

# -------------------------------
# Update system
# -------------------------------
echo -e "${YELLOW}[+] Updating system...${NC}"
apt update -y

# -------------------------------
# Install base dependencies
# -------------------------------
echo -e "${YELLOW}[+] Installing base packages...${NC}"
apt install -y git curl wget jq nmap python3 python3-pip

# -------------------------------
# Install Go (if not present)
# -------------------------------
if ! command -v go &>/dev/null; then
    echo -e "${YELLOW}[+] Installing Go...${NC}"
    apt install -y golang
fi

# Set Go path
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# -------------------------------
# Install Recon Tools
# -------------------------------
echo -e "${YELLOW}[+] Installing recon tools...${NC}"

go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/hakluke/hakrawler@latest

# -------------------------------
# Python tools
# -------------------------------
echo -e "${YELLOW}[+] Installing Python tools...${NC}"

pip3 install sublist3r

# -------------------------------
# Other tools (apt / manual)
# -------------------------------
echo -e "${YELLOW}[+] Installing system tools...${NC}"

apt install -y whatweb

# httprobe (manual install)
if ! command -v httprobe &>/dev/null; then
    go install github.com/tomnomnom/httprobe@latest
fi

# gowitness
if ! command -v gowitness &>/dev/null; then
    go install github.com/sensepost/gowitness@latest
fi

# -------------------------------
# Move A.S.T.R.A to system path
# -------------------------------
echo -e "${YELLOW}[+] Installing A.S.T.R.A binary...${NC}"

chmod +x astra.sh
cp astra.sh /usr/local/bin/astra

# -------------------------------
# Banners directory check
# -------------------------------
if [ ! -d "banners" ]; then
    echo -e "${YELLOW}[!] banners/ directory not found. Create it manually.${NC}"
fi

# -------------------------------
# Done
# -------------------------------
echo -e "${GREEN}[+] Installation complete!${NC}"

echo ""
echo -e "${GREEN}Run your tool like:${NC}"
echo -e "${YELLOW}astra example.com${NC}"
echo ""
echo -e "${GREEN}A.S.T.R.A is ready to hunt 🎯${NC}"