#!/bin/bash

set -e

bootstrap_linux() {
  echo "Setting up bootstrap for Linux machine..."
  echo "Installing Ansible..."
  sudo apt update
  sudo apt install --yes software-properties-common
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install --yes ansible
  echo "Installed Ansible!"
}

bootstrap_mac() {
  sudo --validate
  xcode-select --install || echo "Skipped installation for command line tools."
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew install ansible
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

ansible-playbook -vvvv main.yml
