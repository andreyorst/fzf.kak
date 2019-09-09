# ╭─────────────╥─────────────────────────╮
# │ Author:     ║ File:                   │
# │ Andrey Orst ║ fzf-svn.kak             │
# ╞═════════════╩═════════════════════════╡
# │ Submodule for Bzr support for fzf.kak │
# ╞═══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak         │
# ╰───────────────────────────────────────╯

hook global ModuleLoaded fzf_vcs %§

declare-option -docstring "command to provide list of files in GNU Bazaar repository to fzf. Arguments are supported
Supported tools:
    <package>:  <value>:
    GNU Bazaar: ""bzr""

Default arguments:
    '(cd $repo_root && bzr ls -R --versioned | awk \""{printf \\\""$repo_root/\\\"" \\\$0 \\\""\\\n\\\"" }\"")'
" \
str fzf_bzr_command "bzr"

map global fzf-vcs -docstring "edit file from GNU Bazaar tree" 'b' '<esc>: fzf-bzr<ret>'

define-command -hidden fzf-bzr %{ evaluate-commands %sh{
    repo_root=$(bzr root)
    case $kak_opt_fzf_bzr_command in
        (bzr)  cmd="(cd $repo_root && bzr ls -R --versioned | awk \"{printf \\\"$repo_root/\\\" \\\$0 \\\"\\\n\\\" }\")" ;;
        (bzr*) cmd=$kak_opt_fzf_bzr_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect $kak_opt_fzf_vertical_map --expect $kak_opt_fzf_horizontal_map"
    printf "%s\n" "fzf -kak-cmd %{edit -existing} -items-cmd %{$cmd} -fzf-args %{-m --expect $kak_opt_fzf_window_map $additional_flags}"
}}

§
