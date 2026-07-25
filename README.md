1. Add the following command to ~/.bashrc:
   ```bash
   eval "$(starship init bash)"
   ```

2. Primary Font:
   SauceCode Pro Nerd Font Mono (regular, 13)
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
