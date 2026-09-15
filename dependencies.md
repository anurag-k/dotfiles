# Dependencies and Linux setup

The supported way to set up a new Linux workstation is to clone this repository
and run the bootstrapper:

```bash
git clone <repository-url> ~/Repos/dotfiles
cd ~/Repos/dotfiles
bash bootstrap.sh
```

The script supports APT (Debian/Ubuntu), DNF (Fedora), and Pacman (Arch). It is
idempotent: it installs system packages, language tooling, the latest official
stable Neovim release, SauceCodePro Nerd Font Mono, and Neovim plugins; links
the tracked configuration into `$HOME`; and enables Starship in Bash.

## What the bootstrapper installs

- Terminal workflow: Alacritty, tmux, Starship, Git, ripgrep, fd, xclip, and
  Fontconfig.
- C/C++: build-essential, CMake, clangd, and GDB.
- Neovim and dependencies: the latest stable official Neovim Linux archive,
  Node/npm, Python virtual environments/pipx, Go, Cargo, ShellCheck, shfmt,
  LuaCheck, StyLua (when packaged), Ruff, efm-langserver, and Mason-managed
  language servers.
- Global Node tooling: Codex, Pyright, TypeScript and its language server,
  Bash language server, and JSON/CSS/HTML language servers.

Neovim is installed under `~/.local/opt` and linked as
`~/.local/bin/nvim`. The official archives support Linux x86-64 and ARM64. Use
either option if that part of the setup should be deferred:

```bash
bash bootstrap.sh --skip-font
bash bootstrap.sh --skip-nvim
```

`--skip-nvim` skips both the Neovim download and its plugin/Mason bootstrap.

## Optional Markdown-to-PDF tools

Install the documentation toolchain on a new machine with:

```bash
bash bootstrap.sh --with-docs
```

This installs the pinned current Pandoc release (3.11), XeLaTeX, and
`rsvg-convert` for SVG images. On Debian/Ubuntu, the SVG utility is supplied by:

```bash
sudo apt install librsvg2-bin
```

Create a shareable PDF from Markdown with:

```bash
pandoc note.md --pdf-engine=xelatex -o note.pdf
```

Verify the tools with `nvim --version`, `pandoc --version`, `xelatex --version`,
and `rsvg-convert --version`.

## Required follow-up

Open a new Bash session after the script completes, then authenticate Codex:

```bash
codex login
```

The `dev` helper creates a tmux session containing Neovim, Codex, and a shell;
it therefore requires `tmux`, `nvim`, `codex`, and `~/.local/bin` on `PATH`.

## Font and architecture notes

SauceCodePro Nerd Font Mono is required for the configured Alacritty font and
the icon glyphs used by the terminal workflow. The bootstrapper downloads it
from the official Nerd Fonts release and refreshes Fontconfig. Verify it with:

```bash
fc-match "SauceCodePro Nerd Font Mono"
```

The tracked `taplo` executable is a static Linux x86-64 binary. It is linked
automatically on x86-64 only; install a Taplo build for the target architecture
on other systems.
