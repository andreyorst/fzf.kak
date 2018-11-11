# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-search.kak         │
# ╞═════════════╩════════════════════════╡
# │ Module for searching inside current  │
# │ buffer with fzf for fzf.kak          │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

map global fzf -docstring "search in buffer"             's' '<esc>: fzf-buffer-search<ret>'

define-command -hidden fzf-buffer-search %{ evaluate-commands %sh{
    title="fzf buffer search"
    message="Search buffer with fzf, and jump to result location"
    echo "info -title '$title' '$message'"
    line=$kak_cursor_line
    char=$(expr $kak_cursor_char_column - 1)
    buffer_content=$(mktemp ${TMPDIR:-/tmp}/kak-curr-buff.XXXXXX)
    echo "execute-keys %{%<a-|>cat<space>><space>$buffer_content<ret>;}"
    echo "execute-keys $line g $char l"
    echo "fzf %{execute-keys \$1 gx} %{(nl -b a -n ln $buffer_content} %{--reverse | cut -f 1; rm $buffer_content)}"
}}

