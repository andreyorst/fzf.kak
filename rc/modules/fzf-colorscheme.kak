# Interactively change (and preview) colorschemes.

hook global ModuleLoaded fzf %{
    map global fzf -docstring "change colorscheme" 'C' '<esc>: require-module fzf-colorscheme; fzf-colorscheme<ret>'
}

provide-module fzf-colorscheme %§

declare-option -docstring 'Apply the highlighted colorscheme to the current client while browsing the list.
Requires fzf 0.38 or higher.
Default value:
    true
' \
bool fzf_colorscheme_live_preview true

declare-option -hidden -docstring 'last colorscheme applied with fzf-colorscheme.
Used to restore the colorscheme when the picker is aborted.' \
str fzf_colorscheme_current

define-command -hidden fzf-colorscheme-apply -params 1 %{
    colorscheme %arg{1}
    set-option global fzf_colorscheme_current %arg{1}
}

define-command -hidden fzf-colorscheme %{ evaluate-commands %sh{
    items_command="find -L \"${kak_config}/colors\" \"${kak_runtime}/colors\" -type f -name '*.kak' 2>/dev/null | sed 's|.*/||;s|\.kak\$||' | sort -u"

    message="Change the colorscheme of the current session.
<ret>: apply selected colorscheme."
    printf "%s\n" "info -title 'fzf colorscheme' '$message'"

    if [ "${kak_opt_fzf_colorscheme_live_preview:-}" = "true" ] && [ "${kak_opt_fzf_implementation:-}" = "fzf" ]; then
        additional_flags="--bind 'focus:execute-silent(printf \"%s\\n\" \"evaluate-commands -client $kak_client colorscheme {}\" | kak -p $kak_session)'"
        if [ -n "${kak_opt_fzf_colorscheme_current:-}" ]; then
            # restore the last known colorscheme when the picker is aborted
            additional_flags="$additional_flags --bind 'esc:become(printf \"%s\\n\" \"$kak_opt_fzf_colorscheme_current\")' --bind 'ctrl-c:become(printf \"%s\\n\" \"$kak_opt_fzf_colorscheme_current\")'"
        fi
    fi

    printf "%s\n" "fzf -kak-cmd %{fzf-colorscheme-apply} -items-cmd %{$items_command} -fzf-args %{$additional_flags}"
}}

§
