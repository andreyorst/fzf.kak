# ╭─────────────╥─────────────────────────╮
# │ Author:     ║ File:                   │
# │ Andrey Orst ║ fzf-svn.kak             │
# ╞═════════════╩═════════════════════════╡
# │ Submodule for Git support for fzf.kak │
# ╞═══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak         │
# ╰───────────────────────────────────────╯

hook global ModuleLoaded fzf_vcs %§

declare-option -docstring "command to provide list of files in git tree to fzf. Arguments are supported
Supported tools:
    <package>: <value>:
    Git:       ""git""

Default arguments:
    'git ls-tree --full-tree --name-only -r HEAD'
" \
str fzf_git_command "git"

map global fzf-vcs -docstring "edit file from Git tree" 'g' '<esc>: fzf-git<ret>'

define-command -override -hidden fzf-git %{ evaluate-commands %sh{

    case $kak_opt_fzf_git_command in
        (git)  cmd='git ls-tree --full-tree --name-only -r HEAD' ;;
        (*)    cmd=$kak_opt_fzf_git_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect $kak_opt_fzf_vertical_map --expect $kak_opt_fzf_horizontal_map"
    printf "%s\n" "fzf -kak-cmd %{edit -existing} -items-cmd %{$cmd} -fzf-args %{-m --expect $kak_opt_fzf_window_map $additional_flags} -filter %{perl -pe \"if (/$kak_opt_fzf_window_map|$kak_opt_fzf_vertical_map|$kak_opt_fzf_horizontal_map|^$/) {} else {print \\\"$(git rev-parse --show-toplevel)/\\\"}\"}"
}}

§
