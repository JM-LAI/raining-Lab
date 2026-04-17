#!/usr/bin/env bash
# GPU Support Training Lab - one command to start
# designed to work on a completely fresh macOS or Linux laptop
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

PORT="${PORT:-8080}"
MIN_PY_MINOR=9  # minimum python 3.9 (we removed all 3.10+ syntax)

is_mac() { [[ "$(uname)" == "Darwin" ]]; }
is_linux() { [[ "$(uname)" == "Linux" ]]; }

# get the python minor version from a given binary, returns 0 if broken
py_minor() {
    "$1" -c 'import sys; print(sys.version_info.minor)' 2>/dev/null || echo "0"
}

# find the best python3 binary (3.9+), preferring newer versions
find_python() {
    local candidates=()
    
    if is_mac; then
        # Homebrew paths first (Apple Silicon then Intel)
        candidates+=(/opt/homebrew/bin/python3.12 /opt/homebrew/bin/python3.11 /opt/homebrew/bin/python3)
        candidates+=(/usr/local/bin/python3.12 /usr/local/bin/python3.11 /usr/local/bin/python3)
    fi
    # system/generic paths — macOS Xcode tools ship python3 (3.9+)
    candidates+=(python3.12 python3.11 python3)
    
    for p in "${candidates[@]}"; do
        if command -v "$p" &>/dev/null || [ -x "$p" ]; then
            local minor
            minor=$(py_minor "$p")
            if [ "$minor" -ge "$MIN_PY_MINOR" ] 2>/dev/null; then
                echo "$p"
                return 0
            fi
        fi
    done
    return 1
}

# fresh macOS needs Xcode CLI tools for git, python, etc.
# this does NOT require admin — any user can install Xcode CLI tools
ensure_xcode_tools() {
    if is_mac && ! xcode-select -p &>/dev/null; then
        echo ""
        echo -e "${YELLOW}Xcode Command Line Tools are needed (provides Python, git, etc.)${NC}"
        echo -e "${YELLOW}A popup will appear — click 'Install' and wait for it to finish.${NC}"
        echo -e "${YELLOW}This can take a few minutes on a fresh Mac.${NC}"
        echo ""
        xcode-select --install 2>/dev/null || true
        echo -e "${CYAN}Waiting for Xcode tools to finish installing...${NC}"
        until xcode-select -p &>/dev/null; do
            sleep 5
        done
        echo -e "${GREEN}Xcode tools installed!${NC}"
    fi
}

# make sure Homebrew is available and in PATH
# returns 1 if brew can't be installed (e.g. no admin rights)
ensure_brew() {
    if ! command -v brew &>/dev/null; then
        echo -e "${CYAN}Installing Homebrew...${NC}"
        if ! NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>/dev/null; then
            echo -e "${YELLOW}Homebrew install needs admin rights — skipping (not required for the lab).${NC}"
            return 1
        fi
    fi
    # make sure brew is in PATH for this session (Apple Silicon vs Intel)
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    return 0
}

# install Python if we can't find 3.9+
install_python() {
    echo -e "${CYAN}Python 3.${MIN_PY_MINOR}+ not found — attempting install...${NC}"
    
    if is_mac; then
        ensure_xcode_tools
        # after Xcode tools, check again — they ship python3
        if find_python &>/dev/null; then
            echo -e "${GREEN}Found Python after Xcode tools install.${NC}"
            return 0
        fi
        # only try Homebrew if we can get it
        if ensure_brew; then
            brew install python@3.11 2>/dev/null && \
                export PATH="/opt/homebrew/opt/python@3.11/bin:/usr/local/opt/python@3.11/bin:$PATH" || true
        fi
    elif is_linux; then
        echo -e "${YELLOW}Need sudo to install Python — you may be prompted for your password.${NC}"
        if command -v apt-get &>/dev/null; then
            sudo apt-get update -qq
            sudo apt-get install -y -qq python3 python3-venv python3-pip
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y -q python3 python3-pip
        elif command -v yum &>/dev/null; then
            sudo yum install -y -q python3 python3-pip
        fi
    fi
}

# install nice-to-have support tools (not required for the lab to run)
install_support_tools() {
    if ! is_mac; then
        return
    fi
    
    # only try if Homebrew is available — skip silently if not
    if ! command -v brew &>/dev/null; then
        if ! ensure_brew; then
            echo -e "${YELLOW}Skipping optional tool installs (no Homebrew). Lab will still work fine.${NC}"
            return
        fi
    fi
    
    # bash 5+ (macOS ships 3.x which is ancient)
    local bash_major
    bash_major=$(bash -c 'echo ${BASH_VERSINFO[0]}' 2>/dev/null || echo "3")
    if [ "$bash_major" -lt 5 ] 2>/dev/null; then
        echo -e "${CYAN}Upgrading Bash (macOS ships 3.x, we need 5+)...${NC}"
        brew install bash 2>/dev/null && echo -e "${GREEN}Bash upgraded.${NC}" || true
    fi
    
    # 1Password CLI
    if ! command -v op &>/dev/null; then
        echo -e "${CYAN}Installing 1Password CLI...${NC}"
        brew install --cask 1password-cli 2>/dev/null && echo -e "${GREEN}1Password CLI installed.${NC}" \
            || echo -e "${YELLOW}1Password CLI install skipped — install manually later if needed.${NC}"
    fi
    
    # git (should come with Xcode tools but just in case)
    if ! command -v git &>/dev/null; then
        brew install git 2>/dev/null || true
    fi
    
    # jq (used by various toolkit scripts)
    if ! command -v jq &>/dev/null; then
        brew install jq 2>/dev/null || true
    fi
    
    # curl (macOS has it but some stripped installs don't)
    if ! command -v curl &>/dev/null; then
        brew install curl 2>/dev/null || true
    fi
}

# check if port is busy and handle it gracefully
check_port() {
    if ! command -v lsof &>/dev/null; then
        return 0
    fi
    
    local pids
    pids=$(lsof -ti :"$PORT" 2>/dev/null || true)
    
    if [ -z "$pids" ]; then
        return 0
    fi
    
    # check if it's our own server
    if echo "$pids" | xargs ps -p 2>/dev/null | grep -q "uvicorn"; then
        echo -e "${YELLOW}Training Lab already running on port ${PORT} — restarting...${NC}"
        echo "$pids" | xargs kill -9 2>/dev/null || true
        sleep 1
        return 0
    fi
    
    # something else is using the port
    local process_info
    process_info=$(lsof -i :"$PORT" -P -n 2>/dev/null | grep LISTEN | head -3)
    echo -e "${YELLOW}Port ${PORT} is already in use:${NC}"
    echo -e "${DIM}${process_info}${NC}"
    echo ""
    echo -e "  ${CYAN}1)${NC} Use a different port"
    echo -e "  ${CYAN}2)${NC} Kill the process and use ${PORT}"
    echo -e "  ${CYAN}3)${NC} Cancel"
    echo ""
    read -rp "  Select [1]: " choice
    choice="${choice:-1}"
    
    case "$choice" in
        1)
            read -rp "  Enter port number: " new_port
            if [[ "$new_port" =~ ^[0-9]+$ ]] && [ "$new_port" -gt 1024 ] && [ "$new_port" -lt 65535 ]; then
                PORT="$new_port"
                echo -e "${GREEN}Using port ${PORT}${NC}"
            else
                echo -e "${RED}Invalid port. Exiting.${NC}"
                exit 1
            fi
            ;;
        2)
            echo "$pids" | xargs kill -9 2>/dev/null || true
            sleep 1
            echo -e "${GREEN}Port ${PORT} cleared.${NC}"
            ;;
        3)
            echo "Cancelled."
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Exiting.${NC}"
            exit 1
            ;;
    esac
}

case "${1:-start}" in
    start|"")
        echo -e "${CYAN}${BOLD}GPU Support Training Lab${NC}"
        echo ""
        
        # step 0: check for outdated alias in shell config
        SHELL_RC="$HOME/.zshrc"
        [[ "$SHELL" != *"zsh"* ]] && SHELL_RC="$HOME/.bashrc"
        if [ -f "$SHELL_RC" ] && grep -q "alias.*Training-Lab.*uvicorn\|alias.*Training-Lab.*xargs kill\|alias.*Training-Lab.*lsof" "$SHELL_RC" 2>/dev/null; then
            echo -e "${YELLOW}Found an outdated Training Lab alias in $(basename "$SHELL_RC") — fixing...${NC}"
            grep -v "alias.*Training-Lab.*uvicorn\|alias.*Training-Lab.*xargs kill\|alias.*Training-Lab.*lsof" "$SHELL_RC" > "${SHELL_RC}.tmp" && mv "${SHELL_RC}.tmp" "$SHELL_RC"
            grep -v "# Training Lab.*kill" "$SHELL_RC" > "${SHELL_RC}.tmp" 2>/dev/null && mv "${SHELL_RC}.tmp" "$SHELL_RC"
            echo "" >> "$SHELL_RC"
            echo "# Training Lab — auto-updates and restarts" >> "$SHELL_RC"
            echo "alias lab='cd ${SCRIPT_DIR} && ./start.sh'" >> "$SHELL_RC"
            echo -e "${GREEN}Fixed. Run 'source ${SHELL_RC}' or open a new terminal to pick it up.${NC}"
        fi
        
        # step 0b: pull latest changes if this is a git repo
        if [ -d ".git" ]; then
            echo -e "${CYAN}Checking for updates...${NC}"
            if git pull --quiet 2>/dev/null; then
                echo -e "${GREEN}Up to date.${NC}"
            else
                echo -e "${YELLOW}Could not check for updates (offline?) — using local version.${NC}"
            fi
            # if requirements changed, force reinstall
            if git diff HEAD@{1} --name-only 2>/dev/null | grep -q "requirements.txt"; then
                rm -f .venv/.installed
                echo -e "${YELLOW}Dependencies changed — will reinstall.${NC}"
            fi
        fi
        
        # step 1: make sure we have basic dev tools on macOS
        ensure_xcode_tools
        
        # step 2: find a usable python, install if needed
        PYTHON=$(find_python) || true
        if [ -z "$PYTHON" ]; then
            install_python
            PYTHON=$(find_python) || true
        fi
        
        if [ -z "$PYTHON" ]; then
            echo ""
            echo -e "${RED}Could not find or install Python 3.${MIN_PY_MINOR}+.${NC}"
            echo ""
            echo -e "  Ask your IT admin to install Python, or try one of these:"
            echo -e "  macOS:  ${CYAN}brew install python@3.11${NC}"
            echo -e "  Ubuntu: ${CYAN}sudo apt install python3 python3-venv python3-pip${NC}"
            echo ""
            echo -e "  If you don't have admin rights, ask a teammate to help"
            echo -e "  or message #customer-support-plg on Slack."
            exit 1
        fi
        
        FOUND_VER=$("$PYTHON" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
        echo -e "${GREEN}Using Python ${FOUND_VER}${NC} (${PYTHON})"
        
        # step 3: install optional support tools (bash 5+, 1password cli, jq, etc.)
        install_support_tools
        
        # step 4: create or fix the venv
        if [ -d ".venv" ]; then
            VENV_MINOR=$(py_minor .venv/bin/python3)
            if [ "$VENV_MINOR" -lt "$MIN_PY_MINOR" ] 2>/dev/null; then
                echo -e "${YELLOW}Existing venv uses Python 3.${VENV_MINOR} — recreating with ${FOUND_VER}...${NC}"
                rm -rf .venv
            fi
        fi
        
        if [ ! -d ".venv" ]; then
            echo "Creating virtual environment..."
            "$PYTHON" -m venv .venv || {
                # venv module might be missing on some Linux distros
                echo -e "${YELLOW}venv module missing — installing...${NC}"
                if command -v apt-get &>/dev/null; then
                    sudo apt-get install -y -qq python3-venv
                fi
                "$PYTHON" -m venv .venv
            }
        fi
        
        # step 5: activate and install packages
        source .venv/bin/activate
        
        if [ ! -f ".venv/.installed" ]; then
            echo "Installing Python packages..."
            pip install -q --upgrade pip 2>/dev/null
            pip install -q -r requirements.txt
            touch .venv/.installed
        fi
        
        # step 6: prep data directory
        mkdir -p data
        
        # step 7: check if port is free
        check_port
        
        # step 8: check if somehow already running after kill
        if curl -sf "http://localhost:${PORT}/health" &>/dev/null 2>&1; then
            echo -e "${GREEN}Already running at http://localhost:${PORT}${NC}"
            open "http://localhost:${PORT}" 2>/dev/null || xdg-open "http://localhost:${PORT}" 2>/dev/null || true
            exit 0
        fi
        
        # step 9: start server
        echo "Starting server on port ${PORT}..."
        uvicorn app.main:app --host 0.0.0.0 --port "$PORT" &
        SERVER_PID=$!
        echo $SERVER_PID > .server.pid
        
        # step 10: wait for startup
        for i in {1..30}; do
            if curl -sf "http://localhost:${PORT}/health" &>/dev/null; then
                break
            fi
            sleep 0.5
        done
        
        echo ""
        echo -e "${GREEN}${BOLD}Ready!${NC} http://localhost:${PORT}"
        echo ""
        echo "Stop with: Ctrl+C or ./start.sh stop"
        
        # step 11: open browser
        open "http://localhost:${PORT}" 2>/dev/null || xdg-open "http://localhost:${PORT}" 2>/dev/null || true
        
        # keep running in foreground so ctrl-c works
        wait $SERVER_PID
        ;;
        
    stop)
        if [ -f ".server.pid" ]; then
            PID=$(cat .server.pid)
            kill "$PID" 2>/dev/null || true
            rm -f .server.pid
        fi
        pkill -f "uvicorn app.main:app" 2>/dev/null || true
        echo "Stopped."
        ;;
        
    reset)
        echo "Resetting progress..."
        rm -f data/progress.db .venv/.installed
        $0 stop 2>/dev/null || true
        sleep 1
        $0 start
        ;;
        
    status)
        if curl -sf "http://localhost:${PORT}/health" &>/dev/null; then
            echo -e "${GREEN}Running${NC} at http://localhost:${PORT}"
        else
            echo -e "${RED}Not running${NC}"
        fi
        ;;
        
    alias)
        ALIAS_NAME="${2:-lab}"
        SHELL_RC="$HOME/.zshrc"
        [[ "$SHELL" != *"zsh"* ]] && SHELL_RC="$HOME/.bashrc"
        
        # backup
        cp "$SHELL_RC" "${SHELL_RC}.backup.$(date +%s)" 2>/dev/null
        
        # remove old alias if exists
        grep -v "alias ${ALIAS_NAME}=.*Training-Lab" "$SHELL_RC" > "${SHELL_RC}.tmp" 2>/dev/null && mv "${SHELL_RC}.tmp" "$SHELL_RC"
        grep -v "# Training Lab" "$SHELL_RC" > "${SHELL_RC}.tmp" 2>/dev/null && mv "${SHELL_RC}.tmp" "$SHELL_RC"
        
        echo "" >> "$SHELL_RC"
        echo "# Training Lab — auto-updates and restarts" >> "$SHELL_RC"
        echo "alias ${ALIAS_NAME}='cd ${SCRIPT_DIR} && ./start.sh'" >> "$SHELL_RC"
        
        echo -e "${GREEN}Alias '${ALIAS_NAME}' added to $(basename "$SHELL_RC")${NC}"
        echo ""
        echo "  Run: source ${SHELL_RC}"
        echo "  Then just type: ${ALIAS_NAME}"
        echo ""
        echo "  It will auto-pull the latest changes and start the lab."
        
        if command -v pbcopy &>/dev/null; then
            echo -n "source ${SHELL_RC}" | pbcopy
            echo -e "  ${GREEN}(source command copied to clipboard)${NC}"
        fi
        ;;
        
    *)
        echo "Usage: ./start.sh [start|stop|reset|status|alias]"
        echo ""
        echo "  start   Start the lab (default)"
        echo "  stop    Stop the lab"
        echo "  reset   Wipe progress and restart"
        echo "  status  Check if running"
        echo "  alias   Create a shell alias (e.g. ./start.sh alias lab)"
        exit 1
        ;;
esac
