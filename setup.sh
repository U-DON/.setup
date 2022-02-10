#!/bin/bash

set -e

python3 -m venv .venv
. .venv/bin/activate
pip install ansible
ansible-pull -U "https://github.com/U-DON/.setup" main.yml
