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
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export HISTIGNORE='ls:la:..:cdnow:gomi:e:ez:sz:'
[ "$USER" = "root" ] && echo 'You are root!' >&2
case $TERM in
    linux) LANG=C ;;
    *) LANG=ja_JP.UTF-8 ;;
esac

## alias
# working
alias cdtmu='cd /mnt/Shared/TMU'
alias cdnow='~/Documents'

# emacs
alias e='emacsclient -nw -a ""'
alias se='sudo emacsclient -nw -a ""'
alias ekill='/usr/bin/emacsclient -e "(kill-emacs)"'

# zsh
alias ez='e ~/.zshrc'
alias sz='source ~/.zshrc'

# system
alias ls="ls --group-directories-first --color=auto --ignore={'\$RECYCLE.BIN','System Volume Information'}"
alias pbcopy='xsel --clipboard --input'
alias open='xdg-open'
alias lsgomi='ls -la ${HOME}/.local/share/Trash/files'
alias fc='ls -UF | grep -v | wc -l'
alias dirc="ls -l | grep '^d' | wc -l"
if [ -d ${HOME}/.local/share/Trash/files ]
then
    alias rm='mv --backup=numbered --target-directory=${HOME}/.local/share/Trash/files/'
fi
alias tree='tree --dirsfirst'
alias rm='rm -f'
alias whatpulse='~/Programs/whatpulse/whatpulse'

# you are blushing
function ks(){
    banner KS
    ls
}
alias ks=ks
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

# python
alias p3='python3'

# matlab
function rmat(){
    matlab -nodisplay -nosplash -nodesktop -r "run('$1');exit;" | tail -n +11
}


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

# zsh settings
# history search by Ctrl-p, Ctrl-n
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/kouei/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/kouei/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/kouei/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/kouei/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# git settings
# method for writing colored blanch name
function rprompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
    # if there is no .git
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
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


# display the current environment
function rprompt-conda-current-env {

  if [ $CONDA_DEFAULT_ENV = "base" ]; then
    # if the current env is base
    return
  fi

  # witre
  echo " %F{white}($CONDA_DEFAULT_ENV)"
}

setopt prompt_subst

# write git status and conda env in right side
RPROMPT='`rprompt-git-current-branch``rprompt-conda-current-env`'

