#!/bin/sh

#
# Install or reinstall powerline in /etc/profile.d.
#
# wget -O - https://raw.githubusercontent.com/aheimsbakk/notes/master/install-powerline.sh | sudo bash
#

BASE_URL=https://raw.githubusercontent.com/aheimsbakk/notes/master

source /etc/os-release

case "$ID" in
  debian | ubuntu)
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get -y install python3-pip git tmux vim-nox wget
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

wget -q -nc -O /etc/profile.d/powerline.sh $BASE_URL/powerline.sh

# Used for debugging
#cp -a powerline.sh /etc/profile.d/powerline.sh

echo
echo "Log out and in again to activate powerline."
echo "Or source the configuration in the current shell:"
echo
echo "  source /etc/profile.d/powerline.sh"
echo
