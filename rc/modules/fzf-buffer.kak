# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-buffer.kak         │
# ╞═════════════╩════════════════════════╡
# │ Module for changing buffers with fzf │
# │ for fzf.kak plugin                   │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

hook global ModuleLoaded fzf %§

map global fzf -docstring "open buffer" 'b' '<esc>: fzf-buffer<ret>'

define-command -hidden fzf-buffer %{ evaluate-commands %sh{
    buffers=$(mktemp ${TMPDIR:-/tmp}/kak-fzf-buffers.XXXXXX)
    eval "set -- $kak_quoted_buflist"
    while [ $# -gt 0 ]; do
        printf "%s\n" "$1" >> $buffers
        shift
    done

    message="Set buffer to edit in current client.
<ret>: switch to selected buffer.
$kak_opt_fzf_window_map: open buffer in new window"
    [ ! -z "${kak_client_env_TMUX}" ] && tmux_keybindings="
$kak_opt_fzf_horizontal_map: open buffer in horizontal split
$kak_opt_fzf_vertical_map: open buffer in vertical split"
    printf "%s\n" "info -title 'fzf buffer' '$message$tmux_keybindings'"
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect $kak_opt_fzf_vertical_map --expect $kak_opt_fzf_horizontal_map"

    printf "%s\n" "fzf -kak-cmd %{buffer} -items-cmd %{(cat $buffers; rm $buffers)} -fzf-args %{--expect $kak_opt_fzf_window_map $additional_flags}"
}}

§
