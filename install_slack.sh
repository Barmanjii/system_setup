#!/bin/bash

echo "Do you want to install Slack? [y/N]"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
  echo "Installing Slack..."
  wget -O slack.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-4.33.90-amd64.deb
  sudo apt install -y ./slack.deb
  rm -f slack.deb
  echo "Slack installed successfully."
else
  echo "Skipping Slack."
fi

