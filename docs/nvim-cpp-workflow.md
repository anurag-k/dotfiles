# Neovim C++ workflow

Use this guide to open, navigate, build, diagnose, and debug a C++ project with
this repository's Neovim configuration. For installation and tool sources, see
the [README](../README.md) and [Neovim setup explanation](nvim-setup-explained.md).

## 1. Project root and working directory

Start this workflow from the project root. File search and live grep use
Neovim's working directory, and the configured GDB launch prompt defaults to
its `build/` directory. The `dev` helper uses that directory to name its tmux
session and to start Neovim and a shell, plus Codex when installed. If search
or debugging points at the wrong project, check `:pwd`.

## 2. Find files and text

The leader key is Space. These mappings search from the current working
directory unless the underlying tool chooses a narrower root.

| Key | Action |
|---|---|
| `<leader>ff` | Find files, including hidden files |
| `<leader>gf` | Find Git-tracked files |
| `<leader>fg` | Search file contents with ripgrep |
| `<leader>fG` | Reuse a saved live-grep query |
| `<leader>fR` | Resume the previous Telescope picker |
| `<leader>fb` | Choose an open buffer |
| `<leader>fr` | Open a recent file |
| `<leader>fa` | List Telescope pickers |
| `<leader>e` | Toggle the file tree |
| `<leader>m` | Focus the file tree |

Within a Telescope prompt, `Ctrl-j` and `Ctrl-k` move through results. Live
grep saves a query when you select a result; `<leader>fG` reopens saved
queries. `:Telescope find_files`, `:Telescope live_grep`, and
`:Telescope buffers` are command equivalents.

Use file search when you know a filename, live grep when you know text, and
clangd navigation when you know a symbol. For example, search for a class
name with `<leader>fg`, place the cursor on it, then use `gd` to follow its
definition.

## 3. Move between code locations

| Key or command | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `K` | Show hover information |
| `Ctrl-o` / `Ctrl-i` | Jump backward / forward in the jump list |
| `<leader><Tab>` | Switch to the previous buffer |
| `:bnext` / `:bprev` | Cycle buffers |
| `:bd` | Close the current buffer |

The LSP mappings are configured globally, but C++ symbol navigation requires
clangd to attach to the buffer. Open a source or header file and check
`:LspInfo` if a symbol action does nothing. `:checkhealth vim.lsp` can help
with a broader LSP failure.

Use `Ctrl-w h/j/k/l` to move between split windows. `<leader>sv` creates a
vertical split and `<leader>sh` a horizontal split; the config opens new
splits to the right or below. `:close` closes the current split. The file
tree and Telescope open files into buffers, so these window and buffer
commands remain useful while following code.

## 4. Give clangd the project build flags

clangd needs the build's include paths, defines, and compiler flags for
reliable navigation and diagnostics. For a CMake project, generate a
compilation database:

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build --parallel
```

CMake writes `build/compile_commands.json`. Make it visible at the project
root when clangd does not find it there:

```bash
ln -s build/compile_commands.json compile_commands.json
```

Only create the link if there is not already a file or link at that path.
The database describes the source files compiled by CMake; a header uses
flags inferred from a related source file. Regenerate it when build options,
include paths, or targets change.

This configuration starts clangd with `--background-index`, `--clang-tidy`,
and `--completion-style=detailed`. It does not configure a separate C++
formatter in Conform. `<leader>cf` asks Conform to format and falls back to
the attached LSP, so clangd handles C++ formatting when it is available.
There is no C++ format-on-save rule in this configuration.

## 5. Read diagnostics and change code

| Key or command | Action |
|---|---|
| `<leader>df` | Show diagnostics at the cursor |
| `]d` / `[d` | Next / previous diagnostic |
| `<leader>ca` | Available code actions |
| `<leader>cr` | Rename the symbol under the cursor |
| `<leader>cf` | Format the current buffer |
| `<leader>ci` or `:LspInfo` | Inspect attached language servers |

clangd diagnostics update while editing. Compiler errors from a CMake build
are a separate source of feedback. A diagnostic about a missing include or
unexpected type is often a sign that clangd has no current compilation
database or that Neovim was opened outside the project root.

For a cross-file rename, inspect the resulting changes before saving or
committing. The `gr` references picker is useful for checking all callers or
implementations before changing an interface.

## 6. Build, test, and use quickfix

Build and run tests from the tmux shell or a separate terminal:

```bash
cmake --build build --parallel
ctest --test-dir build --output-on-failure
```

A shell build does not automatically fill Neovim's quickfix list. If you
want compiler errors there, use Neovim's built-in `:make` command. This
configuration does not define a `:make` mapping or set a CMake-specific
`makeprg`, so set the build command for the session first:

```vim
:set makeprg=cmake\ --build\ build
:make
:copen
```

| Quickfix command | Action |
|---|---|
| `:copen` / `:cclose` | Show / hide the list |
| `:cnext` / `:cprev` | Next / previous error |
| `:cfirst` / `:clast` | First / last error |

The `makeprg` setting above is local to the current Neovim session. Use a
project-specific value if the project needs a preset or a different build
directory. `:make` uses Neovim's error parsing; if it misses a compiler
message, check `:set errorformat?` and the raw build output.

## 7. Debug the built program

The configured nvim-dap adapter launches `gdb -i dap`. Build with debug
information, open a C++ source file, then:

| Key | Action |
|---|---|
| `F9` | Toggle a breakpoint |
| `F5` | Start or continue |
| `F10` | Step over |
| `F11` | Step into |
| `F12` | Step out |
| `<leader>dt` | Terminate the session |

On the first `F5`, enter the executable path at the prompt. It starts with
`<current working directory>/build/`; choose the actual target produced by
your CMake build. The adapter launches with the project as its working
directory. nvim-dap-ui opens at session start and closes when it ends, showing
scopes, variables, the call stack, and the debug console.

If a breakpoint is not hit, check that the executable path is correct, the
source matches the build, and the program reaches that line. For debug
information, configure with `-DCMAKE_BUILD_TYPE=Debug`, rebuild, then check:

```bash
file build/<executable>
readelf -S build/<executable> | grep -E 'debug|symtab'
```

The debug adapter is configured for C++ source files. A CMake target built in
another directory still works if you enter its actual executable path.

## 8. Troubleshooting

| Problem | Check |
|---|---|
| `gd` or `gr` does nothing | Open a C++ buffer and inspect `:LspInfo`; check `clangd --version` in a shell. |
| Wrong include paths or many false diagnostics | Regenerate `compile_commands.json`; confirm the project-root link and `:pwd`. |
| File or grep search misses files | Check `:pwd`, Git tracking for `<leader>gf`, and whether ripgrep is installed. |
| Build errors do not appear in quickfix | Run the build through Neovim's built-in `:make`; a tmux-shell build does not populate quickfix. |
| Debug session does not start | Check `gdb --version`, the executable path, and the selected build target. |
| Breakpoints do not bind | Rebuild with debug information and check that source and executable match. |

For plugin and language-server installation details, consult the
[general setup explanation](nvim-setup-explained.md).
