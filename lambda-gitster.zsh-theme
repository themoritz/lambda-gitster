local ret_status="%(?:%{$fg_bold[green]%}λ:%{$fg_bold[red]%}λ%s)%{$reset_color%}"

function get_pwd(){
  git_root=$PWD
  while [[ $git_root != / && ! -e $git_root/.git ]]; do
    git_root=$git_root:h
  done
  if [[ $git_root = / ]]; then
    unset git_root
    prompt_short_dir=%~
  else
    parent=${git_root%\/*}
    prompt_short_dir=${PWD#$parent/}
  fi
  echo $prompt_short_dir
}

function nix_prompt() {
  echo -n "%{$fg[yellow]%}$1%{$reset_color%}"
}

# nix-shell: currently running nix-shell
function get_nix_shell() {
  if [[ -n "$IN_NIX_SHELL" ]]; then
    if [[ -n $NIX_SHELL_PACKAGES ]]; then
      local package_names=""
      local packages=($NIX_SHELL_PACKAGES)
      for package in $packages; do
        package_names+=" ${package##*.}"
      done
      nix_prompt "{$package_names } "
    elif [[ -n $name ]]; then
      local cleanName=${name#interactive-}
      cleanName=${cleanName%-environment}
      nix_prompt "{ $cleanName } "
    else # This case is only reached if the nix-shell plugin isn't installed or failed in some way
      nix_prompt "nix-shell {} "
    fi
  fi
}

PROMPT='$ret_status $(get_nix_shell)%{$fg_bold[black]%}$(get_pwd) $(git_prompt_info)%{$reset_color%}%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✓%{$reset_color%}"
