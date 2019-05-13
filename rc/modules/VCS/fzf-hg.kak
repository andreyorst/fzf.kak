# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-svn.kak            │
# ╞═════════════╩════════════════════════╡
# │ Submodule for Hg support for fzf.kak │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

declare-option -docstring "command to provide list of files in mercurial repository to fzf. Arguments are supported
Supported tools:
    <package>:     <value>:
    Mercurial SCM: ""hg""

Default arguments:
    ""hg locate -f -0 -I .hg locate -f -0 -I .""
" \
str fzf_hg_command "hg"

hook global ModuleLoad fzf_vcs %§

map global fzf-vcs -docstring "edit file from mercurial tree" 'h' '<esc>: fzf-hg<ret>'

define-command -hidden fzf-hg %{ evaluate-commands %sh{
    current_path=$(pwd)
    repo_root=$(hg root)
    case $kak_opt_fzf_hg_command in
    hg)
        cmd="hg locate -f -0 -I .hg locate -f -0 -I ." ;;
    hg*)
        cmd=$kak_opt_fzf_hg_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect $kak_opt_fzf_vertical_map --expect $kak_opt_fzf_horizontal_map"
    printf "%s\n" "fzf -kak-cmd %{cd $repo_root; edit -existing} -items-cmd %{$cmd} -fzf-args %{-m --expect $kak_opt_fzf_window_map $additional_flags} -post-action %{cd $current_path}"
}}

§
