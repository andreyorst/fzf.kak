# ╭─────────────╥───────────────────╮
# │ Author:     ║ Plugin:           │
# │ Andrey Orst ║ fzf.kak           │
# ╞═════════════╩═══════════════════╡
# │ This plugin implements fzf      │
# │ mode for Kakoune. This mode     │
# │ adds several mappings to invoke │
# │ different fzf commands.         │
# ╰─────────────────────────────────╯

try %{ declare-user-mode fzf } catch %{echo -markup "{Error}Can't declare mode 'fzf' - already exists"}

# Options
declare-option -docstring 'allow showing preview window
Default value:
    true
' \
bool fzf_preview true

declare-option -docstring 'amount of lines to pass to preview window
Default value: 100' \
int fzf_preview_lines 100

declare-option -docstring 'Highlighter to use in preview window. You can provide
only the name of the tool that you want to use, or specify a command.
Supported tools:
    <package>: <value>:
    Bat:       "bat"
    Coderay:   "coderay"
    Highlight: "highlight"
    Rouge:     "rouge"

These are default arguments for the tools above:
    <tool>:    <value>:
    bat:       "bat --color=always --style=header,grid,numbers {}"
    coderay:   "coderay {}"
    highlight: "highlight --failsafe -O ansi {}"
    rouge:     "rougify {}"
' \
str fzf_highlighter "highlight"

declare-option -docstring "height of fzf tmux split in screen lines or percents.
Default value: 25%%" \
str fzf_tmux_height '25%'

declare-option -docstring "height of fzf tmux split for file preview in screen lines or percents.
Default value: 70%%" \
str fzf_tmux_height_file_preview '70%'

declare-option -docstring "width of preview window.
Default value: 50%%" \
str fzf_preview_width '50%'

declare-option -docstring "height of preview window.
Default value: 60%%" \
str fzf_preview_height '60%'

# Commands
define-command -docstring "Enter fzf-mode.
fzf-mode contains mnemonic key bindings for every fzf.kak command

Best used with mapping like:
    map global normal '<some key>' ': fzf-mode<ret>'
" \
fzf-mode %{ try %{ evaluate-commands 'enter-user-mode fzf' } }

define-command -hidden fzf -params 2..3 %{ evaluate-commands %sh{
    callback=$1
    items_command=$2
    additional_flags=$3
    tmux_height=$kak_opt_fzf_tmux_height

    items_executable=$(echo $items_command | grep -o -E "[[:alpha:]]+" | head -1)
    if [ -z $(command -v $items_executable) ]; then
        echo "fail %{'$items_executable' executable not found}"
        exit
    fi

    tmp=$(mktemp $(eval echo ${TMPDIR:-/tmp}/kak-fzf.XXXXXX))
    exec=$(mktemp $(eval echo ${TMPDIR:-/tmp}/kak-exec.XXXXXX))

    if [ "$(echo $callback | grep -o -E '[[:alpha:]]+' | head -1)" = "edit" ] && [ $kak_opt_fzf_preview = "true" ]; then
        case $kak_opt_fzf_highlighter in
        bat)
            highlighter="bat --color=always --style=header,grid,numbers {}" ;;
        coderay)
            highlighter="coderay {}" ;;
        highlight)
            highlighter="highlight --failsafe -O ansi {}" ;;
        rouge)
            highlighter="rougify {}" ;;
        bat*|coderay*|highlight*|rougify*)
            highlighter=$kak_opt_fzf_highlighter ;;
        *)
            executable=$(echo $kak_opt_fzf_highlighter | grep -o -E '[[:alpha:]]+' | head -1)
            echo "echo -markup %{{Information}'$executable' highlighter is not supported by the script. fzf.kak may not work as you expect.}"
            highlighter=$kak_opt_fzf_highlighter ;;
        esac
        if [ ! -z "${kak_client_env_TMUX}" ]; then
            preview_pos="pos=right:$kak_opt_fzf_preview_width;"
            tmux_height=$kak_opt_fzf_tmux_height_file_preview
        else
            preview_pos='sleep 0.1; if [ $(tput cols) -gt $(expr $(tput lines) \* 2) ]; then pos=right:'$kak_opt_fzf_preview_width'; else pos=top:'$kak_opt_fzf_preview_height'; fi;'
        fi
        additional_flags="--preview '($highlighter || cat {}) 2>/dev/null | head -n $kak_opt_fzf_preview_lines' --preview-window=\$pos $additional_flags"
    fi

    if [ ! -z "${kak_client_env_TMUX}" ]; then
        cmd="$preview_pos $items_command | fzf-tmux -d $tmux_height --expect ctrl-q $additional_flags > $tmp"
    elif [ ! -z "${kak_opt_termcmd}" ]; then
        fzfcmd=$(mktemp $(eval echo ${TMPDIR:-/tmp}/kak-fzfcmd.XXXXXX))
        chmod 755 $fzfcmd
        echo "cd $PWD && $preview_pos $items_command | fzf --expect ctrl-q $additional_flags > $tmp" > $fzfcmd
        cmd="$kak_opt_termcmd 'sh -c $fzfcmd'"
    else
        echo "fail termcmd option is not set"
        exit
    fi

    (
        eval "$cmd"
        if [ -s $tmp ]; then
            (
                read action
                if [ "${callback% *}" != "change-directory" ]; then
                    case $action in
                        ctrl-w)
                            wincmd="x11-new "
                            [ ! -z "${kak_client_env_TMUX}" ] && wincmd="tmux-new-window " ;;
                        ctrl-s)
                            wincmd="tmux-new-vertical " ;;
                        ctrl-v)
                            wincmd="tmux-new-horizontal " ;;
                        alt-*)
                            kind="${action##*-}"
                            callback="fzf-tag $kind" ;;
                        *)
                            wincmd= ;;
                    esac
                    callback="$wincmd$callback"
                    echo "echo evaluate-commands -client $kak_client \"$callback\" | kak -p $kak_session" > $exec
                else
                    echo "echo evaluate-commands -client $kak_client \"$callback\" | kak -p $kak_session" > $exec
                    echo "echo evaluate-commands -client $kak_client \"fzf-cd\"    | kak -p $kak_session" >> $exec
                fi
                chmod 755 $exec
                while read file; do
                    $exec "\'$file'"
                done
            ) < $tmp
        fi
        rm $tmp
        rm $exec
        [ -z "$fzfcmd" ] && rm $fzfcmd
    ) > /dev/null 2>&1 < /dev/null &
}}

