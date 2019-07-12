#!/bin/bash
# vim: ts=2 st=2 et ai:
#
# Author: Arnulf Heimsbakk
# URL   : https://github.com/aheimsbakk/notes
# Date  : 2019-06-12

# Install termux utils
apt-get install -y vim-python python tmux git openssh bash-completion procps
pip3 install --upgrade pip
pip3 install powerline-shell powerline-status

# Add starting powerline daemon and bindings to bash
if ! grep -q powerline ~/.bashrc
then
  cat <<EOF >> ~/.bashrc
if [ -f `which powerline-daemon` ]; then
    powerline-daemon -q
fi

function _update_ps1() {
    PS1=\$(powerline-shell \$?)
}

if [[ \$TERM != linux && ! \$PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; \$PROMPT_COMMAND"
fi
EOF
fi

# Bash show only left side of powerline, use that theme
mkdir -p ~/.config/powerline
cat <<EOF > ~/.config/powerline/config.json
{
    "common": {
        "default_top_theme": "ascii"
    },
    "ext": {
        "shell": {
            "theme": "default_leftonly"
            }
    }
}
EOF

mkdir -p ~/.config/powerline-shell
cat <<EOF > ~/.config/powerline-shell/config.json
{
  "segments": [
    "virtual_env",
    "ssh",
    "cwd",
    "git",
    "hg",
    "jobs",
    "root"
  ],
  "mode": "flat"
}
EOF

# Add powerline for tmux
touch ~/.tmux.conf
if ! grep -q powerline ~/.tmux.conf
then
  cat <<EOF >> ~/.tmux.conf
source "/data/data/com.termux/files/usr/lib/python3.7/site-packages/powerline/bindings/tmux/powerline.conf"
set -g mouse on
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
set bg=dark
set list
set listchars=nbsp:¬,tab:>-,extends:»,precedes:«,trail:•
set ai
set et
set ts=2
set st=2
set sw=2
set modeline
set modelines=5
syntax on
EOF
fi

