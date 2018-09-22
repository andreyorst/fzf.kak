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

declare-option -docstring "command to provide list of files to fzf.
Possible values:
      find - GNU Find
      ag - The Silver Searcher
      rg - ripgrep
" \
str fzf_file_command "find"

declare-user-mode fzf

define-command -docstring \
"fzf-mode: Enter fzf-mode
This is to be used in mappings to enter fzf-mode
For example: map global normal <c-p> ':fzf-mode<ret>'
" \
fzf-mode %{ evaluate-commands 'enter-user-mode fzf' }

map global fzf -docstring "open file"             f '<esc>:fzf-file<ret>'
map global fzf -docstring "open buffer"           b '<esc>:fzf-buffer<ret>'
map global fzf -docstring "find tag"              t '<esc>:fzf-tag<ret>'
map global fzf -docstring "change directory"      c '<esc>:fzf-tag<ret>'
map global fzf -docstring "edif file in git tree" g '<esc>:fzf-git<ret>'

define-command -hidden -docstring \
"fzf-file: Run fzf to open file
Configurable options:
    fzf_file_command: command to run with fzf to list possible files. 
"\
fzf-file -params 0..1 %{
    evaluate-commands %sh{
        if [ -z $(command -v $kak_opt_fzf_file_command) ]; then
    		printf %s\\n "evaluate-commands -client $kak_client echo -markup '{Information}$kak_opt_fzf_file_command is not installed. Falling back to find'" | kak -p ${kak_session}
            kak_opt_fzf_file_command="find"
        fi
        case $kak_opt_fzf_file_command in
        find)
            cmd="find -L %arg{1} -name .git -prune -o -name .svn -prune -o -regex '.*\b\(bower_components\|output\|.mozilla\|firefox\|node_modules\|grunt\|cache\|Cache\|config/\(Slack\|chromium\|goole-chrome\)\)\(/|$\).*' -prune -o \( -type f -o -type l \) -a -not -path %arg{1} -a -not -name '.' -print | sed 's@^\./@@'"
            ;;
        ag)
            cmd="ag -l -f -p ~/.binignore -p ~/.ignore --hidden --one-device . %arg{1}"
            ;;
        rg)
            cmd="rg --ignore-file ~/.binignore -L --hidden --files %arg{1}"
            ;;
        *)
            echo fail "fzf wrong file command: \'$kak_opt_fzf_file_command'"
            exit
            ;;
        esac
        eval echo 'fzf \"edit \$1\" \"$cmd\"'
    }
}

define-command -hidden fzf-git -params 0..1 %{
    fzf "edit $1" "git ls-tree --name-only -r HEAD %arg{1}"
}

define-command -hidden fzf-tag -params 0..1 %{
    fzf "ctags-search $1" "readtags -l | cut -f1 | sort -u"
}

define-command -hidden fzf-cd -params 0..1 %{
    fzf "cd $1" "find %arg{1} -type d -path *.git -prune -o -type d -print"
}

define-command -hidden fzf -params 2.. %{ exec %sh{
    tmp=$(mktemp /tmp/kak-fzf.XXXXXX)
    exec=$(mktemp /tmp/kak-exec.XXXXXX)
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

define-command -hidden fzf-buffer %{ evaluate-commands %sh{
    tmp=$(mktemp /tmp/kak-fzf.XXXXXX)
    setbuf=$(mktemp /tmp/kak-setbuf.XXXXXX)
    delbuf=$(mktemp /tmp/kak-delbuf.XXXXXX)
    echo "echo eval -client $kak_client \"buffer        \$1\" | kak -p $kak_session" > $setbuf
    echo "echo eval -client $kak_client \"delete-buffer \$1\" | kak -p $kak_session" > $delbuf
    echo "echo eval -client $kak_client \"fzf-buffer       \" | kak -p $kak_session" >> $delbuf
    chmod 755 $setbuf
    chmod 755 $delbuf
    (
        # todo: expect ctrl-[vw] to make execute in new windows instead
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

