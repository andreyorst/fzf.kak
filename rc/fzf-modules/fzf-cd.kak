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

declare-option -docstring 'allow showing preview window while changing directories
Default value:
    false
' \
bool fzf_cd_preview false

declare-option -docstring 'command to show list of directories in preview window
Default value:
    tree -d
' \
str cd_preview_cmd "tree -d {}"

declare-option -docstring 'maximum amount of previewed directories' \
int fzf_preview_dirs '300'

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
    if [ $kak_opt_fzf_cd_preview = "true" ]; then
        preview="--preview '($kak_opt_cd_preview_cmd) 2>/dev/null | head -n $kak_opt_fzf_preview_dirs'"
    fi
    printf "%s\n" "fzf %{change-directory} %{$items_command} %{$preview} %{fzf-cd}"
}}

