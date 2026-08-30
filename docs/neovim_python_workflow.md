# Neovim Python Workflow

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

Ruff is installed through Mason and provides:

- linting / diagnostics
- code actions
- import organization
- auto-fixes
- formatting

`<leader>ca` opens available Ruff/Pyright code actions.

---

# Python virtual environments

Create a project environment:

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

Use `python -m pip` to ensure packages are installed into the active interpreter:

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

## PyCharm-equivalent mapping

```text
PyCharm                         Neovim

Code completion          →      Pyright + blink.cmp
Type checking            →      Pyright
Go to definition         →      gd
Find usages              →      gr
Rename                   →      <leader>cr
Quick fixes              →      <leader>ca
Reformat Code            →      <leader>cf
Format on save           →      Ruff + Conform
Linting                  →      Ruff
Virtual environment      →      .venv
Run Python               →      python main.py
Run tests                →      pytest
Debugger                 →      nvim-dap + debugpy
Debug variables/stack    →      nvim-dap-ui
```
