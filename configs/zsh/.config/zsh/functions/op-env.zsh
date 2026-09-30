# ── 1Password secrets: fetched once per login session, cached in RAM ──
#
# Templates hold only op:// references and live locally (NOT in this repo):
#   ${OP_ENV_TPL_DIR:-~/.config/zsh/op-env/tpl}/*.tpl
#   e.g. export HA_TOKEN='{{ op://Vault/item/password }}'
#
# All templates are injected in one `op inject` call (single 1Password prompt)
# and cached in $XDG_RUNTIME_DIR (tmpfs, 0600, removed at logout).
#
# This file only defines functions. Start loading with `op-env-load`
# (called from ~/.zshrc_local, after OP_BIOMETRIC_UNLOCK_ENABLED is set).
#
#   op-env-refresh   refetch now (e.g. after rotating a token)
#   op-env-clear     delete cache and unset all op-env variables

typeset -g _op_env_cache="$XDG_RUNTIME_DIR/op-env.zsh"
typeset -g _op_env_lock="${_op_env_cache}.lock"

_op_env_tpl_dir() { print -r -- "${OP_ENV_TPL_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh/op-env/tpl}"; }

# Sets $reply to the template files, sorted by name
_op_env_tpls() { reply=( "$(_op_env_tpl_dir)"/*.tpl(N) ); }

# First line of the cache; records which templates it was built from
_op_env_header() {
  local -a reply; _op_env_tpls
  print -r -- "# op-env-tpls: ${(j: :)${(@)reply:t}}"
}

# True when the cache is out of date: a template is newer than the cache,
# or templates were added / removed / renamed since it was built
_op_env_stale() {
  local -a newest=( "$(_op_env_tpl_dir)"/*.tpl(Nom[1]) )
  [[ -n $newest && $newest -nt $_op_env_cache ]] && return 0
  local first
  IFS= read -r first < "$_op_env_cache" 2>/dev/null
  [[ $first != "$(_op_env_header)" ]]
}

# Variable names exported by the templates and the current cache
_op_env_vars() {
  local -a reply files; _op_env_tpls
  files=( $reply )
  [[ -r $_op_env_cache ]] && files+=( "$_op_env_cache" )
  (( $#files )) || return 0
  sed -n 's/^[[:space:]]*export[[:space:]]\{1,\}\([A-Za-z_][A-Za-z0-9_]*\)=.*/\1/p' -- $files | sort -u
}

_op_env_can_prompt() {
  [[ -o interactive && -t 0 && -t 1 ]] \
    && (( $+commands[op] )) \
    && pgrep -u $UID -x 1password >/dev/null
}

_op_env_fetch() {
  local -a reply; _op_env_tpls
  (( $#reply )) || { print -u2 "op-env: no templates in $(_op_env_tpl_dir)"; return 1; }
  local tmp="${_op_env_cache}.$$" f
  if {
       _op_env_header
       for f in $reply; do print -r -- "$(<$f)"; done   # guarantees a newline between files
     } | timeout --foreground 30 op inject --out-file "$tmp" --file-mode 0600 >/dev/null 2>&1
  then
    chmod 0600 "$tmp" && mv -f "$tmp" "$_op_env_cache"
  else
    rm -f "$tmp"
    print -u2 "op-env: could not load secrets from 1Password (run op-env-refresh)"
    return 1
  fi
}

op-env-load() {
  [[ -n $XDG_RUNTIME_DIR ]] || return 0
  local -a reply; _op_env_tpls
  (( $#reply )) || return 0

  if [[ -r $_op_env_cache ]] && ! _op_env_stale; then
    source "$_op_env_cache"
    return
  fi

  if _op_env_can_prompt; then
    # Remove a lock left behind by a shell that was killed mid-prompt
    [[ -d $_op_env_lock ]] && find "$_op_env_lock" -maxdepth 0 -mmin +1 -exec rmdir {} + 2>/dev/null
    if mkdir "$_op_env_lock" 2>/dev/null; then
      _op_env_fetch
      rmdir "$_op_env_lock" 2>/dev/null
    fi
  fi

  # Fresh cache, or the stale one as fallback when fetching wasn't possible
  [[ -r $_op_env_cache ]] && source "$_op_env_cache"
  return 0
}

op-env-refresh() {
  [[ -n $XDG_RUNTIME_DIR ]] || { print -u2 "op-env: XDG_RUNTIME_DIR not set"; return 1; }
  op-env-clear
  _op_env_fetch && source "$_op_env_cache"
}

op-env-clear() {
  local -a names=( ${(f)"$(_op_env_vars)"} )
  (( $#names )) && unset -- $names
  rm -f "$_op_env_cache"
}
