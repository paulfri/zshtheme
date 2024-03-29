autoload -U colors && colors
autoload -Uz add-zsh-hook 
setopt nopromptbang prompt{cr,percent,sp,subst}

local cyan="%{$fg[cyan]%}"
local green="%{$fg[green]%}"
local red="%{$fg[red]%}"
local yellow="%{$fg[yellow]%}"

# git-info
typeset -gA git_info
zstyle ':zim:git-info' verbose yes
zstyle ':zim:git-info:branch' format '%b'
zstyle ':zim:git-info:commit' format '%c'
zstyle ':zim:git-info:clean' format '%F{green}λ'
zstyle ':zim:git-info:dirty' format '%F{red}λ'
zstyle ':zim:git-info:ahead' format '%F{green}↑%F{242}%A '
zstyle ':zim:git-info:behind' format '%F{red}↓%F{242}%B '
zstyle ':zim:git-info:keys' format \
  'prompt' '%F{white}%C%D' \
  'rprompt' '%A%B%F{242}%b%F{white} '

add-zsh-hook precmd git-info

# duration-info
zstyle ':zim:duration-info' format "%F{yellow}%d "
zstyle ':zim:duration-info' threshold 2.0
zstyle ':zim:duration-info' show-milliseconds yes

add-zsh-hook preexec duration-info-preexec
add-zsh-hook precmd duration-info-precmd

# prompt-pwd
zstyle ':zim:prompt-pwd' git-root yes

# prompt
local user_host="%F{blue}%n@%m%{$reset_color%}"
local return_code="%(?..%F{red} %?↵ %{$reset_color%}) "
local systime="%F{cyan}%*%{$reset_color%}"

PS1='${user_host}:%F{242}$(prompt-pwd) ${(e)git_info[prompt]:-λ}%f '

local right_prompt='${return_code}${duration_info}%{$reset_color%}${(e)git_info[rprompt]}${systime}%{$reset_color%}'
RPS1="${right_prompt} ★ %{$reset_color%}"

function zle-line-init zle-keymap-select {
  RPS1="${right_prompt} ${${KEYMAP/vicmd/☆}/(main|viins)/★}%{$reset_color%}"

  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
