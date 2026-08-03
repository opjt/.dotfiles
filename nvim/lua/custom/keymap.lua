-- 상태 저장용 변수
local diagnostics_enabled = true

-- 토글 함수
local function toggle_diagnostics()
  if diagnostics_enabled then
    vim.diagnostic.enable(false) -- 현재 버퍼 진단 끄기
    diagnostics_enabled = false
  else
    vim.diagnostic.enable(true) -- 현재 버퍼 진단 켜기
    diagnostics_enabled = true
  end
end

-- 단축키 등록 (<leader>dd 로 예시)
vim.keymap.set('n', '<leader>td', toggle_diagnostics, { noremap = true, silent = true, desc = 'Toggle Diagnostics' })

-- 버퍼 닫기 (창 레이아웃은 유지한 채 버퍼만 제거: mini.bufremove)
vim.keymap.set('n', '<leader>W', function()
  require('mini.bufremove').delete(0, false)
end, { noremap = true, silent = true, desc = 'Buffer Delete' })

-- 저장 시 ruff로 lint 자동수정 + import 정리 (VSCode의 source.fixAll.ruff / source.organizeImports.ruff 대응)
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.py',
  desc = 'Ruff: fix lint issues + organize imports on save',
  callback = function(args)
    local clients = vim.lsp.get_clients { bufnr = args.buf, name = 'ruff' }
    local client = clients[1]
    if not client then
      return
    end

    -- ruff expects LSP-shaped Diagnostic objects (with a `range` field), not
    -- Neovim's internal diagnostic shape (lnum/col). Each nvim diagnostic that
    -- originated from an LSP publishDiagnostics keeps the original under
    -- user_data.lsp, so pull that back out.
    local lsp_diagnostics = {}
    for _, d in ipairs(vim.diagnostic.get(args.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })) do
      if d.user_data and d.user_data.lsp then
        table.insert(lsp_diagnostics, d.user_data.lsp)
      end
    end

    local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
    params.context = {
      only = { 'source.fixAll.ruff', 'source.organizeImports.ruff' },
      diagnostics = lsp_diagnostics,
    }

    local result = client:request_sync('textDocument/codeAction', params, 1000, args.buf)
    if not result or not result.result then
      return
    end

    for _, action in ipairs(result.result) do
      -- ruff advertises codeActionProvider.resolveProvider = true and only sends
      -- title/kind/data up front; the actual edit has to be fetched via codeAction/resolve.
      if not action.edit and client:supports_method('codeAction/resolve') then
        local resolved = client:request_sync('codeAction/resolve', action, 1000, args.buf)
        action = (resolved and resolved.result) or action
      end

      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
      elseif action.command then
        client:exec_cmd(action.command, { bufnr = args.buf })
      end
    end
  end,
})
