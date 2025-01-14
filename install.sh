#!/bin/bash

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
git gh vim nano neovim curl wget gpg terminator fzf openssl net-tools
)

# Installing basic packages
echo "Installing basic packages..."
for package in "${PACKAGES[@]}"; do
  install_package "$package"
done

gh auth login

# Setup Git
echo "Enter User name:"
read user_name
git config --global user.name "$user_name"

echo "Enter Email address:"
read email
git config --global user.email "$email"

# Function to install custom git aliases from a file
install_git_aliases() {
  echo "Do you want to install custom git aliases? [y/N]"
  read -r response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    ALIAS_FILE="./settings/git-aliases.txt"  

    # Check if the alias file exists
    if [[ -f "$ALIAS_FILE" ]]; then
      echo "Adding custom git aliases to .gitconfig..."

      # Check if [alias] section exists in .gitconfig
      if ! grep -q "^\[alias\]" ~/.gitconfig; then
        echo "[alias]" >> ~/.gitconfig
      fi

      # Read the alias file and add each alias
      while read -r alias_line; do
        # Skip empty lines or comments
        if [[ -z "$alias_line" || "$alias_line" =~ ^# ]]; then
          continue
        fi

        # Check if alias line starts with '  ' (indentation), remove leading spaces/tabs
        alias_line=$(echo "$alias_line" | sed 's/^[[:space:]]*//')

        # Check if the alias already exists in .gitconfig
        alias_name=$(echo "$alias_line" | cut -d' ' -f1)
        if ! grep -q "^$alias_name =" ~/.gitconfig; then
          echo "$alias_line" >> ~/.gitconfig
        else
          echo "Alias '$alias_name' already exists, skipping."
        fi
      done < <(sed '1d' "$ALIAS_FILE")  # Remove the first line with '[alias]'

      echo "Git aliases have been added to .gitconfig."
    else
      echo "Alias file $ALIAS_FILE does not exist."
    fi
  fi
}

# Main installation procedure
install_git_aliases

# Prompt to install additional software
echo "Do you want to install additional software (e.g., VSCode, Slack, Brave)? [y/N]"
read -r install_software

if [[ "$install_software" =~ ^[Yy]$ ]]; then
  # List of additional software scripts
  SCRIPTS=(
    "install_vscode.sh"
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
