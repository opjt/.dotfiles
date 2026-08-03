return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                exclude = { "**/.venv", "**/build", "**/.pytest_cache", "**/.ruff_cache" },
              },
            },
          },
        },
      },
    },
  },
}
