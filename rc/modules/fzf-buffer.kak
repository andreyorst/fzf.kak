# Author: Andrey Listopadov
# Module for changing buffers with fzf for fzf.kak plugin
# https://github.com/andreyorst/fzf.kak

hook global ModuleLoaded fzf %{
    map global fzf -docstring "open buffer" 'b' '<esc>: require-module fzf-buffer; fzf-buffer<ret>'
    map global fzf -docstring "delete buffer" '<a-b>' '<esc>: require-module fzf-buffer; fzf-delete-buffer<ret>'
}

provide-module fzf-buffer %§

define-command -hidden fzf-buffer %{ evaluate-commands %sh{
    buffers=""
    eval "set -- ${kak_quoted_buflist:?}"
    while [ $# -gt 0 ]; do
        buffers="$1
$buffers"
        shift
    done

    message="Set buffer to edit in current client.
<ret>: switch to selected buffer.
${kak_opt_fzf_window_map:-ctrl-w}: open buffer in new window"
    [ -n "${kak_client_env_TMUX:-}" ] && tmux_keybindings="
${kak_opt_fzf_horizontal_map:-ctrl-s}: open buffer in horizontal split
${kak_opt_fzf_vertical_map:-ctrl-v}: open buffer in vertical split"
    printf "%s\n" "info -title 'fzf buffer' '$message$tmux_keybindings'"
    [ -n "${kak_client_env_TMUX:-}" ] && additional_flags="--expect ${kak_opt_fzf_vertical_map:-ctrl-v} --expect ${kak_opt_fzf_horizontal_map:-ctrl-s}"

    printf "%s\n" "fzf -kak-cmd %{buffer} -items-cmd %{printf \"%s\n\" \"$buffers\"} -fzf-args %{--expect ${kak_opt_fzf_window_map:-ctrl-w} $additional_flags}"
}}

define-command -hidden fzf-delete-buffer %{ evaluate-commands %sh{
    buffers=""
    eval "set -- ${kak_quoted_buflist:?}"
    while [ $# -gt 0 ]; do
        buffers="$1
$buffers"
        shift
    done

    message="Delete buffer.
<ret>: delete selected buffer."
    printf "%s\n" "info -title 'fzf delete-buffer' '$message'"
    printf "%s\n" "fzf -kak-cmd %{delete-buffer} -multiple-cmd %{delete-buffer} -items-cmd %{printf \"%s\n\" \"$buffers\"} -fzf-args %{-m --expect ${kak_opt_fzf_window_map:-ctrl-w} ${additional_flags:-}}"
}}

§
