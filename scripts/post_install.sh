#!/bin/bash
# OMARCHY Post-Install Setup

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

show_next_steps() {
    header "🚀 Next Steps"

    echo -e "1. ${BOLD}Set Zsh as default shell:${NC}"
    echo -e "   ${BLUE}chsh -s \$(which zsh)${NC}"

    echo -e "\n2. ${BOLD}Restart your shell${NC} or run:"
    echo -e "   ${BLUE}source ~/.zshrc${NC}"

    echo -e "\n3. ${BOLD}In tmux, install plugins:${NC}"
    echo -e "   ${BLUE}prefix + I${NC}"

    echo -e "\n4. ${BOLD}Stow your dotfiles:${NC}"
    echo -e "   ${BLUE}cd ~/.dotfiles && stow */${NC}"

    echo -e "\n5. ${BOLD}Customize for OMARCHY:${NC}"
    echo -e "   ${BLUE}Edit configs to match your workflow${NC}"

    echo -e "\n${GREEN}🎉 Setup complete! Make it your own.${NC}"
}

main() {
    header "🏠 OMARCHY Post-Install Setup"
    echo -e "${BLUE}Take anything and make it your own${NC}\n"

    # Check we have basic tools
    check_dependencies

    # Show what's available
    echo -e "${BLUE}ℹ Available setup modules:${NC}"
    echo "  📦 Apps + Oh My Zsh + plugins (includes TPM)"
    echo "  🗄️  Databases (MongoDB + PostgreSQL)"

    # Run setup modules
    ask_and_run "Install development apps, Oh My Zsh and plugins?" "install_apps.sh"
    ask_and_run "Setup MongoDB and PostgreSQL databases?" "setup_databases.sh"

    # Setup MongoDB Compass desktop entry if installed
    if command_exists mongodb-compass; then
        ask_and_run "Setup MongoDB Compass desktop entry?" "setup_mongodb_compass.sh"
    fi

    # Show next steps
    show_next_steps
}

# Run the script
main "$@"