function _update_ps1() {
    PS1="$($(which powerline-go) -truncate-segment-width 12 -static-prompt-indicator -hostname-only-if-ssh -mode flat -numeric-exit-codes -error $? -jobs $(jobs -p | wc -l))"
}

if [ "$TERM" != "linux" ] && [ -f "$(which powerline-go)" ]; then
  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

