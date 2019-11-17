#!/bin/bash
# vim: ts=2 st=2 et ai:
#
# Author: Arnulf Heimsbakk 
# URL   : https://github.com/aheimsbakk/notes
# Date  : 2018-11-17

# Install powerline and Vim with Python bindings
sudo dnf install -y powerline tmux tmux-powerline vim vim-powerline
pip3 install --user powerline-gitstatus

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
mkdir -p ~/.config/powerline/themes/shell
cat <<EOF > ~/.config/powerline/config.json
{
  "common": {
    "default_top_theme": "unicode"
  },
  "ext": {
    "shell": {
      "theme": "leftonly"
    }
  }
}
EOF

cat <<EOF > ~/.config/powerline/themes/shell/leftonly.json
{
  "segments": {
    "left": [
      {
        "function": "powerline.segments.common.net.hostname",
        "priority": 10
      },
      {
        "function": "powerline.segments.common.env.user",
        "priority": 30
      },
      {
        "function": "powerline.segments.common.env.virtualenv",
        "priority": 50
      },
      {
        "function": "powerline_gitstatus.gitstatus",
        "priority": 40
      },
      {
        "function": "powerline.segments.shell.cwd",
        "priority": 10
      },
      {
        "function": "powerline.segments.shell.jobnum",
        "priority": 20
      },
      {
        "function": "powerline.segments.shell.last_pipe_status",
        "priority": 10
      }
    ]
  }
}
EOF

mkdir -p ~/.config/powerline/colorschemes
cat <<EOF > ~/.config/powerline/colorschemes/default.json
{
  "groups": {
    "gitstatus":                 { "fg": "gray8",           "bg": "gray2", "attrs": [] },
    "gitstatus_branch":          { "fg": "gray8",           "bg": "gray2", "attrs": [] },
    "gitstatus_branch_clean":    { "fg": "green",           "bg": "gray2", "attrs": [] },
    "gitstatus_branch_dirty":    { "fg": "gray8",           "bg": "gray2", "attrs": [] },
    "gitstatus_branch_detached": { "fg": "mediumpurple",    "bg": "gray2", "attrs": [] },
    "gitstatus_tag":             { "fg": "darkcyan",        "bg": "gray2", "attrs": [] },
    "gitstatus_behind":          { "fg": "gray10",          "bg": "gray2", "attrs": [] },
    "gitstatus_ahead":           { "fg": "gray10",          "bg": "gray2", "attrs": [] },
    "gitstatus_staged":          { "fg": "green",           "bg": "gray2", "attrs": [] },
    "gitstatus_unmerged":        { "fg": "brightred",       "bg": "gray2", "attrs": [] },
    "gitstatus_changed":         { "fg": "mediumorange",    "bg": "gray2", "attrs": [] },
    "gitstatus_untracked":       { "fg": "brightestorange", "bg": "gray2", "attrs": [] },
    "gitstatus_stashed":         { "fg": "darkblue",        "bg": "gray2", "attrs": [] },
    "gitstatus:divider":         { "fg": "gray8",           "bg": "gray2", "attrs": [] }
  }
}
EOF

# Add powerline for tmux
touch ~/.tmux.conf
if ! grep -q powerline ~/.tmux.conf
then
  cat <<EOF >> ~/.tmux.conf
source "/usr/share/tmux/powerline.conf"
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
EOF
fi

