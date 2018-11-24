# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-file.kak           │
# ╞═════════════╩════════════════════════╡
# │ Module for opening files with fzf    │
# │ for fzf.kak plugin                   │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

declare-option -docstring "command to provide list of files to fzf. Arguments are supported
Supported tools:
    <package>:           <value>:
    GNU Find:            ""find""
    The Silver Searcher: ""ag""
    ripgrep:             ""rg""
    fd:                  ""fd""

Default arguments:
    find: ""find -type f -follow""
    ag:   ""ag -l -f --hidden --one-device .""
    rg:   ""rg -L --hidden --files""
    fd:   ""fd --type f --follow""
" \
str fzf_file_command "find"

map global fzf -docstring "open file" 'f' '<esc>: fzf-file<ret>'

define-command -hidden fzf-file %{ evaluate-commands %sh{
    if [ -z "$(command -v $kak_opt_fzf_file_command)" ]; then
        printf "%s\n" "echo -markup '{Information}''$kak_opt_fzf_file_command'' is not installed. Falling back to ''find'''"
        kak_opt_fzf_file_command="find"
    fi
    case $kak_opt_fzf_file_command in
    find)
        cmd="find -type f -follow" ;;
    ag)
        cmd="ag -l -f --hidden --one-device . " ;;
    rg)
        cmd="rg -L --hidden --files" ;;
    fd)
        cmd="fd --type f --follow" ;;
    find*|ag*|rg*|fd*)
        cmd=$kak_opt_fzf_file_command ;;
    *)
        items_executable=$(printf "%s\n" "$kak_opt_fzf_file_command" | grep -o -E "[[:alpha:]]+" | head -1)
        printf "%s\n" "echo -markup '{Information}'Warning: '$executable'' is not supported by fzf.kak.'"
        cmd=$kak_opt_fzf_file_command ;;
    esac

    message="Open single or multiple files.
<ret>: open file in new buffer.
<c-w>: open file in new window"
    [ ! -z "${kak_client_env_TMUX}" ] && tmux_keybindings="
<c-s>: open file in horizontal split
<c-v>: open file in vertical split"

    printf "%s\n" "info -title 'fzf file' '$message$tmux_keybindings'"
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    printf "%s\n" "fzf %{edit} %{$cmd} %{-m --expect ctrl-w $additional_flags}"
}}

