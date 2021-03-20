# Author: Andrey Listopadov
# Module for storing and loading projects with fzf for fzf.kak plugin
# https://github.com/andreyorst/fzf.kak

hook global ModuleLoaded fzf %{
    map global fzf -docstring "open project" 'p' '<esc>: require-module fzf-project; fzf-project<ret>'
}

provide-module fzf-project %§

require-module fzf-file

declare-option -docstring "file where saved projects are stored" str fzf_project_file "%val{config}/.fzf-projects"
declare-option -docstring %sh{ printf "%s\n" "use '~/' instead of '${HOME}'" } bool fzf_project_use_tilda false


try %{ declare-user-mode fzf-project }

map global fzf -docstring "project menu" '<a-p>' '<esc>: enter-user-mode fzf-project<ret>'
map global fzf-project -docstring "save current path as project" 's' '<esc>: fzf-save-path-as-project<ret>'
map global fzf-project -docstring "save current path as project (use basename)" '<a-s>' '<esc>: fzf-save-path-as-project-no-prompt<ret>'
map global fzf-project -docstring "update project" 'u' '<esc>: fzf-update-project-path<ret>'
map global fzf-project -docstring "delete project from project list" 'd' '<esc>: fzf-delete-project<ret>'
map global fzf-project -docstring "rename project" 'r' '<esc>: fzf-rename-project<ret>'

define-command -hidden fzf-project %{ evaluate-commands %sh{
    if [ -s "${kak_opt_fzf_project_file:-}" ]; then
        printf '%s\n' "info -title %{fzf open project} %{Change the server's working directory to selected project}"
        printf "%s\n" "fzf -kak-cmd change-directory -items-cmd %{cat ${kak_opt_fzf_project_file}} -fzf-args %{--reverse --delimiter=':' -n'1'} -post-action fzf-file -filter %{sed 's/.*:  //'}"
    else
        printf "%s\n" "echo -markup %{{Information}No project defined in '${kak_opt_fzf_project_file}'}"
    fi
}}

define-command -hidden fzf-save-path-as-project %{ prompt -shell-script-candidates %{printf "%s\n" "${PWD##*/}"} "Project's name: " %{ evaluate-commands %sh{
    if [ -n "${kak_text:-}" ]; then
        mkdir -p "${kak_opt_fzf_project_file%/*}"
        exists=$(grep "${kak_text}:  " "${kak_opt_fzf_project_file:-}")
        if [ -z "${exists}" ]; then
            [ "${kak_opt_fzf_project_use_tilda:-true}" = "false" ] && project_path=$(pwd) || project_path=$(pwd | perl -pe "s(${HOME})(~)")
            printf "%s:  %s\n" "${kak_text}" "${project_path}" >> "${kak_opt_fzf_project_file}"
            printf "%s\n" "echo -markup %{{Information}saved '$(pwd)' project as '${kak_text}'}"
        else
            printf "%s\n" "fzf-project-confirm-impl %{Project '${kak_text}' exists. Update? (y/N): } %{fzf-update-project-path-impl %{${kak_text}} %{${PWD}}} %{Project '${kak_text}' updated} %{Project '${kak_text}' kept}"
        fi
    else
        printf "%s\n" "echo -markup %{{Error} Project name can't be empty}"
    fi
}}}

define-command -hidden fzf-save-path-as-project-no-prompt %{ evaluate-commands %sh{
    mkdir -p "${kak_opt_fzf_project_file%/*}"
    # portable version of `basename'
    base() {
        filename="$1"
        case "$filename" in
            (*/*[!/]*)
                trail=${filename##*[!/]}
                filename=${filename%%"$trail"}
                base=${filename##*/} ;;
            (*[!/]*)
                trail=${filename##*[!/]}
                base=${filename%%"$trail"} ;;
            (*) base="/" ;;
        esac
        printf "%s\n" "${base}"
    }
    project_name=$(base "${PWD}")
    exists=$(grep "${project_name}:  " "${kak_opt_fzf_project_file}")
    if [ -z "${exists}" ]; then
        [ "${kak_opt_fzf_project_use_tilda:-true}" = "false" ] && project_path=$(pwd) || project_path=$(pwd | perl -pe "s(${HOME})(~)")
        printf "%s:  %s\n" "${project_name}" "${project_path}" >> "${kak_opt_fzf_project_file}"
        printf "%s\n" "echo -markup %{{Information}saved '$(pwd)' project as '${project_name}'}"
    else
        printf "%s\n" "fzf-project-confirm-impl %{Project '${project_name}' exists. Update? (y/N): } %{fzf-update-project-path-impl %{${project_name}} %{${PWD}}} %{${project_name}} %{Project '${project_name}' updated} %{Project '${project_name}' kept}"
    fi
}}

define-command -docstring \
"fzf-add-project [<switches>] <path> [<name>]: add given <path> to project list with given <name>. If name omitted basename of the project is used for the name
Switches:
    -force: overwrite project if exists without asking" \
fzf-add-project -file-completion -params 1..2 %{ evaluate-commands %sh{
    if [ "$1" = "-force" ]; then
        force="true"
        shift
    fi
    # portable version of `basename'
    base() {
        filename="$1"
        case "$filename" in
            (*/*[!/]*)
                trail=${filename##*[!/]}
                filename=${filename%%"$trail"}
                base=${filename##*/} ;;
            (*[!/]*)
                trail=${filename##*[!/]}
                base=${filename%%"$trail"} ;;
            (*) base="/" ;;
        esac
        printf "%s\n" "${base}"
    }
    mkdir -p "${kak_opt_fzf_project_file%/*}"
    project_path="$1"
    project_name="$2"
    [ -z "${project_name}" ] && project_name=$(base "${project_path}")
    exists=$(grep "${project_name}:  " "${kak_opt_fzf_project_file}")
    if [ -z "${exists}" ] || [ "${force}" = "true" ]; then
        [ "${kak_opt_fzf_project_use_tilda:-true}" = "false" ] || project_path=$(printf "%s\n" "${project_path}" | perl -pe "s(${HOME})(~)")
        printf "%s:  %s\n" "${project_name}" "${project_path}" >> "${kak_opt_fzf_project_file}"
        printf "%s\n" "echo -markup %{{Information}saved '${project_path}' project as '${project_name}'}"
    else
        printf "%s\n" "fzf-project-confirm-impl %{Project '${project_name}' exists. Update? (y/N): } %{fzf-update-project-path-impl %{${project_name}} %{${project_path}}} %{Project '${project_name}' updated} %{Project '${project_name}' kept}"
    fi
}}

define-command -docstring \
"fzf-project-confirm-impl <message> <command> [<success_message>] [<fail_message>]: promt user to confirm action" \
-hidden fzf-project-confirm-impl -params 2..4 %{
    prompt -shell-script-candidates %{printf "%s\n%s\n" "y" "n"} "%arg{1}" %{ evaluate-commands %sh{
        shift; function_to_call=$1; success_message=$2;  fail_message=$3
        choice=$(printf "%s" "${kak_text:-}" | perl -pe "s/y(es)?.*//i") # case isensetive lookup for yes answer
        if [ -z "${choice}" ]; then
            printf "%s\n" "${function_to_call}"
            [ -n "${success_message}" ] && printf "%s\n" "echo -markup %{{Information}${success_message}}"
        else
            [ -n "${fail_message}" ] && printf "%s\n" "echo -markup %{{Information}${fail_message}}"
        fi
    }}
}

define-command -hidden fzf-update-project-path %{
    prompt -shell-script-candidates %{ perl -ne '/^([^:]+)/ && print "$1\n"' ${kak_opt_fzf_project_file} } "Project to update: " %{
        fzf-update-project-path-impl %val{text}
        echo -markup "{Information}'%val{text}' project updated"
    }
}

define-command -hidden fzf-update-project-path-impl -params 1..2 %{ nop %sh{
    tmp=$(mktemp "${TMPDIR:-/tmp}/fzf-project.XXXXXXX")
    [ $# -eq 1 ] && project_path=$(pwd)
    [ "${kak_opt_fzf_project_use_tilda}" = "false" ] && project_path=$2 || project_path=$(printf "%s\n" $2 | perl -pe "s(${HOME})(~)")
    perl -pe "s(\Q$1:  \E.*)($1:  ${project_path})" "${kak_opt_fzf_project_file}" > ${tmp} && cat ${tmp} > "${kak_opt_fzf_project_file}"
    rm -rf ${tmp}
}}

define-command -hidden fzf-delete-project %{
    prompt -shell-script-candidates %{ perl -ne '/^([^:]+)/ && print "$1\n"' ${kak_opt_fzf_project_file} } "Project to delete: " %{ nop %sh{
        tmp=$(mktemp "${TMPDIR:-/tmp}/fzf-project.XXXXXXX")
        perl -pe "s(\Q${kak_text}:  \E.*\n)()" "${kak_opt_fzf_project_file}" > ${tmp} && cat ${tmp} > "${kak_opt_fzf_project_file}"
        rm -rf ${tmp}
    }}
}

define-command -hidden fzf-rename-project %{
    prompt -shell-script-candidates %{ perl -ne '/^([^:]+)/ && print "$1\n"' ${kak_opt_fzf_project_file} } "Project to rename: " %{ evaluate-commands %sh{
        tmp=$(mktemp "${TMPDIR:-/tmp}/fzf-project.XXXXXXX")
        project_name=${kak_text}
        printf "%s\n" "prompt %{New name: } %{ evaluate-commands %sh{
            perl -pe \"s(${project_name}:)(\${kak_text}:)\" \"${kak_opt_fzf_project_file}\" > ${tmp} && cat ${tmp} > "${kak_opt_fzf_project_file}"
            printf \"%s\n\" \"echo -markup %{{Information}'${project_name}' renamed to '\${kak_text}'}\"
        }}"
        rm -rf ${tmp}
    }}
}

§
