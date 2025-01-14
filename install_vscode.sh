#!/bin/bash

echo "Do you want to install Visual Studio Code and configure it with custom extensions? [y/N]"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
  echo "Installing Visual Studio Code..."

  # Install dependencies for Visual Studio Code
  sudo apt install -y software-properties-common apt-transport-https curl

  # Add the Microsoft repository and key
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

  # Install Visual Studio Code
  sudo apt update
  sudo apt install -y code

  echo "Visual Studio Code installed successfully."

  # Install VS Code Extensions

  # Check if the extensions file exists
  if [ ! -f "./vscode-extensions.txt" ]; then
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
  done < "./vscode-extensions.txt"

  echo "VS Code extensions have been installed."

  # Set custom settings and keybindings (adjust paths accordingly)
  echo "Applying custom settings and keybindings for VS Code..."

  # Define the target directory for VS Code user settings on Ubuntu
  VSCODE_USER_SETTINGS_DIR="${HOME}/.config/Code/User"

  # Check if VS Code settings directory exists
  if [ -d "$VSCODE_USER_SETTINGS_DIR" ]; then
    # Link custom settings and keybindings files
    ln -sf "${HOME}/settings/VSCode-Settings.json" "${VSCODE_USER_SETTINGS_DIR}/settings.json"
    ln -sf "${HOME}/settings/VSCode-Keybindings.json" "${VSCODE_USER_SETTINGS_DIR}/keybindings.json"
    echo "VS Code settings and keybindings have been updated."
  else
    echo "VS Code user settings directory does not exist. Please ensure VS Code is installed."
  fi

  # Open VS Code (optional: you can skip this if you don't want to open VS Code automatically)
  code .
  echo "Login to extensions (Copilot, Grammarly, etc.) within VS Code."
  echo "Press enter to continue..."
  read
else
  echo "Skipping VS Code installation and configuration."
fi

