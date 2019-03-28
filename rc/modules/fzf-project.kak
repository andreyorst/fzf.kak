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

try %{ declare-user-mode fzf }
map global fzf -docstring "open project" 'p' '<esc>: fzf-project<ret>'

try %{ declare-user-mode fzf-project }
map global fzf -docstring "project menu" '<a-p>' '<esc>: enter-user-mode fzf-project<ret>'
map global fzf-project -docstring "save current path as project" 's' '<esc>: fzf-save-path-as-project<ret>'
map global fzf-project -docstring "update project" 'u' '<esc>: fzf-update-project-path<ret>'

define-command -hidden fzf-project %{ evaluate-commands %sh{
    printf '%s\n' "info -title %{fzf open project} %{Change the server's working directory to selected project}"
    printf "%s\n" "fzf -kak-cmd change-directory -items-cmd %{cat $kak_opt_fzf_projects_file} -preview-cmd %{$preview} -post-action fzf-file -filter %{sed 's/.*:  //'}"
}}

define-command fzf-save-path-as-project %{ prompt "Project's name: " %{ nop %sh{
    mkdir -p "${kak_opt_fzf_projects_file%/*}"
    tmp=$(mktemp "${TMPDIR:-/tmp}/fzf-project.XXXXXXX")
    project=$(grep "$kak_text:  " $kak_opt_fzf_projects_file)
    if [ -z "${project}" ]; then
        printf "%s:  %s\n" "$kak_text" "$(pwd)" >> $kak_opt_fzf_projects_file
    else
        perl -pe "s(\Q$kak_text:  \E.*)($kak_text:  $(pwd))" "${kak_opt_fzf_projects_file}" > ${tmp} && cat ${tmp} > "${kak_opt_fzf_projects_file}"
    fi
    rm -rf ${tmp}
}}}

define-command fzf-update-project-path %{
    prompt -shell-script-candidates %{ perl -n -e '/^([^:]+)/ && print "$1\n"' $kak_opt_fzf_projects_file } "Project to update: " %{ nop %sh{
        tmp=$(mktemp "${TMPDIR:-/tmp}/fzf-project.XXXXXXX")
        perl -pe "s(\Q$kak_text:  \E.*)($kak_text:  $(pwd))" "${kak_opt_fzf_projects_file}" > ${tmp} && cat ${tmp} > "${kak_opt_fzf_projects_file}"
        rm -rf ${tmp}
    }}
}

