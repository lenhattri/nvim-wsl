# Neovim của hisato

Cấu hình Neovim tự dựng trên [lazy.nvim](https://github.com/folke/lazy.nvim), hướng
cyberpunk. Không dùng framework (NvChad/LazyVim) — mọi file đều của bạn, sửa thoải mái.

- **Phím leader:** `Space`
- **Bảng phím đầy đủ:** [KEYMAPS.md](KEYMAPS.md)
- **Quên phím?** Giữ `Space` 0.4 giây, which-key hiện mọi nhánh. Hoặc `Space f k`
  để tìm phím bằng Telescope.

---

## Cấu trúc

```
~/.config/nvim/
├── init.lua                  nạp core/ rồi lazy.nvim
├── lua/core/
│   ├── options.lua           tuỳ chọn vim, diagnostics, clipboard WSL
│   ├── keymaps.lua           phím không phụ thuộc plugin
│   ├── autocmds.lua          autocmd (highlight yank, trim whitespace, …)
│   ├── lazy.lua              bootstrap + cấu hình lazy.nvim
│   ├── theme.lua             nạp/ghi nhớ colorscheme
│   └── ascii.lua             ASCII art cho dashboard (file sinh tự động)
└── lua/plugins/
    ├── theme.lua             12 colorscheme
    ├── ui.lua                lualine, bufferline, noice, indent, cursor…
    ├── dashboard.lua         màn hình chào cyberpunk
    ├── editor.lua            telescope, nvim-tree, gitsigns, which-key…
    ├── lsp.lua               mason, lspconfig, navic, conform
    ├── cmp.lua               nvim-cmp + LuaSnip
    └── treesitter.lua        treesitter + textobjects + context
```

Mỗi file trong `lua/plugins/` trả về một bảng spec của lazy.nvim. Thêm file mới vào
thư mục đó là nó tự được nạp — không cần khai báo ở đâu cả.

---

## Việc hằng ngày

### Mở file

| Muốn gì | Làm sao |
|---|---|
| Mở file theo tên | `Space Space` (hoặc `Space f f`) |
| Tìm theo nội dung | `Space f g` |
| Tìm chữ dưới con trỏ trong cả dự án | `Space f w` |
| File vừa mở gần đây | `Space f r` |
| Cây thư mục | `Space e` |
| Tìm trong file đang mở | `Space f /` |

Trong Telescope: `Ctrl-j` / `Ctrl-k` để di chuyển, `Enter` mở, `Esc` thoát,
`Ctrl-q` đẩy toàn bộ kết quả vào quickfix.

### Sửa code với LSP

Server tự cài qua Mason và tự bật khi bạn mở file đúng loại.

| Muốn gì | Làm sao |
|---|---|
| Xem định nghĩa | `g d` |
| Xem mọi chỗ dùng | `g r` |
| Đọc tài liệu | `K` |
| Đổi tên biến/hàm | `Space l r` |
| Sửa lỗi tự động | `Space l a` |
| Xem lỗi dòng hiện tại | `Space l d` |
| Nhảy lỗi tiếp theo | `] d` |
| Danh sách lỗi cả dự án | `Space x x` |

### Git

| Muốn gì | Làm sao |
|---|---|
| Nhảy hunk tiếp/trước | `] h` / `[ h` |
| Xem hunk | `Space g p` |
| Stage hunk | `Space g h` |
| Bỏ thay đổi của hunk | `Space g r` |
| Ai sửa dòng này | `Space g B` |
| Xem diff cả file | `Space g d` |
| Lịch sử commit | `Space g c` |

Blame dòng hiện tại hiện mờ ở cuối dòng sau 0.5 giây. Tắt bằng `Space g t`.

### Định dạng code

Lưu file là tự format (conform.nvim). Tắt tạm:

```vim
:FormatDisable     " tắt toàn cục
:FormatDisable!    " chỉ tắt cho buffer hiện tại
:FormatEnable      " bật lại
```

Format thủ công: `Space c f`.

---

## Đổi theme

`Space u c` mở danh sách 62 theme, **xem trước ngay khi di chuyển con trỏ**. Chọn
xong lựa chọn được ghi vào `~/.local/share/nvim/colorscheme` và tự áp dụng ở lần
khởi động sau.

Mặc định là `cyberdream`. Đổi mặc định ở `lua/core/theme.lua`:

```lua
local DEFAULT = "cyberdream"
```

Dashboard luôn giữ màu neon riêng, không đổi theo theme.

---

## Tuỳ biến

### Thêm plugin

Tạo file mới trong `lua/plugins/`, ví dụ `lua/plugins/extra.lua`:

```lua
return {
  {
    "tên-tác-giả/tên-plugin",
    event = "VeryLazy",        -- nạp trễ cho nhanh khởi động
    opts = { ... },            -- lazy.nvim tự gọi require("tên").setup(opts)
  },
}
```

Lưu file rồi `Space L` → `I` để cài. Hoặc khởi động lại nvim, lazy tự phát hiện.

### Thêm LSP server

Mở `lua/plugins/lsp.lua`, thêm tên server vào `ensure_installed`:

```lua
ensure_installed = {
  "lua_ls", "ts_ls", "html", "cssls", "jsonls", "bashls", "pyright",
  "gopls",          -- ví dụ: thêm Go
},
```

Mason tự tải về và `automatic_enable` tự bật nó. Cần chỉnh riêng thì thêm:

```lua
vim.lsp.config("gopls", {
  settings = { gopls = { ... } },
})
```

> **Lưu ý:** `stylua` nằm trong danh sách `exclude` của `automatic_enable`.
> nvim-lspconfig có file `lsp/stylua.lua` nên mason-lspconfig sẽ tưởng nhầm
> stylua là language server và khởi động nó — nó thoát ngay với mã lỗi 2.
> stylua được conform.nvim gọi đúng cách. Formatter khác cũng có thể vướng
> lỗi này; nếu thấy "Client X quit with exit code" thì thêm X vào `exclude`.

### Thêm formatter

Hai chỗ, trong `lua/plugins/lsp.lua`:

```lua
-- 1. để Mason tải nó về
{ "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = { ensure_installed = { "stylua", "prettierd", "shfmt", "ruff", "gofumpt" } } }

-- 2. gán cho loại file
formatters_by_ft = {
  go = { "gofumpt" },
}
```

### Thêm ngôn ngữ cho treesitter

`lua/plugins/treesitter.lua` → `ensure_installed`. Thực ra không cần: `auto_install`
đang bật nên mở file lạ là nó tự tải parser.

### Đổi ASCII art ở dashboard

Art nằm trong `lua/core/ascii.lua` (`portrait` cho màn rộng, `uwu` cho màn hẹp).
Thay bằng art khác thì dán vào đó, rồi sửa `ART_W` trong `lua/plugins/dashboard.lua`
cho khớp **chiều rộng tính bằng ô** của art mới.

Nên dùng art kiểu **braille** (`⣿⡿⠿`) chứ đừng dùng khối (`██░░▒▒`): braille nhồi
8 chấm vào một ô nên mịn hơn nhiều, còn khối chỉ có 4 mức sáng và nhìn như vỡ pixel.

---

## Khởi động nhanh cỡ nào

Dashboard hiện số liệu thật ở dòng cuối. Muốn xem chi tiết plugin nào chậm:

```vim
:Lazy profile
```

Mọi plugin đều nạp trễ trừ nhóm colorscheme (phải nạp sớm để `Space u c` xem trước
được) và lualine/bufferline/noice (nạp ở `VeryLazy`, tức sau khi đã vẽ xong màn hình).

---

## Xử lý sự cố

| Triệu chứng | Nguyên nhân & cách xử lý |
|---|---|
| Icon hiện thành ô vuông | Terminal chưa dùng Nerd Font. Cài JetBrainsMono Nerd Font rồi chọn trong Windows Terminal → Settings → profile → Appearance → Font face |
| Treesitter báo lỗi compile | Thiếu `gcc`/`make`: `sudo apt install build-essential` |
| Mason không cài được server | Thiếu `unzip`: `sudo apt install unzip` |
| LSP không chạy | `:LspInfo` xem đã attach chưa, `:Mason` xem server đã cài chưa, `:checkhealth lsp` |
| Plugin lỗi sau khi update | `:Lazy restore` quay về lockfile, hoặc `:Lazy clean` rồi `:Lazy sync` |
| Copy/paste không sang Windows | Cấu hình WSL dùng `clip.exe` + `powershell.exe`, xem `lua/core/options.lua` |
| Terminal quá nhỏ/to | `C-Up` `C-Down` `C-Left` `C-Right` ngay trong terminal. Đổi cỡ mặc định ở `size`/`float_opts` trong `lua/plugins/editor.lua` |
| Muốn kiểm tra tổng thể | `:checkhealth` |

Lệnh chẩn đoán hay dùng:

```vim
:Lazy          " quản lý plugin (I cài, U cập nhật, X xoá, P profile)
:Mason         " quản lý LSP/formatter (i cài, X gỡ)
:LspInfo       " server nào đang gắn vào buffer này
:ConformInfo   " formatter nào áp dụng cho buffer này
:checkhealth   " kiểm tra toàn bộ
```

---

## Phụ thuộc hệ thống

Đã cài đủ trên máy này. Nếu dựng lại ở máy khác:

```bash
sudo apt install build-essential unzip ripgrep fd-find git curl
# nodejs cho các LSP viết bằng JS (ts_ls, html, cssls, jsonls, bashls)
```

| Gói | Dùng để làm gì |
|---|---|
| `build-essential` | compile parser của treesitter — **bắt buộc** |
| `unzip` | Mason giải nén gói LSP |
| `ripgrep` | `Space f g` tìm theo nội dung |
| `fd-find` | tìm file nhanh hơn (trên Ubuntu lệnh tên là `fdfind`) |
| `nodejs` | chạy các LSP viết bằng JavaScript |
