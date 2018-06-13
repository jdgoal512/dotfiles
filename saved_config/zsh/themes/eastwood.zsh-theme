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

c0="%{$fg_no_bold[cyan]%}"
c1="%{$fg_no_bold[blue]%}"
c2="%{$fg_bold[blue]%}"

PROMPT='%(?..%{$fg[red]%}[%?]%{$fg[reset_color]%})$(git_custom_status)%{$fg_no_bold[cyan]%}[$c1$(pwd | sed "s,$HOME,~," | sed "s,/,$c0/$c1,g" | sed "s,\(.*\)/[^m]*m,\1/$c2,")$c0]%{$reset_color%}%B$%b '
