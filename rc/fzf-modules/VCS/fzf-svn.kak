# ╭─────────────╥─────────────────────────╮
# │ Author:     ║ File:                   │
# │ Andrey Orst ║ fzf-svn.kak             │
# ╞═════════════╩═════════════════════════╡
# │ Submodule for Svn support for fzf.kak │
# ╞═══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak         │
# ╰───────────────────────────────────────╯

declare-option -docstring "command to provide list of files in svn repository to fzf. Arguments are supported
Supported tools:
    <package>:  <value>:
    Subversion: ""svn""

Default arguments:
    ""svn list -R . | grep -v '$/' | tr '\\n' '\\0'""
" \
str fzf_svn_command "svn"

map global fzf-vcs -docstring "edit file from Subversion tree" 's' '<esc>: fzf-svn<ret>'

define-command -hidden fzf-svn %{ evaluate-commands %sh{
    case $kak_opt_fzf_svn_command in
    svn)
        cmd="svn list -R . | grep -v '$/' | tr '\\n' '\\0'" ;;
    svn*)
        cmd=$kak_opt_fzf_svn_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    printf "%s\n" "fzf %{edit} %{$cmd} %{-m --expect ctrl-w $additional_flags}"
}}

