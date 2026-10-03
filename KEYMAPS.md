# Keymaps

`<leader>` = **`Space`**. Hold `Space` for 0.4s to let which-key show the hints.
Search for any key: `Space f k`.

Notation: `C-` = Ctrl, `M-` = Alt, `S-` = Shift.

---

## Dashboard (greeting screen)

| Key | Action |
|---|---|
| `n` | New file |
| `f` | Find file |
| `o` | Open the file tree |
| `r` | Recent files |
| `g` | Search by content |
| `s` | Restore session |
| `c` | Open the config directory |
| `u` | Switch theme |
| `l` | Lazy |
| `m` | Mason |
| `q` | Quit |

---

## Basics

| Key | Mode | Action |
|---|---|---|
| `jk` | insert | Leave insert mode |
| `C-s` | normal, insert | Save the file |
| `Esc` | normal | Clear the search highlight |
| `Space q q` | normal | Quit everything |
| `Space ?` | normal | Keys local to the current buffer |

---

## Movement

| Key | Action |
|---|---|
| `j` / `k` | Down/up **by display line** (long wrapped lines still move correctly) |
| `C-d` / `C-u` | Half a page down/up, cursor recentred |
| `n` / `N` | Next/previous search result, auto-centred |
| `s` | **Flash** — type 2 characters and jump straight there |
| `S` | Flash by syntax node (function, block…) |
| `]]` / `[[` | Next/previous usage of the word under the cursor |

> `s` and `S` have replaced vim's original `s`/`S` (substitute). If you want
> substitute, use `c l` and `c c`.

---

## Windows

| Key | Action |
|---|---|
| `C-h` `C-j` `C-k` `C-l` | Move to the left/below/above/right window |
| `Space w v` | Split vertically |
| `Space w s` | Split horizontally |
| `Space w d` | Close the window |
| `Space w e` | Equalise the sizes |
| `C-Up` / `C-Down` | Taller / shorter |
| `C-Left` / `C-Right` | Narrower / wider |

---

## Buffers (the tabs along the top)

| Key | Action |
|---|---|
| `S-l` / `S-h` | Next/previous buffer |
| `Space b b` | Back to the buffer you just left |
| `Space b d` | Close the buffer |
| `Space b o` | Close every other buffer |
| `Space b p` | Pin the buffer |
| `Space b P` | Close every unpinned buffer |
| `Space b l` / `Space b r` | Close the buffers to the left / right |
| `Space f b` | Buffer list (`C-d` inside it deletes) |

---

## Finding files & content (Telescope)

| Key | Action |
|---|---|
| `Space Space` | Find a file (the fastest key) |
| `Space f f` | Find a file |
| `Space f g` | Search by content project-wide |
| `Space f w` | Search the word under the cursor |
| `Space f /` | Search inside the current file |
| `Space f r` | Recently opened files |
| `Space f b` | Open buffers |
| `Space f h` | `:help` pages |
| `Space f k` | Look up a keymap |
| `Space f c` | Command list |
| `Space f d` | Every diagnostic in the project |
| `Space f s` / `Space f S` | Symbols in the file / across the workspace |
| `Space f t` | TODO/FIXME list |

Inside the Telescope window:

| Key | Action |
|---|---|
| `C-j` / `C-k` | Down / up |
| `C-q` | Push every result to the quickfix list |
| `Esc` | Close |

---

## File tree

| Key | Action |
|---|---|
| `Space e` | Toggle the file tree |
| `Space o` | Move the cursor into the tree |
| `Space f e` | Reveal where the current file sits in the tree |

With the cursor inside the tree: `a` create, `d` delete, `r` rename, `x` cut,
`c` copy, `p` paste, `R` refresh, `H` toggle hidden files, `g?` show all keys.

---

## LSP

Only works when a language server is attached to the buffer (`:LspInfo` to check).

| Key | Action |
|---|---|
| `g d` | Go to definition |
| `g r` | All references |
| `g I` | All implementations |
| `g y` | Go to type definition |
| `g D` | Go to declaration |
| `K` | Hover docs |
| `g K` | Function signature help |
| `Space l r` | Rename |
| `Space l a` | Code action (auto-fix) |
| `Space l d` | Diagnostic for the current line |
| `Space l i` | LSP info |
| `Space u h` | Toggle inlay hints |
| `C-f` / `C-b` | Scroll the open docs window |

> `g r` waits 0.4s before firing, because Neovim 0.11 ships `gra` `gri` `grn` `grr`
> so it has to wait and see whether you keep typing. To get rid of the delay, remap
> `gr` to something else in `lua/plugins/lsp.lua`, or just use Neovim's own `grr`.

---

## Diagnostics

| Key | Action |
|---|---|
| `] d` / `[ d` | Next / previous diagnostic |
| `Space x d` | Show the diagnostic on the current line |
| `Space x x` | Project-wide diagnostics panel (Trouble) |
| `Space x X` | Diagnostics panel for this file only |
| `Space x s` | Symbol tree |
| `Space x l` | LSP references |
| `Space x q` | Quickfix |
| `Space x t` | TODO list |
| `Space u d` | Toggle diagnostic display |

---

## Git

| Key | Action |
|---|---|
| `] h` / `[ h` | Next / previous hunk |
| `Space g p` | Preview the hunk |
| `Space g h` | Stage the hunk (works in visual mode) |
| `Space g r` | Reset the hunk (works in visual mode) |
| `Space g S` | Stage the whole file |
| `Space g u` | Unstage the hunk you just staged |
| `Space g R` | Reset every change in the file |
| `Space g d` | Diff the whole file |
| `Space g B` | Full blame for the current line |
| `Space g t` | Toggle the faded end-of-line blame |
| `Space g c` | Commit history |
| `Space g s` | Git status |
| `Space g b` | Branch list |

---

## Editing code

| Key | Mode | Action |
|---|---|---|
| `g c c` | normal | Comment / uncomment the line |
| `g c` | visual | Comment / uncomment the selection |
| `g c o` / `g c O` | normal | Add a comment line below / above |
| `y s` + motion + char | normal | Surround with brackets/quotes. e.g. `ysiw"` wraps the word in `"` |
| `c s` + old + new | normal | Change the surround. e.g. `cs"'` turns `"` into `'` |
| `d s` + char | normal | Remove the surround. e.g. `ds"` |
| `J` / `K` | visual | Move the selection down / up |
| `M-j` / `M-k` | normal | Move the line down / up |
| `<` / `>` | visual | Indent, **keeping the selection** |
| `p` | visual | Paste without clobbering what's in the register |
| `Space d` | normal, visual | Delete without writing to the clipboard |
| `Space c f` | normal, visual | Format |

### Selecting by syntax (treesitter)

| Key | Action |
|---|---|
| `C-Space` | Start selecting; press again to widen to the enclosing syntax node |
| `Backspace` | Shrink again |

### Text objects

Use after `d` `c` `y` `v`. e.g. `d i f` = delete the function body, `v a c` = select
the whole class.

| Object | Meaning |
|---|---|
| `a f` / `i f` | Whole function / function body |
| `a c` / `i c` | Whole class / class body |
| `a a` / `i a` | Whole parameter / parameter body |
| `a l` / `i l` | Whole loop / loop body |
| `a i` / `i i` | Whole if block / if body |

| Key | Action |
|---|---|
| `] f` / `[ f` | Next / previous function |
| `] c` / `[ c` | Next / previous class |
| `Space c s` / `Space c S` | Swap the parameter with the next / previous one |
| `] t` / `[ t` | Next / previous TODO |

---

## Completion

| Key | Action |
|---|---|
| `C-Space` | Trigger completion manually |
| `Tab` / `S-Tab` | Select down / up, or jump between snippet placeholders |
| `C-n` / `C-p` | Select down / up |
| `Enter` | Accept the selected entry |
| `C-e` | Close the menu |
| `C-d` / `C-u` | Scroll the documentation pane beside it |

Completion works on the command line too: type `:` or `/`, then `Tab`.

---

## Terminal

| Key | Action |
|---|---|
| `C-\` | Toggle the floating terminal (works from inside the terminal too) |
| `Space t f` | Floating terminal |
| `Space t h` | Horizontal split terminal |
| `Space t v` | Vertical split terminal |
| `Space t t` | Terminal taking up a whole tab |
| `Esc Esc` | Leave terminal mode for normal mode |

### Resizing — works **while you're typing a command**, no need to leave the terminal

| Key | Action |
|---|---|
| `C-Up` / `C-Down` | 2 lines taller / shorter |
| `C-Right` / `C-Left` | 6 columns wider / narrower |

The size is remembered until you quit nvim, for both splits and floating windows.
To open at a given size: `:ToggleTerm size=25 direction=horizontal`.

---

## Sessions

| Key | Action |
|---|---|
| `Space q s` | Restore this directory's session |
| `Space q l` | Restore the most recent session |
| `Space q d` | Don't save a session this time |

---

## UI toggles

| Key | Action |
|---|---|
| `Space u c` | **Switch theme** (live preview, remembers your choice) |
| `Space u z` | Zen mode (focus) |
| `Space u w` | Line wrap |
| `Space u r` | Relative line numbers |
| `Space u s` | Spell check |
| `Space u d` | Show/hide diagnostics |
| `Space u h` | Inlay hints |
| `Space u t` | Sticky context bar at the top |
| `Space u n` | Dismiss notifications |

---

## Notifications & command line (noice)

| Key | Action |
|---|---|
| `Space s n` | Notification history |
| `Space s l` | Last notification |
| `Space s d` | Dismiss all |

---

## Management

| Key | Action |
|---|---|
| `Space L` | Lazy — inside it `I` install, `U` update, `X` remove, `P` profile |
| `Space M` | Mason — inside it `i` install, `X` uninstall |

---

## Built into Neovim 0.11

Not set by this config, but available:

| Key | Action |
|---|---|
| `g r r` | References |
| `g r n` | Rename |
| `g r a` | Code action |
| `g r i` | Implementation |
| `g O` | Symbols in the file |
| `g x` | Open the link/path under the cursor in a browser |
| `] b` / `[ b` | Next / previous buffer |
| `] q` / `[ q` | Next / previous quickfix item |
| `] <Space>` / `[ <Space>` | Insert a blank line below / above |
