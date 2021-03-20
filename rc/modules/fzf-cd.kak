# Author: Andrey Listopadov
# Module for changing directories with fzf for fzf.kak plugin
# https://github.com/andreyorst/fzf.kak

hook global ModuleLoaded fzf %{
    map global fzf -docstring "change directory" 'c' '<esc>: require-module fzf-cd; fzf-cd<ret>'
}

provide-module fzf-cd %§

declare-option -docstring "command to provide list of directories to fzf.
Default value:
    find: (echo .. && find . \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type d -print)
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
str cd_preview_command "tree -d {}"

declare-option -docstring 'maximum amount of previewed directories' \
int fzf_preview_dirs '300'

define-command -hidden fzf-cd %{ evaluate-commands %sh{
    printf '%s\n' "info -title %{fzf change directory} %{Change the server's working directory
current path: $(pwd)}"
    case ${kak_opt_fzf_cd_command:-} in
        (find) items_command="(echo .. && find . \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type d -print)" ;;
        (*)    items_command=$kak_opt_fzf_cd_command ;;
    esac
    if [ "${kak_opt_fzf_cd_preview:-}" = "true" ]; then
        preview_flag="-preview"
        preview="--preview '(${kak_opt_cd_preview_command:-}) 2>/dev/null | head -n ${kak_opt_fzf_preview_dirs:-0}'"
    fi
    printf "%s\n" "fzf $preview_flag -kak-cmd %{change-directory} -items-cmd %{$items_command} -preview-cmd %{$preview} -post-action %{fzf-cd}"
}}

§
