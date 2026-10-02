# ── 1Password secrets: fetched once per login session, cached in RAM ──
#
# Templates hold only op:// references and live locally (NOT in this repo):
#   ${OP_ENV_TPL_DIR:-~/.config/zsh/op-env/tpl}/*.tpl
#   e.g. export HA_TOKEN='{{ op://Vault/item/password }}'
# (OP_ENV_TPL_DIR is read once, when this file is sourced.)
#
# All templates are injected in one `op inject` call (single 1Password prompt)
# and cached in $XDG_RUNTIME_DIR (tmpfs, 0600, removed at logout).
#
# This file only defines functions. Start loading with `op-env-load`
# (called from ~/.zshrc_local, after OP_BIOMETRIC_UNLOCK_ENABLED is set).
#
#   op-env-refresh   refetch now (e.g. after rotating a token)
#   op-env-clear     delete cache and unset all op-env variables

typeset -g _op_env_tpl_dir="${OP_ENV_TPL_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh/op-env/tpl}"
# $XDG_RUNTIME_DIR may be unset when this file is sourced, so the cache
# paths are resolved lazily on first use.
typeset -g _op_env_cache _op_env_lock

_op_env_paths() {
  emulate -L zsh
  [[ -n $XDG_RUNTIME_DIR ]] || return 1
  [[ -n $_op_env_cache ]] && return 0
  _op_env_cache="$XDG_RUNTIME_DIR/op-env.zsh"
  _op_env_lock="${_op_env_cache}.lock"
}

# Sets $reply to the template files, sorted by name
_op_env_tpls() {
  emulate -L zsh
  reply=( "$_op_env_tpl_dir"/*.tpl(N) )
}

# First line of the cache; records which templates it was built from
_op_env_header() {
  emulate -L zsh
  local -a reply; _op_env_tpls
  print -r -- "# op-env-tpls: ${(j: :)${(@)reply:t}}"
}

# True when the cache is out of date: a template is newer than the cache,
# or templates were added / removed / renamed since it was built
_op_env_stale() {
  emulate -L zsh
  local -a newest=( "$_op_env_tpl_dir"/*.tpl(Nom[1]) )
  [[ -n $newest && $newest -nt $_op_env_cache ]] && return 0
  local first
  IFS= read -r first < "$_op_env_cache" 2>/dev/null
  [[ $first != "$(_op_env_header)" ]]
}

# Variable names exported by the templates and the current cache
# (may contain duplicates; callers dedupe with the (u) flag)
_op_env_vars() {
  emulate -L zsh
  local -a reply files; _op_env_tpls
  files=( $reply )
  [[ -r $_op_env_cache ]] && files+=( "$_op_env_cache" )
  (( $#files )) || return 0
  sed -n 's/^[[:space:]]*export[[:space:]]\{1,\}\([A-Za-z_][A-Za-z0-9_]*\)=.*/\1/p' -- $files
}

_op_env_can_prompt() {
  emulate -L zsh
  [[ -o interactive && -t 0 && -t 1 ]] \
    && (( $+commands[op] )) \
    && pgrep -u $UID -x 1password >/dev/null
}

_op_env_fetch() {
  emulate -L zsh
  local -a reply; _op_env_tpls
  (( $#reply )) || { print -u2 "op-env: no templates in $_op_env_tpl_dir"; return 1; }
  local tmp="${_op_env_cache}.$$" f out
  # Each template is printed with exactly one trailing newline, so files can't
  # run together.  op's stderr is captured in $out for the error message below
  # (2>&1 before >/dev/null); its stdout is discarded.
  # NB: keep comments OUT of $( ) — its contents are re-parsed at runtime,
  # where interactive shells don't recognise comments by default.
  if out=$( {
         _op_env_header
         for f in $reply; do print -r -- "$(<$f)"; done
       } | timeout --foreground 30 op inject --out-file "$tmp" 2>&1 >/dev/null )
  then
    mv -f "$tmp" "$_op_env_cache"   # `op inject` creates the output 0600
  else
    rm -f "$tmp"
    print -u2 "op-env: could not load secrets from 1Password (run op-env-refresh)"
    [[ -n $out ]] && print -u2 -r -- "op-env: $out"
    return 1
  fi
}

op-env-load() {
  emulate -L zsh
  _op_env_paths || return 0
  local -a reply; _op_env_tpls
  (( $#reply )) || return 0

  if [[ -r $_op_env_cache ]] && ! _op_env_stale; then
    source "$_op_env_cache"
    return
  fi

  if _op_env_can_prompt; then
    # Remove a lock left behind by a shell that was killed mid-prompt
    # (older than a minute; a live fetch never outlives `timeout 30` above)
    local -a old=( "$_op_env_lock"(N/mm+1) )
    (( $#old )) && rmdir $old 2>/dev/null
    if mkdir "$_op_env_lock" 2>/dev/null; then
      _op_env_fetch
      rmdir "$_op_env_lock" 2>/dev/null
    fi
  fi

  # Fresh cache, or the stale one as fallback when fetching wasn't possible
  [[ -r $_op_env_cache ]] && source "$_op_env_cache"
  return 0
}

# Refetch, keeping the current values when the fetch fails
op-env-refresh() {
  emulate -L zsh
  _op_env_paths || { print -u2 "op-env: XDG_RUNTIME_DIR not set"; return 1; }
  local -a names=( ${(fu)"$(_op_env_vars)"} )
  _op_env_fetch || return 1
  names+=( ${(fu)"$(_op_env_vars)"} )
  (( $#names )) && unset -- ${(u)names}
  source "$_op_env_cache"
}

op-env-clear() {
  emulate -L zsh
  _op_env_paths || return 0
  local -a names=( ${(fu)"$(_op_env_vars)"} )
  (( $#names )) && unset -- $names
  rm -f "$_op_env_cache"
}
