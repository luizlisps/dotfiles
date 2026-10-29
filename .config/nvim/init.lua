-- Theme only: junegunn/seoul256.vim, dark variant on its default 237 background.
vim.pack.add({
  { src = "https://github.com/junegunn/seoul256.vim", name = "seoul256" },
}, { confirm = false })

vim.opt.background = "dark"
vim.g.seoul256_background = 237
vim.cmd.colorscheme("seoul256")
