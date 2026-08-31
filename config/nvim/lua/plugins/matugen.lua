-- 1. Gọi trực tiếp file màu ra một table tĩnh bên ngoài
local ok, matugen_raw = pcall(require, "matugen_colors")
local matugen_table = ok and type(matugen_raw) == "table" and matugen_raw or {}

return {
  -- Cấu hình plugin Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- Định vị bản tối mocha làm gốc
      color_overrides = {
        -- Đổ table màu sạch đã kiểm tra kiểu dữ liệu vào đây
        mocha = matugen_table, 
      },
      integrations = {
        alpha = true,
        cmp = true,
        flash = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mini = true,
        native_lsp = { enabled = true },
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },

  -- 2. Ép LazyVim nhận diện colorscheme chuẩn hệ thống Catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
