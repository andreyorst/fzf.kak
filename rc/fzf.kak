# ╭─────────────╥───────────────────╮
# │ Author:     ║ Plugin:           │
# │ Andrey Orst ║ fzf.kak           │
# ╞═════════════╩═══════════════════╡
# │ This plugin implements fzf      │
# │ mode for Kakoune. This mode     │
# │ adds several mappings to invoke │
# │ different fzf commands.         │
# ╰─────────────────────────────────╯

try %{ declare-user-mode fzf } catch %{ echo -markup "{Error}Can't declare mode 'fzf' - already exists" }

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
    bat:       "bat --color=always --style=plain {}"
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

define-command -docstring "Enter fzf-mode.
fzf-mode contains mnemonic key bindings for every fzf.kak command

Best used with mapping like:
    map global normal '<some key>' ': fzf-mode<ret>'
" \
fzf-mode %{ try %{ evaluate-commands 'enter-user-mode fzf' } }

define-command -hidden fzf-vertical -params 2 %{
    try %{
        tmux-terminal-vertical kak -c %val{session} -e "%arg{1} %arg{2}"
    } catch %{
        tmux-new-vertical "%arg{1} %arg{2}"
    }
}

define-command -hidden fzf-horizontal -params 2 %{
    try %{
        tmux-terminal-horizontal kak -c %val{session} -e "%arg{1} %arg{2}"
    } catch %{
        tmux-new-horizontal "%arg{1} %arg{2}"
    }
}

define-command -hidden fzf-window -params 2 %{
    try %sh{
        if [ -n "$kak_client_env_TMUX" ]; then
            printf "%s\n" 'tmux-terminal-window kak -c %val{session} -e "%arg{1} %arg{2}"'
        else
            printf "%s\n" 'x11-terminal kak -c %val{session} -e "%arg{1} %arg{2}"'
        fi
    } catch %sh{
        if [ -n "$kak_client_env_TMUX" ]; then
            printf "%s\n" 'tmux-new-window "%arg{1} %arg{2}"'
        else
            printf "%s\n" 'x11-new "%arg{1} %arg{2}"'
        fi
    }
}

define-command -hidden -docstring \
"fzf <command> <items command> [<fzf args> <extra commands>]: generic fzf command.
This command can be used to create new fzf wrappers for various Kakoune or external
features. More about arguments:

<command>:
The <command> is a Kakoune command that should be used after fzf returns some result.
For example to open file chooser we can call fzf with `edit` as a command:
'fzf %{edit} %{<items command>}'
After choosing one or more files in fzf, <command> will be used with each of them.

<items command>
This is the shell command that is used to provide list of values to fzf. It can be
any command that provides newline separated list of items, which is then piped to fzf.

<fzf args>
These are additional flags for fzf program, that are passed to it. You can check them
in fzf manual.

<extra commands>
This is extra commands that are preformed after fzf finishis and main command was
executed. This can be used to invoke fzf back, like in fzf-cd command, or to execute
any other Kakoune command that is meaningfull in current situation. This is more is
a workaround of problem with executing composite commands, where fzf result should
be in the middle of the command and may be changed or removed it further versions.

If you want to develop a module with fzf command, feel free to check for existing
module implementations in 'rc/fzf-modules' directory." \
fzf -params 2..4 %{ evaluate-commands %sh{
    command=$1
    items_command=$2
    additional_flags=$3
    extra_action=$4
    tmux_height=$kak_opt_fzf_tmux_height

    items_executable=$(printf "%s\n" "$items_command" | grep -o -E "[[:alpha:]]+" | head -1)
    if [ -z "$(command -v $items_executable)" ]; then
        printf "%s\n" "fail %{'$items_executable' executable not found}"
        exit
    fi

    if [ $command = "edit" ] && [ $kak_opt_fzf_preview = "true" ]; then
        case $kak_opt_fzf_highlighter in
        bat)
            highlighter="bat --color=always --style=plain {}" ;;
        coderay)
            highlighter="coderay {}" ;;
        highlight)
            highlighter="highlight --failsafe -O ansi {}" ;;
        rouge)
            highlighter="rougify {}" ;;
        bat*|coderay*|highlight*|rougify*)
            highlighter=$kak_opt_fzf_highlighter ;;
        *)
            executable=$(printf "%s\n" "$kak_opt_fzf_highlighter" | grep -o -E '[[:alpha:]]+' | head -1)
            printf "%s\n" "echo -markup %{{Information}'$executable' highlighter is not supported by the script. fzf.kak may not work as you expect.}"
            highlighter=$kak_opt_fzf_highlighter ;;
        esac

        tmux_height=$kak_opt_fzf_tmux_height_file_preview
        additional_flags="--preview '($highlighter || cat {}) 2>/dev/null | head -n $kak_opt_fzf_preview_lines' --preview-window=\$pos $additional_flags"
    fi

    if [ -n "$kak_client_env_TMUX" ]; then
        preview_pos="pos=right:$kak_opt_fzf_preview_width;"
    else
        preview_pos="sleep 0.1; [ \$(tput cols) -gt \$(expr \$(tput lines) \* 2) ] && pos=right:$kak_opt_fzf_preview_width || pos=top:$kak_opt_fzf_preview_height;"
    fi

    tmp=$(mktemp ${TMPDIR:-/tmp}/kak-fzf-tmp.XXXXXX)
    fzfcmd=$(mktemp ${TMPDIR:-/tmp}/kak-fzfcmd.XXXXXX)
    printf "%s\n" "cd $PWD && $preview_pos $items_command | SHELL=$(command -v sh) fzf $additional_flags > $tmp; rm $fzfcmd" > $fzfcmd
    chmod 755 $fzfcmd

    if [ -n "$kak_client_env_TMUX" ]; then
        [ -n "${tmux_height%%*%}" ] && measure="-p" || measure="-p"
        cmd="command tmux split-window $measure ${tmux_height%%%*} 'sh -c $fzfcmd'"
    elif [ -n "$kak_opt_termcmd" ]; then
        cmd="$kak_opt_termcmd 'sh -c $fzfcmd'"
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
                case $action in
                    ctrl-w)
                        wincmd="fzf-window" ;;
                    ctrl-s)
                        wincmd="fzf-vertical" ;;
                    ctrl-v)
                        wincmd="fzf-horizontal" ;;
                    *)
                        if [ -n "$action" ]; then
                            printf "%s\n" "evaluate-commands -client $kak_client '$command' '$action'" | kak -p $kak_session
                            [ -n "$extra_action" ] && printf "%s\n" "evaluate-commands -client $kak_client $extra_action" | kak -p $kak_session
                        fi ;;
                esac
                kakoune_command() {
                    printf "%s\n" "evaluate-commands -client $kak_client $wincmd $command %{$1}"
                    [ -n "$extra_action" ] && printf "%s\n" "evaluate-commands -client $kak_client $extra_action"
                }
                while read item; do
                    kakoune_command "$item" | kak -p $kak_session
                done
            ) < $tmp
        fi
        rm $tmp
    ) > /dev/null 2>&1 < /dev/null &
}}

