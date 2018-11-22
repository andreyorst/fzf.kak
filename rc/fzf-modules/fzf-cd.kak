# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-cd.kak             │
# ╞═════════════╩════════════════════════╡
# │ Module for changing directories with │
# │ fzf for fzf.kak plugin               │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

declare-option -docstring "command to provide list of directories to fzf.
Default value:
    find: (echo .. && find \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type d -print)
" \
str fzf_cd_command "find"

map global fzf -docstring "change directory" 'c' '<esc>: fzf-cd<ret>'

define-command -hidden fzf-cd %{ evaluate-commands %sh{
        title="fzf change directory"
        message="Change the server''s working directory"
        echo "info -title '$title' '$message'"
        case $kak_opt_fzf_cd_command in
        find)
            cmd="(echo .. && find \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type d -print)" ;;
        *)
            cmd=$kak_opt_fzf_cd_command ;;
        esac
        echo "fzf %{change-directory} %{$cmd}"
}}

