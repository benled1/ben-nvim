-- lua/lsp.lua
local lspconfig = require("lspconfig")

-- Capabilities so nvim-cmp can show docs in completion menu
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Common on_attach to set keymaps + handlers
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  -- Hover docs: put cursor on a symbol and press K
  map("n", "K", vim.lsp.buf.hover, "LSP Hover (docs)")

  -- Signature help: shows function parameters (also auto when typing `(` below)
  map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "LSP Signature Help")

  -- Handy extras
  map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("n", "gl", vim.diagnostic.open_float, "Line Diagnostics")
end

-- Tweak diagnostic UI a bit (optional)
vim.diagnostic.config({
  float = { border = "rounded" },
  virtual_text = true,
  severity_sort = true,
})
-- Make LSP floating windows pretty
local orig = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig(contents, syntax, opts, ...)
end

-- OPTIONAL: auto-show hover docs when you pause the cursor
-- (comment these lines out if you don’t want auto popups)
vim.o.updatetime = 300
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  callback = function()
    -- Only open if not already visible
    local wins = vim.api.nvim_tabpage_list_wins(0)
    for _, w in ipairs(wins) do
      local cfg = vim.api.nvim_win_get_config(w)
      if cfg and cfg.zindex then
        return
      end
    end
    vim.lsp.buf.hover()
  end,
})

-- OPTIONAL: inline signature hints while typing
require("lsp_signature").setup({
  hint_enable = true,
  floating_window = true,
  transparency = 0,
  bind = true,
  handler_opts = { border = "rounded" },
})

local cmp = require("cmp")
local luasnip = require("luasnip")

vim.o.completeopt = "menu,menuone,noselect"

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
    { name = "luasnip" },
  },
  window = {
    documentation = cmp.config.window.bordered(), -- this shows the docs panel
  },
})
