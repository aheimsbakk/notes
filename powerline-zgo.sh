if [ -z "${CONTAINER_ID+x}" ]; then
  export CONTAINER_ID=""
fi

function _update_ps1() {
  PS1="$(powerline-go -hostname-only-if-ssh -shell-var CONTAINER_ID -git-mode compact -modules host,shell-var,venv,direnv,user,cwd,perms,terraform-workspace,kube,git,hg,jobs,exit,newline,root -shell-var-no-warn-empty -max-width 90 -colorize-hostname -static-prompt-indicator -mode flat -numeric-exit-codes -error $? -jobs $(jobs -p | wc -l))"
}

if [ "$TERM" != "linux" ] && [ -f "$(which powerline-go)" ]; then
  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

