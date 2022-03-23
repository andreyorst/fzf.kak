# Author: Andrey Listopadov
# Module running interactive grep with skim for fzf.kak
# https://github.com/andreyorst/fzf.kak

hook global ModuleLoaded fzf %§
    evaluate-commands %sh{
        if [ -n "$(command -v sk)" ]; then
            printf "%s\n" "echo -debug -- %{skim support is deprecated and will be removed in future release, use fzf-grep instead}"
            printf "%s\n" "map global fzf -docstring %{Interactive grep with skim} '<a-g>' '<esc>: require-module fzf-sk-grep; fzf-sk-grep<ret>'"
        fi
    }
§

provide-module fzf-sk-grep %§

declare-option -docstring "what command to use to provide list of grep search matches.
Grep output must follow the format of 'filename:line-number:text'

Default value:
    grep -RHn" \
str fzf_sk_grep_command 'grep -RHn'

declare-option -hidden str fzf_sk_first_file ''

define-command -hidden fzf-sk-grep %{ evaluate-commands %sh{
    if [ -z "$(command -v sk)" ]; then
    	printf "%s\n" "echo -markup %{{Information}skim required to run this command}"
    	exit
	fi
    title="skim interactive grep"
    message="Interactively grep pattern from current directory
<ret>: open search result in new buffer.
${kak_opt_fzf_window_map:-ctrl-w}: open search result in new terminal"
    [ -n "${kak_client_env_TMUX:-}" ] && tmux_keybindings="
${kak_opt_fzf_horizontal_map:-ctrl-s}: open search result in horizontal split
${kak_opt_fzf_vertical_map:-ctrl-v}: open search result in vertical split"
    printf "%s\n" "echo -markup %{{Information}skim support is deprecated and will be removed in future release, use fzf-grep instead}"
    printf "%s\n" "info -title '${title}' '${message}${tmux_keybindings}'"
    [ -n "${kak_client_env_TMUX}" ] && additional_flags="--expect ${kak_opt_fzf_vertical_map:-ctrl-v} --expect ${kak_opt_fzf_horizontal_map:-ctrl-s}"
    printf "%s\n" "fzf -kak-cmd %{fzf-sk-grep-handler} -fzf-impl %{sk --ansi -m -i -c '${kak_opt_fzf_sk_grep_command:-} {}'} -fzf-args %{--expect ${kak_opt_fzf_window_map:-ctrl-w} $additional_flags} -multiple-cmd %{fzf-sk-populate-grep} -post-action %{buffer %opt{fzf_sk_first_file}}"
}}

define-command -hidden fzf-sk-grep-handler -params 1 %{
    evaluate-commands %sh{
        printf "%s\n" "$1" | awk '{
                 file = $0; sub(/:.*/, "", file); gsub("&", "&&", file);
                 line = $0; sub(/[^:]+:/, "", line); sub(/:.*/, "", line)
                 print "edit -existing %&" file "&; execute-keys %&" line "gxvc&"
                 print "set-option global fzf_sk_first_file %&" file "&"
             }'
    }
    fzf-sk-populate-grep %arg{1}
}

define-command -hidden fzf-sk-populate-grep -params 1 %{
    try %{
        buffer *grep*
    } catch %{
        edit -scratch *grep*
        set-option buffer filetype grep
    }
    evaluate-commands -save-regs '"' -buffer *grep* %{
        set-register dquote %arg{1}
        execute-keys gjPo
    }
}

§
