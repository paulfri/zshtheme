autoload -U colors && colors
setopt nopromptbang prompt{cr,percent,sp,subst}

local cyan="%{$fg[cyan]%}"
local green="%{$fg[green]%}"
local grey="%F{242}"
local red="%{$fg[red]%}"
local reset="%{$reset_color%}" 

typeset -gA git_info
if (( ${+functions[git-info]} )); then
  zstyle ':zim:git-info' verbose yes
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format '%c'
  zstyle ':zim:git-info:clean' format '%F{green}λ'
  zstyle ':zim:git-info:dirty' format '%F{red}λ'
  zstyle ':zim:git-info:ahead' format '%F{green}↑%F{242}%A '
  zstyle ':zim:git-info:behind' format '%F{red}↓%F{242}%B '
  zstyle ':zim:git-info:keys' format \
    'prompt' '%F{white}%C%D' \
    'rprompt' ' %A%B%F{242}%b%F{white}'

  autoload -Uz add-zsh-hook && add-zsh-hook precmd git-info
fi

local user_host="%F{blue}%n@%m%{$reset_color%}"
local working_dir="%F{242}%c%{$reset_color%}"
local return_code="%(?..%F{red} %? ↵%{$reset_color%})"
local systime="%F{cyan}%*%{$reset_color%}"

PS1='${user_host}:${working_dir} ${(e)git_info[prompt]:-λ} '
local right_prompt='${return_code} ${(e)git_info[rprompt]} ${systime}'

function zle-line-init zle-keymap-select {
  RPS1="${right_prompt} ${${KEYMAP/vicmd/☆}/(main|viins)/★}"

  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
