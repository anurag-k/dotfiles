#!/usr/bin/env bash
# Bootstrap this dotfiles repository on a Linux workstation.
# Run from a clone of the repository: bash bootstrap.sh

set -Eeuo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
LOCAL_BIN="$HOME/.local/bin"
SKIP_FONT=false
SKIP_NVIM=false
WITH_DOCS=false
PANDOC_VERSION=3.11

usage() {
  cat <<'EOF'
Usage: bash bootstrap.sh [--skip-font] [--skip-nvim] [--with-docs]

Supports APT (Debian/Ubuntu), DNF (Fedora), and Pacman (Arch). It installs the
system and language tooling used by this repository, installs the SauceCodePro
Nerd Font, links the tracked configuration into $HOME, enables Starship for
Bash, and installs the latest stable Neovim plus its plugins and Mason language
servers. --with-docs adds Pandoc, XeLaTeX, and SVG conversion support.
EOF
}

while (($#)); do
  case "$1" in
    --skip-font) SKIP_FONT=true ;;
    --skip-nvim) SKIP_NVIM=true ;;
    --with-docs) WITH_DOCS=true ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if [[ $(id -u) -eq 0 ]]; then
  printf 'Run this script as your normal user; it invokes sudo for package installation.\n' >&2
  exit 1
fi

link_file() {
  local source=$1 target=$2
  mkdir -p "$(dirname "$target")"
  if [[ -e $target && ! -L $target ]]; then
    printf 'Refusing to replace existing non-symlink: %s\n' "$target" >&2
    printf 'Move it aside, then re-run this script.\n' >&2
    exit 1
  fi
  ln -sfn "$source" "$target"
}

append_once() {
  local file=$1 line=$2
  touch "$file"
  grep -Fqx "$line" "$file" || printf '\n%s\n' "$line" >> "$file"
}

install_packages() {
  if command -v apt-get >/dev/null 2>&1; then
    printf '%s\n' 'Installing packages with APT...'
    sudo apt-get update
    sudo apt-get install -y \
      alacritty tmux starship git curl ripgrep fd-find xclip fontconfig \
      unzip build-essential cmake clangd gdb python3-venv python3-pip pipx npm \
      shellcheck shfmt golang-go cargo lua-check
    sudo apt-get install -y stylua || printf 'StyLua is not packaged here; it will be installed with Cargo.\n' >&2
    if $WITH_DOCS; then
      sudo apt-get install -y texlive-xetex librsvg2-bin
    fi
  elif command -v dnf >/dev/null 2>&1; then
    printf '%s\n' 'Installing packages with DNF...'
    sudo dnf install -y \
      alacritty tmux starship git curl ripgrep fd-find xclip fontconfig \
      unzip gcc gcc-c++ make cmake clang-tools-extra gdb python3-pip pipx npm \
      ShellCheck shfmt golang cargo lua-check
    sudo dnf install -y stylua || printf 'StyLua is not packaged here; it will be installed with Cargo.\n' >&2
    if $WITH_DOCS; then
      sudo dnf install -y texlive-xetex librsvg2-tools
    fi
  elif command -v pacman >/dev/null 2>&1; then
    printf '%s\n' 'Installing packages with Pacman...'
    sudo pacman -Sy --needed --noconfirm \
      alacritty tmux starship git curl ripgrep fd xclip fontconfig \
      unzip base-devel cmake clang gdb python python-pipx npm shellcheck shfmt \
      go rust lua-check
    sudo pacman -S --needed --noconfirm stylua || printf 'StyLua is not packaged here; it will be installed with Cargo.\n' >&2
    if $WITH_DOCS; then
      sudo pacman -S --needed --noconfirm texlive-xetex librsvg
    fi
  else
    printf 'Unsupported package manager. Install the tools listed in README.md, then re-run with --skip-nvim if needed.\n' >&2
    exit 1
  fi
}

install_latest_neovim() {
  local machine nvim_arch archive temp_dir unpacked version install_dir
  machine=$(uname -m)
  case "$machine" in
    x86_64) nvim_arch=x86_64 ;;
    aarch64|arm64) nvim_arch=arm64 ;;
    *)
      printf 'No official Neovim Linux archive is configured for architecture: %s\n' "$machine" >&2
      exit 1
      ;;
  esac

  printf '%s\n' 'Installing the latest stable Neovim release...'
  temp_dir=$(mktemp -d)
  archive="$temp_dir/nvim-linux-$nvim_arch.tar.gz"
  curl --fail --location --retry 3 \
    --output "$archive" \
    "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$nvim_arch.tar.gz"
  tar -xzf "$archive" -C "$temp_dir"
  unpacked="$temp_dir/nvim-linux-$nvim_arch"
  version=$("$unpacked/bin/nvim" --version | sed -n '1s/^NVIM v//p')
  if [[ -z $version ]]; then
    printf '%s\n' 'Could not determine the downloaded Neovim version.' >&2
    exit 1
  fi

  install_dir="$HOME/.local/opt/nvim-$version"
  if [[ ! -e $install_dir ]]; then
    mv "$unpacked" "$install_dir"
  elif [[ ! -x $install_dir/bin/nvim ]]; then
    printf 'Existing Neovim installation is incomplete: %s\n' "$install_dir" >&2
    exit 1
  fi
  ln -sfn "$install_dir/bin/nvim" "$LOCAL_BIN/nvim"
  rm -rf "$temp_dir"
  printf 'Neovim %s is available at %s.\n' "$version" "$LOCAL_BIN/nvim"
}

install_pandoc() {
  local machine pandoc_arch checksum archive temp_dir unpacked install_dir tool
  machine=$(uname -m)
  case "$machine" in
    x86_64)
      pandoc_arch=amd64
      checksum=37edb3bbcf722f921a009941bf5874e2e0c09263226c9b4a2d980788cb062ab6
      ;;
    aarch64|arm64)
      pandoc_arch=arm64
      checksum=56ed5566ec41d22ec9ee0704e6ac0b98ba102e92384efd5306173a22d314c79a
      ;;
    *)
      printf 'No official Pandoc Linux archive is configured for architecture: %s\n' "$machine" >&2
      exit 1
      ;;
  esac

  printf 'Installing Pandoc %s...\n' "$PANDOC_VERSION"
  temp_dir=$(mktemp -d)
  archive="$temp_dir/pandoc-$PANDOC_VERSION-linux-$pandoc_arch.tar.gz"
  curl --fail --location --retry 3 \
    --output "$archive" \
    "https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-linux-$pandoc_arch.tar.gz"
  printf '%s  %s\n' "$checksum" "$archive" | sha256sum --check --status
  tar -xzf "$archive" -C "$temp_dir"
  unpacked="$temp_dir/pandoc-$PANDOC_VERSION"
  install_dir="$HOME/.local/opt/pandoc-$PANDOC_VERSION"
  if [[ ! -e $install_dir ]]; then
    mv "$unpacked" "$install_dir"
  elif [[ ! -x $install_dir/bin/pandoc ]]; then
    printf 'Existing Pandoc installation is incomplete: %s\n' "$install_dir" >&2
    exit 1
  fi
  for tool in pandoc pandoc-server; do
    if [[ -x $install_dir/bin/$tool ]]; then
      ln -sfn "$install_dir/bin/$tool" "$LOCAL_BIN/$tool"
    fi
  done
  rm -rf "$temp_dir"
}

install_packages

mkdir -p "$LOCAL_BIN" "$HOME/.local/opt" "$HOME/.vim/undodir"
export PATH="$LOCAL_BIN:$PATH"

if ! $SKIP_NVIM; then
  install_latest_neovim
fi

if $WITH_DOCS; then
  install_pandoc
fi

printf '%s\n' 'Installing Node-based language servers and Codex...'
sudo npm install -g \
  @openai/codex pyright typescript typescript-language-server \
  bash-language-server vscode-langservers-extracted

printf '%s\n' 'Installing Python and Go tooling...'
pipx ensurepath
if ! command -v ruff >/dev/null 2>&1; then
  pipx install ruff
fi
if ! command -v efm-langserver >/dev/null 2>&1; then
  GOBIN="$LOCAL_BIN" go install github.com/mattn/efm-langserver@latest
fi

if ! command -v stylua >/dev/null 2>&1; then
  cargo install stylua
fi

link_file "$REPO_DIR/.config/alacritty" "$HOME/.config/alacritty"
link_file "$REPO_DIR/.config/nvim" "$HOME/.config/nvim"
link_file "$REPO_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
link_file "$REPO_DIR/.tmux.conf" "$HOME/.tmux.conf"
link_file "$REPO_DIR/.local/bin/dev" "$LOCAL_BIN/dev"

if [[ $(uname -m) == x86_64 ]]; then
  link_file "$REPO_DIR/.local/bin/taplo" "$LOCAL_BIN/taplo"
else
  printf 'Skipping bundled Taplo: it is an x86-64 binary. Install Taplo for this architecture.\n' >&2
fi

append_once "$HOME/.bashrc" 'export PATH="$HOME/.local/bin:$PATH"'
append_once "$HOME/.bashrc" 'eval "$(starship init bash)"'

if ! $SKIP_FONT; then
  if ! fc-match 'SauceCodePro Nerd Font Mono' | grep -qi 'SauceCodePro'; then
    printf '%s\n' 'Installing SauceCodePro Nerd Font...'
    temp_dir=$(mktemp -d)
    trap 'rm -rf "$temp_dir"' EXIT
    curl --fail --location --retry 3 \
      --output "$temp_dir/SourceCodePro.tar.xz" \
      'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SourceCodePro.tar.xz'
    mkdir -p "$FONT_DIR"
    tar -xJf "$temp_dir/SourceCodePro.tar.xz" -C "$temp_dir"
    find "$temp_dir" -type f -iname '*.ttf' -exec install -m 0644 -t "$FONT_DIR" {} +
    fc-cache -f "$FONT_DIR"
  fi
fi

if ! $SKIP_NVIM; then
  printf '%s\n' 'Bootstrapping Neovim plugins and Mason servers...'
  nvim --headless '+Lazy! sync' +qa
  nvim --headless \
    "+lua require('lazy').load({plugins={'mason.nvim','mason-lspconfig.nvim'}})" \
    '+MasonInstall lua-language-server pyright bash-language-server json-lsp yaml-language-server typescript-language-server' \
    +qa
fi

printf '%s\n' 'Done. Open a new Bash session, then run `codex login` before using `dev`.'
