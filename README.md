## 1. Environment

### Bootstrap

After cloning this repository, run:

```bash
bash bootstrap.sh
```

The script supports APT (Debian/Ubuntu), DNF (Fedora), and Pacman (Arch). It
installs the required packages and language tooling, links the configuration
into your home directory, installs the SauceCodePro Nerd Font, and bootstraps
Neovim. It modifies `~/.bashrc` only to add `~/.local/bin` and Starship
initialization. Use `--skip-font` or `--skip-nvim` to omit either network-heavy
step.

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
