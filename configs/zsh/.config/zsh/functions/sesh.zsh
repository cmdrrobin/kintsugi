function sesh_start() {
  sesh connect "$(
    sesh list --icons | fzf --no-border \
      --ansi \
      --list-border \
      --no-sort --prompt '⚡  ' \
      --input-border \
      --header-border \
      --bind 'tab:down,btab:up' \
      --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
      --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
      --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
      --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
      --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
      --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
      --preview-window 'right:70%' \
      --preview 'sesh preview {}' \
  )"
}

function sesh-sessions() {
  exec </dev/tty
  exec <&1
  local session
  session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
  zle reset-prompt > /dev/null 2>&1 || true
  [[ -z "$session" ]] && return
  sesh connect $session
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions
