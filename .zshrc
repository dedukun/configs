#########
# ALIAS #
#########

# User defined aliases
unalias -a
alias vi="nvim"
alias vim="nvim"
alias ag="\$SCRIPTS/ag.sh"
alias ls='ls -h --color=auto --group-directories-first --sort=extension'
alias l='ls -l'
alias ll='ls -lA'
alias less='less -i'
alias grep='grep --color'
alias grep-source='grep --include={"*.[hc]","*.[hc]pp","*.java","*.py","*.js","*.ejs","*.html","*.sh","*.tex","*.vim"}'
alias info='info --vi-keys'

alias xxstartx='exec startx &> /dev/null'
alias update-time='sudo ntpdate pt.pool.ntp.org'

# project alias
alias gbtcd='cd $($SCRIPTS/project/manage.sh gbt --get)'
alias percd='cd $($SCRIPTS/project/manage.sh personal --get)'
alias mtdcd='cd $(mtd --select)'

# wine aliases
alias wine="WINEPREFIX=\$HOME/.config/wine/wine32 wine"
alias wine64="WINEPREFIX=\$HOME/.config/wine/wine64 wine64"
alias winecfg="WINEPREFIX=\$HOME/.config/wine/wine32 winecfg"
alias wine64cfg="WINEPREFIX=\$HOME/.config/wine/wine64 winecfg"

############
# FUCTIONS #
############

sourcerust() {
  source $HOME/.cargo/env
}

youtube() {
    workonenv
    workon mps-youtube
    mpsyt
    deactivate
}

# start python's virtualenvwrapper
workonenv() {
    export WORKON_HOME="$HOME/.virtualenvs"
    export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python3"
    . "$HOME/.local/bin/virtualenvwrapper.sh"
}

pip_upgrade() {

    if [ -z "$1" ]; then
        echo "Missing argument"
        return 1
    fi

    case $1 in
        "2" )
            ;;
        "2.7" )
            ;;
        "3" )
            ;;
        "3.7" )
            ;;
        *)
            echo "ERROR: Unknown version '$1'"
            return 1
            ;;

    esac

    sh -c "python$1 -m pip list --outdated | tail -n +3 | awk '{print \$1;}' | xargs python$1 -m pip install --user --upgrade"
}

# gitignore
gitignore() {
    local_ignores="""\
### Local Ignores ###
generate-tags.sh
compile_commands.json
"""
    remote_ignores=$(curl -L -s "https://www.gitignore.io/api/windows,linux,osx,vim,$*")
    echo "$local_ignores$remote_ignores"
}

# https://superuser.com/questions/611538/is-there-a-way-to-display-a-countdown-or-stopwatch-timer-in-a-terminal
stopwatch() {
    local date1
    date1=$(date +%s)
    while true; do
        echo -ne "$(date -u --date @$(($(date +%s) - date1)) +%H:%M:%S)\r"
        sleep 0.1
    done
}

run_swallow() {
  echo
  eval swallow $BUFFER
  BUFFER=''
  zle reset-prompt
}

###############
# ZPLUG STUFF #
###############

export ZPLUG_HOME="$ZSH_CONFIGS/.zplug"
source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug "zsh-users/zsh-completions"

zplug 'mafredri/zsh-async', from:github
zplug 'sindresorhus/pure', use:pure.zsh, from:github, as:theme

# Source plugins and add commands to $PATH
zplug load

##################
# CONFIGURATIONS #
##################

# pure
zstyle :prompt:pure:git:stash show yes

setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
HISTFILE=~/.config/zsh/zsh_history
SAVEHIST=10000
HISTSIZE=10000

ZSH_DISABLE_COMPFIX=true

autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zmodload zsh/complist
compinit

# Include hidden files in autocomplete:
_comp_options+=(globdots)

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# ZLE hooks for prompt's vi mode status
function zle-line-init zle-keymap-select {
	# Change the cursor style depending on keymap mode.
	case $KEYMAP {
		vicmd)
			printf '\e[0 q' # Box.
			;;

		viins|main)
			printf '\e[6 q' # Vertical bar.
			;;
	}
}
zle -N zle-line-init
zle -N zle-keymap-select

# swallow keybinding
zle -N run_swallow
bindkey '^P' run_swallow

#################
# FZF OVERWRITE #
#################

# Initialize fzf
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

# https://github.com/junegunn/fzf/issues/1309
# Remove repeated entries from fzf history search
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -rl 1 |
    sort -k2 -k1rn | uniq -f 1 | sort -r -n |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
