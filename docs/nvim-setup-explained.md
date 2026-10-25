# Neovim setup explained

This generic overview explains how the tracked Neovim setup fits together: parsing, language servers, diagnostics, formatting, and documentation tools. It applies across languages. For installation, see the [README](../README.md).

## Current language support

| File type | Parsing/highlighting | LSP or diagnostics | Formatting |
|---|---|---|---|
| C/C++ | tree-sitter `cpp` | `clangd` | LSP fallback via `<leader>cf` |
| Python | tree-sitter `python` | Pyright and Ruff | Ruff through Conform; on save |
| Bash/sh | tree-sitter `bash` | efm with ShellCheck | shfmt through Conform; efm on save |
| Lua | tree-sitter `lua` | lua_ls; efm with LuaCheck | StyLua through efm |
| YAML | tree-sitter `yaml` | yamlls | LSP fallback if available |
| TOML | no configured parser | Taplo, on x86-64 by default | LSP fallback if available |
| JavaScript/TypeScript | tree-sitter | ts_ls | LSP fallback if available |
| Markdown/MDX | tree-sitter Markdown | Marksman | Prettier through Conform; on save |
| JSON/HTML/CSS | tree-sitter parsers | no server enabled in this config | LSP fallback if available |
| AsciiDoc | Neovim built-in filetype and syntax | no server enabled | no formatter configured |

The full parser list is in
[`nvim-treesitter.lua`](../.config/nvim/lua/plugins/nvim-treesitter.lua).
The enabled language servers are in
[`nvim-lspconfig.lua`](../.config/nvim/lua/plugins/nvim-lspconfig.lua).
The bootstrapper installs some additional Node language servers, but installing
a server alone does not enable it in Neovim.

## Where tools come from

- `bootstrap.sh` installs system tools such as `clangd`, ShellCheck, and shfmt;
  Ruff through `pipx`; efm through Go; and StyLua through the package manager
  or Cargo. It links the bundled x86-64 Taplo executable.
- Mason installs the packages listed below into Neovim's local data
  directory. Its packages are downloaded per machine, not committed here.
- Neovim's built-in LSP client runs servers enabled with `vim.lsp.enable`.
  Mason handles installation; tree-sitter handles parsing; Conform invokes
  external formatters.

`<leader>cf` formats the current buffer with Conform and falls back to LSP
formatting. Python and Markdown are formatted by Conform before save. The efm
save hook handles its configured file types. See
[`conform.lua`](../.config/nvim/lua/plugins/conform.lua) for the exact list.

## Mason packages and installation

You do not copy `~/.local/share/nvim/mason/` into this repository or create it
by hand. These tracked commands and configurations request packages on a new
machine:

| Source | Mason package names | When |
|---|---|---|
| `bootstrap.sh` | `lua-language-server`, `pyright`, `bash-language-server`, `json-lsp`, `yaml-language-server`, `typescript-language-server` | During the headless bootstrap; the install command waits for completion. |
| [`mason-lspconfig.lua`](../.config/nvim/lua/plugins/mason-lspconfig.lua) | Those six, plus `clangd` and `marksman` | After opening a file in regular Neovim; already installed packages are kept. |
| [`mason-tool-installer.lua`](../.config/nvim/lua/plugins/mason-tool-installer.lua) | `marksman`, `prettier`, `tree-sitter-cli` | Shortly after regular Neovim startup. |

`mason-lspconfig.lua` names servers using LSP identifiers (`lua_ls`, `bashls`,
`jsonls`, `yamlls`, `ts_ls`); the table uses the corresponding Mason package
names. Installing a server does not enable it: the current LSP configuration
does not enable `bashls` or `jsonls`. The bootstrapper also installs some tools
outside Mason, including a system `clangd` and `pipx` Ruff.

Open `:Mason` to see the installed packages. If a requested package is still
missing after startup, use `:MasonInstall <package-name>` and check its error
messages. Packages already present locally but absent from all three lists are
not recreated by the dotfiles setup.

## Common checks

| Purpose | Command |
|---|---|
| Attached LSP clients | `:LspInfo` |
| Mason packages | `:Mason` |
| Current file type | `:set filetype?` |
| Buffer diagnostics | `<leader>df` |
| All diagnostics in quickfix | `:lua vim.diagnostic.setqflist()` then `:copen` |
| Parser status | `:checkhealth nvim-treesitter` |

The configured LSP keys include `K` for hover, `gd` for definition, `gr` for
references, `<leader>cr` for rename, and `<leader>ca` for code actions.

## Documentation formats

Markdown editing uses Marksman, Prettier, render-markdown, and mkdnflow. The
optional `bootstrap.sh --with-docs` installs Pandoc, XeLaTeX, and
`rsvg-convert` for PDF output. VimTeX handles LaTeX editing and uses
`latexmk` and Zathura for compilation and viewing; see the
[README's LaTeX section](../README.md#optional-latex-editing-with-vimtex) for
installation details.

### AsciiDoc

Neovim recognizes `.adoc` files and provides built-in AsciiDoc syntax and
filetype settings. This configuration adds no AsciiDoc LSP, formatter, preview
plugin, or render command. Install Asciidoctor separately to create HTML:

```bash
asciidoctor document.adoc
```

This writes `document.html` by default. `bootstrap.sh --with-docs` does not
install Asciidoctor; that option covers the Markdown-to-PDF toolchain above.

### PlantUML

The PlantUML plugin provides `.puml` syntax only. Install the PlantUML command
separately to render diagrams; the bootstrapper does not install it.
