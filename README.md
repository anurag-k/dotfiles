# Linux dotfiles

Configuration for Alacritty, tmux, Starship, Neovim, and a `dev` helper that
opens a project in tmux with Neovim, Codex, and a shell.

## Set up a workstation

Clone the repository and run the bootstrapper as your normal user:

```bash
git clone <repository-url> ~/Repos/dotfiles
cd ~/Repos/dotfiles
bash bootstrap.sh
```

The script supports APT (Debian/Ubuntu), DNF (Fedora), and Pacman (Arch). It
installs packages and language tools, links the tracked configuration into your
home directory, adds `~/.local/bin` and Starship initialization to `~/.bashrc`,
installs the SauceCodePro Nerd Font, downloads the latest stable official
Neovim release, and bootstraps Neovim plugins and Mason packages. Existing
non-symlink configuration files at the link destinations must be moved aside
before running it. Re-running the script refreshes its links and setup.

| Option | Effect |
|---|---|
| `--skip-font` | Skip the Nerd Font download. |
| `--skip-nvim` | Skip the Neovim download and plugin/Mason bootstrap. |
| `--with-docs` | Add Pandoc, XeLaTeX, and `rsvg-convert` for Markdown-to-PDF work. |

Neovim is installed under `~/.local/opt` and linked at `~/.local/bin/nvim`.
The official Linux archive step supports x86-64 and ARM64. The bundled `taplo`
executable is Linux x86-64 only; install Taplo separately on another
architecture if you need TOML LSP support.

### Installed tools

- Terminal and shell: Alacritty, tmux, Starship, Git, ripgrep, fd, xclip, and
  Fontconfig.
- C/C++: a compiler/build toolchain, CMake, clangd, and GDB.
- Neovim support: Node/npm, Python virtual environments and pipx, Go, Cargo,
  ShellCheck, shfmt, LuaCheck, StyLua, Ruff, and efm-langserver.
- Global Node tools: Codex, Pyright, TypeScript and its language server, Bash
  language server, and JSON/CSS/HTML language servers.
- Mason: the bootstrapper installs six language-server packages; Neovim
  requests additional packages on startup or when opening a file. See
  [Mason packages and installation](docs/nvim-setup-explained.md#mason-packages-and-installation)
  for the exact list and how to check it. Mason's data directory is local and
  is not committed to this repository.

The bootstrapper does not install every tool discussed in the optional workflow
notes. For Python debugging, install `debugpy` in the project's `.venv`.
VimTeX's optional compile/view tools are covered below. Asciidoctor and
PlantUML are separate installs if you use those formats.

### After installation

Open a new Bash session so `~/.local/bin` and Starship are available, then
authenticate Codex:

```bash
codex login
```

From a project directory, `dev` opens or attaches its tmux session. It needs
`tmux`, `nvim`, and `codex` on `PATH`. Check the editor with `nvim --version`
and the font with `fc-match "SauceCodePro Nerd Font Mono"`.

## Optional Markdown-to-PDF support

```bash
bash bootstrap.sh --with-docs
pandoc note.md --pdf-engine=xelatex -o note.pdf
```

The flag installs the pinned Pandoc version used by `bootstrap.sh` (currently
3.11), XeLaTeX, and `rsvg-convert` for SVG images. On Debian/Ubuntu,
`rsvg-convert` comes from `librsvg2-bin`. Verify with `pandoc --version`,
`xelatex --version`, and `rsvg-convert --version`.

## Optional LaTeX editing with VimTeX

The regular Neovim plugin bootstrap installs VimTeX for `.tex` editing and
syntax highlighting. `--with-docs` installs XeLaTeX; on Debian/Ubuntu its
`texlive-xetex` package also pulls in `texlive-latex-base`, which provides
PDFLaTeX. VimTeX is configured to run `latexmk` for compilation and open the
resulting PDF in Zathura. Add those two optional tools on Debian/Ubuntu with:

```bash
sudo apt install latexmk zathura
```

For other distributions, install their `latexmk` and Zathura packages if you
use VimTeX's compile/view commands. Check the pieces you need with
`pdflatex --version`, `xelatex --version`, `latexmk -v`, and
`zathura --version`. A TeX engine compiles the document; `latexmk` manages
rebuilds, and Zathura displays the PDF.

## Optional desktop setup

Alacritty uses SauceCodePro Nerd Font Mono. If you skipped font installation,
install that font yourself and refresh Fontconfig. On Ubuntu, you can assign
`Ctrl+Alt+T` to the `alacritty` command in Settings → Keyboard → Keyboard
Shortcuts, after releasing any existing binding for that shortcut.

## 60% keyboard layer with keyd (optional)

The tracked [keyd layer](keyd/default.conf) makes Caps Lock a function layer
when held while preserving Caps Lock on tap. To install it from source:

```bash
git clone https://github.com/rvaiya/keyd.git keyd-src
cd keyd-src
make
sudo make install
cd ..
sudo install -Dm644 keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable --now keyd
sudo keyd reload
```

The layer maps `Caps + 1–0`, `-`, `=` to `F1–F12`; `Caps + H/J/K/L` to
Home/Page Down/Page Up/End; `Caps + I` to Insert; and `Caps + Backspace` to
Delete.

## Workflow notes

These are references for working with the configuration, not prerequisites for
running the bootstrapper:

- [Neovim setup explained](docs/nvim-setup-explained.md): how the general editor setup fits together and where its tools come from.
- [Neovim Python workflow](docs/nvim-python-workflow.md): project environments, formatting, tests, and debugging.
- [Neovim C++ workflow](docs/nvim-cpp-workflow.md): project navigation, clangd, CMake builds, diagnostics, and GDB debugging.
