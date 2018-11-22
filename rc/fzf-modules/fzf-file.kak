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
        echo "echo -markup '{Information}''$kak_opt_fzf_file_command'' is not installed. Falling back to ''find'''"
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
        executable=$(echo $kak_opt_fzf_file_command | awk '{print $1'}| tr '(' ' ' | cut -d " " -f 2)
        echo "echo -markup '{Information}''$executable'' is not supported by the script. fzf.kak may not work as you expect.'"
        cmd=$kak_opt_fzf_file_command ;;
    esac
    title="fzf file"
    [ ! -z "${kak_client_env_TMUX}" ] && additional_keybindings="
<c-s>: open file in horizontal split
<c-v>: open file in vertical split"
    message="Open single or multiple files.
<ret>: open file in new buffer.
<c-w>: open file in new window $additional_keybindings"
    echo "info -title '$title' '$message'"
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    echo "fzf %{edit} %{$cmd} %{-m --expect ctrl-w $additional_flags}"
}}

