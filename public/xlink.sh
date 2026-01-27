#!/bin/bash
#═══════════════════════════════════════════════════════════
# XLink - Link Your VMs, Ditch Public IPs
# by xasim.me
# Version: 1.0.0
#═══════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'

# Config
INSTALL_DIR="/opt/xlink"
CONFIG_DIR="/etc/xlink"
VERSION="1.0.0"
TAILSCALE_TAGS="${XLINK_TAGS:-}"

# Temp file path for Tailscale installer (set during install)
TAILSCALE_INSTALLER=""

cleanup() {
    if [ -n "$TAILSCALE_INSTALLER" ]; then
        rm -f "$TAILSCALE_INSTALLER"
    fi
}
trap cleanup EXIT

require_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}✗ Please run this script as root (use sudo).${NC}"
        exit 1
    fi
}

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo -e "${RED}✗ Missing required command: $1${NC}"
        exit 1
    fi
}

# Banner (Style 2 - Modern & Bold)
show_banner() {
    clear
    echo -e "${PURPLE}"
    echo ""
    echo "  ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄"
    echo ""
    echo -e "  ${WHITE}██╗  ██╗██╗     ██╗███╗   ██╗██╗  ██╗${NC}"
    echo -e "  ${WHITE}╚██╗██╔╝██║     ██║████╗  ██║██║ ██╔╝${NC}"
    echo -e "  ${WHITE} ╚███╔╝ ██║     ██║██╔██╗ ██║█████╔╝${NC}"
    echo -e "  ${WHITE} ██╔██╗ ██║     ██║██║╚██╗██║██╔═██╗${NC}"
    echo -e "  ${WHITE}██╔╝ ██╗███████╗██║██║ ╚████║██║  ██╗${NC}"
    echo -e "  ${WHITE}╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝${NC}"
    echo ""
    echo -e "${PURPLE}  ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄${NC}"
    echo ""
    echo -e "  ${GRAY}Link Your VMs, Ditch Public IPs${NC}"
    echo -e "  ${CYAN}by xasim.me • v${VERSION}${NC}"
    echo ""
}

# Detect VM details
detect_vm() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} ${WHITE}Detecting VM Details...${NC}                              ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    HOSTNAME=$(hostname)
    if [ -n "${XLINK_HOSTNAME:-}" ]; then
        if [[ ! $XLINK_HOSTNAME =~ ^[a-zA-Z0-9-]{1,63}$ ]]; then
            echo -e "${RED}✗ Invalid XLINK_HOSTNAME format.${NC}"
            exit 1
        fi
        HOSTNAME="$XLINK_HOSTNAME"
    fi
    OS=$(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 || echo "Unknown")
    RAM=$(free -m 2>/dev/null | awk 'NR==2{print $2}' || echo "0")
    CPU=$(nproc 2>/dev/null || echo "1")
    DISK=$(df -h / 2>/dev/null | awk 'NR==2{print $2}' || echo "Unknown")
    PUBLIC_IP=$(curl -fsS --max-time 5 https://ifconfig.me 2>/dev/null || echo "N/A")
    PRIVATE_IP=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "N/A")
    ARCH=$(uname -m)
    KERNEL=$(uname -r)
    
    echo -e "${CYAN}┌───────────────────────────────────────────────────────┐${NC}"
    printf "${CYAN}│${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}│${NC}\n" "Hostname:" "$HOSTNAME"
    printf "${CYAN}│${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}│${NC}\n" "OS:" "$OS"
    printf "${CYAN}│${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}│${NC}\n" "RAM:" "${RAM} MB"
    printf "${CYAN}│${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}│${NC}\n" "CPU:" "${CPU} core(s)"
    printf "${CYAN}│${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}│${NC}\n" "Disk:" "$DISK"
    printf "${CYAN}│${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}│${NC}\n" "Architecture:" "$ARCH"
    printf "${CYAN}│${NC} %-20s ${YELLOW}%-30s${NC} ${CYAN}│${NC}\n" "Public IP:" "$PUBLIC_IP"
    printf "${CYAN}│${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}│${NC}\n" "Private IP:" "$PRIVATE_IP"
    echo -e "${CYAN}└───────────────────────────────────────────────────────┘${NC}"
    echo ""
}

# Get Tailscale auth key
get_auth_key() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} ${WHITE}Tailscale Authentication${NC}                            ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${YELLOW}🔑 Tailscale Auth Key Required${NC}"
    echo ""
    echo -e "${WHITE}Get your auth key:${NC}"
    echo -e "  ${CYAN}1.${NC} Visit: ${GREEN}https://login.tailscale.com/admin/settings/keys${NC}"
    echo -e "  ${CYAN}2.${NC} Click: ${GREEN}Generate auth key${NC}"
    echo -e "  ${CYAN}3.${NC} Check: ${GREEN}✅ Reusable${NC}"
    echo -e "  ${CYAN}4.${NC} Copy the key"
    echo ""
    
    local prompt
    prompt="$(echo -e "${YELLOW}Enter auth key:${NC} ")"
    if [ -t 0 ]; then
        read -r -s -p "$prompt" AUTH_KEY
    elif [ -r /dev/tty ]; then
        read -r -s -p "$prompt" AUTH_KEY < /dev/tty
    else
        echo -e "${RED}✗ No TTY available for auth key input.${NC}"
        exit 1
    fi
    echo ""
    
    if [[ ! $AUTH_KEY =~ ^tskey-auth- ]]; then
        echo -e "${RED}✗ Invalid auth key format!${NC}"
        echo -e "${GRAY}Auth key should start with 'tskey-auth-'${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Auth key validated${NC}"
    echo ""
}

# Install Tailscale
install_tailscale() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} ${WHITE}Installing Tailscale...${NC}                              ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -ne "${YELLOW}[1/3]${NC} Downloading Tailscale... "
    TAILSCALE_INSTALLER="$(mktemp /tmp/tailscale-install.XXXXXX)"
    curl -fSsL https://tailscale.com/install.sh -o "$TAILSCALE_INSTALLER"
    echo -e "${GREEN}✓${NC}"
    
    echo -ne "${YELLOW}[2/3]${NC} Installing packages... "
    if ! bash "$TAILSCALE_INSTALLER" > /dev/null 2>&1; then
        echo -e "${RED}✗${NC}"
        echo -e "${RED}Tailscale installer failed.${NC}"
        exit 1
    fi
    rm -f "$TAILSCALE_INSTALLER"
    TAILSCALE_INSTALLER=""
    echo -e "${GREEN}✓${NC}"
    
    echo -ne "${YELLOW}[3/3]${NC} Connecting to network... "
    if ! command -v tailscale >/dev/null 2>&1; then
        echo -e "${RED}✗${NC}"
        echo -e "${RED}Tailscale command not found after install.${NC}"
        exit 1
    fi
    local tag_args=()
    if [ -n "$TAILSCALE_TAGS" ]; then
        if [[ ! $TAILSCALE_TAGS =~ ^tag:[A-Za-z0-9_-]+(,tag:[A-Za-z0-9_-]+)*$ ]]; then
            echo -e "${RED}✗ Invalid XLINK_TAGS format. Use: tag:one,tag:two${NC}"
            exit 1
        fi
        tag_args=(--advertise-tags="$TAILSCALE_TAGS")
    fi
    if ! tailscale up --authkey="$AUTH_KEY" --hostname="$HOSTNAME" "${tag_args[@]}" > /dev/null 2>&1; then
        echo -e "${RED}✗${NC}"
        echo -e "${RED}Failed to connect to Tailscale.${NC}"
        exit 1
    fi
    TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || true)
    if [ -z "$TAILSCALE_IP" ]; then
        echo -e "${RED}✗${NC}"
        echo -e "${RED}Failed to fetch Tailscale IP.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓${NC}"
    
    echo ""
    echo -e "${GREEN}✓ Tailscale installed successfully!${NC}"
    echo ""
}

# Setup XLink
setup_xlink() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} ${WHITE}Setting Up XLink...${NC}                                  ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -ne "${YELLOW}[1/2]${NC} Creating directories... "
    mkdir -p "$INSTALL_DIR" "$CONFIG_DIR"
    echo -e "${GREEN}✓${NC}"
    
    echo -ne "${YELLOW}[2/2]${NC} Saving configuration... "
    cat > "$CONFIG_DIR/config.json" <<EOF
{
  "version": "$VERSION",
  "installed_at": "$(date -Iseconds)",
  "hostname": "$HOSTNAME",
  "tailscale_ip": "$TAILSCALE_IP",
  "os": "$OS",
  "ram": "$RAM",
  "cpu": "$CPU"
}
EOF
    chmod 600 "$CONFIG_DIR/config.json"
    echo -e "${GREEN}✓${NC}"
    
    echo ""
    echo -e "${GREEN}✓ XLink configured successfully!${NC}"
    echo ""
}

# Show final output
show_output() {
    clear
    show_banner
    
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}                                                       ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}       ${WHITE}✓ Setup Complete! VM Connected!${NC}              ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}                                                       ${GREEN}║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # VM Details
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} ${WHITE}VM Details${NC}                                           ${CYAN}║${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════════════════════╣${NC}"
    printf "${CYAN}║${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}║${NC}\n" "Hostname:" "$HOSTNAME"
    printf "${CYAN}║${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}║${NC}\n" "Tailscale IP:" "$TAILSCALE_IP"
    printf "${CYAN}║${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}║${NC}\n" "Status:" "🟢 Online"
    printf "${CYAN}║${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}║${NC}\n" "OS:" "$OS"
    printf "${CYAN}║${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}║${NC}\n" "RAM:" "${RAM} MB"
    printf "${CYAN}║${NC} %-20s ${GREEN}%-30s${NC} ${CYAN}║${NC}\n" "CPU:" "${CPU} core(s)"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Access Info
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC} ${WHITE}🔐 Access This VM${NC}                                    ${YELLOW}║${NC}"
    echo -e "${YELLOW}╠═══════════════════════════════════════════════════════╣${NC}"
    echo -e "${YELLOW}║${NC}   ${GREEN}ssh root@${TAILSCALE_IP}${NC}                              ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Next Steps
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC} ${WHITE}💡 Next Steps${NC}                                        ${PURPLE}║${NC}"
    echo -e "${PURPLE}╠═══════════════════════════════════════════════════════╣${NC}"
    echo -e "${PURPLE}║${NC}   ${WHITE}1.${NC} Delete public IP to save \$3/month              ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}   ${WHITE}2.${NC} Visit: ${CYAN}https://xasim.me/xlink${NC}                   ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}   ${WHITE}3.${NC} Run this script on other VMs                  ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Footer
    echo -e "${GRAY}═══════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}Time taken: ${SECONDS} seconds${NC}"
    echo -e "${GRAY}Installed in: ${INSTALL_DIR}${NC}"
    echo -e "${GRAY}Config: ${CONFIG_DIR}/config.json${NC}"
    echo -e "${GRAY}═══════════════════════════════════════════════════════${NC}"
    echo ""
}

# Main function
main() {
    show_banner
    require_root
    require_command curl
    detect_vm
    get_auth_key
    install_tailscale
    setup_xlink
    show_output
}

# Run
main
