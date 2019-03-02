# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ sk-grep.kak            │
# ╞═════════════╩════════════════════════╡
# │ Module running interactive grep with │
# │ ski for fzf.kak                      │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak        │
# ╰──────────────────────────────────────╯

declare-option str fzf_sk_grep_command 'grep -r'

evaluate-commands %sh{
    if [ -n "$(command -v sk)" ]; then
        printf "%s\n" "map global fzf -docstring %{Interactive grep with skim} 'g' '<esc>: sk-interactive-grep<ret>'"
    fi
}

define-command -hidden sk-interactive-grep %{ evaluate-commands %sh{
    if [ -z "$(command -v sk)" ]; then
    	printf "%s\n" "echo -markup %{{Information}skim required to run this command}"
    	exit
	fi
    title="skim interactive grep"
    message="Interactively grep pattern from current directory"
    printf "%s\n" "info -title '$title' '$message'"
    impl=$kak_opt_fzf_implementation
    printf "%s\n" "set-option global fzf_implementation sk
                   fzf %{fzf-sk-grep-handler} %{echo >/dev/null 2>&1} %{-i -c '$kak_opt_fzf_sk_grep_command {}'}
                   set-option global fzf_implementation $impl"
}}

define-command fzf-sk-grep-handler -params 1 %{ evaluate-commands %sh{
    file="${1%%:*}"
    pattern="${1##:*}"
    printf "%s\n" "edit -existing %{$file}; execute-keys /\Q$pattern"
}}

