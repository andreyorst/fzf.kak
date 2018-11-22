# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-vcs.kak            │
# ╞═════════════╩════════════════════════╡
# │ Module that declares VCS submodule   │
# │ for various version control systems  │
# │ to open files with fzf               │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

try %{ declare-user-mode fzf-vcs } catch %{echo -markup "{Error}Can't declare mode 'fzf-vcs' - already exists"}

map global fzf -docstring "edit file from vcs repo"      'v'     '<esc>: fzf-vcs<ret>'
map global fzf -docstring "svitch to vcs selection mode" '<a-v>' '<esc>: fzf-vcs-mode<ret>'

define-command -docstring "Enter fzf-vcs-mode.
This mode allows selecting specific vcs command." \
fzf-vcs-mode %{ try %{ evaluate-commands 'enter-user-mode fzf-vcs' } }

define-command -hidden -docstring 'Wrapper command for fzf vcs to automatically decect
used version control system.

Supported vcs:
    Git:           "git"
    Subversion:    "svn"
    Mercurial SCM: "hg"
    GNU Bazaar:    "bzr"
' \
fzf-vcs %{ evaluate-commands %sh{
    commands="git rev-parse --is-inside-work-tree
svn info
hg --cwd . root
bzr status"
    IFS='
'
    for cmd in $commands; do
        eval $cmd >/dev/null 2>&1
        res=$?
        if [ "$res"  = "0" ]; then
            vcs=$(printf "%s\n" "$cmd" | awk '{print $1}')
            title="fzf $vcs"
            [ ! -z "${kak_client_env_TMUX}" ] && additional_keybindings="
<c-s>: open file in horizontal split
<c-v>: open file in vertical split"
            message="Open single or multiple files from git tree.
<ret>: open file in new buffer.
<c-w>: open file in new window $additional_keybindings"
            printf "%s\n" "info -title %{$title} %{$message}"
            printf "%s\n" "fzf-$vcs"
            exit
        fi
    done
    printf "%s\n" "echo -markup '{Information}No VCS found in current folder'"
}}

