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

# this will fail if yank-ring.kak isn't installed
hook global -once WinCreate .* %{
    try %{
        set-option -add global yank_ring_history
        map global fzf -docstring "open yank-ring" 'y' '<esc>: fzf-yank-ring<ret>'
    }
}

declare-option -hidden str fzf_yank_ring_result

define-command -hidden fzf-yank-ring %{ evaluate-commands %sh{
    yanks=$(mktemp ${TMPDIR:-/tmp}/kak-fzf-yanks.XXXXXX)
    eval "set -- $kak_opt_yank_ring_history"
    while [ $# -gt 0 ]; do
        item=$(printf "%s" "$1" | sed "s/^'//;s/'$//" | awk 1 ORS='␤')
        printf "%s\n" "$item" >> $yanks
        shift
    done

    message="Swap between items in yank-ring."
    printf "%s\n" "fzf -kak-cmd %{set-option global fzf_yank_ring_result} -items-cmd %{cat $yanks} -post-action %{fzf-yank-ring-set-dquote}"
}}

define-command fzf-yank-ring-set-dquote %{
    set-register dquote %sh{
        printf "%s\n" "$kak_opt_fzf_yank_ring_result" | sed "s/␤/\n/g;"
    }
}

