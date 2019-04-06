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
map global fzf-project -docstring "rename project" 'r' '<esc>: fzf-rename-project<ret>'

declare-option -docstring "file where saved projects are stored" str fzf_project_file "%val{config}/.fzf-projects"
declare-option -docstring %sh{ printf "%s\n" "use '~/' instead of '$HOME'" } bool fzf_project_use_tilda false

define-command -hidden fzf-project %{ evaluate-commands %sh{
    if [ -s $kak_opt_fzf_project_file ]; then
        printf '%s\n' "info -title %{fzf open project} %{Change the server's working directory to selected project}"
        printf "%s\n" "fzf -kak-cmd change-directory -items-cmd %{cat $kak_opt_fzf_project_file} -fzf-args %{--reverse} -post-action fzf-file -filter %{sed 's/.*:  //'}"
    else
        printf "%s\n" "echo -markup %{{Information}No project defined in '$kak_opt_fzf_project_file'}"
    fi
}}

define-command -hidden fzf-save-path-as-project %{ prompt -shell-script-candidates %{printf "%s\n" "${PWD##*/}"} "Project's name: " %{ evaluate-commands %sh{
    mkdir -p "${kak_opt_fzf_project_file%/*}"
    tmp=$(mktemp "${TMPDIR:-/tmp}/fzf-project.XXXXXXX")
    project=$(grep "$kak_text:  " $kak_opt_fzf_project_file)
    if [ -z "${project}" ]; then
        [ "${kak_opt_fzf_project_use_tilda}" = "false" ] && project_path=$(pwd) || project_path=$(pwd | perl -pe "s($HOME)(~)")
        printf "%s:  %s\n" "$kak_text" "${project_path}" >> $kak_opt_fzf_project_file
        printf "%s\n" "echo -markup %{{Information}saved '$(pwd)' project as '$kak_text'}"
    else
        project="$kak_text"
        printf "%s\n" "fzf-project-confirm-impl %{fzf-update-project-path-impl} %{$project} %{Project '$project' updated} %{Project '$project' kept}"
    fi
    rm -rf ${tmp}
}}}

define-command -hidden fzf-project-confirm-impl -params 2..4 %{
    prompt -shell-script-candidates %{printf "%s\n%s\n" "y" "n"} "Project '%arg{2}' exists. Update? (y/N): " %{ evaluate-commands %sh{
        function_to_call=$1;  project=$2;  success_message=$3;  fail_message=$4
        choice=$(printf "%s" "$kak_text" | perl -pe "s/y(es)?.*//i") # case isensetive lookup for yes answer
        if [ -z "$choice" ]; then
            printf "%s\n" "$function_to_call %{$project}"
            [ -n "$success_message" ] && printf "%s\n" "echo -markup %{{Information}$success_message}"
        else
            [ -n "$fail_message" ] && printf "%s\n" "echo -markup %{{Information}$fail_message '$choice'}"
        fi
    }}
}

define-command -hidden fzf-update-project-path %{
    prompt -shell-script-candidates %{ perl -ne '/^([^:]+)/ && print "$1\n"' $kak_opt_fzf_project_file } "Project to update: " %{
        fzf-update-project-path-impl %val{text}
        echo -markup "{Information}'%val{text}' project updated"
    }
}

define-command -hidden fzf-update-project-path-impl -params 1 %{ nop %sh{
    tmp=$(mktemp "${TMPDIR:-/tmp}/fzf-project.XXXXXXX")
    [ "${kak_opt_fzf_project_use_tilda}" = "false" ] && project_path=$(pwd) || project_path=$(pwd | perl -pe "s($HOME)(~)")
    perl -pe "s(\Q$1:  \E.*)($1:  ${project_path})" "${kak_opt_fzf_project_file}" > ${tmp} && cat ${tmp} > "${kak_opt_fzf_project_file}"
    rm -rf ${tmp}
}}

define-command -hidden fzf-delete-project %{
    prompt -shell-script-candidates %{ perl -ne '/^([^:]+)/ && print "$1\n"' $kak_opt_fzf_project_file } "Project to delete: " %{ nop %sh{
        tmp=$(mktemp "${TMPDIR:-/tmp}/fzf-project.XXXXXXX")
        perl -pe "s(\Q$kak_text:  \E.*\n)()" "${kak_opt_fzf_project_file}" > ${tmp} && cat ${tmp} > "${kak_opt_fzf_project_file}"
        rm -rf ${tmp}
    }}
}

define-command -hidden fzf-rename-project %{
    prompt -shell-script-candidates %{ perl -ne '/^([^:]+)/ && print "$1\n"' $kak_opt_fzf_project_file } "Project to rename: " %{ evaluate-commands %sh{
        tmp=$(mktemp "${TMPDIR:-/tmp}/fzf-project.XXXXXXX")
        project_name=${kak_text}
        printf "%s\n" "prompt %{New name: } %{ evaluate-commands %sh{
            perl -pe \"s($project_name:)(\$kak_text:)\" \"${kak_opt_fzf_project_file}\" > ${tmp} && cat ${tmp} > "${kak_opt_fzf_project_file}"
            printf \"%s\n\" \"echo -markup %{{Information}'$project_name' renamed to '\$kak_text'}\"
            printf \"%s\n\" \"fzf-project\"
        }}"
        rm -rf ${tmp}
    }}
}

