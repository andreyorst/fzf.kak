# ╭─────────────╥─────────────────────────╮
# │ Author:     ║ File:                   │
# │ Andrey Orst ║ fzf-svn.kak             │
# ╞═════════════╩═════════════════════════╡
# │ Submodule for Bzr support for fzf.kak │
# ╞═══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak         │
# ╰───────────────────────────────────────╯

declare-option -docstring "command to provide list of files in GNU Bazaar repository to fzf. Arguments are supported
Supported tools:
    <package>:  <value>:
    GNU Bazaar: ""bzr""

Default arguments:
    ""bzr ls -R --versioned -0""
" \
str fzf_bzr_command "bzr"

map global fzf-vcs -docstring "edit file from GNU Bazaar tree" 'b' '<esc>: fzf-bzr<ret>'

define-command -hidden fzf-bzr %{ evaluate-commands %sh{
    case $kak_opt_fzf_bzr_command in
    bzr)
        cmd="bzr ls -R --versioned -0" ;;
    bzr*)
        cmd=$kak_opt_fzf_bzr_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    printf "%s\n" "fzf %{edit} %{$cmd} %{-m --expect ctrl-w $additional_flags}"
}}

