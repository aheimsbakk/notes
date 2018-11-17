#!/bin/bash
# vim: ts=2 st=2 et ai:
#
# Author: Arnulf Heimsbakk 
# URL   : https://github.com/aheimsbakk/notes
# Date  : 2018-11-17

# Install powerline and Vim with Python bindings
sudo dnf install -y powerline tmux tmux-powerline vim vim-powerline

# Add starting powerline daemon and bindings to bash
if ! grep -q powerline ~/.bashrc
then
  cat <<EOF >> ~/.bashrc
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bash/powerline.sh
fi
EOF
fi

# Bash show only left side of powerline, use that theme
mkdir -p ~/.config/powerline
cat <<EOF > ~/.config/powerline/config.json 
{
    "ext": {
        "shell": {
            "theme": "default_leftonly"
            }
    }
}
EOF

# Add powerline for tmux
touch ~/.tmux.conf
if ! grep -q powerline ~/.tmux.conf
then
  cat <<EOF >> ~/.tmux.conf
source "/usr/share/tmux/powerline.conf"
EOF
fi

# Add powerline for vim
touch ~/.vimrc
if ! grep -q powerline ~/.vimrc
then
  cat <<EOF >> ~/.vimrc
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256
EOF
fi

