# Author: Andrey Listopadov
# Module for grepping file contents
# https://github.com/andreyorst/fzf.kak

hook global ModuleLoaded fzf %{
    map -docstring 'grep file contents recursively' global fzf g ': require-module fzf-grep; fzf-grep<ret>'
}

provide-module fzf-grep %§

declare-option -docstring "what command to use to provide list of grep search matches.
Grep output must follow the format of 'filename:line-number:text'

Default value:
    grep -RHn" \
str fzf_grep_command 'grep'


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

    printf "%s\n" "info -title '${title}' '${message}${tmux_keybindings}'"
    [ -n "${kak_client_env_TMUX}" ] && additional_flags="--expect ${kak_opt_fzf_vertical_map:-ctrl-v} --expect ${kak_opt_fzf_horizontal_map:-ctrl-s}"
    printf "%s\n" "fzf -kak-cmd %{evaluate-commands} -fzf-args %{--expect ${kak_opt_fzf_window_map:-ctrl-w} $additional_flags  --delimiter=':' -n'3..'} -items-cmd %{$cmd} -filter %{sed -E 's/([^:]+):([^:]+):.*/edit -existing \1; execute-keys \2gvc/'}"
}}

§
