function _update_ps1() {
    PS1="$(powerline-go -git-mode compact -modules venv,user,host,cwd,perms,git,hg,jobs,exit,root -max-width 50 -colorize-hostname -static-prompt-indicator -mode flat -numeric-exit-codes -error $? -jobs $(jobs -p | wc -l))"
}

if [ "$TERM" != "linux" ] && [ -f "$(which powerline-go)" ]; then
  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

