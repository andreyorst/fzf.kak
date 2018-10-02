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

try %{ declare-user-mode fzf } catch %{fail "Can't declare mode 'fzf' - already exists"}

# Options
declare-option -docstring "command to provide list of files to fzf. Arguments are supported
Supported tools:
    <package>:           <value>:
    GNU Find:            ""find""
    The Silver Searcher: ""ag""
    ripgrep:             ""rg""
    fd:                  ""fd""

Default arguments:
    find: ""find -type f""
    ag:   ""ag -l -f --hidden --one-device .""
    rg:   ""rg -L --hidden --files""
    fd:   ""fd --type f --follow""
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

# default mappings
map global fzf -docstring "open buffer"           b '<esc>: fzf-buffer<ret>'
map global fzf -docstring "change directory"      c '<esc>: fzf-cd<ret>'
map global fzf -docstring "open file"             f '<esc>: fzf-file<ret>'
map global fzf -docstring "edif file in git tree" g '<esc>: fzf-git<ret>'
map global fzf -docstring "search in buffer"      s '<esc>: fzf-buffer-search<ret>'
map global fzf -docstring "find tag"              t '<esc>: fzf-tag<ret>'

# Commands
define-command -docstring "Enter fzf-mode.
fzf-mode contains mnemonic key bindings for every fzf.kak command

Best used with mapping like:
    map global normal '<some key>' ': fzf-mode<ret>'
" \
fzf-mode %{ try %{ evaluate-commands 'enter-user-mode fzf' } }

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
        fd)
            cmd="fd --type f --follow"
            ;;
        find*|ag*|rg*|fd*)
            cmd=$kak_opt_fzf_file_command
            ;;
        *)
            executable=$(echo $kak_opt_fzf_file_command | awk '{print $1}'| tr '(' ' ' | cut -d " " -f 2)
            echo "echo -markup '{Information}''$executable'' is not supported by the script. fzf.kak may not work as you expect.'"
            cmd=$kak_opt_fzf_file_command
            ;;
        esac
        title="fzf file"
        [ ! -z "${kak_client_env_TMUX}" ] && additional_keybindings="
<c-s>: open file in horizontal split
<c-v>: open file in vertical split"
        message="Open single or multiple files.
<ret>: open file in new buffer.
<c-w>: open file in new window $additional_keybindings"
        echo "info -title '$title' '$message'"
        [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
        eval echo 'fzf \"edit \$1\" \"$cmd\" \"-m --expect ctrl-w $additional_flags\"'
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
        title="fzf git"
        [ ! -z "${kak_client_env_TMUX}" ] && additional_keybindings="
<c-s>: open file in horizontal split
<c-v>: open file in vertical split"
        message="Open single or multiple files from git tree.
<ret>: open file in new buffer.
<c-w>: open file in new window $additional_keybindings"
        echo "info -title '$title' '$message'"
        [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
        eval echo 'fzf \"edit \$1\" \"$cmd\" \"-m --expect ctrl-w $additional_flags\"'
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
        title="fzf tag"
        [ ! -z "${kak_client_env_TMUX}" ] && additional_keybindings="
<c-s>: open tag in horizontal split
<c-v>: open tag in vertical split"
        message="Jump to a symbol''s definition.<ret>: open tag in new buffer.
<c-w>: open tag in new window $additional_keybindings"
        echo "info -title '$title' '$message'"
        [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
        eval echo 'fzf \"ctags-search \$1\" \"$cmd\" \"--expect ctrl-w $additional_flags\"'
    }
}

define-command -hidden fzf-cd %{
    evaluate-commands %sh{
        title="fzf change directory"
        message="Change the server''s working directory"
        echo "info -title '$title' '$message'"
    }
    fzf "change-directory $1" "(echo .. && find \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type d -print)"
}

define-command -hidden fzf-buffer-search %{
    evaluate-commands %sh{
        title="fzf buffer search"
        message="Search buffer with fzf, and jump to result location"
        echo "info -title '$title' '$message'"
        line=$kak_cursor_line
        char=$(expr $kak_cursor_char_column - 1)
        buffer_content=$(mktemp ${TMPDIR:-/tmp}/kak-curr-buff.XXXXXX)
        echo "execute-keys %{%<a-|>cat<space>><space>$buffer_content<ret>;}"
        echo "execute-keys $line g $char l"
        echo "fzf \"execute-keys \$1 gx\" \"(nl -b a -n ln $buffer_content\" \"--reverse | cut -f 1)\""
        (echo "fzf \"execute-keys \$1 gx\" \"(nl -b a -n ln $buffer_content\" \"--reverse | cut -f 1)\"") 1>&2
        # sleep 2 is needed to because everything is done asynchronously, so file should not be deleted until it was read by fzf
        echo "nop %sh{sleep 2; rm $buffer_content}"
    }
}

define-command -hidden fzf -params 2..3 %{ evaluate-commands %sh{
    callback=$1
    items_command=$2
    additional_flags=$3

    # 'tr' - if '(cmd1 && cmd2) | fzf' was passed 'awk' will return '(cmd1'
    items_executable=$(echo $items_command | awk '{print $1}' | tr '(' ' ' | cut -d " " -f 2)
    if [ -z $(command -v $items_executable) ]; then
        echo "fail \'$items_executable' executable not found"
        exit
    fi

    tmp=$(mktemp $(eval echo ${TMPDIR:-/tmp}/kak-fzf.XXXXXX))
    exec=$(mktemp $(eval echo ${TMPDIR:-/tmp}/kak-exec.XXXXXX))

    if [ ! -z "${kak_client_env_TMUX}" ]; then
        cmd="$items_command | fzf-tmux -d 15 --color=16 --expect ctrl-q $additional_flags > $tmp"
    elif [ ! -z "${kak_opt_termcmd}" ]; then
        path=$(pwd)
        cmd="$kak_opt_termcmd \"sh -c 'cd $path && $items_command | fzf --color=16 --expect ctrl-q $additional_flags > $tmp'\""
    else
        echo "fail termcmd option is not set"
        exit
    fi

    (
        eval "$cmd"
        if [ -s $tmp ]; then
            (
                read action
                if [ "${callback% *}" != "change-directory" ]; then
                    case $action in
                        "ctrl-w")
                            wincmd="x11-new "
                            [ ! -z "${kak_client_env_TMUX}" ] && wincmd="tmux-new-window " ;;
                        "ctrl-s")
                            wincmd="tmux-new-vertical " ;;
                        "ctrl-v")
                            wincmd="tmux-new-horizontal " ;;
                        *)
                            wincmd= ;;
                    esac
                    callback="$wincmd$callback"
                    echo "echo evaluate-commands -client $kak_client \"$callback\" | kak -p $kak_session" > $exec
                else
                    echo "echo evaluate-commands -client $kak_client \"$callback\" | kak -p $kak_session" > $exec
                    echo "echo evaluate-commands -client $kak_client \"fzf-cd\"    | kak -p $kak_session" >> $exec
                fi
                chmod 755 $exec
                while read file; do
                    $exec "\'$file'"
                done
            ) < $tmp
        fi
        rm $tmp
        rm $exec
    ) > /dev/null 2>&1 < /dev/null &
}}

define-command -hidden fzf-buffer %{ evaluate-commands %sh{
    tmp=$(mktemp $(eval echo ${TMPDIR:-/tmp}/kak-fzf.XXXXXX))
    setbuf=$(mktemp $(eval echo ${TMPDIR:-/tmp}/kak-setbuf.XXXXXX))
    delbuf=$(mktemp $(eval echo ${TMPDIR:-/tmp}/kak-delbuf.XXXXXX))
    buffers=$(mktemp $(eval echo ${TMPDIR:-/tmp}/kak-buffers.XXXXXX))
    IFS="'"
    for buffer in $kak_buflist; do
        [ ! -z $buffer ] && [ $buffer != ' ' ] && echo $buffer >> $buffers
    done
    if [ ! -z "${kak_client_env_TMUX}" ]; then
        cmd="cat $buffers | fzf-tmux -d 15 --color=16 --expect ctrl-d > $tmp"
    elif [ ! -z "${kak_opt_termcmd}" ]; then
        cmd="$kak_opt_termcmd \"sh -c 'cat $buffers | fzf --color=16 --expect ctrl-d > $tmp'\""
    else
        echo "fail termcmd option is not set"
    fi

    echo "info -title 'fzf buffer' 'Set buffer to edit in current client
<c-d>: delete selected buffer'"

    echo "echo evaluate-commands -client $kak_client \"buffer        \'\$1'\" | kak -p $kak_session" > $setbuf
    echo "echo evaluate-commands -client $kak_client \"delete-buffer \'\$1'\" | kak -p $kak_session" > $delbuf
    echo "echo evaluate-commands -client $kak_client \"fzf-buffer       \" | kak -p $kak_session" >> $delbuf
    chmod 755 $setbuf
    chmod 755 $delbuf
    (
        eval "$cmd"
        if [ -s $tmp ]; then
            (
                read action
                read buf
                if [ "$action" = "ctrl-d" ]; then
                    $setbuf $kak_bufname
                    $delbuf $buf
                else
                    $setbuf $buf
                fi
            ) < $tmp
        else
            $setbuf $kak_bufname
        fi
        rm $tmp
        rm $setbuf
        rm $delbuf
        rm $buffers
    ) > /dev/null 2>&1 < /dev/null &
}}

