#!/bin/sh

#
# Install or reinstall powerline in /etc/profile.d.
#
# wget -O - https://raw.githubusercontent.com/aheimsbakk/notes/master/install-powerline.sh | sudo bash
#

BASE_URL=https://raw.githubusercontent.com/aheimsbakk/notes/master

source /etc/os-release

case "$ID" in
  debian | raspbian | ubuntu)
    export DEBIAN_FRONTEND=noninteractive
    if [ "$(uname -m)" = "armv7l" ]; then
      wget -q -nc -O /usr/local/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-linux-arm
    elif [ "$(uname -m)" = "aarch64" ]; then
      wget -q -nc -O /usr/local/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-linux-arm64
    else
      wget -q -nc -O /usr/local/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-linux-amd64
    fi
    chmod +x /usr/local/bin/powerline-go
    apt-get update
    apt-get -y install python3-pip git tmux vim-nox wget fonts-powerline
  ;;
  fedora)
    dnf -y install python3-pip git tmux vim wget powerline-go
  ;;
  rhel | centos)
    yum -y install python3-pip git tmux vim wget powerline-go
  ;;
  *)
    echo Unknown OS.
    exit 1
  ;;
esac

wget -q -nc -O /etc/profile.d/powerline-zgo.sh $BASE_URL/powerline-zgo.sh
wget -q -nc -O /etc/profile.d/powerline-other.sh $BASE_URL/powerline-other.sh

echo
echo "Log out and in again to activate powerline-go."
echo "Or source the configuration in the current shell:"
echo
echo "  source /etc/profile.d/powerline-zgo.sh"
echo "  source /etc/profile.d/powerline-other.sh"
echo
