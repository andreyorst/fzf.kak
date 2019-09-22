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

hook global ModuleLoaded fzf %§

map global fzf -docstring "edit file from vcs repo"      'v'     '<esc>: require-module fzf_vcs; fzf-vcs<ret>'
map global fzf -docstring "switch to vcs selection mode" '<a-v>' '<esc>: fzf-vcs-mode<ret>'

define-command -docstring "Enter fzf-vcs-mode.
This mode allows selecting specific vcs command." \
fzf-vcs-mode %{ require-module fzf_vcs; evaluate-commands 'enter-user-mode fzf-vcs' }

§

provide-module fzf_vcs %§

declare-user-mode fzf-vcs

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
$kak_opt_fzf_horizontal_map: open file in horizontal split
$kak_opt_fzf_vertical_map: open file in vertical split"
            message="Open single or multiple files from git tree.
<ret>: open file in new buffer.
$kak_opt_fzf_window_map: open file in new terminal $additional_keybindings"
            printf "%s\n" "info -title %{$title} %{$message}"
            printf "%s\n" "fzf-$vcs"
            exit
        fi
    done
    printf "%s\n" "echo -markup '{Information}No VCS found in current folder'"
}}

§
