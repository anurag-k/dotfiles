## 1. Environment

### Bootstrap

After cloning this repository, run:

```bash
bash bootstrap.sh
```

The script supports APT (Debian/Ubuntu), DNF (Fedora), and Pacman (Arch). It
installs the required packages and language tooling, links the configuration
into your home directory, installs the SauceCodePro Nerd Font, downloads the
latest official stable Neovim release, and bootstraps its plugins. It modifies
`~/.bashrc` only to add `~/.local/bin` and Starship initialization. Use
`--skip-font` or `--skip-nvim` to omit either network-heavy step.

For Markdown-to-PDF and SVG support, use the optional documentation setup:

```bash
bash bootstrap.sh --with-docs
```

This installs Pandoc, XeLaTeX, and `rsvg-convert`. On Debian/Ubuntu, the latter
comes from `sudo apt install librsvg2-bin`. Convert a note with:

```bash
pandoc note.md --pdf-engine=xelatex -o note.pdf
```

The tracked `taplo` executable is static Linux x86-64 only. On another
architecture, install Taplo separately and place it on `PATH`.

  Add the following command to ~/.bashrc:
   ```bash
   eval "$(starship init bash)"
   ```

## 2. Font

   Primary Font: SauceCode Pro Nerd Font Mono (regular, 13)
   
   Download:
   https://www.nerdfonts.com/font-downloads
  
   Install:
   ```bash
   mkdir -p ~/.local/share/fonts
   cp *.ttf ~/.local/share/fonts
   fc-cache -fv
   ```
   Verify:
   ```bash
   fc-match "SauceCodePro Nerd Font Mono"
   ```
## 3. Alacritty Shortcut (optional)

   Create a custom keyboard shortcut to launch Alacritty.
   
   On Ubuntu:
   
   1. Open:
      ```
      Settings → Keyboard → Keyboard Shortcuts
      ```

   2. Disable the default terminal launcher shortcut if it is already assigned to another terminal. Add a new custom shortcut:
   
      **Name:**
      ```
      Alacritty
      ```
   
      **Command:**
      ```bash
      alacritty
      ```
   
      **Shortcut:**
      ```
      Ctrl + Alt + T
      ```

## 4. 60% keyboard layer with keyd (optional)

The tracked `keyd/default.conf` adds a Caps Lock function layer while keeping
the normal Caps Lock behavior when the key is tapped. Build and install `keyd`
from source:

```bash
git clone https://github.com/rvaiya/keyd.git keyd-src
cd keyd-src
make
sudo make install
cd ..
```

Copy the configuration and enable the service:

```bash
sudo install -Dm644 keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable --now keyd
sudo keyd reload
systemctl status keyd
```

The layer provides these mappings:

- `Caps + 1–0`, `-`, `=` → `F1–F12`
- `Caps + H/J/K/L` → Home/Page Down/Page Up/End
- `Caps + I` → Insert
- `Caps + Backspace` → Delete
