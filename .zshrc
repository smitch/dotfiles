# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install
fpath=(~/.zsh-completions $fpath)
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats '%F{green}%c%u[git:%b]%f'
zstyle ':vcs_info:*' actionformats '[%b%a]'

# function _update_vcs_info_msg(){
#   psvar=()
#   LANG=en_US.UTF-8 vcs_info
#   psvar[2]=$(_git_not_pushed)
#   [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
# }

autoload -Uz add-zsh-hook
# add-zsh-hook precmd _update_vcs_info_msg

function _git_not_pushed(){
  if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
    head="$(git rev-parse HEAD)"
    for x in $(git rev-parse --remotes); do
      if [[ "$head" = "$x" ]]; then
        return 0;
      fi
    done
    echo '*'
  fi
  return 0
}

setopt prompt_subst
# PROMPT=$'%{\e[$[32+$RANDOM % 5]m%}%n@%U%B$HOST'$'%{\e[m%}%u: '
PROMPT=$'%{\e[$[32+$RANDOM % 5]m%}%n@%U%B%m'$'%{\e[m%}%u: '
# RPROMPT="%1(v|%F{green}%1v%f|)"
# RPROMPT=$'%{\e[33m%}[%~]%{\e[m%}'
# RPROMPT='${vcs_info_msg_0_}'$'%{\e[32m%}[%~]%{\e[m%}'
# RPROMPT='${vcs_info_msg_0_}'$'%{$fg[red]%}''$(_git_not_pushed)'$'%{$reset_color}%}'$'%{\e[32m%}[%~]%{\e[m%}'
RPROMPT=$'%{\e[31m%}''$(_git_not_pushed)''${vcs_info_msg_0_}'$'%{\e[32m%}[%~]%{\e[m%}'

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

setopt hist_ignore_space
# setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
setopt ignore_eof
setopt no_beep
setopt auto_cd
setopt auto_pushd
# setopt correct
setopt list_packed

if [ `uname -a | awk '{print $1}'` = "Darwin" ]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# alias lpr2='lpr -o PageSize=A4 -o Duplex=DuplexNoTumble'

unsetopt auto_menu

# fortune

# if [[ $TERM != screen ]]; then
	# screen;
# fi

precmd () {
  local tmp='%~'
  local HPWD=${(%)tmp}
	local WINDOW_NAME=`basename $HPWD`
  if [[ $TERM = screen ]]; then
    printf '\ek%s\e\\' $WINDOW_NAME
  fi
  vcs_info
}

if [ -e /usr/bin/src-hilite-lesspipe.sh ]; then
  export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
fi
export LESS=' -R '

PATH=$PATH:~/local/go/bin:~/local/bin

function shared-kill(){
  echo $RBUFFER > ~/.tmp/shared_kill_ring; RBUFFER=""
}
function shared-yank(){
  LBUFFER=$LBUFFER"`cat ~/.tmp/shared_kill_ring`";
}
zle -N shared-kill
zle -N shared-yank
bindkey '^[j' shared-kill
bindkey '^[u' shared-yank
