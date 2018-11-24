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
    echo "info -title 'fzf buffer' 'Set buffer to edit in current client.
<c-d>: delete selected buffer'"

    tmux_height=$kak_opt_fzf_tmux_height
    buffers=$(printf "%s\n" "$kak_buflist" | sed "s/^'//;s/'$//;s/' '/\n/g")

    tmp=$(mktemp ${TMPDIR:-/tmp}/kak-fzf-tmp.XXXXXX)
    fzfcmd=$(mktemp ${TMPDIR:-/tmp}/kak-fzfcmd.XXXXXX)
    printf "%s\n" "printf '%s\n' '$buffers' | SHELL=$(command -v sh) fzf --expect ctrl-d > $tmp" > $fzfcmd
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
                read action
                read buf
                if [ "$action" = "ctrl-d" ]; then
                    printf "%s\n" "evaluate-commands -client $kak_client delete-buffer $buf" | kak -p $kak_session
                    printf "%s\n" "evaluate-commands -client $kak_client fzf-buffer" | kak -p $kak_session
                else
                    printf "%s\n" "evaluate-commands -client $kak_client buffer $buf" | kak -p $kak_session
                fi
            ) < $tmp
        else
            printf "%s\n" "evaluate-commands -client $kak_client buffer $kak_bufname" | kak -p $kak_session
        fi
        rm $tmp
    ) > /dev/null 2>&1 < /dev/null &
}}
