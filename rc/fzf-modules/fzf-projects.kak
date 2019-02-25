# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-project.kak        │
# ╞═════════════╩════════════════════════╡
# │ Module for storing and loading       │
# │ projects with fzf for fzf.kak plugin │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

declare-option -docstring "a file where saved projects are stored" \
str fzf_projects_file %sh{ echo "$HOME/.cache/fzf.kak/projects" }

declare-option -docstring 'allow showing preview window while changing projects
Default value:
    false
' \
bool fzf_projects_preview false

declare-option -docstring 'command to show list of directories in preview window
Default value:
    tree -d
' \
str fzf_projects_preview_cmd "tree -d {}"

declare-option -docstring 'maximum amount of previewed directories' \
int fzf_projects_preview_dirs '300'

map global fzf -docstring "open project" 'p' '<esc>: fzf-project<ret>'

define-command -hidden fzf-project %{ evaluate-commands %sh{
    tmux_height=$kak_opt_fzf_tmux_height
    printf '%s\n' "info -title %{fzf open project} %{Change the server's working directory to selected project}"

    items_command="cat $kak_opt_fzf_projects_file"
    if [ $kak_opt_fzf_cd_preview = "true" ]; then
        preview="--preview '($kak_opt_cd_preview_cmd) 2>/dev/null | head -n $kak_opt_fzf_preview_dirs'"
    fi
    printf "%s\n" "fzf %{change-directory} %{$items_command} %{$preview} %{fzf-file}"
}}

define-command fzf-save-path-as-project %{ prompt "Project's name: " %{ nop %sh{
    mkdir -p "${kak_opt_fzf_projects_file%/*}"
    printf "%s: %s\n" "$kak_text" "$(pwd)" >> $kak_opt_fzf_projects_file
}}}

# a command to get poject names if `prompt' will ever support `-shell-script-candidates'
# %sh{ perl -n -e '/^([^:]+)/ && print "$1\n"' $kak_opt_fzf_projects_file }
define-command fzf-update-project-path %{
    prompt "Project to update: " %{ nop %sh{
       sed -i -E "s/($kak_text: ).*/\1$(pwd)/" "$kak_opt_fzf_projects_file"
    }}
}

