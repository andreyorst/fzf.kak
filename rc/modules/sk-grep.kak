# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ sk-grep.kak            │
# ╞═════════════╩════════════════════════╡
# │ Module running interactive grep with │
# │ ski for fzf.kak                      │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

declare-option -docstring "what command to use to provide list of grep search matches.
Grep output must follow the format of 'filename:line-number:text'

Default value:
    grep -RHn" \
str fzf_sk_grep_command 'grep -RHn'

try %{ declare-user-mode fzf }

evaluate-commands %sh{
    if [ -n "$(command -v sk)" ]; then
        printf "%s\n" "map global fzf -docstring %{Interactive grep with skim} 'g' '<esc>: fzf-sk-interactive-grep<ret>'"
    fi
}

define-command -hidden fzf-sk-interactive-grep %{ evaluate-commands %sh{
    if [ -z "$(command -v sk)" ]; then
    	printf "%s\n" "echo -markup %{{Information}skim required to run this command}"
    	exit
	fi
    title="skim interactive grep"
    message="Interactively grep pattern from current directory
<ret>: open search result in new buffer.
<c-w>: open search result in new window"
    [ ! -z "${kak_client_env_TMUX}" ] && tmux_keybindings="
<c-s>: open search result in horizontal split
<c-v>: open search result in vertical split"

    printf "%s\n" "info -title '${title}' '${message}${tmux_keybindings}'"
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    impl=$kak_opt_fzf_implementation
    printf "%s\n" "set-option global fzf_implementation %{sk -i -c '$kak_opt_fzf_sk_grep_command {}'}
                   fzf -kak-cmd %{fzf-sk-grep-handler} -items-cmd %{echo >/dev/null 2>&1} -fzf-args %{--expect ctrl-w $additional_flags}
                   set-option global fzf_implementation %{${impl}}"
}}

define-command -hidden fzf-sk-grep-handler -params 1 %{ evaluate-commands %sh{
    printf "%s\n" "$1" | awk '{
             file = $0; sub(/:.*/, "", file); gsub("&", "&&", file);
             line = $0; sub(/[^:]+:/, "", line); sub(/:.*/, "", line)
             print "edit -existing %&" file "&; execute-keys %&" line "gxvc&";
         }'
}}

