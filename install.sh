#!/bin/bash

# Updating and upgrading the system
echo "Updating and upgrading the system..."
sudo apt update -y && sudo apt upgrade -y

# Function to install a package
install_package() {
  local package=$1
  echo "Do you want to install $package? [y/N]"
  read -r response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    if sudo apt install -y "$package"; then
      echo "$package installed successfully."
    else
      echo "Failed to install $package!" >&2
    fi
  else
    echo "Skipping $package."
  fi
}

# List of packages to install
PACKAGES=(
git gh vim nano neovim curl wget gpg
)

# Iterate through the package list
echo "Starting package installation..."
for package in "${PACKAGES[@]}"; do
  install_package "$package"
done

# Final message
echo "Installation complete! Your system is now up-to-date and has the necessary tools installed."
