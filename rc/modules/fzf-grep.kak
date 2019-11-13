# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-grep.kak           │
# ╞═════════════╩════════════════════════╡
# │ Module for grepping file contents    │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

hook global ModuleLoaded fzf %§

declare-option -docstring "what command to use to provide list of grep search matches.
Grep output must follow the format of 'filename:line-number:text'

Default value:
    grep -RHn" \
str fzf_grep_command 'grep'

map -docstring 'grep file contents recursively' global fzf g ': fzf-grep<ret>'

define-command -hidden fzf-grep %{ evaluate-commands %sh{
    if [ -z "$(command -v $kak_opt_fzf_grep_command)" ]; then
        printf "%s\n" "echo -markup '{Information}''$kak_opt_fzf_grep_command'' is not installed. Falling back to ''grep'''"
        kak_opt_fzf_grep_command="grep"
    fi
    case $kak_opt_fzf_grep_command in
        (grep)      cmd="grep -RHn '' ." ;;
        (rg)        cmd="rg --line-number --no-column --no-heading --color=never ''" ;;
        (grep*|rg*) cmd=$kak_opt_fzf_grep_command ;;
        (*)         items_executable=$(printf "%s\n" "$kak_opt_fzf_grep_command" | grep -o -E "[[:alpha:]]+" | head -1)
                    printf "%s\n" "echo -markup %{{Information}Warning: '$executable' is not supported by fzf.kak.}"
                    cmd=$kak_opt_fzf_grep_command ;;
    esac

    cmd="$cmd 2>/dev/null"

    title="fzf grep"
    message="grep through contents of all files recursively.
<ret>: open search result in new buffer.
$kak_opt_fzf_window_map: open search result in new terminal"
    [ ! -z "${kak_client_env_TMUX}" ] && tmux_keybindings="
$kak_opt_fzf_horizontal_map: open search result in horizontal split
$kak_opt_fzf_vertical_map: open search result in vertical split"

    printf "%s\n" "info -title '${title}' '${message}${tmux_keybindings}'"
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect $kak_opt_fzf_vertical_map --expect $kak_opt_fzf_horizontal_map"
    printf "%s\n" "fzf -kak-cmd %{evaluate-commands} -fzf-args %{--expect $kak_opt_fzf_window_map $additional_flags} -items-cmd %{$cmd} -filter %{sed -E 's/([^:]+):([^:]+):.*/edit -existing \1; execute-keys \2gvc/'}"
}}

§
