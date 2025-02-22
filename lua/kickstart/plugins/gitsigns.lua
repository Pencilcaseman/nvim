-- return {}

return {
  'lewis6991/gitsigns.nvim',
  -- event = 'VeryLazy',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', '<leader>gb', gitsigns.blame_line, { desc = '[G]it [B]lame line' })
      map('n', '<leader>gt', gitsigns.toggle_current_line_blame, { desc = '[G]it [T]oggle Blame' })
      map('n', '<leader>gd', gitsigns.toggle_deleted, { desc = '[G]it Show [D]eleted' })
    end,
  },
}
