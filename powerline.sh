#!/bin/bash
# vim: ts=2 st=2 et ai:
#
# Author: Arnulf Heimsbakk
# URL   : https://github.com/aheimsbakk/notes
# Date  : 2019-11-17

# Powerline directories
PY_VER="$($(which python3) --version | grep -Eo '[[:digit:]]\.[[:digit:]]+')"
PL_DIR="$HOME/.local/lib/python$PY_VER/site-packages/powerline"
PL_CNF_DIR="$HOME/.config/powerline"

# Fix bash history
HISTFILESIZE=-1
HISTSIZE=2000
HISTTIMEFORMAT="%a %b %d %T %Z %Y: "
PROMPT_COMMAND="history -n"

# Install powerline
test -f "$(which $HOME/.local/bin/powerline-daemon)" || pip3 install --user powerline-status powerline-gitstatus

# Bash show only left side of powerline, use that theme
( test -d $PL_CNF_DIR/colorschemes || test -d $PL_CNF_DIR/themes/shell ) || mkdir -p $PL_CNF_DIR/{colorschemes,themes/shell}
test -f $PL_CNF_DIR/config.json || cat <<EOF > $PL_CNF_DIR/config.json
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

test -f $PL_CNF_DIR/themes/shell/leftonly.json || cat <<EOF > $PL_CNF_DIR/themes/shell/leftonly.json
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
        "priority": 40,
        "args": {
          "show_tag": "exact"
        }
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

test -f $PL_CNF_DIR/colorschemes/default.json || cat <<EOF > $PL_CNF_DIR/colorschemes/default.json
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
test -f $HOME/.tmux.conf || cat <<EOF >> $HOME/.tmux.conf
source "$PL_DIR/bindings/tmux/powerline.conf"
set -g mouse on
EOF

# Add powerline for vim
test -f $HOME/.vimrc || cat <<EOF >> $HOME/.vimrc
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

# Workaround for Ubuntu
export PATH=${PATH}:$HOME/.local/bin

# Starting powerline daemon and bindings to bash
if [ -f $(which $HOME/.local/bin/powerline-daemon) ]; then
  $HOME/.local/bin/powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source $PL_DIR/bindings/bash/powerline.sh
fi