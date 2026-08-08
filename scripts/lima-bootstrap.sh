#!/usr/bin/env bash
# Installs the apt packages this nvim config (LazyVim + mason) needs on a
# fresh lima VM: unzip/curl/git for mason's installer, clangd/clang-format
# for C (mason has no linux-arm64 clangd binaries, see nvim/lua/plugins/clangd.lua),
# and node/go/python toolchains for the go/json/markdown/python/toml LazyVim extras.
set -euo pipefail

PACKAGES=(
  build-essential
  unzip
  curl
  git
  ripgrep
  fd-find
  clangd
  clang-format
  nodejs
  npm
  python3-pip
  golang-go
)

sudo apt-get update
sudo apt-get install -y "${PACKAGES[@]}"

# Neovim: pinned to match the version this dotfiles config was last verified
# against (bump this + re-test when intentionally upgrading).
NVIM_VERSION="v0.12.1"
NVIM_ARCH="nvim-linux-$(dpkg --print-architecture | sed 's/amd64/x86_64/;s/arm64/arm64/')"
NVIM_DEST="/usr/local/${NVIM_ARCH}"

if [[ ! -x "${NVIM_DEST}/bin/nvim" ]] || [[ "$("${NVIM_DEST}/bin/nvim" --version | head -1)" != "NVIM ${NVIM_VERSION}" ]]; then
  TMP_TARBALL="$(mktemp)"
  curl -fL "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_ARCH}.tar.gz" -o "${TMP_TARBALL}"
  sudo rm -rf "${NVIM_DEST}"
  sudo tar -C /usr/local -xzf "${TMP_TARBALL}"
  rm -f "${TMP_TARBALL}"
fi

echo "nvim: $("${NVIM_DEST}/bin/nvim" --version | head -1)"

# Put nvim on PATH for every shell. `limactl shell` runs an interactive
# non-login bash, which reads /etc/bash.bashrc (not /etc/profile.d), so both
# are set here to also cover login shells and other interpreters.
NVIM_PATH_LINE="export PATH=\"${NVIM_DEST}/bin:\$PATH\""
echo "${NVIM_PATH_LINE}" | sudo tee /etc/profile.d/nvim-path.sh > /dev/null
sudo chmod +x /etc/profile.d/nvim-path.sh
grep -qxF "${NVIM_PATH_LINE}" /etc/bash.bashrc 2>/dev/null || echo "${NVIM_PATH_LINE}" | sudo tee -a /etc/bash.bashrc > /dev/null

# Share the nvim config with the mac host: lima mounts /Users from the host
# by default, so this points at the same dotfiles checkout instead of a copy.
DOTFILES_NVIM="/Users/pjt/dotfiles/nvim"
CONFIG_NVIM="${HOME}/.config/nvim"

mkdir -p "${HOME}/.config"
if [[ -L "${CONFIG_NVIM}" && "$(readlink "${CONFIG_NVIM}")" == "${DOTFILES_NVIM}" ]]; then
  : # already linked
elif [[ -e "${CONFIG_NVIM}" ]]; then
  mv "${CONFIG_NVIM}" "${CONFIG_NVIM}.bak.$(date +%s)"
  ln -s "${DOTFILES_NVIM}" "${CONFIG_NVIM}"
else
  ln -s "${DOTFILES_NVIM}" "${CONFIG_NVIM}"
fi
echo "nvim config: ${CONFIG_NVIM} -> $(readlink "${CONFIG_NVIM}")"
