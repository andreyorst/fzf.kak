# Author: Andrey Listopadov
# Module for grepping file contents
# https://github.com/andreyorst/fzf.kak

hook global ModuleLoaded fzf %{
    map -docstring 'grep file contents recursively' global fzf g ': require-module fzf-grep; fzf-grep<ret>'
}

provide-module fzf-grep %§

declare-option -docstring "What command to use to provide a list of grep search matches.
Grep output must follow the format of 'filename:line-number:text', and specify a pattern to match across all file contents.
By default, an empty pattern is searched, effectively matching every line in every file.
GNU grep and ripgrep are supported by default.

Default value:
    grep -RHn '' ." \
str fzf_grep_command 'grep'

declare-option -docstring "Whether to enable preview in grep window." \
bool fzf_grep_preview true

declare-option -docstring "Preview command for seeing file contents of the selected item.

Default value:
    cat {1}" \
str fzf_grep_preview_command 'cat'


define-command -hidden fzf-grep %{ evaluate-commands %sh{
    if [ -z "$(command -v "${kak_opt_fzf_grep_command%% *}")" ]; then
        printf "%s\n" "echo -markup '{Information}''$kak_opt_fzf_grep_command'' is not installed. Falling back to ''grep'''"
        kak_opt_fzf_grep_command="grep"
    fi
    case $kak_opt_fzf_grep_command in
        (grep)      cmd="grep -RHn '' ." ;;
        (rg)        cmd="rg --line-number --no-column --no-heading --color=never ''" ;;
        (grep*|rg*) cmd=$kak_opt_fzf_grep_command ;;
        (*)         items_executable=$(printf "%s\n" "$kak_opt_fzf_grep_command" | grep -o -E "[[:alpha:]]+" | head -1)
                    printf "%s\n" "echo -markup %{{Information}Warning: '$items_executable' is not supported by fzf.kak.}"
                    cmd=$kak_opt_fzf_grep_command ;;
    esac

    cmd="$cmd 2>/dev/null"

    title="fzf grep"
    message="grep through contents of all files recursively.
<ret>: open search result in new buffer.
${kak_opt_fzf_window_map:-ctrl-w}: open search result in new terminal"
    [ -n "${kak_client_env_TMUX:-}" ] && tmux_keybindings="
${kak_opt_fzf_horizontal_map:-ctrl-s}: open search result in horizontal split
${kak_opt_fzf_vertical_map:-ctrl-v}: open search result in vertical split"

    case $kak_opt_fzf_grep_preview_command in
        (cat)       highlight_cmd="cat {1}";;
        (bat)       highlight_cmd="bat --color=always --highlight-line {2} {1}";;
        (cat*|bat*) highlight_cmd="$kak_opt_fzf_grep_preview_command";;
        (*)         items_executable=$(printf "%s\n" "$kak_opt_fzf_grep_command" | grep -o -E "[[:alpha:]]+" | head -1)
                    printf "%s\n" "echo -markup %{{Information}Warning: '$items_executable' is not supported by fzf.kak.}"
                    highlight_cmd="$kak_opt_fzf_grep_preview_command" ;;
    esac

    preview_cmd=""
    if [ "${kak_opt_fzf_grep_preview:-}" = "true" ]; then
        preview_cmd="-preview -preview-cmd %{--preview '(${highlight_cmd} || cat {1}) 2>/dev/null | head -n ${kak_opt_fzf_preview_lines:-}' --preview-window=\${pos}}"
    fi

    printf "%s\n" "info -title '${title}' '${message}${tmux_keybindings}'"
    [ -n "${kak_client_env_TMUX}" ] && additional_flags="--expect ${kak_opt_fzf_vertical_map:-ctrl-v} --expect ${kak_opt_fzf_horizontal_map:-ctrl-s}"
    printf "%s\n" "fzf -kak-cmd %{evaluate-commands} ${preview_cmd} -fzf-args %{--expect ${kak_opt_fzf_window_map:-ctrl-w} $additional_flags  --delimiter=':' -n'3..'} -items-cmd %{$cmd} -filter %{sed -E 's/([^:]+):([^:]+):.*/edit -existing \1; execute-keys \2gvc/'}"
}}

§
