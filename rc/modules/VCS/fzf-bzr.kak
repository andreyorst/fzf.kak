# Author: Andrey Listopadov
# Submodule for Bzr support for fzf.kak
# https://github.com/andreyorst/fzf.kak

hook global ModuleLoaded fzf-vcs %{
    map global fzf-vcs -docstring "edit file from GNU Bazaar tree" 'b' '<esc>: require-module fzf-bzr; fzf-bzr<ret>'
}

provide-module fzf-bzr %§

declare-option -docstring "command to provide list of files in GNU Bazaar repository to fzf. Arguments are supported
Supported tools:
    <package>:  <value>:
    GNU Bazaar: ""bzr""

Default arguments:
    '(cd $repo_root && bzr ls -R --versioned)'
" \
str fzf_bzr_command "bzr"

define-command -hidden fzf-bzr %{ evaluate-commands %sh{
    repo_root=$(bzr root)
    case $kak_opt_fzf_bzr_command in
        (bzr)  cmd="(cd $repo_root && bzr ls -R --versioned)" ;;
        (*)    cmd=$kak_opt_fzf_bzr_command ;;
    esac
    [ -n "${kak_client_env_TMUX}" ] && additional_flags="--expect ${kak_opt_fzf_vertical_map:-ctrl-v} --expect ${kak_opt_fzf_horizontal_map:-ctrl-s}"
    printf "%s\n" "fzf -kak-cmd %{edit -existing} -items-cmd %{$cmd} -fzf-args %{-m --expect ${kak_opt_fzf_window_map:-ctrl-w} $additional_flags} -filter %{perl -pe \"if (/${kak_opt_fzf_window_map:-ctrl-w}|${kak_opt_fzf_vertical_map:-ctrl-v}|${kak_opt_fzf_horizontal_map:-ctrl-s}|^$/) {} else {print \\\"$repo_root/\\\"}\"}"
}}

§
