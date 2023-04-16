#!/usr/bin/env bash

# This script installs Nix, Nix packages, pyenv, and sets up a global Python 3.10 environment

# Install Nix
if ! command -v nix-env &> /dev/null; then
  echo "Installing Nix..."
  curl -L https://nixos.org/nix/install | sh
  . $HOME/.nix-profile/etc/profile.d/nix.sh
  echo "Nix has been installed successfully."
fi

# Update Nix
nix-channel --update

# Install Nix packages
packages=(
  nixpkgs.git
  nixpkgs.ripgrep
  nixpkgs.zsh
)

for package in "${packages[@]}"; do
  nix-env -iA "$package"
done

echo "Nix packages have been installed successfully."

# Install pyenv and dependencies
if ! command -v pyenv &> /dev/null; then
  sudo apt-get update
  sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

  curl https://pyenv.run | bash

  echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
  echo 'eval "$(pyenv init -)"' >> ~/.zshrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc

  source ~/.zshrc

  echo "pyenv has been installed successfully."
fi

# Install Python 3.10 and set it as global version
if ! pyenv versions | grep -q "3.10.0"; then
  pyenv install 3.10.0
  pyenv global 3.10.0

  echo "Python 3.10 has been installed and set as the global version."
fi
