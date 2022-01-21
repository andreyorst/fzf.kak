# Author: Andrey Listopadov
# Module for opening files with fzf for fzf.kak plugin
# https://github.com/andreyorst/fzf.kak

hook global ModuleLoaded fzf %{
    map global fzf -docstring "open file" 'f' '<esc>: require-module fzf-file; fzf-file<ret>'
    map global fzf -docstring "open file in dir of currently displayed file" 'F' '<esc>: require-module fzf-file; fzf-file buffile-dir<ret>'
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


define-command -hidden fzf-file -params 0..1 %{ evaluate-commands %sh{
    # Default fzf-file behavior
    search_dir="."
    if [ "$1" = "buffile-dir" ]; then
        # If the buffile-dir functionality (which is currently mapped to <fzf-mode> F) is
        # invoked by mistake on a buffile like `*scratch*` or `*grep*` and similar, there will be
        # no slashes in the buffile name and `dirname` will return `.` which means the functionality
        # will revert to the normal fzf-file behavior -- which is what we want in this scenario.
        search_dir=$(dirname "$kak_buffile")
    fi

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

    cmd="cd $search_dir; $cmd 2>/dev/null"
    maybe_filter_param=""
    if [ "$search_dir" != "." ]; then
        # Since we cd-ed into search dir in $cmd, prefix the $search_dir path after fzf returns the results by using -filter switch of fzf.
        # Kakoune either needs an absolute path or path relative to its pwd to edit a file. Since the pwd of $cmd and kakoune now differ,
        # we cannot use a relative path, so we construct the absolute path by prefixing the $search_dir to the file outputted by fzf.
        maybe_filter_param=$(printf "%s %s" "-filter" "%{perl -pe \"if (/${kak_opt_fzf_window_map:-ctrl-w}|${kak_opt_fzf_vertical_map:-ctrl-v}|${kak_opt_fzf_horizontal_map:-ctrl-s}|^$/) {} else {print \\\"$search_dir/\\\"\"}}")
    fi
    message="Open single or multiple files.
<ret>: open file in new buffer.
${kak_opt_fzf_window_map:-ctrl-w}: open file in new terminal"
    [ -n "${kak_client_env_TMUX:-}" ] && tmux_keybindings="
${kak_opt_fzf_horizontal_map:-ctrl-s}: open file in horizontal split
${kak_opt_fzf_vertical_map:-ctrl-v}: open file in vertical split"

    printf "%s\n" "info -title 'fzf file' '$message$tmux_keybindings'"
    [ -n "${kak_client_env_TMUX}" ] && additional_flags="--expect ${kak_opt_fzf_vertical_map:-ctrl-v} --expect ${kak_opt_fzf_horizontal_map:-ctrl-s}"
    [ "${kak_opt_fzf_file_preview:-}" = "true" ] && preview_flag="-preview"
    printf "%s\n" "fzf $preview_flag $maybe_filter_param -kak-cmd %{edit -existing} -items-cmd %{$cmd} -fzf-args %{-m --expect ${kak_opt_fzf_window_map:-ctrl-w} $additional_flags}"
}}

§
