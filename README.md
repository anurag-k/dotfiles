## 1. Environment

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
