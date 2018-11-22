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
    printf '%s\n' "info -title %{fzf change directory} %{Change the server's working directory}"

    case $kak_opt_fzf_cd_command in
        find)
            items_command="(echo .. && find \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type d -print)" ;;
        *)
            items_command=$kak_opt_fzf_cd_command ;;
    esac

    tmux_height=$kak_opt_fzf_tmux_height

    items_executable=$(printf "%s\n" "$items_command" | grep -o -E "[[:alpha:]]+" | head -1)
    if [ -z $(command -v $items_executable) ]; then
        printf "%s\n" "fail %{'$items_executable' executable not found}"
        exit
    fi

    tmp=$(mktemp ${TMPDIR:-/tmp}/kak-fzf.XXXXXX)

    if [ ! -z "${kak_client_env_TMUX}" ]; then
        cmd="$items_command | fzf-tmux -d $tmux_height > $tmp"
    elif [ ! -z "${kak_opt_termcmd}" ]; then
        fzfcmd=$(mktemp ${TMPDIR:-/tmp}/kak-fzfcmd.XXXXXX)
        chmod 755 $fzfcmd
        printf "%s\n" "cd $PWD && $items_command | fzf > $tmp" > $fzfcmd
        cmd="$kak_opt_termcmd 'sh -c $fzfcmd'"
    else
        printf "%s\n" "fail termcmd option is not set"
        exit
    fi

    (
        eval "$cmd"
        if [ -s $tmp ]; then
            (
                while read item; do
                    printf "%s\n" "evaluate-commands -client $kak_client 'change-directory' '$item'" | kak -p $kak_session
                    printf "%s\n" "evaluate-commands -client $kak_client fzf-cd" | kak -p $kak_session
                done
            ) < $tmp
        fi
        rm $tmp
        [ -z "$fzfcmd" ] && rm $fzfcmd
    ) > /dev/null 2>&1 < /dev/null &
}}
