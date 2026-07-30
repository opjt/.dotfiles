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
vim.keymap.set('n', '<leader>Q', function()
  require('mini.bufremove').delete(0, false)
end, { noremap = true, silent = true, desc = 'Buffer Delete' })
