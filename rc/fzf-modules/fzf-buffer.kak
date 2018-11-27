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
    printf "%s\n" "info -title %{fzf buffer} %{Set buffer to edit in current client.}"
    buffers=$(mktemp ${TMPDIR:-/tmp}/kak-fzf-buffers.XXXXXX)
    eval "set -- $kak_buflist"
    while [ $# -gt 0 ]; do
        printf "%s\n" "$1" >> $buffers
        shift
    done
    printf "%s\n" "fzf %{buffer} %{(cat $buffers; rm $buffers)}"
}}
