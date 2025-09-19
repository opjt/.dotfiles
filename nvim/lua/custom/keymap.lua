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
