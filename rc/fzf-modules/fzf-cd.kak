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
    tmux_height=$kak_opt_fzf_tmux_height
    printf '%s\n' "info -title %{fzf change directory} %{Change the server's working directory}"

    case $kak_opt_fzf_cd_command in
        find)
            items_command="(echo .. && find \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type d -print)" ;;
        *)
            items_command=$kak_opt_fzf_cd_command ;;
    esac
    printf "%s\n" "fzf %{change-directory} %{$items_command} %{&& printf '%s\n' '; evaluate-commands fzf-cd'}"
}}

