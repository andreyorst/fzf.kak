# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ fzf-cd.kak             │
# ╞═════════════╩════════════════════════╡
# │ Module for changing directories with │
# │ fzf for fzf.kak plugin               │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

declare-option -docstring "command to provide list of directories to fzf.
Default value:
    find: (echo .. && find \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type d -print)
" \
str fzf_cd_command "find"

map global fzf -docstring "change directory" 'c' '<esc>: fzf-cd<ret>'

define-command -hidden fzf-cd %{ evaluate-commands %sh{
    tmux_height=$kak_opt_fzf_tmux_height
    printf '%s\n' "info -title %{fzf change directory} %{Change the server's working directory}"

    case $kak_opt_fzf_cd_command in
        find)
            items_command="(echo .. && find \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type d -print)" ;;
        *)
            items_command=$kak_opt_fzf_cd_command ;;
    esac

    tmp=$(mktemp ${TMPDIR:-/tmp}/kak-fzf-tmp.XXXXXX)
    fzfcmd=$(mktemp ${TMPDIR:-/tmp}/kak-fzfcmd.XXXXXX)
    printf "%s\n" "cd $PWD && $items_command | SHELL=$(command -v sh) fzf > $tmp" > $fzfcmd
    chmod 755 $fzfcmd

    if [ -n "$kak_client_env_TMUX" ]; then
        [ -n "${tmux_height%%*%}" ] && measure="-p" || measure="-p"
        cmd="command tmux split-window $measure ${tmux_height%%%*} 'sh -c $fzfcmd; rm $fzfcmd'"
    elif [ -n "$kak_opt_termcmd" ]; then
        cmd="$kak_opt_termcmd 'sh -c $fzfcmd; rm $fzfcmd'"
    else
        printf "%s\n" "fail %{termcmd option is not set}"
        rm $fzfcmd
        rm $tmp
        exit
    fi

    (
        eval "$cmd"
        while [ -e $fzfcmd ]; do
            sleep 0.1
        done
        if [ -s $tmp ]; then
            (
                while read item; do
                    printf "%s\n" "evaluate-commands -client $kak_client change-directory %{$item}" | kak -p $kak_session
                    printf "%s\n" "evaluate-commands -client $kak_client fzf-cd" | kak -p $kak_session
                done
            ) < $tmp
        fi
        rm $tmp
    ) > /dev/null 2>&1 < /dev/null &
}}

