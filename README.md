# dotfiles

Personal preferences

## Install

### Xcode

```bash
xcode-select --install
```

### VS Code

https://code.visualstudio.com/download

### Postico

https://eggerapps.at/postico/

### Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```bash
brew doctor
```

### Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Copy custom theme

```bash
cp ./yokota.zsh-theme ~/.oh-my-zsh/themes/
```

Add to `~/.zshrc`

```ini
ZSH_THEME="yokota"
```

## Git

### Aliases

Add aliases to `~/.gitconfig` which includes some pretty log formats

```ini
[alias]
	co = checkout
	st = status -sb
	ds = diff --staged
	l = log --pretty=format:'%C(yellow)%h%d %C(cyan)%ad %cn  %C(reset)%s' --decorate --date=short
	ls = log --pretty=format:'%C(yellow)%h%d %C(cyan)%ad %cn  %C(reset)%s' --decorate --graph --date=short
	ll = log --pretty=format:'%C(yellow)%h%d %C(cyan)%ad %cn  %C(reset)%s' --decorate --graph --date=short --stat
```

### Global Config

```bash
git config --global core.editor "vim"
git config --global branch.autosetuprebase always
git config --global push.default tracking
git config --global push.autoSetupRemote true
git config --global commit.gpgSign true
git config --global user.name "Brent Yokota"
```

### Context Config

Use separate side by side config files and include in `~/.gitconfig`

```ini
[includeIf "gitdir:src/"]
  path = .gitconfig-work
[includeIf "gitdir:other/"]
  path = .gitconfig-other
```

`~/.gifconfig-other`

```ini
[user]
  email = me@email.com
```

`~/.gitconfig-work`

```ini
[user]
  email = me@email.com
[commit]
  gpgsign = true
```

## Tips and Tricks

- [ssh config file](https://nerderati.com/2011-03-17-simplify-your-life-with-an-ssh-config-file/)
- [reflog is op](https://github.blog/2015-06-08-how-to-undo-almost-anything-with-git/)
- [ohmyzsh cheatsheet](https://kapeli.com/cheat_sheets/Oh-My-Zsh_Git.docset/Contents/Resources/Documents/index)
