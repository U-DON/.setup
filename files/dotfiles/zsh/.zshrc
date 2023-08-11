# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  asdf
  direnv
  docker
  fd
  fzf
  git
  kubectl
  ripgrep
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

alias bat='batcat'
alias fd='fdfind'
alias rg='rg -S'

export BAT_THEME='OneHalfDark'
export GPG_TTY=$TTY
export VISUAL='nvim'
export EDITOR=$VISUAL

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5c6370"

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
  end-of-line
  vi-end-of-line
  vi-add-eol
)

export ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
  forward-char
  forward-word
  emacs-forward-word
  vi-forward-char
  vi-forward-word
  vi-forward-word-end
  vi-forward-blank-word
  vi-forward-blank-word-end
  vi-find-next-char
  vi-find-next-char-skip
)

# Load local configuration.
[ -s ~/.zshrc.local ] && . ~/.zshrc.local

[ -s ~/.asdf/plugins/dotnet/set-dotnet-env.zsh ] && . ~/.asdf/plugins/dotnet/set-dotnet-env.zsh

[ -s ~/.asdf/plugins/java/set-java-home.zsh ] && . ~/.asdf/plugins/java/set-java-home.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"
