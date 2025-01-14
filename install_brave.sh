#!/bin/bash

echo "Do you want to install Brave Browser? [y/N]"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
  echo "Installing Brave Browser..."
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  sudo apt update
  sudo apt install -y brave-browser
  echo "Brave Browser installed successfully."
else
  echo "Skipping Brave Browser."
fi

