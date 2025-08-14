# Author: Andrey Listopadov
# Submodule for Git support for fzf.kak
# https://github.com/andreyorst/fzf.kak

hook global ModuleLoaded fzf-vcs %§
    map global fzf-vcs -docstring "edit file from Jujutsu tree" 'g' '<esc>: require-module fzf-jj; fzf-jj<ret>'
§

provide-module fzf-jj %§

declare-option -docstring "command to provide list of files in Jujutsu tree to fzf. Arguments are supported
Supported tools:
    <package>: <value>:
    Jujutsu:       ""jj""

Default arguments:
    'jj file list'
" \
str fzf_jj_command "jj"

define-command -hidden fzf-jj %{ evaluate-commands %sh{
    case $kak_opt_fzf_jj_command in
        (jj)  cmd='jj file list' ;;
        (*)   cmd=$kak_opt_fzf_jj_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ${kak_opt_fzf_vertical_map:-ctrl-v} --expect ${kak_opt_fzf_horizontal_map:-ctrl-s}"
    printf "%s\n" "fzf -kak-cmd %{edit -existing} -items-cmd %{$cmd} -fzf-args %{-m --expect ${kak_opt_fzf_window_map:-ctrl-w} $additional_flags} -filter %{perl -pe \"if (/${kak_opt_fzf_window_map:-ctrl-w}|${kak_opt_fzf_vertical_map:-ctrl-v}|${kak_opt_fzf_horizontal_map:-ctrl-s}|^$/) {} else {print \\\"$(jj workspace root)/\\\"}\"}"
}}

§
