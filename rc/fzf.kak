# ╭─────────────╥───────────────────╮
# │ Author:     ║ Plugin:           │
# │ Andrey Orst ║ fzf.kak           │
# ╞═════════════╩═══════════════════╡
# │ Initial implementation by:      │
# │ https://github.com/topisani     │
# ╞═════════════════════════════════╡
# │ This plugin implements fzf      │
# │ mode for Kakoune. This mode     │
# │ adds several mappings to invoke │
# │ different fzf commands.         │
# ╰─────────────────────────────────╯

# New mode
evaluate-commands %sh{ modes="_ "$kak_user_modes; [ -z "${modes##*fzf*}" ] || echo declare-user-mode fzf }

# Options
declare-option -docstring "command to provide list of files to fzf.
Supported tools:
      find - GNU Find
      ag - The Silver Searcher
      rg - ripgrep

Arguments are also can be passed along with it.
Default arguments are:
      find -type f
      ag -l -f --hidden --one-device .
      rg -L --hidden --files
" \
str fzf_file_command "find"

declare-option -docstring "path to tmp folder
Default value:
      /tmp/
" \
str fzf_tmp "/tmp/"

# default mappings
map global fzf -docstring "open file"             f '<esc>: fzf-file<ret>'
map global fzf -docstring "open buffer"           b '<esc>: fzf-buffer<ret>'
map global fzf -docstring "find tag"              t '<esc>: fzf-tag<ret>'
map global fzf -docstring "change directory"      c '<esc>: fzf-cd<ret>'
map global fzf -docstring "edif file in git tree" g '<esc>: fzf-git<ret>'

# Commands
define-command -override -docstring \
"fzf-mode: Enter fzf-mode
This is to be used in mappings to enter fzf-mode
For example: map global normal <c-p> ': fzf-mode<ret>'
" \
fzf-mode %{ evaluate-commands 'enter-user-mode fzf' }

define-command -override -hidden -docstring \
"fzf-file: Run fzf to open file
Configurable options:
    fzf_file_command: command to run with fzf to list possible files. 
" \
fzf-file %{
    evaluate-commands %sh{
        if [ -z $(command -v $kak_opt_fzf_file_command) ]; then
            echo "echo -markup '{Information}''$kak_opt_fzf_file_command'' is not installed. Falling back to ''find'''"
            kak_opt_fzf_file_command="find"
        fi
        case $kak_opt_fzf_file_command in
        find)
            cmd="find -type f"
            ;;
        ag)
            cmd="ag -l -f --hidden --one-device . "
            ;;
        rg)
            cmd="rg -L --hidden --files"
            ;;
        find*|ag*|rg*)
            cmd=$kak_opt_fzf_file_command
            ;;
        *)
            echo "echo -markup '{Information}$kak_opt_fzf_file_command is not supported by the script. It may not work as you expect."
            cmd=$kak_opt_fzf_file_command
            ;;
        esac
        eval echo 'fzf \"edit \$1\" \"$cmd\"'
    }
}

define-command -override -hidden fzf-git %{
    fzf "edit $1" "git ls-tree --name-only -r HEAD"
}

define-command -override -hidden fzf-tag %{
    fzf "ctags-search $1" "readtags -l | cut -f1 | sort -u"
}

define-command -override -hidden fzf-cd %{
    fzf "change-directory $1" "find \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type d -print"
}

define-command -override -hidden fzf -params 2 %{ evaluate-commands %sh{
    if [ -z "${kak_client_env_TMUX}" ]; then
        echo 'fail "client was not started under tmux"'
        exit
    fi
    tmp=$(mktemp $(eval echo $kak_opt_fzf_tmp/kak-fzf.XXXXXX))
    exec=$(mktemp $(eval echo $kak_opt_fzf_tmp/kak-exec.XXXXXX))
    callback=$1; shift
    items_command=$1; shift
    if [ -z $(command -v $(echo $items_command | head -n 1)) ]; then
        eval echo fail "\'$(echo $items_command | head -n 1)' executable not found. Is it installed?"
        exit
    fi
    flags='--color=16'
    [ -z "${@##* -multi*}" ] && flags="$flags -m"
    echo "echo eval -client $kak_client \"$callback\" | kak -p $kak_session" > $exec
    chmod 755 $exec
    (
        eval "$items_command | fzf-tmux -d 15 $flags > $tmp"
        (while read file; do
            $exec $file
        done) < $tmp
        rm $tmp
        rm $exec
    ) > /dev/null 2>&1 < /dev/null &
}}

define-command -override -hidden fzf-buffer %{ evaluate-commands %sh{
    if [ -z "${kak_client_env_TMUX}" ]; then
        echo 'fail "client was not started under tmux"'
        exit
    fi
    tmp=$(mktemp $(eval echo $kak_opt_fzf_tmp/kak-fzf.XXXXXX))
    setbuf=$(mktemp $(eval echo $kak_opt_fzf_tmp/kak-setbuf.XXXXXX))
    delbuf=$(mktemp $(eval echo $kak_opt_fzf_tmp/kak-delbuf.XXXXXX))
    echo "echo eval -client $kak_client \"buffer        \$1\" | kak -p $kak_session" > $setbuf
    echo "echo eval -client $kak_client \"delete-buffer \$1\" | kak -p $kak_session" > $delbuf
    echo "echo eval -client $kak_client \"fzf-buffer       \" | kak -p $kak_session" >> $delbuf
    chmod 755 $setbuf
    chmod 755 $delbuf
    (
        eval "echo $kak_buflist | tr ' ' '\n' | sort |
            fzf-tmux -d 15 --color=16 -e --preview='$setbuf {}' --preview-window=up:hidden --expect ctrl-d > $tmp"
        if [ -s $tmp ]; then
            ( read action
              read buf
              if [ "$action" == "ctrl-d" ]; then
                  $setbuf $kak_bufname
                  $delbuf $buf
              else
                  $setbuf $buf
              fi) < $tmp
        else
            $setbuf $kak_bufname
        fi
        rm $tmp
        rm $setbuf
        rm $delbuf
    ) > /dev/null 2>&1 < /dev/null &
}}

