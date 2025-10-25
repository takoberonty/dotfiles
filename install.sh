#!/usr/bin/env bash
#
# Dotfiles Installation Script
#
# This script installs dotfiles by creating symbolic links from the repository
# to your home directory.
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory (repository root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME}"
DRY_RUN=false

# Dotfile mappings: category:filename1,filename2,...
declare -A DOTFILE_MAPPINGS=(
    ["bash"]=".bashrc,.bash_profile"
    ["git"]=".gitconfig,.gitignore_global"
    ["vim"]=".vimrc"
)

# Print colored message
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Create a symlink
create_symlink() {
    local source=$1
    local target=$2
    local filename=$(basename "$target")

    if [[ ! -f "$source" ]]; then
        print_message "$YELLOW" "  ⚠️  ${filename}: source file not found"
        return
    fi

    if [[ -L "$target" ]] && [[ "$(readlink -f "$target")" == "$source" ]]; then
        print_message "$GREEN" "  ✓ ${filename}: already linked"
        return
    fi

    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        local backup="${target}.backup"
        print_message "$YELLOW" "  ⚠️  ${filename}: exists, backing up to ${backup##*/}"
        if [[ "$DRY_RUN" != true ]]; then
            [[ -e "$backup" ]] && rm -f "$backup"
            mv "$target" "$backup"
        fi
    fi

    echo "  → ${filename}: linking"
    if [[ "$DRY_RUN" != true ]]; then
        ln -s "$source" "$target"
    fi
}

# Remove a symlink
remove_symlink() {
    local target=$1
    local filename=$(basename "$target")

    if [[ -L "$target" ]]; then
        echo "  → ${filename}: removing symlink"
        if [[ "$DRY_RUN" != true ]]; then
            rm -f "$target"
        fi
    elif [[ -e "$target" ]]; then
        print_message "$YELLOW" "  ⚠️  ${filename}: exists but is not a symlink (skipping)"
    else
        print_message "$YELLOW" "  ⚠️  ${filename}: not found (skipping)"
    fi
}

# Install dotfiles
install_dotfiles() {
    echo "Installing dotfiles..."
    echo "Repository: ${SCRIPT_DIR}"
    echo "Home: ${HOME_DIR}"
    echo

    if [[ "$DRY_RUN" == true ]]; then
        print_message "$YELLOW" "DRY RUN MODE - No changes will be made"
        echo
    fi

    for category in "${!DOTFILE_MAPPINGS[@]}"; do
        local source_dir="${SCRIPT_DIR}/${category}"
        
        if [[ ! -d "$source_dir" ]]; then
            print_message "$YELLOW" "⚠️  Skipping ${category}: directory not found"
            continue
        fi

        echo "Installing ${category} dotfiles:"
        
        IFS=',' read -ra files <<< "${DOTFILE_MAPPINGS[$category]}"
        for filename in "${files[@]}"; do
            local source="${source_dir}/${filename}"
            local target="${HOME_DIR}/${filename}"
            create_symlink "$source" "$target"
        done
        echo
    done

    print_message "$GREEN" "✓ Installation complete!"
}

# Uninstall dotfiles
uninstall_dotfiles() {
    echo "Uninstalling dotfiles..."
    echo "Home: ${HOME_DIR}"
    echo

    if [[ "$DRY_RUN" == true ]]; then
        print_message "$YELLOW" "DRY RUN MODE - No changes will be made"
        echo
    fi

    for category in "${!DOTFILE_MAPPINGS[@]}"; do
        echo "Removing ${category} dotfiles:"
        
        IFS=',' read -ra files <<< "${DOTFILE_MAPPINGS[$category]}"
        for filename in "${files[@]}"; do
            local target="${HOME_DIR}/${filename}"
            remove_symlink "$target"
        done
        echo
    done

    print_message "$GREEN" "✓ Uninstallation complete!"
}

# Show usage
show_usage() {
    cat << EOF
Usage: $0 [install|uninstall] [OPTIONS]

Actions:
    install     Install dotfiles by creating symbolic links
    uninstall   Remove dotfile symbolic links

Options:
    --dry-run   Show what would be done without making changes
    --help      Show this help message

Examples:
    $0 install
    $0 install --dry-run
    $0 uninstall

EOF
}

# Main script
main() {
    local action=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            install|uninstall)
                action=$1
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
            *)
                echo "Error: Unknown argument: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    # Check if action is provided
    if [[ -z "$action" ]]; then
        echo "Error: No action specified"
        show_usage
        exit 1
    fi

    # Execute action
    case $action in
        install)
            install_dotfiles
            ;;
        uninstall)
            uninstall_dotfiles
            ;;
    esac
}

main "$@"
