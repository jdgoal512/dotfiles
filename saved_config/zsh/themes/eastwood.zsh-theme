#!/usr/bin/zsh

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local cb=$(git_current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

git_stuff() {
   if [ -d .git ] || [ git rev-parse --git-dir >/dev/null 2>&1 ]; then
       if [ ! -z "$(git status --porcelain 2>/dev/null | tail -n1)" ]; then
           echo -n "%{$fg[yellow]%}"
       else
           echo -n "%{$fg[green]%}"
       fi
       git branch | grep "\*" | awk '{print $2}' | tr -d "\n"
   fi 
}

c0="%{$fg_no_bold[cyan]%}"
c1="%{$fg_no_bold[blue]%}"
c2="%{$fg_bold[blue]%}"

PROMPT='$c1$(pwd | sed "s,$HOME,~," | sed "s,/,$c0/$c1,g" | sed "s,\(.*\)/[^m]*m,\1/$c2,")%{$reset_color%}%B$%b '
RPROMPT='$(git_stuff)%(?.. %{$fg[white]$bg[red]%}*%?)%{$reset_color%}$(date +" %-I:%M:%S")'
