# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-buffer.kak         │
# ╞═════════════╩════════════════════════╡
# │ Module for changing buffers with fzf │
# │ for fzf.kak plugin                   │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

map global fzf -docstring "open buffer" 'b' '<esc>: fzf-buffer<ret>'

define-command -hidden fzf-buffer %{ evaluate-commands %sh{
    buffers=$(mktemp ${TMPDIR:-/tmp}/kak-fzf-buffers.XXXXXX)
    eval "set -- $kak_buflist"
    while [ $# -gt 0 ]; do
        printf "%s\n" "$1" >> $buffers
        shift
    done

    message="Set buffer to edit in current client.
<ret>: switch to selected buffer.
<c-w>: open buffer in new window"
    [ ! -z "${kak_client_env_TMUX}" ] && tmux_keybindings="
<c-s>: open buffer in horizontal split
<c-v>: open buffer in vertical split"
    printf "%s\n" "info -title 'fzf buffer' '$message$tmux_keybindings'"
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"

    printf "%s\n" "fzf %{buffer} %{(cat $buffers; rm $buffers)} %{--expect ctrl-w $additional_flags}"
}}
