# ╭─────────────╥───────────────────────╮
# │ Authors:    ║ File:                 │
# │ Andrey Orst ║ fzf-yank-ring.kak     │
# │ losnappas   ║                       │
# ╞═════════════╩═══════════════════════╡
# │ Module for selecting items in yank  │
# │ ring for fzf.kak plugin             │
# ╞═════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak       │
# │ GitHub.com/alexherbo2/yank-ring.kak │
# ╰─────────────────────────────────────╯

try %{ declare-user-mode fzf }
map global fzf -docstring "open yank-ring" 'y' '<esc>: fzf-yank-ring<ret>'

define-command -hidden fzf-yank-ring %{ evaluate-commands %sh{
    yanks=$(mktemp ${TMPDIR:-/tmp}/kak-fzf-yanks.XXXXXX)
    eval "set -- $kak_opt_yank_ring_history"
    while [ $# -gt 0 ]; do
        item=$(printf "%s" "$1" | awk 1 ORS='␤')
        printf "%s\n" "$item" >> $yanks
        shift
    done

    message="Swap between yanks."

    printf "%s" "fzf -kak-cmd %{set-register dquote} -items-cmd %{cat $yanks} -filter %{sed \"s/␤/\\\n/g;s/^'|'$//\"}"
}}

