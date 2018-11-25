# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-search.kak         │
# ╞═════════════╩════════════════════════╡
# │ Module for searching inside current  │
# │ buffer with fzf for fzf.kak          │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

map global fzf -docstring "search in buffer" 's' '<esc>: fzf-buffer-search<ret>'

define-command -hidden fzf-buffer-search %{ evaluate-commands %sh{
    title="fzf buffer search"
    message="Search buffer with fzf, and jump to result location"
    printf "%s\n" "info -title '$title' '$message'"
    buffer_content="$(mktemp ${TMPDIR:-/tmp}/fzf-buff-${kak_buffile##*/}.XXXXXX)"
    printf "%s\n" "execute-keys -draft %{%<a-|>cat<space>><space>$buffer_content<ret>;}"
    printf "%s\n" "fzf %{execute-keys} %{(nl -b a -n ln $buffer_content; rm $buffer_content)} %{--reverse | cut -f 1} %{execute-keys gx}"
}}

