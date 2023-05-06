#!/bin/sh

#
# Install or reinstall powerline in /etc/profile.d.
#
# wget -O - https://raw.githubusercontent.com/aheimsbakk/notes/master/install-powerline.sh | sudo bash
#

BASE_URL=https://raw.githubusercontent.com/aheimsbakk/notes/master

source /etc/os-release

rm -f /usr/local/bin/powerline-go
if [ "$(uname -m)" = "armv7l" ]; then
  wget -q -nc -O /usr/local/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.22.1/powerline-go-linux-arm
elif [ "$(uname -m)" = "aarch64" ]; then
  wget -q -nc -O /usr/local/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.22.1/powerline-go-linux-arm64
else
  wget -q -nc -O /usr/local/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.22.1/powerline-go-linux-amd64
fi
chmod +x /usr/local/bin/powerline-go

case "$ID" in
  debian | raspbian | ubuntu)
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get -y install python3-pip git tmux vim-nox wget fonts-powerline
  ;;
  fedora)
    dnf -y install python3-pip git tmux vim wget
  ;;
  rhel | centos)
    yum -y install python3-pip git tmux vim wget
  ;;
  *)
    echo Unknown OS.
    exit 1
  ;;
esac

rm -f /etc/profile.d/powerline-zgo.sh /etc/profile.d/powerline-other.sh /etc/profile.d/z-powerline-go.sh /etc/profile.d/powerline.sh /etc/profile.d/zzz-powerline.sh
wget -q -nc -O /etc/profile.d/z-powerline-go.sh $BASE_URL/powerline-zgo.sh
wget -q -nc -O /etc/profile.d/powerline-other.sh $BASE_URL/powerline-other.sh

echo
echo "Log out and in again to activate powerline-go."
echo "Or source the configuration in the current shell:"
echo
echo "  source /etc/profile.d/powerline-other.sh"
echo "  source /etc/profile.d/z-powerline-go.sh"
echo
