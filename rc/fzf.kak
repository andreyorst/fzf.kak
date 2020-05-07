# ╭─────────────╥───────────────────╮
# │ Author:     ║ Plugin:           │
# │ Andrey Orst ║ fzf.kak           │
# ╞═════════════╩═══════════════════╡
# │ This plugin implements fzf      │
# │ mode for Kakoune. This mode     │
# │ adds several mappings to invoke │
# │ different fzf commands.         │
# ╰─────────────────────────────────╯

define-command -docstring "Enter fzf-mode.
fzf-mode contains mnemonic key bindings for every fzf.kak command

Best used with mapping like:
    map global normal '<some key>' ': fzf-mode<ret>'
" \
fzf-mode %{ require-module fzf; evaluate-commands 'enter-user-mode fzf' }

provide-module fzf %§

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

declare-option -docstring 'preview window position.
Supported values: up (top),  down (bottom), left, right, auto

Default value: auto' \
str fzf_preview_pos "auto"

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
str fzf_highlight_command "highlight"

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

declare-option -docstring "mapping to execute action in new window" \
str fzf_window_map 'ctrl-w'

declare-option -docstring "mapping to execute action in new vertical split" \
str fzf_vertical_map 'ctrl-v'

declare-option -docstring "mapping to execute action in new horizontal split" \
str fzf_horizontal_map 'ctrl-s'

declare-option -docstring 'command to use to create new window when not using tmux.

Default value: terminal kak -c %val{session} -e "%arg{@}"' \
str fzf_terminal_command 'terminal kak -c %val{session} -e "%arg{@}"'

declare-option -docstring "use main selection as default query for fzf if the selection is longer than 1 char." \
bool fzf_use_main_selection true

declare-option -docstring "Default options for fzf." \
str fzf_default_opts ''

try %{ declare-user-mode fzf }

define-command -hidden -docstring "wrapper command to create new vertical split" \
fzf-vertical -params .. %{ evaluate-commands %{
    tmux-terminal-vertical kak -c %val{session} -e "%arg{@}"
}}

define-command -hidden -docstring "wrapper command to create new horizontal split" \
fzf-horizontal -params .. %{ evaluate-commands %{
    tmux-terminal-horizontal kak -c %val{session} -e "%arg{@}"
}}

define-command -hidden -docstring "wrapper command to create new terminal" \
fzf-window -params .. %{ evaluate-commands %sh{
    if [ -n "$kak_client_env_TMUX" ]; then
        printf "%s\n" 'tmux-terminal-window kak -c %val{session} -e "%arg{@}"'
    else
        printf "%s\n" "$kak_opt_fzf_terminal_command"
    fi
}}

define-command -docstring \
"fzf <switches>: generic fzf command. This command can be used to create new fzf wrappers for various Kakoune or external features.

Switches:
    -kak-cmd <command>: A Kakoune cmd that is applied to fzf resulting value
    -multiple-cmd <command>: A Kakoune cmd that is applied all multiple selected files but the first one
    -items-cmd <items command>: A command that is used as a pipe to provide list of values to fzf
    -fzf-impl <implementation>: Owerride fzf implementation variable
    -fzf-args <args>: Additional flags for fzf program
    -preview-cmd <command>: A preview command
    -preview: Should fzf window include preview
    -filter <commands>: A pipe which will be applied to result provided by fzf
    -post-action <commands>: Extra commands that are preformed after `-kak-cmd' command" \
-shell-script-completion %{
    printf "%s\n" "-kak-cmd
-multiple-cmd
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

    [ "${kak_opt_fzf_use_main_selection}" = "true" ] && \
    [ $(printf "%s" "${kak_selection}" | wc -m) -gt 1 ] && \
    default_query="-i -q ${kak_selection}"

    while [ $# -gt 0 ]; do
        case $1 in
            (-kak-cmd)      shift; kakoune_cmd="$1"  ;;
            (-multiple-cmd) shift; multiple_cmd="$1" ;;
            (-items-cmd)    shift; items_cmd="$1 |"  ;;
            (-fzf-impl)     shift; fzf_impl="$1"     ;;
            (-fzf-args)     shift; fzf_args="$1"     ;;
            (-preview-cmd)  shift; preview_cmd="$1"  ;;
            (-preview)             preview="true"    ;;
            (-filter)       shift; filter="| $1"     ;;
            (-post-action)  shift; post_action="$1"  ;;
        esac
        shift
    done

    [ -z "$multiple_cmd" ] && multiple_cmd="$kakoune_cmd"

    if [ "${preview}" = "true" ]; then
        # bake position option to define them at runtime
        [ -n "${kak_client_env_TMUX}" ] && tmux_height="${kak_opt_fzf_preview_tmux_height}"
        case ${kak_opt_fzf_preview_pos} in
            (top|up)      preview_position="pos=top:${kak_opt_fzf_preview_height};" ;;
            (bottom|down) preview_position="pos=down:${kak_opt_fzf_preview_height};" ;;
            (right)       preview_position="pos=right:${kak_opt_fzf_preview_width};" ;;
            (left)        preview_position="pos=left:${kak_opt_fzf_preview_width};" ;;
            (auto|*)      preview_position="sleep 0.1; [ \$(tput cols) -gt \$(expr \$(tput lines) \* 2) ] && pos=right:${kak_opt_fzf_preview_width} || pos=top:${kak_opt_fzf_preview_height};"
        esac

        # handle preview if not defined explicitly with `-preview-cmd'
        if [ ${kak_opt_fzf_preview} = "true" ] && [ -z "${preview_cmd}" ]; then
            case ${kak_opt_fzf_highlight_command} in
                (bat)       highlight_cmd="bat --color=always --style=plain {}" ;;
                (coderay)   highlight_cmd="coderay {}" ;;
                (highlight) highlight_cmd="highlight --failsafe -O ansi {}" ;;
                (rouge)     highlight_cmd="rougify {}" ;;
                (*)         highlight_cmd="${kak_opt_fzf_highlight_command}" ;;
            esac
            preview_cmd="--preview '(${highlight_cmd} || cat {}) 2>/dev/null | head -n ${kak_opt_fzf_preview_lines}' --preview-window=\${pos}"
        fi
    fi

    fzf_tmp=$(mktemp -d ${TMPDIR:-/tmp}/fzf.kak.XXXXXX)
    fzfcmd="${fzf_tmp}/fzfcmd"
    result="${fzf_tmp}/result"

    (
        shell_path="$(command -v sh)"
        if [ -n "${shell_path}" ]; then
            # portable shebang
            printf "%s\n" "#!${shell_path}"
            # set SHELL because fzf preview uses it
            printf "%s\n" "SHELL=${shell_path}"
        fi
        # compose entire fzf command with all args into single file which will be executed later
        printf "%s\n" "export FZF_DEFAULT_OPTS=\"$kak_opt_fzf_default_opts\""
        printf "%s\n" "cd \"${PWD}\" && ${preview_position} ${items_cmd} ${fzf_impl} ${default_query} ${fzf_args} ${preview_cmd} ${filter} > ${result}"
        printf "%s\n" "rm ${fzfcmd}"
    ) >> ${fzfcmd}
    chmod 755 ${fzfcmd}

    if [ -n "${kak_client_env_TMUX}" ]; then
        # set default height if not set already
        [ -z "${tmux_height}" ] && tmux_height=${kak_opt_fzf_tmux_height}
        # if height contains `%' then `-p' will be used
        [ -n "${tmux_height%%*%}" ] && measure="-l" || measure="-p"
        # `terminal' doesn't support any kind of width and height parameters, so tmux panes are created by tmux itself
        cmd="nop %sh{ command tmux split-window -t '${kak_client_env_TMUX_PANE}' ${measure} ${tmux_height%%%*} env ${fzfcmd} < /dev/null > /dev/null 2>&1 }"
    else
        cmd="${kak_opt_fzf_terminal_command%% *} %{${fzfcmd}}"
    fi

    printf "%s\n" "${cmd}"

    # main loop
    (   while [ -e ${fzfcmd} ]; do sleep 0.1; done
        if [ -s ${result} ]; then
            (
                while read -r line; do
                    case ${line} in
                        (${kak_opt_fzf_window_map})     wincmd="fzf-window"     ;;
                        (${kak_opt_fzf_vertical_map})   wincmd="fzf-vertical"   ;;
                        (${kak_opt_fzf_horizontal_map}) wincmd="fzf-horizontal" ;;
                        (*)                             item=${line} ;;
                    esac
                    if [ -n "${item}" ]; then
                        item=$(printf "%s\n" "${item}" | sed "s/@/@@/g;s/&/&&/g")
                        kakoune_cmd=$(printf "%s\n" "${kakoune_cmd}" | sed "s/&/&&/g")
                        printf "%s\n" "evaluate-commands -client ${kak_client} ${wincmd} %&${kakoune_cmd} %@${item}@&"
                        break
                    fi
                done
                [ -n "${multiple_cmd}" ] && multiple_cmd=$(printf "%s\n" "${multiple_cmd}" | sed "s/&/&&/g")
                while read -r line; do
                    line=$(printf "%s\n" "${line}" | sed "s/@/@@/g;s/&/&&/g")
                    printf "%s\n" "evaluate-commands -client ${kak_client} ${wincmd} %&${multiple_cmd} %@${line}@&"
                done
                if [ -n "${post_action}" ]; then
                    post_action=$(printf "%s\n" "${post_action}" | sed "s/&/&&/g")
                    printf "%s\n" "evaluate-commands -client ${kak_client} %&${post_action}&"
                fi
            ) < ${result} | kak -p ${kak_session}
        fi
        rm -rf ${fzf_tmp}
    ) > /dev/null 2>&1 < /dev/null &
}}

§
