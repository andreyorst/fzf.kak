# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-svn.kak            │
# ╞═════════════╩════════════════════════╡
# │ Submodule for Hg support for fzf.kak │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

hook global ModuleLoaded fzf_vcs %§

declare-option -docstring "command to provide list of files in mercurial repository to fzf. Arguments are supported
Supported tools:
    <package>:     <value>:
    Mercurial SCM: ""hg""

Default arguments:
    ""hg locate -f""
" \
str fzf_hg_command "hg"

map global fzf-vcs -docstring "edit file from mercurial tree" 'h' '<esc>: fzf-hg<ret>'

define-command -hidden fzf-hg %{ evaluate-commands %sh{
    case $kak_opt_fzf_hg_command in
        (hg)  cmd="hg locate -f" ;;
        (hg*) cmd=$kak_opt_fzf_hg_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect $kak_opt_fzf_vertical_map --expect $kak_opt_fzf_horizontal_map"
    printf "%s\n" "fzf -kak-cmd %{edit -existing} -items-cmd %{$cmd} -fzf-args %{-m --expect $kak_opt_fzf_window_map $additional_flags}"
}}

§
