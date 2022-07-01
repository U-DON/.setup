#!/bin/bash

set -e

bootstrap_linux() {
  echo "Linux support TBD..."

  # python3 -m venv .venv
  # . .venv/bin/activate
  # pip install --upgrade pip ansible

  exit 1
}

bootstrap_mac() {
  sudo --validate

  xcode-select --install || echo "Skipped command line developer tools installation."
  /usr/sbin/softwareupdate --install-rosetta

  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  eval "$(/opt/homebrew/bin/brew shellenv)"

  brew install ansible
}

bootstrap_unsupported() {
  echo "Unsupported OS!"
  exit 1
}

case "$(uname -s)" in
   Linux)  bootstrap_linux ;;
  Darwin)  bootstrap_mac ;;
       *)  bootstrap_unsupported ;;
esac

ansible-playbook -vvvv main.yml
