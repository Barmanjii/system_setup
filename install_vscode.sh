#!/bin/bash

echo "Do you want to install Visual Studio Code and configure it with custom extensions? [y/N]"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
  echo "Installing Visual Studio Code..."

  # Install dependencies for Visual Studio Code
  sudo apt install -y software-properties-common apt-transport-https

  # Add the Microsoft repository and key
  sudo apt-get install wget gpg
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
  rm -f packages.microsoft.gpg

  # Install Visual Studio Code
  sudo apt update
  sudo apt install -y code

  echo "Visual Studio Code installed successfully."

  # Install VS Code Extensions

  # Check if the extensions file exists
  if [ ! -f "./settings/vscode-extensions.txt" ]; then
    echo "Extensions list file 'vscode-extensions.txt' not found. Please create it with the extension IDs."
    exit 1
  fi

  # Read the extensions from the file and install them
  echo "Installing VS Code extensions from the list..."
  while IFS= read -r extension; do
    if [[ -n "$extension" ]]; then
      installed_extensions=$(code --list-extensions)
      if echo "$installed_extensions" | grep -qi "^$extension$"; then
        echo "$extension is already installed. Skipping..."
      else
        echo "Installing $extension..."
        code --install-extension "$extension"
      fi
    fi
  done < "./settings/vscode-extensions.txt"

  echo "VS Code extensions have been installed."

  # Set custom settings and keybindings (adjust paths accordingly)
  echo "Applying custom settings and keybindings for VS Code..."

  # Define the VS Code user settings directory
  VSCODE_USER_SETTINGS_DIR="${HOME}/.config/Code/User"

  # Check if VS Code settings directory exists
  if [ -d "$VSCODE_USER_SETTINGS_DIR" ]; then
    # Move the settings and keybindings files to the correct directory
    mv "./settings/VSCode-Settings.json" "${VSCODE_USER_SETTINGS_DIR}/settings.json"
    mv "./settings/VSCode-Keybindings.json" "${VSCODE_USER_SETTINGS_DIR}/keybindings.json"
  echo "VS Code settings and keybindings have been updated."
  else
    echo "VS Code user settings directory does not exist. Please ensure VS Code is installed."
  fi
else
  echo "Skipping VS Code installation and configuration."
fi

