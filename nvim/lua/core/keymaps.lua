local keymap = vim.keymap -- for conciseness

---------------- General Keymaps -------------------

-- save file
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>")

--Format code
keymap.set("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format()<CR>", {desc = "Code format"})

--move highlighted stuff up and down
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
keymap.set("n", "J", "mzJ`z")

--Yank to clipboard
keymap.set({"n", "v"}, "<leader>y", '\"+y')

--replace current word
keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {desc = "Replace current word"})

-- window management
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })     -- split window vertically
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })   -- split window horizontally
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })      -- make split windows equal width & height
keymap.set("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Move to window using the <alt> hjkl keys
keymap.set("n", "<A-h>", "<C-w>h", { desc = "Go to left window", remap = true })
keymap.set("n", "<A-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
keymap.set("n", "<A-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
keymap.set("n", "<A-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Tmux overrides
keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", {desc = "Tmux navigate window left"})
keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", {desc = "Tmux navigate window right"})
keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", {desc = "Tmux navigate window down"})
keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", {desc = "Tmux navigate window up"})

-- buffers
keymap.set("n", "<A-1>", "<Cmd>BufferLineGoToBuffer 1<CR>")
keymap.set("n", "<A-2>", "<Cmd>BufferLineGoToBuffer 2<CR>")
keymap.set("n", "<A-3>", "<Cmd>BufferLineGoToBuffer 3<CR>")
keymap.set("n", "<A-4>", "<Cmd>BufferLineGoToBuffer 4<CR>")
keymap.set("n", "<A-5>", "<Cmd>BufferLineGoToBuffer 5<CR>")
keymap.set("n", "<A-6>", "<Cmd>BufferLineGoToBuffer 6<CR>")
keymap.set("n", "<A-7>", "<Cmd>BufferLineGoToBuffer 7<CR>")
keymap.set("n", "<A-8>", "<Cmd>BufferLineGoToBuffer 8<CR>")
keymap.set("n", "<A-9>", "<Cmd>BufferLineGoToBuffer 9<CR>")
keymap.set("n", "<A-w>", "<Cmd>bdelete<CR>")
keymap.set("n", "<A-q>", "<Cmd>q<CR>")
