# Bảng phím

`<leader>` = **`Space`**. Giữ `Space` 0.4 giây để which-key hiện gợi ý.
Tìm phím bất kỳ: `Space f k`.

Ký hiệu: `C-` = Ctrl, `M-` = Alt, `S-` = Shift.

---

## Dashboard (màn hình chào)

| Phím | Việc |
|---|---|
| `n` | File mới |
| `f` | Tìm file |
| `o` | Mở cây thư mục |
| `r` | File gần đây |
| `g` | Tìm theo nội dung |
| `s` | Khôi phục session |
| `c` | Mở thư mục config |
| `u` | Đổi theme |
| `l` | Lazy |
| `m` | Mason |
| `q` | Thoát |

---

## Cơ bản

| Phím | Chế độ | Việc |
|---|---|---|
| `jk` | insert | Thoát insert mode |
| `C-s` | normal, insert | Lưu file |
| `Esc` | normal | Xoá highlight tìm kiếm |
| `Space q q` | normal | Thoát tất cả |
| `Space ?` | normal | Phím riêng của buffer hiện tại |

---

## Di chuyển

| Phím | Việc |
|---|---|
| `j` / `k` | Xuống/lên **theo dòng hiển thị** (dòng dài bị wrap vẫn đi đúng) |
| `C-d` / `C-u` | Nửa trang xuống/lên, con trỏ về giữa màn hình |
| `n` / `N` | Kết quả tìm tiếp/trước, tự canh giữa |
| `s` | **Flash** — gõ 2 ký tự rồi nhảy thẳng tới đó |
| `S` | Flash theo khối cú pháp (hàm, block…) |
| `]]` / `[[` | Chỗ dùng tiếp/trước của chữ dưới con trỏ |

> `s` và `S` đã thay cho `s`/`S` gốc của vim (substitute). Muốn dùng substitute
> thì dùng `c l` và `c c`.

---

## Cửa sổ

| Phím | Việc |
|---|---|
| `C-h` `C-j` `C-k` `C-l` | Sang cửa sổ trái/dưới/trên/phải |
| `Space w v` | Tách dọc |
| `Space w s` | Tách ngang |
| `Space w d` | Đóng cửa sổ |
| `Space w e` | Chia đều kích thước |
| `C-Up` / `C-Down` | Cao hơn / thấp hơn |
| `C-Left` / `C-Right` | Hẹp hơn / rộng hơn |

---

## Buffer (tab ở trên cùng)

| Phím | Việc |
|---|---|
| `S-l` / `S-h` | Buffer kế/trước |
| `Space b b` | Quay lại buffer vừa rời |
| `Space b d` | Đóng buffer |
| `Space b o` | Đóng mọi buffer khác |
| `Space b p` | Ghim buffer |
| `Space b P` | Đóng mọi buffer chưa ghim |
| `Space b l` / `Space b r` | Đóng các buffer bên trái / phải |
| `Space f b` | Danh sách buffer (trong đó `C-d` để xoá) |

---

## Tìm file & nội dung (Telescope)

| Phím | Việc |
|---|---|
| `Space Space` | Tìm file (phím nhanh nhất) |
| `Space f f` | Tìm file |
| `Space f g` | Tìm theo nội dung cả dự án |
| `Space f w` | Tìm chữ đang ở dưới con trỏ |
| `Space f /` | Tìm trong file đang mở |
| `Space f r` | File mở gần đây |
| `Space f b` | Buffer đang mở |
| `Space f h` | Tài liệu `:help` |
| `Space f k` | Tra phím tắt |
| `Space f c` | Danh sách lệnh |
| `Space f d` | Mọi lỗi trong dự án |
| `Space f s` / `Space f S` | Symbol trong file / cả workspace |
| `Space f t` | Danh sách TODO/FIXME |

Trong cửa sổ Telescope:

| Phím | Việc |
|---|---|
| `C-j` / `C-k` | Xuống / lên |
| `C-q` | Đẩy toàn bộ kết quả sang quickfix |
| `Esc` | Đóng |

---

## Cây thư mục

| Phím | Việc |
|---|---|
| `Space e` | Bật/tắt cây thư mục |
| `Space o` | Nhảy con trỏ vào cây |
| `Space f e` | Chỉ ra file đang mở nằm ở đâu trong cây |

Khi con trỏ ở trong cây: `a` tạo mới, `d` xoá, `r` đổi tên, `x` cắt, `c` sao chép,
`p` dán, `R` nạp lại, `H` ẩn/hiện file ẩn, `g?` xem toàn bộ phím.

---

## LSP

Chỉ hoạt động khi buffer có language server gắn vào (`:LspInfo` để kiểm tra).

| Phím | Việc |
|---|---|
| `g d` | Tới định nghĩa |
| `g r` | Mọi chỗ tham chiếu |
| `g I` | Mọi chỗ cài đặt (implementation) |
| `g y` | Tới định nghĩa kiểu |
| `g D` | Tới khai báo |
| `K` | Tài liệu nổi |
| `g K` | Gợi ý tham số hàm |
| `Space l r` | Đổi tên |
| `Space l a` | Code action (sửa lỗi tự động) |
| `Space l d` | Lỗi của dòng hiện tại |
| `Space l i` | Thông tin LSP |
| `Space u h` | Bật/tắt inlay hint |
| `C-f` / `C-b` | Cuộn cửa sổ tài liệu đang mở |

> `g r` chờ 0.4 giây trước khi chạy, vì Neovim 0.11 có sẵn `gra` `gri` `grn` `grr`
> nên nó phải đợi xem bạn có gõ thêm không. Muốn hết chờ thì đổi `gr` sang phím
> khác trong `lua/plugins/lsp.lua`, hoặc dùng thẳng `grr` của Neovim.

---

## Chẩn đoán lỗi

| Phím | Việc |
|---|---|
| `] d` / `[ d` | Lỗi kế / trước |
| `Space x d` | Xem lỗi dòng hiện tại |
| `Space x x` | Bảng lỗi cả dự án (Trouble) |
| `Space x X` | Bảng lỗi riêng file này |
| `Space x s` | Cây symbol |
| `Space x l` | Tham chiếu LSP |
| `Space x q` | Quickfix |
| `Space x t` | Danh sách TODO |
| `Space u d` | Bật/tắt hiện lỗi |

---

## Git

| Phím | Việc |
|---|---|
| `] h` / `[ h` | Hunk kế / trước |
| `Space g p` | Xem nội dung hunk |
| `Space g h` | Stage hunk (dùng được ở visual mode) |
| `Space g r` | Bỏ thay đổi của hunk (dùng được ở visual mode) |
| `Space g S` | Stage cả file |
| `Space g u` | Bỏ stage hunk vừa stage |
| `Space g R` | Bỏ mọi thay đổi trong file |
| `Space g d` | Xem diff cả file |
| `Space g B` | Blame đầy đủ dòng hiện tại |
| `Space g t` | Bật/tắt blame mờ ở cuối dòng |
| `Space g c` | Lịch sử commit |
| `Space g s` | Trạng thái git |
| `Space g b` | Danh sách nhánh |

---

## Sửa code

| Phím | Chế độ | Việc |
|---|---|---|
| `g c c` | normal | Comment / bỏ comment dòng |
| `g c` | visual | Comment / bỏ comment vùng chọn |
| `g c o` / `g c O` | normal | Thêm dòng comment dưới / trên |
| `y s` + motion + ký tự | normal | Bọc bằng ngoặc/nháy. Ví dụ `ysiw"` bọc từ bằng `"` |
| `c s` + cũ + mới | normal | Đổi loại bọc. Ví dụ `cs"'` đổi `"` thành `'` |
| `d s` + ký tự | normal | Gỡ bọc. Ví dụ `ds"` |
| `J` / `K` | visual | Đẩy vùng chọn xuống / lên |
| `M-j` / `M-k` | normal | Đẩy dòng xuống / lên |
| `<` / `>` | visual | Thụt lề, **giữ nguyên vùng chọn** |
| `p` | visual | Dán mà không nuốt mất nội dung đang copy |
| `Space d` | normal, visual | Xoá mà không ghi vào clipboard |
| `Space c f` | normal, visual | Format |

### Chọn theo cú pháp (treesitter)

| Phím | Việc |
|---|---|
| `C-Space` | Bắt đầu chọn, bấm thêm để nới rộng theo khối cú pháp |
| `Backspace` | Thu hẹp lại |

### Text object

Dùng sau `d` `c` `y` `v`. Ví dụ `d i f` = xoá ruột hàm, `v a c` = chọn cả class.

| Object | Nghĩa |
|---|---|
| `a f` / `i f` | Cả hàm / ruột hàm |
| `a c` / `i c` | Cả class / ruột class |
| `a a` / `i a` | Cả tham số / ruột tham số |
| `a l` / `i l` | Cả vòng lặp / ruột vòng lặp |
| `a i` / `i i` | Cả khối if / ruột khối if |

| Phím | Việc |
|---|---|
| `] f` / `[ f` | Hàm kế / trước |
| `] c` / `[ c` | Class kế / trước |
| `Space c s` / `Space c S` | Đổi chỗ tham số với cái sau / trước |
| `] t` / `[ t` | TODO kế / trước |

---

## Gõ gợi ý (completion)

| Phím | Việc |
|---|---|
| `C-Space` | Mở gợi ý thủ công |
| `Tab` / `S-Tab` | Chọn xuống / lên, hoặc nhảy giữa các ô của snippet |
| `C-n` / `C-p` | Chọn xuống / lên |
| `Enter` | Chấp nhận mục đang chọn |
| `C-e` | Đóng gợi ý |
| `C-d` / `C-u` | Cuộn phần tài liệu bên cạnh |

Gợi ý cũng chạy ở dòng lệnh: gõ `:` hoặc `/` rồi `Tab`.

---

## Terminal

| Phím | Việc |
|---|---|
| `C-\` | Bật/tắt terminal nổi (dùng được cả trong terminal) |
| `Space t f` | Terminal nổi |
| `Space t h` | Terminal tách ngang |
| `Space t v` | Terminal tách dọc |
| `Space t t` | Terminal chiếm trọn một tab riêng |
| `Esc Esc` | Rời chế độ terminal về normal |

### Chỉnh kích thước — dùng được **ngay khi đang gõ lệnh**, không cần thoát terminal

| Phím | Việc |
|---|---|
| `C-Up` / `C-Down` | Cao thêm / bớt 2 dòng |
| `C-Right` / `C-Left` | Rộng thêm / bớt 6 cột |

Kích thước được nhớ cho tới khi thoát nvim, cả split lẫn cửa sổ nổi.
Mở sẵn một cỡ nhất định: `:ToggleTerm size=25 direction=horizontal`.

---

## Session

| Phím | Việc |
|---|---|
| `Space q s` | Khôi phục session của thư mục này |
| `Space q l` | Khôi phục session gần nhất |
| `Space q d` | Không lưu session lần này |

---

## Bật/tắt giao diện

| Phím | Việc |
|---|---|
| `Space u c` | **Đổi theme** (xem trước trực tiếp, nhớ lựa chọn) |
| `Space u z` | Zen mode (tập trung) |
| `Space u w` | Xuống dòng tự động |
| `Space u r` | Số dòng tương đối |
| `Space u s` | Kiểm tra chính tả |
| `Space u d` | Hiện/ẩn lỗi |
| `Space u h` | Inlay hint |
| `Space u t` | Thanh ngữ cảnh dính ở trên |
| `Space u n` | Dọn thông báo |

---

## Thông báo & dòng lệnh (noice)

| Phím | Việc |
|---|---|
| `Space s n` | Lịch sử thông báo |
| `Space s l` | Thông báo cuối |
| `Space s d` | Dọn tất cả |

---

## Quản lý

| Phím | Việc |
|---|---|
| `Space L` | Lazy — trong đó `I` cài, `U` cập nhật, `X` xoá, `P` xem tốc độ |
| `Space M` | Mason — trong đó `i` cài, `X` gỡ |

---

## Có sẵn từ Neovim 0.11

Không do config này đặt, nhưng dùng được:

| Phím | Việc |
|---|---|
| `g r r` | Tham chiếu |
| `g r n` | Đổi tên |
| `g r a` | Code action |
| `g r i` | Implementation |
| `g O` | Symbol trong file |
| `g x` | Mở link/đường dẫn dưới con trỏ bằng trình duyệt |
| `] b` / `[ b` | Buffer kế / trước |
| `] q` / `[ q` | Mục quickfix kế / trước |
| `] <Space>` / `[ <Space>` | Chèn dòng trống dưới / trên |
