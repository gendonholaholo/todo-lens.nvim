# 🧪 TODO-LENS.NVIM TESTING GUIDE

## 📋 Pre-Test Checklist

✅ Plugin sudah dikonfigurasi di `/home/Gos/.config/nvim/lua/plugins/testgos.lua`
✅ File test `test_file.lua` sudah dibuat
✅ Neovim v0.11.2 sudah terinstall

## 🚀 Langkah Testing

### 1. Restart Neovim
```bash
# Keluar dari Neovim jika sedang buka, lalu buka lagi
nvim
```

### 2. Buka File Test
```vim
:e test_file.lua
```

### 3. Test Highlighting
- Anda seharusnya melihat kata-kata berikut ter-highlight dengan warna berbeda:
  - `TODO` - Orange (#ff9e64)
  - `FIXME` - Red (#e86671)
  - `HACK` - Purple (#bb9af7)
  - `NOTE` - Blue (#7dcfff)
  - `BUG` - Pink (#f7768e)
  - `PERF` - Green (#9ece6a)

### 4. Test Commands

#### A. TodoList Command
```vim
:TodoList
```
**Expected Result:** Quickfix window terbuka dengan daftar semua TODO items

#### B. TodoToggle Command
```vim
:TodoToggle
```
**Expected Result:** Highlighting hilang, jalankan lagi untuk menampilkan kembali

#### C. TodoTelescope Command (jika ada Telescope)
```vim
:TodoTelescope
```
**Expected Result:** Telescope picker terbuka dengan fuzzy search

### 5. Test Keymaps
- `<leader>tl` - TodoList
- `<leader>tt` - TodoToggle
- `<leader>tf` - TodoTelescope

## 🔧 Troubleshooting

### Problem: Plugin tidak load
**Solution:**
1. Restart Neovim
2. Check `:Lazy` untuk melihat status plugin
3. Run `:Lazy reload todo-lens.nvim`

### Problem: Tidak ada highlighting
**Solution:**
1. Check `:TodoToggle` untuk memastikan highlighting aktif
2. Pastikan file berisi TODO comments
3. Check `:messages` untuk error

### Problem: Commands tidak ada
**Solution:**
1. Check `:command Todo` untuk melihat available commands
2. Pastikan plugin sudah di-setup dengan benar

### Problem: Keymaps tidak work
**Solution:**
1. Check leader key: `:echo mapleader`
2. Test manual command dulu: `:TodoList`

## 📊 Expected Test Results

Jika semua berjalan dengan baik, Anda akan melihat:
- ✅ 6 TODO items ter-highlight dengan warna berbeda
- ✅ `:TodoList` menampilkan 6 items di quickfix
- ✅ `:TodoToggle` menghilangkan/menampilkan highlighting
- ✅ Keymaps `<leader>tl`, `<leader>tt`, `<leader>tf` berfungsi

## 🐛 Jika Ada Error

Jalankan command berikut untuk debugging:
```vim
:messages
:checkhealth todo-lens
:lua print(vim.inspect(require("todo_lens")))
```

## 🎉 Success Indicators

Plugin berhasil jika:
1. File `test_file.lua` menampilkan highlighting pada TODO comments
2. `:TodoList` menampilkan 6 items
3. Navigasi quickfix berfungsi (tekan Enter pada item untuk jump)
4. Toggle highlighting berfungsi

---

**Next Steps:** Jika test berhasil, plugin siap digunakan di project Anda! 