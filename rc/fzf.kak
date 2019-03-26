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

define-command -docstring \
"fzf <switches>: generic fzf command. This command can be used to create new fzf wrappers for various Kakoune or external features.

Switches:
    -kak-cmd <command>: A Kakoune cmd that is applied to fzf resulting value.
    -items-cmd <items command>: A command that is used to provide list of values to fzf.
    -fzf-args <args>: Additional flags for fzf program
    -post-action <commands>: Extra commands that are preformed after `-kak-cmd' command.
    -preview: should fzf window include preview" \
fzf -shell-script-candidates %{echo "-kak-cmd\n-items-cmd\n-fzf-args\n-post-action\n"} -params .. %{ evaluate-commands %sh{
    while [ $# -gt 0 ]; do
        case $1 in
            -kak-cmd)     shift; kakoune_cmd="$1" ;;
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
            [ -z "${kakoune_cmd##edit*}" ] && tmux_height="$kak_opt_fzf_file_preview_tmux_height"
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
        [ -z "$tmux_height" ] && tmux_height=$kak_opt_fzf_tmux_height
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
