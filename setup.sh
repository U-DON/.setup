#!/bin/bash

set -e

bootstrap_linux() {
  echo "Setting up bootstrap for Linux..."

  sudo apt update

  echo "Installing dependencies for add-apt-repository..."
  sudo apt install --yes \
    python3-launchpadlib \
    software-properties-common

  echo "Adding apt repository for Ansible..."
  sudo add-apt-repository --yes --update ppa:ansible/ansible

  echo "Installing Ansible..."
  sudo apt install --yes ansible

  echo "Finished bootstrap for Linux!"
}

bootstrap_mac() {
  echo "Setting up bootstrap for macOS..."
  sudo --validate

  echo "Installing command line tools..."
  xcode-select --install || echo "Skipped installation for command line tools."

  echo "Installing Rosetta..."
  /usr/sbin/softwareupdate \
    --install-rosetta \
    --agree-to-license

  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  eval "$(/opt/homebrew/bin/brew shellenv)"

  echo "Installing Ansible..."
  brew install ansible

  echo "Finished bootstrap for macOS!"
}

bootstrap_unsupported() {
  echo "Unsupported OS!"
  exit 1
}

case "$(uname -s)" in
   Linux) bootstrap_linux ;;
  Darwin) bootstrap_mac ;;
       *) bootstrap_unsupported ;;
esac

echo "Running Ansible playbook..."
ansible-playbook -vvvv main.yml
