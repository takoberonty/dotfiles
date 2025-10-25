# dotfiles

Personal configuration files (dotfiles) for setting up a new computer with all my favorite tools and configurations.

## Overview

This repository contains dotfiles for various tools and applications, along with installation scripts to easily deploy them on a new system.

## Structure

```
.
├── bash/               # Bash configuration
│   ├── .bashrc
│   └── .bash_profile
├── git/                # Git configuration
│   ├── .gitconfig
│   └── .gitignore_global
├── vim/                # Vim configuration
│   └── .vimrc
├── install.py          # Python installation script
└── install.sh          # Bash installation script
```

## Installation

You can use either the Python or Bash installation script to set up your dotfiles.

### Using Python Script

```bash
# Clone the repository
git clone https://github.com/takoberonty/dotfiles.git
cd dotfiles

# Install dotfiles (creates symbolic links)
./install.py install

# Dry run to see what would be done
./install.py install --dry-run

# Uninstall dotfiles (removes symbolic links)
./install.py uninstall
```

### Using Bash Script

```bash
# Clone the repository
git clone https://github.com/takoberonty/dotfiles.git
cd dotfiles

# Install dotfiles (creates symbolic links)
./install.sh install

# Dry run to see what would be done
./install.sh install --dry-run

# Uninstall dotfiles (removes symbolic links)
./install.sh uninstall
```

## What the Scripts Do

Both installation scripts:
- Create symbolic links from the dotfiles in this repository to your home directory
- Automatically backup any existing dotfiles with a `.backup` extension
- Support dry-run mode to preview changes before applying them
- Can uninstall by removing the symbolic links

## Customization

After installation, you should customize some files:

1. **git/.gitconfig**: Update your name and email
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. Modify any dotfiles to match your preferences
3. Re-run the installation script to update the symbolic links if needed

## Requirements

- **Python script**: Python 3.6 or higher
- **Bash script**: Bash 4.0 or higher (pre-installed on most Unix-like systems)
- Git (for cloning the repository)

## Features

### Bash Configuration
- Command history optimization
- Color support for ls and grep
- Useful aliases for common commands
- Git command aliases
- Customized prompt

### Git Configuration
- Common aliases (st, co, br, ci, lg)
- Colored output
- Global gitignore patterns
- Editor set to vim

### Vim Configuration
- Line numbers and syntax highlighting
- Smart indentation (4 spaces)
- Search highlighting
- Mouse support
- No backup or swap files

## Adding New Dotfiles

To add new dotfiles:

1. Create a new directory for the category (e.g., `tmux/`)
2. Add your dotfile(s) to that directory
3. Update the `dotfile_mappings` in both `install.py` and `install.sh`
4. Run the installation script again

## License

This is free and unencumbered software released into the public domain.
