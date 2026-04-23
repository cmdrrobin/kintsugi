# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# Basic variables
export ZSH="$HOME/.config/zsh"
export XDG_CONFIG_HOME="$HOME/.config";
export XDG_DATA_HOME="$HOME/.local/share";
export XDG_CACHE_HOME="$HOME/.cache";

export PATH=$HOME/.local/bin:$PATH

# Load default Omarchy shell settings
source ${ZSH}/omarchy/omarchy.zsh

# Add custom completions directory to fpath
fpath=(~/.config/zsh/completions $fpath)
# Load and initialise completion system
autoload -U compinit && compinit

# Antidote
export ANTIDOTE_HOME=$XDG_CACHE_HOME/antidote
# Lazy-load antidote and generate the static load file only when needed
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
source ${ZSH}/antidote/antidote.zsh
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  (
    antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
  )
fi
source ${zsh_plugins}.zsh

typeset -U path cdpath fpath manpath

# Vi mode config
#
# Enable zsh's built-in vi mode
bindkey -v

# Bring back some non-vi defaults
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Define FZF options and theme colouring
local fzf_default_opts=(
  '--preview-window right:50%:noborder:hidden'
  '--color=fg:#908caa,bg:#232136,hl:#ea9a97'
  '--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97'
  '--color=border:#44415a,header:#3e8fb0,gutter:#232136'
  '--color=spinner:#f6c177,info:#9ccfd8'
  '--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa'
  '--multi'
  '--bind "alt-p:toggle-preview"'
)

export FZF_DEFAULT_OPTS="${fzf_default_opts[*]}"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"

# allow fzf-tab follow default opts
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Aliases
alias -- s='sesh_start'
alias -- vi=nvim
alias -- vim=nvim

for f in ${ZSH}/functions/*.zsh; do
  source $f
done

# Variables
export LANG="en_US.UTF-8";
export LC_CTYPE="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";
export EDITOR="nvim";
export PAGER="less -FirSwX";
export CLICOLOR=1;

# History
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="$HOME/.zsh_history"

# SSH Agent with 1Password
export SSH_AUTH_SOCK=~/.1password/agent.sock

# Opencode
export PATH="/home/robin/.opencode/bin:$PATH"

# Rust (cargo)
export PATH="$HOME/.cargo/bin:$PATH"

# NOTE: When local zshrc file exists, source it!
# This is used when some settings shouldn't be managed by git (or my dotfiles)
[[ -e $HOME/.zshrc_local ]] && source $HOME/.zshrc_local

. "$HOME/.local/share/../bin/env"
