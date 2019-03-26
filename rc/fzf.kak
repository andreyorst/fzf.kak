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
declare-option -docstring 'implementation of fzf that you want to use.
Currently supported implementations:
    fzf:  github.com/junegunn/fzf
    sk: github.com/lotabout/skim' \
str fzf_implementation 'fzf'

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
str fzf_highlight_cmd "highlight"

declare-option -docstring "height of fzf tmux split in screen lines or percents.
Default value: 25%%" \
str fzf_tmux_height '25%'

declare-option -docstring "height of fzf tmux split for file preview in screen lines or percents.
Default value: 70%%" \
str fzf_file_preview_tmux_height '70%'

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

define-command -hidden fzf-vertical -params .. %{
    try %{
        tmux-terminal-vertical kak -c %val{session} -e "%arg{@}"
    } catch %{
        tmux-new-vertical "%arg{@}"
    }
}

define-command -hidden fzf-horizontal -params .. %{
    try %{
        tmux-terminal-horizontal kak -c %val{session} -e "%arg{@}"
    } catch %{
        tmux-new-horizontal "%arg{@}"
    }
}

define-command -hidden fzf-window -params .. %{
    try %sh{
        if [ -n "$kak_client_env_TMUX" ]; then
            printf "%s\n" 'tmux-terminal-window kak -c %val{session} -e "%arg{@}"'
        else
            printf "%s\n" 'x11-terminal kak -c %val{session} -e "%arg{@}"'
        fi
    } catch %sh{
        if [ -n "$kak_client_env_TMUX" ]; then
            printf "%s\n" 'tmux-new-window "%arg{@}"'
        else
            printf "%s\n" 'x11-new "%arg{@}"'
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
This is extra commands that are preformed after fzf finishes and main command was
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

    if [ -z "${command##edit*}" ] && [ $kak_opt_fzf_preview = "true" ]; then
        case $kak_opt_fzf_highlight_cmd in
        bat)
            highlighter="bat --color=always --style=plain {}" ;;
        coderay)
            highlighter="coderay {}" ;;
        highlight)
            highlighter="highlight --failsafe -O ansi {}" ;;
        rouge)
            highlighter="rougify {}" ;;
        bat*|coderay*|highlight*|rougify*)
            highlighter=$kak_opt_fzf_highlight_cmd ;;
        *)
            executable=$(printf "%s\n" "$kak_opt_fzf_highlight_cmd" | grep -o -E '[[:alpha:]]+' | head -1)
            printf "%s\n" "echo -markup %{{Information}'$executable' highlighter is not supported by the script. fzf.kak may not work as you expect.}"
            highlighter=$kak_opt_fzf_highlight_cmd ;;
        esac

        tmux_height=$kak_opt_fzf_file_preview_tmux_height
        additional_flags="--preview '($highlighter || cat {}) 2>/dev/null | head -n $kak_opt_fzf_preview_lines' --preview-window=\$pos $additional_flags"
    fi

    if [ -n "$kak_client_env_TMUX" ]; then
        preview_pos="pos=right:$kak_opt_fzf_preview_width;"
    else
        preview_pos="sleep 0.1; [ \$(tput cols) -gt \$(expr \$(tput lines) \* 2) ] && pos=right:$kak_opt_fzf_preview_width || pos=top:$kak_opt_fzf_preview_height;"
    fi

    tmp=$(mktemp ${TMPDIR:-/tmp}/kak-fzf-tmp.XXXXXX)
    fzfcmd=$(mktemp ${TMPDIR:-/tmp}/kak-fzfcmd.XXXXXX)
    printf "%s\n" "cd \"$PWD\" && $preview_pos $items_command | SHELL=$(command -v sh) $kak_opt_fzf_implementation $additional_flags > $tmp; rm $fzfcmd" > $fzfcmd
    chmod 755 $fzfcmd

    if [ -n "$kak_client_env_TMUX" ]; then
        [ -n "${tmux_height%%*%}" ] && measure="-l" || measure="-p"
        cmd="nop %sh{ command tmux split-window $measure ${tmux_height%%%*} 'sh -c $fzfcmd' }"
    else
        cmd="terminal %{$fzfcmd}"
    fi

    (
        printf "%s\n" "${cmd}" | kak -p ${kak_session}
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
                    printf "%s\n" "evaluate-commands -client $kak_client $wincmd %{$command %{$1}}"
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

define-command -docstring \
"fzf <switches>: generic fzf command. This command can be used to create new fzf wrappers for various Kakoune or external features.

Switches:
    -kak-cmd <command>: A Kakoune cmd that is applied to fzf resulting value.
    -items-cmd <items command>: A command that is used to provide list of values to fzf.
    -fzf-args <args>: Additional flags for fzf program
    -post-action <commands>: Extra commands that are preformed after `-kak-cmd' command.
    -preview: should fzf window include preview" \
new-fzf -shell-script-candidates %{echo "-kak-cmd\n-items-cmd\n-fzf-args\n-post-action\n"} -params .. %{ evaluate-commands %sh{
    tmux_height=$kak_opt_fzf_tmux_height
    while [ $# -gt 0 ]; do
        case $1 in
            -kak-cmd)     shift; kakoune_cmd="${kakoune_cmd} $1" ;;
            -items-cmd)   shift; items_cmd="${items_cmd} $1" ;;
            -fzf-args)    shift; fzf_args="${fzf_args} $1" ;;
            -post-action) shift; post_action="${post_action} $1" ;;
            -preview)     preview="true" ;;
            *)            ignored="${ignored} $1" ;;
        esac
        shift
    done

    if [ "$preview" = "true" ] && [ ${kak_opt_fzf_preview} = "true" ]; then
        case ${kak_opt_fzf_highlight_cmd} in
            bat)       highlight_cmd="bat --color=always --style=plain {}" ;;
            coderay)   highlight_cmd="coderay {}" ;;
            highlight) highlight_cmd="highlight --failsafe -O ansi {}" ;;
            rouge)     highlight_cmd="rougify {}" ;;
            *)         highlight_cmd="${kak_opt_fzf_highlight_cmd}" ;;
        esac
        if [ -n "${kak_client_env_TMUX}" ]; then
            [ -z "${kakoune_cmd##edit*}" ] && tmux_height=$kak_opt_fzf_file_preview_tmux_height
            preview_position="pos=right:${kak_opt_fzf_preview_width};"
        else
            preview_position="sleep 0.1; [ \$(tput cols) -gt \$(expr \$(tput lines) \* 2) ] && pos=right:${kak_opt_fzf_preview_width} || pos=top:${kak_opt_fzf_preview_height};"
        fi
        fzf_args="${fzf_args} --preview '(${highlight_cmd} || cat {}) 2>/dev/null | head -n ${kak_opt_fzf_preview_lines}' --preview-window=\${pos}"
    fi

    fzf_tmp=$(mktemp -d ${TMPDIR:-/tmp}/fzf.kak.XXXXXX)
    fzfcmd="${fzf_tmp}/fzfcmd"
    result="${fzf_tmp}/result"
    printf "%s\n" "cd \"${PWD}\" && ${preview_position} ${items_cmd} | SHELL=$(command -v sh) ${kak_opt_fzf_implementation} ${fzf_args} > ${result}; rm ${fzfcmd}" > ${fzfcmd}
    chmod 755 ${fzfcmd}

    if [ -n "${kak_client_env_TMUX}" ]; then
        [ -n "${tmux_height%%*%}" ] && measure="-l" || measure="-p"
        cmd="nop %sh{ command tmux split-window ${measure} ${tmux_height%%%*} 'sh -c ${fzfcmd}' }"
    else
        cmd="terminal %{${fzfcmd}}"
    fi

    (
        printf "%s\n" "${cmd}" | kak -p ${kak_session}
        while [ -e $fzfcmd ]; do
            sleep 0.1
        done
        if [ -s $result ]; then
            (
                read action
                case $action in
                    ctrl-w) wincmd="fzf-window" ;;
                    ctrl-s) wincmd="fzf-vertical" ;;
                    ctrl-v) wincmd="fzf-horizontal" ;;
                    *)
                        if [ -n "$action" ]; then
                            printf "%s\n" "evaluate-commands -client $kak_client '$kakoune_cmd' '$action'" | kak -p $kak_session
                            [ -n "$post_action" ] && printf "%s\n" "evaluate-commands -client $kak_client $post_action" | kak -p $kak_session
                        fi ;;
                esac
                kakoune_command() {
                    printf "%s\n" "evaluate-commands -client $kak_client $wincmd %{$kakoune_cmd %{$1}}"
                    [ -n "$post_action" ] && printf "%s\n" "evaluate-commands -client $kak_client $post_action"
                }
                while read item; do
                    kakoune_command "$item" | kak -p $kak_session
                done
            ) < $result
        fi
        rm $fzf_tmp
    ) > /dev/null 2>&1 < /dev/null &
}}
