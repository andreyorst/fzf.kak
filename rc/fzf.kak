# ╭─────────────╥───────────────────╮
# │ Author:     ║ Plugin:           │
# │ Andrey Orst ║ fzf.kak           │
# ╞═════════════╩═══════════════════╡
# │ This plugin implements fzf      │
# │ mode for Kakoune. This mode     │
# │ adds several mappings to invoke │
# │ different fzf commands.         │
# ╰─────────────────────────────────╯

try %{ declare-user-mode fzf }

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
str fzf_preview_tmux_height '70%'

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

define-command -hidden -docstring "wrapper command to create new vertical split. Should work in both new and old Kakoune" \
fzf-vertical -params .. %{ try %{
    tmux-terminal-vertical kak -c %val{session} -e "%arg{@}"
} catch %{
    tmux-new-vertical "%arg{@}"
}}

define-command -hidden -docstring "wrapper command to create new horizontal split. Should work in both new and old Kakoune" \
fzf-horizontal -params .. %{ try %{
    tmux-terminal-horizontal kak -c %val{session} -e "%arg{@}"
} catch %{
    tmux-new-horizontal "%arg{@}"
}}

define-command -hidden -docstring "wrapper command to create new window. Should work in both new and old Kakoune" \
fzf-window -params .. %{ try %sh{
    if [ -n "$kak_client_env_TMUX" ]; then
        printf "%s\n" 'tmux-terminal-window kak -c %val{session} -e "%arg{@}"'
    else
        printf "%s\n" 'terminal kak -c %val{session} -e "%arg{@}"'
    fi
} catch %sh{
    if [ -n "$kak_client_env_TMUX" ]; then
        printf "%s\n" 'tmux-new-window "%arg{@}"'
    else
        printf "%s\n" 'new "%arg{@}"'
    fi
}}

define-command -docstring \
"fzf <switches>: generic fzf command. This command can be used to create new fzf wrappers for various Kakoune or external features.

Switches:
    -kak-cmd <command>: A Kakoune cmd that is applied to fzf resulting value.
    -items-cmd <items command>: A command that is used as a pipe to provide list of values to fzf.
    -fzf-impl <implementation>: Owerride fzf implementation variable.
    -fzf-args <args>: Additional flags for fzf program.
    -preview-cmd: A preview command.
    -preview: Should fzf window include preview.
    -filter <commands>: A pipe which will be applied to result provided by fzf.
    -post-action <commands>: Extra commands that are preformed after `-kak-cmd' command." \
-shell-script-completion %{
    printf "%s\n" "-kak-cmd
-items-cmd
-fzf-impl
-fzf-args
-preview-cmd
-preview
-filter
-post-action"
} \
fzf -params .. %{ evaluate-commands %sh{
    fzf_impl="${kak_opt_fzf_implementation}"

    while [ $# -gt 0 ]; do
        case $1 in
            -kak-cmd)     shift; kakoune_cmd="$1" ;;
            -items-cmd)   shift; items_cmd="$1 |" ;;
            -fzf-impl)    shift; fzf_impl="$1"    ;;
            -fzf-args)    shift; fzf_args="$1"    ;;
            -preview-cmd) shift; preview_cmd="$1" ;;
            -preview)            preview="true"   ;;
            -filter)      shift; filter="| $1"    ;;
            -post-action) shift; post_action="$1" ;;
        esac; shift
    done

    if [ "${preview}" = "true" ]; then
        # bake position option to define them at runtime
        if [ -n "${kak_client_env_TMUX}" ]; then
            preview_position="pos=right:${kak_opt_fzf_preview_width};"
            # tmux height should be changed when preview is on
            tmux_height="${kak_opt_fzf_preview_tmux_height}"
        else
            # this code chooses previewposition depending on window width at runtime
            preview_position="sleep 0.1; [ \$(tput cols) -gt \$(expr \$(tput lines) \* 2) ] && pos=right:${kak_opt_fzf_preview_width} || pos=top:${kak_opt_fzf_preview_height};"
        fi
        # handle preview if not defined explicitly with `-preview-cmd'
        if [ ${kak_opt_fzf_preview} = "true" ] && [ -z "${preview_cmd}" ]; then
            case ${kak_opt_fzf_highlight_cmd} in
                bat)       highlight_cmd="bat --color=always --style=plain {}" ;;
                coderay)   highlight_cmd="coderay {}" ;;
                highlight) highlight_cmd="highlight --failsafe -O ansi {}" ;;
                rouge)     highlight_cmd="rougify {}" ;;
                *)         highlight_cmd="${kak_opt_fzf_highlight_cmd}" ;;
            esac
            preview_cmd="--preview '(${highlight_cmd} || cat {}) 2>/dev/null | head -n ${kak_opt_fzf_preview_lines}' --preview-window=\${pos}"
        fi
    fi

    fzf_tmp=$(mktemp -d ${TMPDIR:-/tmp}/fzf.kak.XXXXXX)
    fzfcmd="${fzf_tmp}/fzfcmd"
    result="${fzf_tmp}/result"

    shell_executable="$(command -v sh)"

    # compose entire fzf command with all args into single file which will be executed later
    printf "%s\n" "cd \"${PWD}\" && ${preview_position} ${items_cmd} SHELL=${shell_executable} ${fzf_impl} ${fzf_args} ${preview_cmd} ${filter} > ${result}; rm ${fzfcmd}" > ${fzfcmd}

    chmod 755 ${fzfcmd}

    if [ -n "${kak_client_env_TMUX}" ]; then
        # set default height if not set already
        [ -z "${tmux_height}" ] && tmux_height=${kak_opt_fzf_tmux_height}
        # if height contains `%' then `-p' will be used
        [ -n "${tmux_height%%*%}" ] && measure="-l" || measure="-p"
        # `terminal' doesn't support any kind of width and height parameters, so tmux panes are created by tmux itself
        cmd="nop %sh{ command tmux split-window ${measure} ${tmux_height%%%*} 'sh -c ${fzfcmd}' }"
    else
        cmd="terminal %{${fzfcmd}}"
    fi

    printf "%s\n" "${cmd}"

    (   while [ -e ${fzfcmd} ]; do sleep 0.1 done
        if [ -s ${result} ]; then
            (
                while read line; do
                    case ${line} in
                        ctrl-w) wincmd="fzf-window" ;;
                        ctrl-s) wincmd="fzf-vertical" ;;
                        ctrl-v) wincmd="fzf-horizontal" ;;
                        *)      item=${line} ;;
                    esac
                    if [ -n "${item}" ]; then
                        printf "%s\n" "evaluate-commands -client ${kak_client} ${wincmd} %{${kakoune_cmd} %{${item}}}"
                    fi
                done
                if [ -n "${post_action}" ]; then
                    printf "%s\n" "evaluate-commands -client ${kak_client} %{${post_action}}"
                fi
            ) < ${result} | kak -p ${kak_session}
        fi
        rm -rf ${fzf_tmp}
    ) > /dev/null 2>&1 < /dev/null &
}}

