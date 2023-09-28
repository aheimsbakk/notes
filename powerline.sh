#!/bin/bash
# vim: ts=2 st=2 et ai:
#
# Author: Arnulf Heimsbakk
# URL   : https://github.com/aheimsbakk/notes
# Date  : 2019-11-17

# Overwrite old configuration
POWERLINE_OVERWRITE=${POWERLINE_OVERWRITE:-0}

# Set overwrite if we find .powerline-overwrite in the home folder.
if [[ -f "$HOME/.powerline-overwrite" ]]; then
  POWERLINE_OVERWRITE=1
  rm "$HOME/.powerline-overwrite"
fi

# Powerline directories
PY_VER="$($(which python3) --version | grep -Eo '[[:digit:]]\.[[:digit:]]+')"
PL_DIR="$HOME/.local/lib/python$PY_VER/site-packages/powerline"
PL_CNF_DIR="$HOME/.config/powerline"

# Create directories
mkdir -p "$PL_CNF_DIR/colorschemes"
mkdir -p "$PL_CNF_DIR/themes/shell"

# Fix bash history
HISTFILESIZE=-1
HISTSIZE=2000
HISTTIMEFORMAT="%a %b %d %T %Z %Y: "
PROMPT_COMMAND="history -n"

# Source my OS
source /etc/os-release

# Install powerline
case "$VERSION_CODENAME" in
  bookworm)
    test -f $PL_DIR/bindings/bash/powerline.sh || ( pip3 install --break-system-packages --user wheel; pip3 install --break-system-packages --user powerline-status powerline-gitstatus )
    ;;
  *)
    test -f $PL_DIR/bindings/bash/powerline.sh || ( pip3 install --user wheel; pip3 install --user powerline-status powerline-gitstatus )
    ;;
esac
# Bash show only left side of powerline, use that theme
( test -d $PL_CNF_DIR/colorschemes || test -d $PL_CNF_DIR/themes/shell ) || mkdir -p $PL_CNF_DIR/{colorschemes,themes/shell}
[ ! -f $PL_CNF_DIR/config.json -o "$POWERLINE_OVERWRITE" -gt 0 ] && cat <<EOF > $PL_CNF_DIR/config.json
{
  "common": {
    "default_top_theme": "ascii"
  },
  "ext": {
    "shell": {
      "theme": "leftonly"
    }
  }
}
EOF

[ ! -f $PL_CNF_DIR/themes/shell/leftonly.json -o "$POWERLINE_OVERWRITE" -gt 0 ] && cat <<EOF > $PL_CNF_DIR/themes/shell/leftonly.json
{
  "segments": {
    "left": [
      {
        "function": "powerline.segments.common.net.hostname",
        "priority": 10
      },
      {
        "function": "powerline.segments.common.env.environment",
        "priority": 20,
        "args": {
          "variable": "DISTTAG"
        }
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
          "show_tag": "exact",
          "formats": {
            "branch": "\ue0a0{}",
            "tag": " *{}",
            "behind": " ↓{}",
            "ahead": " ↑{}",
            "staged": " ●{}",
            "unmerged": " x{}",
            "changed": " +{}",
            "untracked": " …{}",
            "stashed": " ○{}"
          }
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

[ ! -f $PL_CNF_DIR/colorschemes/default.json -o "$POWERLINE_OVERWRITE" -gt 0 ] && cat <<EOF > $PL_CNF_DIR/colorschemes/default.json
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
[ ! -f $HOME/.tmux.conf -o "$POWERLINE_OVERWRITE" -gt 0 ] && cat <<EOF > $HOME/.tmux.conf
source "$PL_DIR/bindings/tmux/powerline.conf"
set -g update-environment "DISPLAY SSH_CONNECTION SSH_CLIENT SSH_TTY"
set-environment -g "SSH_AUTH_SOCK" \$HOME/.ssh/ssh_auth_sock
set -g mouse on
bind -n C-s set-window-option synchronize-panes
EOF

# Add VIM plug plugin

[ "$POWERLINE_OVERWRITE" -gt 0 ] && rm -f ~/.vim/autoload/plug.vim
test -f ~/.vim/autoload/plug.vim ||
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/0.10.0/plug.vim

# Add powerline for vim
[ ! -f $HOME/.vimrc -o "$POWERLINE_OVERWRITE" -gt 0 ] && cat <<EOF > $HOME/.vimrc
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256
set bg=light
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

" https://github.com/junegunn/vim-plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin('~/.vim/plugged')
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
call plug#end()

" Folding (zc zo) za zA zr zR zm zM
set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()

let g:lsp_signs_enabled = 1           " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
EOF

# Add ssh rc for enabling permanent ssh socket for tmux
mkdir -p "$HOME/.ssh"
[ ! -f "$HOME/.ssh/rc" ] || [ "$POWERLINE_OVERWRITE" -gt 0 ] && cat <<EOF > "$HOME/.ssh/rc"
#!/bin/bash
if [ ! -L "\$SSH_AUTH_SOCK" -a -S "\$SSH_AUTH_SOCK" ]; then
  ln -sf \$SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi

if read proto cookie && [ -n "\$DISPLAY" ]; then
  if [ "\$(echo \$DISPLAY | cut -c1-10)" = "localhost:" ]; then
    echo add unix:\$(echo \$DISPLAY | cut -c11-) \$proto \$cookie
  else
    echo add \$DISPLAY \$proto \$cookie
  fi | xauth -q -
fi
EOF
chmod +x "$HOME/.ssh/rc"

# Set my favorit editor
export EDITOR=vim

# Workaround for Ubuntu
export PATH=${PATH}:$HOME/.local/bin

# Turn off colors for ls
#alias ls="ls -F --color=never"

# Starting powerline daemon and bindings to bash
if [ -f $(which $HOME/.local/bin/powerline-daemon) ]; then
  $HOME/.local/bin/powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source $PL_DIR/bindings/bash/powerline.sh
fi
