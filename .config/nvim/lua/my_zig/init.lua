vim.pack.add {
  'https://codeberg.org/ziglang/zig.vim',
}

-- don't show parse errors in a separate window
vim.g.zig_fmt_parse_errors = 1
-- enable  format-on-save from vim.lsp + ZLS
vim.g.build_on_save = 1
-- Terminal colors
vim.o.termguicolors = true
-- Formatting with ZLS matches `zig fmt`.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.zig', '*.zon' },
  callback = function(ev)
    vim.lsp.buf.format()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.zig', '*.zon' },
  callback = function(ev)
    vim.lsp.buf.code_action {
      context = { only = { 'source.fixAll' } },
      apply = true,
    }
  end,
})

vim.lsp.config['zls'] = {
  -- Set to 'zls' if `zls` is in your PATH
  cmd = { 'zls' },
  filetypes = { 'zig' },
  root_markers = { 'build.zig' },
  -- There are two ways to set config options:
  --   - edit your `zls.json` that applies to any editor that uses ZLS
  --   - set in-editor config options with the `settings` field below.
  --
  -- Further information on how to configure ZLS:
  -- https://zigtools.org/zls/configure/
  settings = {
    zls = {
      -- Whether to enable build-on-save diagnostics
      --
      -- Further information about build-on save:
      -- https://zigtools.org/zls/guides/build-on-save/
      -- enable_build_on_save = true,

      -- omit the following line if `zig` is in your PATH
    },
  },
}
vim.lsp.enable 'zls'
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
