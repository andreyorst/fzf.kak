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

try %{ declare-user-mode fzf }

# Options
declare-option -docstring "command to provide list of files to fzf. Arguments are supported
Supported tools:
    <package>:           <value>:
    GNU Find:            ""find""
    The Silver Searcher: ""ag""
    ripgrep:             ""rg""

Default arguments:
    find: ""find -type f""
    ag:   ""ag -l -f --hidden --one-device .""
    rg:   ""rg -L --hidden --files""
" \
str fzf_file_command "find"

declare-option -docstring "command to provide list of files in git tree to fzf. Arguments are supported
Supported tools:
    <package>:                  <value>:
    Git --fast-version-control: ""git""

Default arguments:
    ""git ls-tree --name-only -r HEAD""
" \
str fzf_git_command "git"

declare-option -docstring "command to provide list of ctags to fzf. Arguments are supported
Supported tools:
    <package>:       <value>:
    universal-ctags: ""readtags""

Default arguments:
        ""readtags -l | cut -f1 | sort -u""
" \
str fzf_tag_command "readtags"

declare-option -docstring "path to tmp folder
Default value: ""/tmp/""
" \
str fzf_tmp "/tmp/"

# default mappings
map global fzf -docstring "open buffer"           b '<esc>: fzf-buffer<ret>'
map global fzf -docstring "change directory"      c '<esc>: fzf-cd<ret>'
map global fzf -docstring "open file"             f '<esc>: fzf-file<ret>'
map global fzf -docstring "edif file in git tree" g '<esc>: fzf-git<ret>'
map global fzf -docstring "find tag"              t '<esc>: fzf-tag<ret>'

# Commands
define-command -docstring "Enter fzf-mode.
fzf-mode contains mnemonic key bindings for every fzf.kak command

Best used with mapping like:
    map global normal '<some key>' ': fzf-mode<ret>'
" \
fzf-mode %{ evaluate-commands 'enter-user-mode fzf' }

define-command -hidden fzf-file %{
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
            echo "echo -markup '{Information}$kak_opt_fzf_file_command is not supported by the script. fzf.kak may not work as you expect."
            cmd=$kak_opt_fzf_file_command
            ;;
        esac
        eval echo 'fzf \"edit \$1\" \"$cmd\"'
    }
}

define-command -hidden fzf-git %{
    evaluate-commands %sh{
        case $kak_opt_fzf_git_command in
        git)
            cmd="git ls-tree --name-only -r HEAD"
            ;;
        git*)
            cmd=$kak_opt_fzf_git_command
            ;;
        *)
            echo "echo -markup '{Information}$kak_opt_fzf_git_command vcs is not supported by the script. fzf.kak may not work as you expect."
            cmd=$kak_opt_fzf_git_command
            ;;
        esac
        eval echo 'fzf \"edit \$1\" \"$cmd\"'
    }
}

define-command -hidden fzf-tag %{
    evaluate-commands %sh{
        case $kak_opt_fzf_tag_command in
        readtags)
            cmd="readtags -l | cut -f1 | sort -u"
            ;;
        readtags*)
            cmd=$kak_opt_fzf_tag_command
            ;;
        *)
            echo "echo -markup '{Information}$kak_opt_fzf_tag_command is not supported by the script. fzf.kak may not work as you expect."
            cmd=$kak_opt_fzf_tag_command
            ;;
        esac
        eval echo 'fzf \"ctags-search \$1\" \"$cmd\"'
    }
}
define-command -hidden fzf-cd %{
    fzf "cd $1" "(echo .. && find \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type d -print)"
}

define-command -hidden fzf -params 2 %{ evaluate-commands %sh{
    callback=$1
    items_command=$2

    # 'tr' - if '(cmd1 && cmd2) | fzf' was passed 'awk' will return '(cmd1'
    items_executable=$(echo $items_command | awk '{print $1}' | tr '(' ' ')
    if [ -z $(command -v $items_executable) ]; then
        echo "fail \'$items_executable' executable not found"
        exit
    fi

    tmp=$(mktemp $(eval echo $kak_opt_fzf_tmp/kak-fzf.XXXXXX))
    exec=$(mktemp $(eval echo $kak_opt_fzf_tmp/kak-exec.XXXXXX))

    if [ ! -z "${kak_client_env_TMUX}" ]; then
        cmd="$items_command | fzf-tmux -d 15 --color=16 -m --expect ctrl-w --expect ctrl-v --expect ctrl-s > $tmp"
        [ "${callback% *}" != "cd" ] && echo "echo -markup '{Information}<c-w>: new window, <c-v>: vertical split, <c-s>: horizontal split'"
    elif [ ! -z "${kak_opt_termcmd}" ]; then
        path=$(pwd)
        cmd="$kak_opt_termcmd \"sh -c 'cd $path && $items_command | fzf --color=16 -m --expect ctrl-w > $tmp'\""
        [ "${callback% *}" != "cd" ] && echo "echo -markup '{Information}<c-w>: new window'"
    else
        echo "fail termcmd option is not set"
    fi

    (
        eval "$cmd"
        if [ -s $tmp ]; then
            (
                read action
                if [ "${callback% *}" != "cd" ]; then
                    case $action in
                        "ctrl-w")
                            wincmd="x11-new"
                            [ ! -z "${kak_client_env_TMUX}" ] && wincmd="tmux-new-window" ;;
                        "ctrl-s")
                            wincmd="tmux-new-vertical" ;;
                        "ctrl-v")
                            wincmd="tmux-new-horizontal" ;;
                        *)
                            wincmd= ;;
                    esac
                    callback="$wincmd $callback"
                fi
                echo "echo eval -client $kak_client \"$callback\" | kak -p $kak_session" > $exec
                chmod 755 $exec
                while read file; do
                    $exec $file
                done
            ) < $tmp
        fi
        rm $tmp
        rm $exec
    ) > /dev/null 2>&1 < /dev/null &
}}

define-command -hidden fzf-buffer %{ evaluate-commands %sh{
    tmp=$(mktemp $(eval echo $kak_opt_fzf_tmp/kak-fzf.XXXXXX))
    setbuf=$(mktemp $(eval echo $kak_opt_fzf_tmp/kak-setbuf.XXXXXX))
    delbuf=$(mktemp $(eval echo $kak_opt_fzf_tmp/kak-delbuf.XXXXXX))
    buffers=$(mktemp $(eval echo $kak_opt_fzf_tmp/kak-buffers.XXXXXX))
    items_command="echo $kak_buflist | tr ' ' '\n' | sort"

    if [ ! -z "${kak_client_env_TMUX}" ]; then
        cmd="$items_command | fzf-tmux -d 15 --color=16 --expect ctrl-d > $tmp"
    elif [ ! -z "${kak_opt_termcmd}" ]; then
        path=$(pwd)
        eval "echo $kak_buflist | tr ' ' '\n' | sort > $buffers"
        cmd="$kak_opt_termcmd \"sh -c 'cat $buffers | fzf --color=16 --expect ctrl-d > $tmp'\""
    else
        echo "fail termcmd option is not set"
    fi

    echo "echo -markup '{Information}<c-d>: delete selected buffer'"

    echo "echo eval -client $kak_client \"buffer        \$1\" | kak -p $kak_session" > $setbuf
    echo "echo eval -client $kak_client \"delete-buffer \$1\" | kak -p $kak_session" > $delbuf
    echo "echo eval -client $kak_client \"fzf-buffer       \" | kak -p $kak_session" >> $delbuf
    chmod 755 $setbuf
    chmod 755 $delbuf
    (
        eval "$cmd"
        if [ -s $tmp ]; then
            ( read action
              read buf
              if [ "$action" = "ctrl-d" ]; then
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
        rm $buffers
    ) > /dev/null 2>&1 < /dev/null &
}}

