local utils = require 'utils'

-- Do not use sessions if using a minimal config
if utils.is_minimal() then
  return {}
end

return {
  'stevearc/resession.nvim',
  lazy = false,
  event = 'VimEnter',
  opts = {},
  keys = function(_, keys)
    local resession = require 'resession'

    return {
      { '<leader>ws', resession.save, desc = '[W]orkspace: [S]ave Session' },
      { '<leader>wl', resession.load, desc = '[W]orkspace: [L]oad Session' },
      { '<leader>wd', resession.delete, desc = '[W]orkspace: [D]elete Session' },
      unpack(keys),
    }
  end,
  config = function(_, opts)
    local resession = require 'resession'
    resession.setup(opts)

    vim.opt.sessionoptions:append 'globals'
    require('resession').add_hook('pre_save', function()
      vim.api.nvim_exec_autocmds('User', { pattern = 'SessionSavePre' })
    end)

    -- Create a new directory-specific session when Neovim exits.
    -- Reload the session when Neovim starts if no args were passed
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
          -- Save these to a different directory, so our manual sessions don't get polluted
          resession.load(vim.fn.getcwd(), { dir = 'dirsession', silence_errors = true })
        end
      end,
      nested = true,
    })

    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        if vim.fn.argc(-1) == 0 then
          resession.save(vim.fn.getcwd(), { dir = 'dirsession', notify = false })
        end
      end,
    })
  end,
}
