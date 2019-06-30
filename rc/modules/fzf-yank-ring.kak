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

hook global ModuleLoaded fzf %§

# this will fail if yank-ring.kak isn't installed
hook global -once WinCreate .* %{ try %{
    set-option -add global yank_ring_history
    map global fzf -docstring "open yank-ring" 'y' '<esc>: fzf-yank-ring<ret>'
}}

define-command -hidden fzf-yank-ring %{ evaluate-commands %sh{
    yanks=$(mktemp ${TMPDIR:-/tmp}/kak-fzf-yanks.XXXXXX)
    eval "set -- $kak_quoted_opt_yank_ring_history"
    while [ $# -gt 0 ]; do
        item=$(printf "%s" "$1" | sed "s/^'//;s/'$//" | awk 1 ORS='␤')
        printf "%s\n" "$item" >> $yanks
        shift
    done

    message="Swap between items in yank-ring."
    printf "%s\n" "fzf -kak-cmd %{fzf-yank-ring-set-dquote} -items-cmd %{cat $yanks} -preview -preview-cmd %{--preview 'printf \"%s\\\n\" {} | sed \"s/␤/\\\n/g\"'}"
}}

define-command -hidden fzf-yank-ring-set-dquote -params 1 %{
    set-register dquote %sh{ printf "%s\n" "$1" | sed "s/␤/\n/g" }
}

§
