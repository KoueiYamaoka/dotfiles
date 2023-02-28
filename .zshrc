#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
# system settings
setxkbmap -option ctrl:nocaps
[ "$USER" = "root" ] && echo 'You are root!' >&2
case $TERM in
    linux) LANG=C ;;
    *) LANG=ja_JP.UTF-8 ;;
esac

## set environment variables
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export HISTORY_IGNORE="(ls|la|..|cd|e|ez|sz|ekill|gomi|lsgomi)"
export PATH=/home/kouei/.local/bin:$PATH

# python (don't add $PYTHONPATH)
export PYTHONPATH=/home/kouei/libraries/python


## alias
# global aliases
alias -g g='| grep '
alias -g pcp='| pbcopy'
alias -g p='| peco'

# vterm for emacs
vterm_cmd() {
    local vterm_elisp
    vterm_elisp=""
    while [ $# -gt 0 ]; do
        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
        shift
    done
    vterm_printf "51;E$vterm_elisp"
}
function open_file_below() {
    vterm_cmd find-file "$(realpath "${@:-.}")"
}

# emacs
alias e="emacs"
alias emacsclient="/usr/local/bin/emacsclient"
function emacs() {
    if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
        if [ $# -eq 1 ]; then
            open_file_below $1
        else
            vterm_printf "51;Eswitch-to-prev-buffer"
        fi
    else
        /usr/local/bin/emacsclient -nw -a "" $1
    fi
}
alias se='sudo emacsclient -nw -a ""'
alias ekill='emacsclient -e "(kill-emacs)"'
alias sekill='sudo emacsclient -e "(kill-emacs)"'

# zsh
alias ez='e ~/.zshrc'
alias sz='source ~/.zshrc'

# system
alias ls="ls --group-directories-first --color=auto --ignore={'\$RECYCLE.BIN','System Volume Information'}"
alias pbcopy='xsel --clipboard --input'
alias open='xdg-open'
alias lsgomi='ls -la ${HOME}/.local/share/Trash/files'
alias fc='ls -UF | grep -v / | wc -l'
alias dirc="ls -l | grep '^d' | wc -l"
if [ -d ${HOME}/.local/share/Trash/files ]
then
    alias rm='mv --backup=numbered --target-directory=${HOME}/.local/share/Trash/files/'
fi
alias tree='tree --dirsfirst'
alias whatpulse='~/Programs/whatpulse/whatpulse'
alias firefox='~/Programs/firefox/firefox'
alias diff='colordiff -u'
if type bat > /dev/null 2>&1; then
    alias cat='bat'
else
    alias cat='batcat'
fi
pgkill () {pgrep $1 | xargs kill -9}

# tools
alias ats='atcoder-tools'


# you are blushing
function ks(){
    banner KS
    ls
}
function mc(){
    banner 'mc???'
    mv $1 $2
}

# shellscript
alias gomi='source ~/shellScripts/gomi.sh'
alias pdfcrops='source ~/shellScripts/pdfcrops.sh'
alias eps2pdf='source ~/shellScripts/eps2pdf.sh'
alias dict='source ~/shellScripts/dict.sh'
alias pdf_reduce='source ~/shellScripts/pdf_reduce.sh'
alias latex2txt='source ~/shellScripts/latex2txt.sh'
alias disp_set='source ~/shellScripts/local/disp_set.sh'
alias calc='source ~/shellScripts/calc.sh'
alias toggle_emacs_frame_existence='source ~/shellScripts/toggle_emacs_frame_existence.sh'

# python
alias p3='python3'
alias poea='poetry add'
alias poead='poetry add --group dev'

# matlab
function rmat(){
    matlab -nodisplay -nosplash -nodesktop -r "run('$1');exit;" | tail -n +11
}

# luatex
alias luatex=lualatex

# keybindings
alias xkeysnail='xhost +SI:localuser:root & sudo xkeysnail ~/.config/xkeysnail/config.py'

# git
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gs='git status'
alias glp="git log --pretty=format:'%C(red reverse)%d%Creset%C(white reverse)%h%Creset%C(green reverse)%an%Creset%C(cyan)%Creset%C(white bold)%w(80)%s%Creset%n%n%w(80,2,2)%b' --graph"
alias gco="git checkout"


# dropbox
alias dropbox='/usr/bin/dropbox'
# misc
alias sl='sl -e'
alias fortune='/usr/games/fortune'

## zsh settings
# history search by Ctrl-p, Ctrl-n
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

## emacs-libvterm settings
vterm_printf(){
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ] ); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}


# git settings
# method for writing colored blanch name
function rprompt-git-current-branch {
    local branch_name st branch_status

    branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`

    if [ "$branch_name" = "" ]; then
    	# if there is no .git
    	return
    fi

    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
	# all git files are comitted
	branch_status="%F{green}"
    elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
	# there are some new files
	branch_status="%F{red}?"
    elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
	# there are some files which are not added to git
	branch_status="%F{red}+"
    elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
	# there are some files which should be committed
	branch_status="%F{yellow}!"
    elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
	# some files are conflicted
	echo "%F{red}!(no branch)"
	return
    else
	# otherwise
	branch_status="%F{blue}"
    fi
    # witre branch name with color
    echo "${branch_status}[$branch_name]"
}

setopt prompt_subst

# write git status in right side
RPROMPT='`rprompt-git-current-branch`'

# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

# peco
function peco-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^Q' peco-history-selection

function peco-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
	BUFFER="cd ${selected_dir}"
	zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^R' peco-cdr
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
