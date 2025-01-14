#!/bin/bash

# Check if the user has sudo privileges
if ! sudo -v &>/dev/null; then
  echo "You must have sudo privileges to run this script. Exiting..."
  exit 1
fi

# Check if bash is available
if ! command -v bash &>/dev/null; then
  echo "Bash is not installed. Please install bash and try again."
  exit 1
fi

# Updating and upgrading the system
echo "Updating and upgrading the system..."
sudo apt update -y && sudo apt upgrade -y

# Function to install a basic package
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

# Basic package list to install
PACKAGES=(
git gh vim nano neovim curl wget gpg terminator
)

# Installing basic packages
echo "Installing basic packages..."
for package in "${PACKAGES[@]}"; do
  install_package "$package"
done

# Prompt to install additional software
echo "Do you want to install additional software (e.g., VSCode, Slack, Brave)? [y/N]"
read -r install_software

if [[ "$install_software" =~ ^[Yy]$ ]]; then
  # List of additional software scripts
  SCRIPTS=(
    "install_vscode.sh"
    "install_slack.sh"
    "install_brave.sh"
  )

  # Run each additional software script
  for script in "${SCRIPTS[@]}"; do
    if [[ -f "$script" ]]; then
      echo "Running $script..."
      bash "$script"
      if [[ $? -ne 0 ]]; then
        echo "Error occurred while running $script. Skipping further scripts."
        break
      fi
    else
      echo "Script $script not found. Skipping..."
    fi
  done
else
  echo "Skipping additional software installation."
fi

# Final message
echo "Installation complete! Your system is now up-to-date and has the necessary tools installed."
