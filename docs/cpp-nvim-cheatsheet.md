# C++ / Neovim Cheatsheet

Practical reference for the current C++ development workflow with Neovim, clangd, CMake, tmux, GDB/nvim-dap, Git, and Codex CLI.

---

## 1. Development Layout

```text
Alacritty
└── tmux
    ├── nvim       # editing, LSP, navigation, debugging
    ├── shell      # CMake, builds, tests, Git
    └── codex      # Codex CLI
```

### Responsibilities

| Tool | Role |
|---|---|
| Neovim | Editing, navigation, LSP, debugging UI |
| clangd | C++ language server |
| CMake | Configure and build |
| tmux | Terminal/session management |
| GDB | Native debugger |
| nvim-dap | Neovim ↔ GDB integration |
| Git | Version control |
| Codex CLI | Coding assistance |

---

# 2. Neovim Basics

## Modes

```text
Normal       navigation and commands
Insert       text entry
Command      :commands
```

## Essential commands

| Action | Command |
|---|---|
| Insert | `i` |
| Normal mode | `Esc` |
| Save | `:w` |
| Quit | `:q` |
| Save + quit | `:wq` |
| Quit without saving | `:q!` |
| Undo | `u` |
| Redo | `Ctrl-r` |
| Delete line | `dd` |
| Yank line | `yy` |
| Paste | `p` |
| Search | `/pattern` |
| Next match | `n` |
| Previous match | `N` |
| Go to line | `:123` |
| Delete entire file | `:%d` |

---

# 3. Navigation

## Splits

```text
Ctrl-w h
Ctrl-w j
Ctrl-w k
Ctrl-w l
```

Move between windows.

```text
Ctrl-w q
```

Close current window.

## Buffers

```vim
:bnext
:bprev
:bd
```

---

# 4. Telescope

```vim
:Telescope find_files
:Telescope live_grep
:Telescope buffers
:Telescope oldfiles
```

| Command | Purpose |
|---|---|
| `find_files` | Find files |
| `live_grep` | Search project |
| `buffers` | Switch buffers |
| `oldfiles` | Recent files |

---

# 5. File Tree

```text
File tree  → project structure / browsing
Telescope  → finding files and text
LSP        → navigating code relationships
```

---

# 6. C++ Project Structure

```text
project/
├── CMakeLists.txt
├── README.md
├── AGENTS.md
├── include/
│   └── project/
│       └── foo.hpp
├── src/
│   ├── foo.cpp
│   └── main.cpp
├── tests/
├── build/
└── compile_commands.json
```

Build artifacts normally stay in:

```text
build/
```

---

# 7. C++ Compilation

Basic:

```bash
g++ -std=c++20 main.cpp -o app
```

Warnings:

```bash
g++ -std=c++20 -Wall -Wextra -Wpedantic main.cpp -o app
```

Debug build:

```bash
g++ -std=c++20 -Wall -Wextra -Wpedantic -g main.cpp -o app
```

Optimization:

```text
-O0    debugging
-O2    normal optimization
-O3    aggressive optimization
```

Typical debug combination:

```text
-g -O0
```

---

# 8. Basic Types

```cpp
bool
char
int
long
long long
float
double
```

Fixed-width integers:

```cpp
#include <cstdint>

std::uint32_t value;
std::int64_t count;
```

String:

```cpp
#include <string>

std::string name = "example";
```

---

# 9. const / constexpr

```cpp
const int value = 10;
```

Compile-time value:

```cpp
constexpr int buffer_size = 1024;
```

---

# 10. References and Pointers

Reference:

```cpp
int x = 10;
int& ref = x;

ref = 20;
```

Const reference:

```cpp
void process(const std::string& text);
```

Pointer:

```cpp
int x = 10;
int* ptr = &x;

*ptr = 20;
```

Null pointer:

```cpp
int* ptr = nullptr;
```

General distinction:

```text
reference → object expected to exist
pointer   → nullability / pointer semantics matter
```

---

# 11. Structs and Classes

Struct:

```cpp
struct Point {
    double x;
    double y;
};
```

Class:

```cpp
class Camera {
public:
    Camera(double fx, double fy);

    void capture();

private:
    double fx_;
    double fy_;
};
```

Constructor:

```cpp
Camera::Camera(double fx, double fy)
    : fx_(fx),
      fy_(fy)
{
}
```

---

# 12. Header / Source

`foo.hpp`:

```cpp
#pragma once

class Foo {
public:
    void run();
};
```

`foo.cpp`:

```cpp
#include "foo.hpp"

void Foo::run()
{
}
```

`main.cpp`:

```cpp
#include "foo.hpp"

int main()
{
    Foo foo;
    foo.run();
}
```

---

# 13. Namespaces

```cpp
namespace perception {

class Tracker {
};

} // namespace perception
```

Usage:

```cpp
perception::Tracker tracker;
```

Prefer explicit names:

```cpp
std::vector<int>
std::string
std::cout
```

Avoid `using namespace` in headers.

---

# 14. Control Flow

## if / else

```cpp
if (condition) {
}
else {
}
```

## for

```cpp
for (int i = 0; i < 10; ++i) {
}
```

## Range-based for

```cpp
for (const auto& value : values) {
}
```

## while

```cpp
while (condition) {
}
```

## switch

```cpp
switch (value) {
case 1:
    break;

case 2:
    break;

default:
    break;
}
```

---

# 15. auto

Useful for verbose or obvious types:

```cpp
auto count = values.size();
auto result = compute();
```

Iterators:

```cpp
auto it = values.begin();
```

Keep explicit types where the exact type carries useful information:

```cpp
std::uint32_t packet_id = ...;
```

---

# 16. STL Containers

Vector:

```cpp
std::vector<int> values;
values.push_back(10);
values.emplace_back(20);
```

Array:

```cpp
std::array<double, 3> point;
```

Map:

```cpp
std::map<std::string, int> counts;
```

Unordered map:

```cpp
std::unordered_map<std::string, int> counts;
```

Set:

```cpp
std::set<int> values;
```

Optional:

```cpp
std::optional<double> result;
```

Variant:

```cpp
std::variant<int, double> value;
```

---

# 17. STL Algorithms

```cpp
#include <algorithm>
```

Sort:

```cpp
std::sort(values.begin(), values.end());
```

Find:

```cpp
auto it = std::find(
    values.begin(),
    values.end(),
    target
);
```

Count:

```cpp
auto count = std::count(
    values.begin(),
    values.end(),
    target
);
```

Transform:

```cpp
std::transform(
    values.begin(),
    values.end(),
    output.begin(),
    [](double value) {
        return value * 2.0;
    });
```

---

# 18. Lambdas

```cpp
auto square = [](double x) {
    return x * x;
};
```

Capture by reference:

```cpp
[&]
```

Capture by value:

```cpp
[=]
```

Specific captures:

```cpp
[x, &result]
```

---

# 19. Smart Pointers

Unique ownership:

```cpp
auto object = std::make_unique<Foo>();
```

Shared ownership:

```cpp
auto object = std::make_shared<Foo>();
```

Weak reference:

```cpp
std::weak_ptr<Foo> weak = shared;
```

Prefer RAII and explicit ownership over raw owning pointers.

---

# 20. Move Semantics

```cpp
std::move(object)
```

Example:

```cpp
std::vector<int> a = create_data();
std::vector<int> b = std::move(a);
```

Conceptually:

```text
copy → duplicate resources
move → transfer resources
```

A moved-from object remains valid, but its old contents should not be assumed.

---

# 21. RAII

```text
Resource Acquisition Is Initialization
```

Resources follow object lifetime.

Example:

```cpp
std::lock_guard<std::mutex> lock(mutex);
```

Other examples:

```cpp
std::unique_ptr<Foo>
std::vector<T>
std::fstream
std::lock_guard<std::mutex>
```

---

# 22. Exceptions

Throw:

```cpp
throw std::runtime_error("Invalid input");
```

Catch:

```cpp
try {
    do_work();
}
catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
}
```

Include:

```cpp
#include <stdexcept>
```

---

# 23. Templates

Function:

```cpp
template <typename T>
T add(T a, T b)
{
    return a + b;
}
```

Class:

```cpp
template <typename T>
class Container {
    T value;
};
```

---

# 24. Useful C++20 Features

Structured bindings:

```cpp
auto [x, y] = point;
```

`std::span`:

```cpp
void process(std::span<const float> data);
```

Concepts:

```cpp
template <typename T>
requires std::floating_point<T>
T compute(T value);
```

Ranges:

```cpp
for (auto value : values |
     std::views::filter(predicate)) {
}
```

`std::jthread`:

```cpp
std::jthread worker([] {
    // work
});
```

---

# 25. Common Includes

```cpp
#include <algorithm>
#include <array>
#include <cstdint>
#include <filesystem>
#include <iostream>
#include <map>
#include <memory>
#include <mutex>
#include <optional>
#include <ranges>
#include <span>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>
```

---

# 26. Input / Output

```cpp
#include <iostream>

std::cout << "Hello\n";
std::cerr << "Error\n";
```

```cpp
std::cout << "value = " << value << '\n';
```

C++20 formatting:

```cpp
#include <format>

std::cout << std::format(
    "value = {}\n",
    value
);
```

---

# 27. Filesystem

```cpp
#include <filesystem>

namespace fs = std::filesystem;

fs::path path = "data/image.png";

if (fs::exists(path)) {
}
```

Useful operations:

```cpp
fs::exists(path);
fs::is_directory(path);
fs::file_size(path);
fs::create_directories(path);
```

---

# 28. Assertions

```cpp
#include <cassert>

assert(value >= 0);
```

Use assertions for programmer assumptions and invariants.

Runtime validation:

```cpp
if (!valid) {
    throw std::runtime_error("Invalid input");
}
```

---

# 29. CMake

Configure:

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
```

Build:

```bash
cmake --build build
```

Parallel build:

```bash
cmake --build build --parallel
```

Run:

```bash
./build/my_app
```

Clean rebuild:

```bash
rm -rf build
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build --parallel
```

---

# 30. Minimal CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.20)

project(my_project
    VERSION 1.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(my_app
    src/main.cpp
    src/foo.cpp
)

target_include_directories(my_app
    PRIVATE
        include
)
```

---

# 31. compile_commands.json

Enable:

```cmake
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
```

Configure:

```bash
cmake -S . -B build
```

Database:

```text
build/compile_commands.json
```

Optional root-level symlink:

```bash
ln -s build/compile_commands.json compile_commands.json
```

`compile_commands.json` gives clangd the actual compiler flags, include paths, defines, and language standard.

---

# 32. clangd

Current setup:

```text
--background-index
--clang-tidy
--completion-style=detailed
```

### Navigation

```text
gd          Go to definition
gD          Go to declaration
gr          Find references
gi          Go to implementation
gt          Go to type definition
K           Hover documentation
```

### Refactoring / diagnostics

```text
<leader>cr  Rename symbol
<leader>ca  Code action
<leader>cf  Format buffer
<leader>ci  LSP information
<leader>df   Diagnostics
]d          Next diagnostic
[d          Previous diagnostic
```

LSP information:

```vim
:LspInfo
```

---

# 33. Diagnostics

Open diagnostic:

```text
<leader>df
```

Navigate:

```text
]d
[d
```

Diagnostics flow:

```text
source code
    ↓
clangd
    ↓
live diagnostics
```

clangd diagnostics and compiler errors from a CMake build are separate sources of information.

---

# 34. Compiler Errors and Quickfix

Build in the tmux shell:

```bash
cmake --build build
```

Example:

```text
src/foo.cpp:42:17: error: expected ';' before '}'
```

Quickfix commands:

```vim
:copen
:cclose
:cnext
:cprev
:cfirst
:clast
```

Workflow:

```text
tmux shell
    ↓
cmake --build build
    ↓
compiler error
    ↓
copy error with tmux copy mode
    ↓
Neovim quickfix
    ↓
:cnext / :cprev
    ↓
jump to source location
```

---

# 35. tmux Copy Mode

Enter copy mode:

```text
Ctrl-a [
```

Search:

```text
/
```

Start selection:

```text
Space
```

Navigate:

```text
h j k l
```

Copy:

```text
Enter
```

Exit:

```text
q
```

Useful for copying compiler errors without the mouse.

---

# 36. GDB

Start:

```bash
gdb ./build/my_app
```

| Command | Purpose |
|---|---|
| `run` | Start |
| `break main` | Break at main |
| `continue` | Continue |
| `next` | Step over |
| `step` | Step into |
| `finish` | Step out |
| `print variable` | Print value |
| `backtrace` | Call stack |
| `list` | Source |
| `quit` | Exit |

Short forms:

```text
r    run
b    break
c    continue
n    next
s    step
f    finish
p    print
bt   backtrace
q    quit
```

---

# 37. nvim-dap

Architecture:

```text
Neovim
   ↓
nvim-dap
   ↓
GDB
   ↓
executable
```

Current keybindings:

| Key | Action |
|---|---|
| `F5` | Start / continue |
| `F9` | Toggle breakpoint |
| `F10` | Step over |
| `F11` | Step into |
| `F12` | Step out |
| `<leader>dt` | Terminate |

Typical workflow:

```text
F9
 ↓
set breakpoint

F5
 ↓
start

breakpoint hit
 ↓
F10 / F11 / F12
 ↓
inspect execution

F5
 ↓
continue

<leader>dt
 ↓
terminate
```

---

# 38. Debug Symbols

Check executable:

```bash
file build/my_app
```

Check debug sections:

```bash
readelf -S build/my_app | grep -E 'debug|symtab'
```

Typical sections:

```text
.debug_info
.debug_line
.debug_abbrev
.debug_str
.symtab
```

---

# 39. DAP Checks

Check GDB:

```bash
gdb --version
```

Check current DAP session:

```vim
:lua print(vim.inspect(require("dap").session()))
```

No active session:

```text
nil
```

---

# 40. Git

Status:

```bash
git status
```

Diff:

```bash
git diff
```

Whitespace:

```bash
git diff --check
```

Stage:

```bash
git add .
```

Commit:

```bash
git commit -m "Description"
```

History:

```bash
git log --oneline
```

---

# 41. tmux

Current prefix:

```text
Ctrl-a
```

Create session:

```bash
tmux new-session -s dev -n nvim
```

List:

```bash
tmux ls
```

Attach:

```bash
tmux attach -t dev
```

Detach:

```text
Ctrl-a d
```

Kill session:

```bash
tmux kill-session -t dev
```

## Windows

Create:

```text
Ctrl-a c
```

Switch:

```text
Ctrl-a 1
Ctrl-a 2
Ctrl-a 3
```

## Panes

Split horizontally:

```text
Ctrl-a -
```

Split vertically:

```text
Ctrl-a |
```

Move:

```text
Ctrl-a h
Ctrl-a j
Ctrl-a k
Ctrl-a l
```

Resize:

```text
Ctrl-a H
Ctrl-a J
Ctrl-a K
Ctrl-a L
```

---

# 42. Python in Neovim

Create virtual environment:

```bash
python3 -m venv .venv
```

Activate:

```bash
source .venv/bin/activate
```

Install:

```bash
pip install <package>
```

Typical role split:

```text
Python → experimentation / plotting / rapid prototyping
C++    → production / performance-critical implementation
```

Useful for perception, computer vision, robotics, and sensor-processing experiments.

---

# 43. Perception / Robotics Libraries

## OpenCV

```cpp
#include <opencv2/opencv.hpp>
```

Typical applications:

```text
image processing
feature detection
feature matching
camera calibration
PnP
stereo vision
optical flow
```

## Eigen

```cpp
#include <Eigen/Dense>
```

Common types:

```cpp
Eigen::Vector3d
Eigen::Matrix3d
Eigen::Matrix4d
Eigen::Quaterniond
```

Typical applications:

```text
linear algebra
rotations
rigid transforms
optimization
SLAM
sensor fusion
```

---

# 44. Coordinate Frames

Rigid transform:

```text
T_AB =
[ R  t ]
[ 0  1 ]
```

where:

```text
R = 3×3 rotation matrix
t = 3×1 translation vector
```

Point transformation:

```text
p_A = T_AB p_B
```

Frame conventions should remain explicit.

---

# 45. Camera Projection

Pinhole model:

```text
x = X / Z
y = Y / Z
```

With intrinsics:

```text
u = fx * X/Z + cx
v = fy * Y/Z + cy
```

Matrix form:

```text
s [u v 1]^T = K [R | t] [X Y Z 1]^T
```

Relevant to:

```text
camera calibration
stereo vision
visual localization
visual odometry
SLAM
3D reconstruction
```

---

# 46. Two-View Geometry

Typical progression:

```text
Image 1 ──┐
           ├── feature detection
Image 2 ──┘
                  ↓
            feature matching
                  ↓
                RANSAC
                  ↓
         fundamental matrix
                  ↓
          essential matrix
                  ↓
           relative pose
              R, t
                  ↓
            triangulation
                  ↓
              3D points
```

Then:

```text
two-view geometry
        ↓
visual odometry
        ↓
local mapping
        ↓
loop closure
        ↓
visual SLAM
        ↓
camera + IMU fusion
```

---

# 47. Codex CLI

Start in project directory:

```bash
codex
```

Repository instructions:

```text
AGENTS.md
```

Example:

```text
This is a C++20 perception project.

Build:
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build --parallel

Use:
- C++20
- CMake
- Eigen
- OpenCV

Prefer clear, testable code.
Avoid unnecessary dependencies.
```

`AGENTS.md` provides repository-level development instructions.

---

# 48. Recommended Daily Workflow

```text
tmux session
    ↓
Neovim
    ↓
edit / navigate with clangd
    ↓
build in tmux shell
    ↓
fix compiler errors
    ↓
set breakpoint with F9
    ↓
debug with F5/F10/F11/F12
    ↓
run tests
    ↓
review git diff
    ↓
Codex assistance when useful
    ↓
commit
```

---

# 49. Troubleshooting

## clangd not working

```vim
:LspInfo
```

Check compilation database:

```bash
ls compile_commands.json
```

or:

```bash
ls build/compile_commands.json
```

---

## Build failure

```bash
cmake --build build
```

Focus on the first meaningful compiler error. Later errors may be consequences of an earlier syntax or type error.

---

## Debugger does not start

```bash
gdb --version
file build/my_app
```

Check debug information:

```bash
readelf -S build/my_app | grep -E 'debug|symtab'
```

---

## Breakpoint does not work

Check:

```text
Debug build
debug symbols
correct executable
source matches executable
program reaches breakpoint
```

---

# 50. Quick Reference

## CMake

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build --parallel
```

## Git

```bash
git status
git diff
git diff --check
git add .
git commit -m "message"
```

## LSP

```text
gd
gr
K
]d
[d
<leader>df
```

## DAP

```text
F5
F9
F10
F11
F12
<leader>dt
```

## Quickfix

```vim
:copen
:cclose
:cnext
:cprev
```

## tmux

```text
Ctrl-a d
Ctrl-a 1
Ctrl-a 2
Ctrl-a 3
Ctrl-a h/j/k/l
```

---

# 51. Development Principles

```text
Neovim    → editing and navigation
clangd    → C++ language intelligence
CMake     → build system
tmux      → terminal workflow
GDB       → runtime truth
nvim-dap  → debugger integration
Git       → version history
Codex     → development assistance
```

Keep the workflow simple.

Use the shell for build and test commands.

Keep builds reproducible through CMake.

Use Debug builds when investigating runtime behavior.

Use compiler diagnostics, LSP diagnostics, tests, and the debugger as separate feedback mechanisms.

Add plugins when a concrete workflow requires them.
