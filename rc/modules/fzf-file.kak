# Author: Andrey Listopadov
# Module for opening files with fzf for fzf.kak plugin
# https://github.com/andreyorst/fzf.kak

hook global ModuleLoaded fzf %{
    map global fzf -docstring "open file" 'f' '<esc>: require-module fzf-file; fzf-file<ret>'
}

provide-module fzf-file %§

declare-option -docstring "command to provide list of files to fzf. Arguments are supported
Supported tools:
    <package>:           <value>:
    GNU Find:            ""find""
    The Silver Searcher: ""ag""
    ripgrep:             ""rg""
    fd:                  ""fd""

Default arguments:
    find: ""find -L . -type f""
    ag:   ""ag -l -f --hidden --one-device .""
    rg:   ""rg -L --hidden --files""
    fd:   ""fd --type f --follow""
" \
str fzf_file_command "find"

declare-option -docstring 'allow showing preview window while searching for file
Default value:
    true
' \
bool fzf_file_preview true


define-command -hidden fzf-file %{ evaluate-commands %sh{
    if [ -z "$(command -v "${kak_opt_fzf_file_command%% *}")" ]; then
        printf "%s\n" "echo -markup '{Information}''$kak_opt_fzf_file_command'' is not installed. Falling back to ''find'''"
        kak_opt_fzf_file_command="find"
    fi
    case $kak_opt_fzf_file_command in
        (find)              cmd="find -L . -type f" ;;
        (ag)                cmd="ag -l -f --hidden --one-device . " ;;
        (rg)                cmd="rg -L --hidden --files" ;;
        (fd)                cmd="fd --type f --follow" ;;
        (find*|ag*|rg*|fd*) cmd=$kak_opt_fzf_file_command ;;
        (*)                 items_executable=$(printf "%s\n" "$kak_opt_fzf_file_command" | grep -o -E "[[:alpha:]]+" | head -1)
                            printf "%s\n" "echo -markup %{{Information}Warning: '$items_executable' is not supported by fzf.kak.}"
                            cmd=$kak_opt_fzf_file_command ;;
    esac

    cmd="$cmd 2>/dev/null"
    message="Open single or multiple files.
<ret>: open file in new buffer.
${kak_opt_fzf_window_map:-ctrl-w}: open file in new terminal"
    [ -n "${kak_client_env_TMUX:-}" ] && tmux_keybindings="
${kak_opt_fzf_horizontal_map:-ctrl-s}: open file in horizontal split
${kak_opt_fzf_vertical_map:-ctrl-v}: open file in vertical split"

    printf "%s\n" "info -title 'fzf file' '$message$tmux_keybindings'"
    [ -n "${kak_client_env_TMUX}" ] && additional_flags="--expect ${kak_opt_fzf_vertical_map:-ctrl-v} --expect ${kak_opt_fzf_horizontal_map:-ctrl-s}"
    [ "${kak_opt_fzf_file_preview:-}" = "true" ] && preview_flag="-preview"
    printf "%s\n" "fzf $preview_flag -kak-cmd %{edit -existing} -items-cmd %{$cmd} -fzf-args %{-m --expect ${kak_opt_fzf_window_map:-ctrl-w} $additional_flags}"
}}

§
