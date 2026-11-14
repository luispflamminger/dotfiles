# dotfiles

My dotfiles for macOS.

Machine-specific settings and secrets go in `~/.zshrc.local`, which `.zshrc`
sources if it exists and which is not tracked here.

## New Mac setup

### 1. Base tools

```bash
xcode-select --install
softwareupdate --install-rosetta
```

Install [Homebrew](https://brew.sh), then:

```bash
git clone https://github.com/luispflamminger/dotfiles.git ~/dotfiles
brew bundle --file ~/dotfiles/Brewfile
```

### 2. Link the dotfiles

Requires GNU Stow >= 2.4 (installed by the Brewfile).

```bash
~/dotfiles/stow-all.sh
```

Enable the git hooks for this repo. A gitleaks check then blocks any commit
whose staged changes contain a secret:

```bash
cd ~/dotfiles && lefthook install
```

If stow reports conflicts with files that already exist (for example a default
`~/.zprofile` or `~/.zshrc`), move them away and rerun, or run
`stow --dotfiles --adopt <package>` to pull them into the repo and check
`git diff` afterwards.

### 3. Node

```bash
fnm install --lts
```

### 4. Keyboard

Swap right Cmd and right Option. The key right of the spacebar is the easiest
one to reach with the right thumb, and on a Mac that's right Cmd. The custom
layout below types umlauts with Option, so after the swap that thumb key works
like AltGr on a PC keyboard. The LaunchAgent applies the mapping with
`hidutil` at every login, because `hidutil` mappings are lost on reboot.
It was generated with [hidutil-generator](https://hidutil-generator.netlify.app).

```bash
cp ~/dotfiles/macos/com.local.KeyRemapping.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.local.KeyRemapping.plist
```

Install the custom layout (made with Ukelele), then add it under
System Settings → Keyboard → Input Sources:

```bash
mkdir -p ~/Library/Keyboard\ Layouts
cp ~/dotfiles/macos/*.keylayout ~/Library/Keyboard\ Layouts/
```

### 5. Manual steps

macOS:

- Privacy & Security → Full Disk Access: enable for WezTerm
- Sound: disable alert sound, startup sound and UI sound effects
- Keyboard: globe key shows emoji and symbols
- Dock: decrease size

Apps:

- Raycast: bind to Cmd+Space (turn off the Spotlight shortcut first), bind
  the emoji picker to Cmd+.
- AltTab (replaces the macOS Cmd+Tab switcher with a per-window list):
  - Controls: Hold `⌘` (Cmd) + Tab
  - Appearance: style Titles, size Medium
  - Show windows from applications: All apps
  - Show windows from Spaces: Visible Spaces
  - Show windows from screens: All screens
  - Show minimized windows, hidden windows and fullscreen windows: Show
  - Order windows by: Recently Focused
- Docker Desktop: open and sign in
- Zen: extensions uBlock Origin and KeePassXC-Browser; restore tabs on
  startup; disable saving passwords and credit cards
- Authenticate to Forgejo
- Clone the KeePassXC database to `~/keepass-db`
- Clone Obsidian notes to `~/obsidian-notes`
- Claude Code / Codex: sign in

## Keeping the Brewfile current

```bash
brew bundle check --file ~/dotfiles/Brewfile      # anything missing?
brew bundle cleanup --file ~/dotfiles/Brewfile    # anything installed but not listed?
```

To add everything newly installed, run
`brew bundle dump --file - --force` and merge the new lines into the matching
group in the `Brewfile`.
