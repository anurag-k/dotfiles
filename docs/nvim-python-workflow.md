# Neovim Python workflow

Use this guide for Python editing, project environments, tests, and debugging
with this repository's Neovim configuration. For installation and tool
sources, see the [README](../README.md) and [Neovim setup explanation](nvim-setup-explained.md).

## Python language support

| Key / Command | Action |
|---|---|
| `K` | Hover documentation |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action / Ruff fixes |
| `<leader>cf` | Format buffer with Ruff |
| `<leader>df` | Show diagnostic |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `<leader>ci` | LSP info |

### Formatting

Python formatting is handled by:

```text
Conform.nvim → Ruff
```

Manual formatting:

```text
<leader>cf
```

Python files are also formatted automatically before save.

### Ruff

Ruff is installed through `pipx` by `bootstrap.sh`. Its LSP and formatter provide:

- linting / diagnostics
- code actions
- import organization
- auto-fixes
- formatting

`<leader>ca` opens available Ruff/Pyright code actions.

---

# Python virtual environments

Create a project environment from the project root (the DAP configuration uses the current directory):

```bash
python3 -m venv .venv
```

Activate:

```bash
source .venv/bin/activate
```

Deactivate:

```bash
deactivate
```

Check the active interpreter:

```bash
which python
```

Check the active environment:

```bash
echo $VIRTUAL_ENV
```

Expected:

```text
/path/to/project/.venv
```

Run a Python program:

```bash
python main.py
```

Install project packages with `python -m pip` so they go into the active interpreter:

```bash
python -m pip install <package>
```

---

# pytest

Install into the project `.venv`:

```bash
python -m pip install pytest
```

Run all tests:

```bash
pytest
```

Run a specific test file:

```bash
pytest test_main.py
```

Run a specific test:

```bash
pytest test_main.py::test_add
```

---

# Debugging

Install `debugpy` inside the project environment before using DAP; the bootstrapper does not install it:

```bash
.venv/bin/python -m pip install debugpy
```

Neovim uses:

```text
nvim-dap
   ↓
debugpy
   ↓
.venv/bin/python
```

## DAP controls

| Key | Action |
|---|---|
| `<F5>` | Start / Continue debugging |
| `<F9>` | Toggle breakpoint |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>dt` | Terminate debugging |

`nvim-dap-ui` automatically opens when debugging starts and provides:

- Scopes / variables
- Call stack
- Breakpoints
- Watches
- Debug console

### Basic debugging workflow

```text
1. Open Python file
2. Put cursor on desired line
3. F9             → breakpoint
4. F5             → start debugger
5. F10/F11/F12    → step
6. Inspect scopes / variables in DAP UI
7. <leader>dt     → terminate
```

---

# Starship Python environment

Starship displays the active Python environment.

Example:

```text
~/tmp/python-test via 🐍 v3.12.3 (.venv)
❯
```

The `.venv` portion confirms that the virtual environment is active.

Activation:

```bash
source .venv/bin/activate
```

Deactivation:

```bash
deactivate
```

---

# Current Python stack

```text
Neovim
│
├── Treesitter
│   └── syntax / highlighting
│
├── Pyright
│   └── LSP / type checking / navigation
│
├── Ruff LSP
│   └── linting / diagnostics / code actions
│
├── Conform.nvim
│   └── Ruff formatting / format-on-save
│
├── nvim-dap
│   └── debugging
│       └── debugpy
│
└── nvim-dap-ui
    └── variables / scopes / call stack
```

Project runtime:

```text
project/
├── .venv/
├── main.py
└── test_main.py
       │
       └── pytest
```
