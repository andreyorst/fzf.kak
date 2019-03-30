# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-project.kak        │
# ╞═════════════╩════════════════════════╡
# │ Module for storing and loading       │
# │ projects with fzf for fzf.kak plugin │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

try %{ declare-user-mode fzf }
map global fzf -docstring "open project" 'p' '<esc>: fzf-project<ret>'

try %{ declare-user-mode fzf-project }
map global fzf -docstring "project menu" '<a-p>' '<esc>: enter-user-mode fzf-project<ret>'
map global fzf-project -docstring "save current path as project" 's' '<esc>: fzf-save-path-as-project<ret>'
map global fzf-project -docstring "update project" 'u' '<esc>: fzf-update-project-path<ret>'
map global fzf-project -docstring "delete project from project list" 'd' '<esc>: fzf-delete-project<ret>'

declare-option -docstring "file where saved projects are stored" str fzf_projects_file "%val{config}/.fzf-projects"

define-command -hidden fzf-project %{ evaluate-commands %sh{
    if [ -s $kak_opt_fzf_projects_file ]; then
        printf '%s\n' "info -title %{fzf open project} %{Change the server's working directory to selected project}"
        printf "%s\n" "fzf -kak-cmd change-directory -items-cmd %{cat $kak_opt_fzf_projects_file} -preview-cmd %{$preview} -post-action fzf-file -filter %{sed 's/.*:  //'}"
    else
        printf "%s\n" "echo -markup %{{Information}No projects defined in '$kak_opt_fzf_projects_file'}"
    fi
}}

define-command -hidden fzf-save-path-as-project %{ prompt "Project's name: " %{ evaluate-commands %sh{
    mkdir -p "${kak_opt_fzf_projects_file%/*}"
    tmp=$(mktemp "${TMPDIR:-/tmp}/fzf-project.XXXXXXX")
    project=$(grep "$kak_text:  " $kak_opt_fzf_projects_file)
    if [ -z "${project}" ]; then
        printf "%s:  %s\n" "$kak_text" "$(pwd)" >> $kak_opt_fzf_projects_file
        printf "%s\n" "echo -markup %{{Information}saved '$(pwd)' project as '$kak_text'}"
    else
        project="$kak_text"
        printf "%s\n" "prompt -shell-script-candidates %{printf '%s\n%s\n' 'y' 'n'} %{Project '$project' exists. Update? (y/N): } %{ evaluate-commands %sh{
            if [ \"\$kak_text\" = 'y' ] || [ \"\$kak_text\" = 'Y' ] || [ \"\$kak_text\" = 'yes' ] || [ \"\$kak_text\" = 'Yes' ] || [ \"\$kak_text\" = 'YEs' ] || [ \"\$kak_text\" = 'YES' ]; then
                printf \"%s\n\" \"fzf-update-project-path-impl %{$project}\"
                printf \"%s\n\" \"echo -markup %{{Information}'$project' project updated}\"
            else
                printf \"%s\n\" \"echo -markup %{{Information}'$project' project kept}\"
            fi
        }}"
    fi
    rm -rf ${tmp}
}}}

define-command -hidden fzf-update-project-path %{
    prompt -shell-script-candidates %{ perl -n -e '/^([^:]+)/ && print "$1\n"' $kak_opt_fzf_projects_file } "Project to update: " %{
        fzf-update-project-path-impl %val{text}
        echo -markup "{Information}'%val{text}' project updated"
    }
}

define-command fzf-update-project-path-impl -params 1 %{ nop %sh{
    tmp=$(mktemp "${TMPDIR:-/tmp}/fzf-project.XXXXXXX")
    perl -pe "s(\Q$1:  \E.*)($1:  $(pwd))" "${kak_opt_fzf_projects_file}" > ${tmp} && cat ${tmp} > "${kak_opt_fzf_projects_file}"
    rm -rf ${tmp}
}}

define-command -hidden fzf-delete-project %{
    prompt -shell-script-candidates %{ perl -n -e '/^([^:]+)/ && print "$1\n"' $kak_opt_fzf_projects_file } "Project to delete: " %{ nop %sh{
        tmp=$(mktemp "${TMPDIR:-/tmp}/fzf-project.XXXXXXX")
        perl -pe "s(\Q$kak_text:  \E.*\n)()" "${kak_opt_fzf_projects_file}" > ${tmp} && cat ${tmp} > "${kak_opt_fzf_projects_file}"
        rm -rf ${tmp}
    }}
}

