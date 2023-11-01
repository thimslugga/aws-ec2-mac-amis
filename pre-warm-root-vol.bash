#!/bin/bash
set -exo pipefail
[[ ! $EUID -eq 0 ]] && echo "RUN AS ROOT!" && exit 1
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${SCRIPT_DIR}"
export PATH="${PATH}:/opt/homebrew/bin:/opt/homebrew/sbin" # support new arm brew location
su ec2-user -c 'brew install fio'
fio --filename=/dev/r$(df -h / | grep -o 'disk[0-9]') --rw=read --bs=1M --iodepth=32 --ioengine=posixaio --direct=1 --name=volume-initialize
su ec2-user -c 'brew uninstall fio'