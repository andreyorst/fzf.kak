# ╭─────────────╥───────────────────╮
# │ Author:     ║ Plugin:           │
# │ Andrey Orst ║ fzf.kak           │
# ╞═════════════╩═══════════════════╡
# │ This plugin implements fzf      │
# │ mode for Kakoune. This mode     │
# │ adds several mappings to invoke │
# │ different fzf commands.         │
# ╰─────────────────────────────────╯

try %{ declare-user-mode fzf } catch %{echo -markup "{Error}Can't declare mode 'fzf' - already exists"}
try %{ declare-user-mode fzf-vcs } catch %{echo -markup "{Error}Can't declare mode 'fzf-vcs' - already exists"}
try %{ declare-user-mode fzf-tag } catch %{echo -markup "{Error}Can't declare mode 'fzf-tag' - already exists"}

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
    <package>: <value>:
    Git :      ""git""

Default arguments:
    ""git ls-tree --name-only -r HEAD""
" \
str fzf_git_command "git"

declare-option -docstring "command to provide list of files in svn repository to fzf. Arguments are supported
Supported tools:
    <package>:  <value>:
    Subversion: ""svn""

Default arguments:
    ""svn list -R . | grep -v '$/' | tr '\\n' '\\0'""
" \
str fzf_svn_command "svn"

declare-option -docstring "command to provide list of files in mercurial repository to fzf. Arguments are supported
Supported tools:
    <package>:     <value>:
    Mercurial SCM: ""hg""

Default arguments:
    ""hg locate -f -0 -I .hg locate -f -0 -I .""
" \
str fzf_hg_command "hg"

declare-option -docstring "command to provide list of files in GNU Bazaar repository to fzf. Arguments are supported
Supported tools:
    <package>:  <value>:
    GNU Bazaar: ""bzr""

Default arguments:
    ""bzr ls -R --versioned -0""
" \
str fzf_bzr_command "bzr"

declare-option -docstring "command to provide list of ctags to fzf. Arguments are supported
Supported tools:
    <package>:       <value>:
    universal-ctags: ""readtags""

Default arguments:
    ""readtags -l | cut -f1 ""
" \
str fzf_tag_command "readtags"

declare-option -docstring "allow showing preview window
Default value:
    true
" \
bool fzf_preview true

declare-option -docstring "amount of lines to pass to preview window
Default value: 100" \
int fzf_preview_lines 100

declare-option -docstring "highlighter to use in preview window
Supported tools:
    <package>: <value>:
    Coderay:   ""coderay""
    Highlight: ""highlight""
    Rouge:     ""rouge""

Default arguments:
    coderay:   ""coderay {}""
    highlight: ""highlight --failsafe -O ansi -l {}""
    rouge:     ""rougify {}""
"\
str fzf_highlighter "highlight"

declare-option -docstring "height of fzf tmux split in screen lines or percents
Default value: 25%%" \
str fzf_tmux_height '25%'

# default mappings
map global fzf -docstring "open buffer"                  'b' '<esc>: fzf-buffer<ret>'
map global fzf -docstring "change directory"             'c' '<esc>: fzf-cd<ret>'
map global fzf -docstring "open file"                    'f' '<esc>: fzf-file<ret>'
map global fzf -docstring "edit file from vcs repo"      'v' '<esc>: fzf-vcs<ret>'
map global fzf -docstring "svitch to vcs selection mode" 'V' '<esc>: fzf-vcs-mode<ret>'
map global fzf -docstring "search in buffer"             's' '<esc>: fzf-buffer-search<ret>'
map global fzf -docstring "find tag"                     't' '<esc>: fzf-tag<ret>'
map global fzf -docstring "find tag"                     'T' '<esc>: fzf-tag-mode<ret>'

map global fzf-vcs -docstring "edit file from Git tree"        'g' '<esc>: fzf-git<ret>'
map global fzf-vcs -docstring "edit file from Subversion tree" 's' '<esc>: fzf-svn<ret>'
map global fzf-vcs -docstring "edit file from mercurial tree"  'h' '<esc>: fzf-hg<ret>'
map global fzf-vcs -docstring "edit file from GNU Bazaar tree" 'b' '<esc>: fzf-bzr<ret>'

declare-option -docstring "fzf tag kind filter for functions" \
str fzf_tag_function_kind "f"
declare-option -docstring "fzf tag kind filter for members" \
str fzf_tag_member_kind "m"
declare-option -docstring "fzf tag kind filter for variables" \
str fzf_tag_variable_kind "v"
declare-option -docstring "fzf tag kind filter for includes" \
str fzf_tag_include_kind "h"
declare-option -docstring "fzf tag kind filter for structures" \
str fzf_tag_structure_kind "s"
declare-option -docstring "fzf tag kind filter for classes" \
str fzf_tag_class_kind "c"
declare-option -docstring "fzf tag kind filter for namespacess" \
str fzf_tag_namespaces_kind "c"

# Commands
define-command -docstring "Enter fzf-mode.
fzf-mode contains mnemonic key bindings for every fzf.kak command

Best used with mapping like:
    map global normal '<some key>' ': fzf-mode<ret>'
" \
fzf-mode %{ try %{ evaluate-commands 'enter-user-mode fzf' } }

define-command -docstring "Enter fzf-mode.
fzf-mode contains mnemonic key bindings for every fzf.kak command

Best used with mapping like:
    map global normal '<some key>' ': fzf-mode<ret>'
" \
fzf-vcs-mode %{ try %{ evaluate-commands 'enter-user-mode fzf-vcs' } }

define-command -docstring "Enter fzf-mode.
fzf-mode contains mnemonic key bindings for every fzf.kak command

Best used with mapping like:
    map global normal '<some key>' ': fzf-mode<ret>'
" \
fzf-tag-mode %{ try %{ evaluate-commands 'enter-user-mode fzf-tag' } }

define-command -hidden fzf-file %{ evaluate-commands %sh{
    if [ -z $(command -v $kak_opt_fzf_file_command) ]; then
        echo "echo -markup '{Information}''$kak_opt_fzf_file_command'' is not installed. Falling back to ''find'''"
        kak_opt_fzf_file_command="find"
    fi
    case $kak_opt_fzf_file_command in
    find)
        cmd="find -type f" ;;
    ag)
        cmd="ag -l -f --hidden --one-device . " ;;
    rg)
        cmd="rg -L --hidden --files" ;;
    fd)
        cmd="fd --type f --follow" ;;
    find*|ag*|rg*|fd*)
        cmd=$kak_opt_fzf_file_command ;;
    *)
        executable=$(echo $kak_opt_fzf_file_command | awk '{print $1'}| tr '(' ' ' | cut -d " " -f 2)
        echo "echo -markup '{Information}''$executable'' is not supported by the script. fzf.kak may not work as you expect.'"
        cmd=$kak_opt_fzf_file_command ;;
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
}}

define-command -docstring "Wrapper command for fzf vcs to automatically decect
used version control system.

Supported vcs:
    Git:           ""git""
    Subversion:    ""svn""
    Mercurial SCM: ""hg""
    GNU Bazaar:    ""bzr""
" \
-hidden fzf-vcs %{ evaluate-commands %sh{
    commands="git rev-parse --is-inside-work-tree
svn info
hg --cwd . root
bzr status"
    IFS='
'
    for cmd in $commands; do
        eval $cmd >/dev/null 2>&1
        res=$?
        if [ "$res"  = "0" ]; then
            vcs=$(echo $cmd | awk '{print $1}')
            title="fzf $vcs"
            [ ! -z "${kak_client_env_TMUX}" ] && additional_keybindings="
<c-s>: open file in horizontal split
<c-v>: open file in vertical split"
            message="Open single or multiple files from git tree.
<ret>: open file in new buffer.
<c-w>: open file in new window $additional_keybindings"
            echo "info -title '$title' '$message'"
            echo "fzf-$vcs"
            exit
        fi
    done
    echo "echo -markup '{Information}No VCS found in current folder'"
}}

define-command -hidden fzf-git %{ evaluate-commands %sh{
    case $kak_opt_fzf_git_command in
    git)
        cmd="git ls-tree --name-only -r HEAD" ;;
    git*)
        cmd=$kak_opt_fzf_git_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    eval echo 'fzf \"edit \$1\" \"$cmd\" \"-m --expect ctrl-w $additional_flags\"'
}}

define-command -hidden fzf-hg %{ evaluate-commands %sh{
    case $kak_opt_fzf_hg_command in
    hg)
        cmd="hg locate -f -0 -I .hg locate -f -0 -I ." ;;
    hg*)
        cmd=$kak_opt_fzf_hg_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    eval echo 'fzf \"edit \$1\" \"$cmd\" \"-m --expect ctrl-w $additional_flags\"'
}}

define-command -hidden fzf-svn %{ evaluate-commands %sh{
    case $kak_opt_fzf_svn_command in
    svn)
        cmd="svn list -R . | grep -v '$/' | tr '\\n' '\\0'" ;;
    svn*)
        cmd=$kak_opt_fzf_svn_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    eval echo 'fzf \"edit \$1\" \"$cmd\" \"-m --expect ctrl-w $additional_flags\"'
}}

define-command -hidden fzf-bzr %{ evaluate-commands %sh{
    case $kak_opt_fzf_bzr_command in
    bzr)
        cmd="bzr ls -R --versioned -0" ;;
    bzr*)
        cmd=$kak_opt_fzf_bzr_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    eval echo 'fzf \"edit \$1\" \"$cmd\" \"-m --expect ctrl-w $additional_flags\"'
}}

define-command -hidden fzf-tag %{ evaluate-commands %sh{
    case $kak_opt_fzf_tag_command in
    readtags)
        cmd="readtags -l | cut -f1" ;;
    readtags*)
        cmd=$kak_opt_fzf_tag_command ;;
    *)
        echo "echo -markup '{Information}$kak_opt_fzf_tag_command is not supported by the script. fzf.kak may not work as you expect."
        cmd=$kak_opt_fzf_tag_command ;;
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
}}


define-command -hidden fzf-cd %{
    evaluate-commands %sh{
        title="fzf change directory"
        message="Change the server''s working directory"
        echo "info -title '$title' '$message'"
    }
    fzf "change-directory $1" "(echo .. && find \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type d -print)"
}

define-command -hidden fzf-buffer-search %{ evaluate-commands %sh{
        title="fzf buffer search"
        message="Search buffer with fzf, and jump to result location"
        echo "info -title '$title' '$message'"
        line=$kak_cursor_line
        char=$(expr $kak_cursor_char_column - 1)
        buffer_content=$(mktemp ${TMPDIR:-/tmp}/kak-curr-buff.XXXXXX)
        echo "execute-keys %{%<a-|>cat<space>><space>$buffer_content<ret>;}"
        echo "execute-keys $line g $char l"
        echo "fzf \"execute-keys \$1 gx\" \"(nl -b a -n ln $buffer_content\" \"--reverse | cut -f 1; rm $buffer_content)\""
    } }

define-command -hidden fzf -params 2..3 %{ evaluate-commands %sh{
    callback=$1
    items_command=$2
    additional_flags=$3

    items_executable=$(echo $items_command | awk '{print $1}' | tr '(' ' ' | cut -d " " -f 2)
    if [ -z $(command -v $items_executable) ]; then
        echo "fail \'$items_executable' executable not found"
        exit
    fi

    tmp=$(mktemp $(eval echo ${TMPDIR:-/tmp}/kak-fzf.XXXXXX))
    exec=$(mktemp $(eval echo ${TMPDIR:-/tmp}/kak-exec.XXXXXX))

    if [ "$(echo $callback | awk '{print $1}')" = "edit" ] && [ $kak_opt_fzf_preview = "true" ]; then
        case $kak_opt_fzf_highlighter in
        coderay)
            highlighter="coderay {}" ;;
        highlight)
            highlighter="highlight --failsafe -O ansi {}" ;;
        rouge)
            highlighter="rougify {}" ;;
        coderay*|highlight*|rougify*)
            highlighter=$kak_opt_fzf_highlighter ;;
        *)
            executable=$(echo $kak_opt_fzf_highlighter | awk '{print $1}'| tr '(' ' ' | cut -d " " -f 2)
            echo "echo -markup '{Information}''$executable'' highlighter is not supported by the script. fzf.kak may not work as you expect.'"
            highlighter=$kak_opt_fzf_highlighter ;;
        esac
        if [ ! -z "${kak_client_env_TMUX}" ]; then
            preview_pos='pos=right:50%;'
        else
            preview_pos='sleep 0.1; if [ $(tput cols) -gt $(expr $(tput lines) * 2) ]; then pos=right:50%; else pos=top:60%; fi;'
        fi
        additional_flags="--preview '($highlighter || cat {}) 2>/dev/null | head -n $kak_opt_fzf_preview_lines' --preview-window=\$pos $additional_flags"
    fi

    if [ ! -z "${kak_client_env_TMUX}" ]; then
        cmd="$preview_pos $items_command | fzf-tmux -d $kak_opt_fzf_tmux_height --expect ctrl-q $additional_flags > $tmp"
    elif [ ! -z "${kak_opt_termcmd}" ]; then
        path=$(pwd)
        additional_flags=$(echo $additional_flags | sed "s:\$pos:\\\\\$pos:")
        cmd="$kak_opt_termcmd \"sh -c \\\"cd $path && $preview_pos $items_command | fzf --expect ctrl-q $additional_flags > $tmp\\\"\""
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
        cmd="cat $buffers | fzf-tmux -d 15 --expect ctrl-d > $tmp"
    elif [ ! -z "${kak_opt_termcmd}" ]; then
        cmd="$kak_opt_termcmd \"sh -c 'cat $buffers | fzf --expect ctrl-d > $tmp'\""
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

declare-option -hidden -docstring "Set of mappings for Ada filetype" \
str fzf_tag_ada "
    <a-P>:  package specifications
    <a-p>:  packages
    <a-T>:  type specifications [off]
    <a-t>:  types
    <a-U>:  subtype specifications [off]
    <a-u>:  subtypes
    <a-c>:  record type components
    <a-l>:  enum type literals
    <a-V>:  variable specifications [off]
    <a-v>:  variables
    <a-f>:  generic formal parameters
    <a-n>:  constants
    <a-x>:  user defined exceptions
    <a-R>:  subprogram specifications
    <a-r>:  subprograms
    <a-K>:  task specifications
    <a-k>:  tasks
    <a-O>:  protected data specifications
    <a-o>:  protected data
    <a-E>:  task/protected data entry specifications [off]
    <a-e>:  task/protected data entries
    <a-b>:  labels
    <a-i>:  loop/declare identifiers
    <a-a>:  automatic variables [off]
    <a-y>:  loops and blocks with no identifier [off]
    <a-S>:  (ctags internal use)"

declare-option -hidden -docstring "Set of mappings for Ant filetype" \
str fzf_tag_ant "
    <a-p>:  projects
    <a-t>:  targets
    <a-P>:  properties(global)
    <a-i>:  antfiles"

declare-option -hidden -docstring "Set of mappings for Asciidoc filetype" \
str fzf_tag_asciidoc "
    <a-c>:  chapters
    <a-s>:  sections
    <a-S>:  level <a-2>: sections
    <a-t>:  level <a-3>: sections
    <a-T>:  level <a-4>: sections
    <a-u>:  level <a-5>: sections
    <a-a>:  anchors"

declare-option -hidden -docstring "Set of mappings for Asm filetype" \
str fzf_tag_asm "
    <a-d>:  defines
    <a-l>:  labels
    <a-m>:  macros
    <a-t>:  types (structs and records)
    <a-s>:  sections"

declare-option -hidden -docstring "Set of mappings for Asp filetype" \
str fzf_tag_asp "
    <a-d>:  constants
    <a-c>:  classes
    <a-f>:  functions
    <a-s>:  subroutines
    <a-v>:  variables"

declare-option -hidden -docstring "Set of mappings for Autoconf filetype" \
str fzf_tag_autoconf "
    <a-p>:  packages
    <a-t>:  templates
    <a-m>:  autoconf macros
    <a-w>:  options specified with --with-...
    <a-e>:  options specified with --enable-...
    <a-s>:  substitution keys
    <a-c>:  automake conditions
    <a-d>:  definitions"

declare-option -hidden -docstring "Set of mappings for AutoIt filetype" \
str fzf_tag_autoit "
    <a-f>:  functions
    <a-r>:  regions
    <a-g>:  global variables
    <a-l>:  local variables
    <a-S>:  included scripts"

declare-option -hidden -docstring "Set of mappings for Automake filetype" \
str fzf_tag_automake "
    <a-d>:  directories
    <a-P>:  programs
    <a-M>:  manuals
    <a-T>:  ltlibraries
    <a-L>:  libraries
    <a-S>:  scripts
    <a-D>:  datum
    <a-c>:  conditions"

declare-option -hidden -docstring "Set of mappings for Awk filetype" \
str fzf_tag_awk "
    <a-f>:  functions"

declare-option -hidden -docstring "Set of mappings for Basic filetype" \
str fzf_tag_basic "
    <a-c>:  constants
    <a-f>:  functions
    <a-l>:  labels
    <a-t>:  types
    <a-v>:  variables
    <a-g>:  enumerations"

declare-option -hidden -docstring "Set of mappings for BETA filetype" \
str fzf_tag_beta "
    <a-f>:  fragment definitions
    <a-p>:  all patterns [off]
    <a-s>:  slots (fragment uses)
    <a-v>:  patterns (virtual or rebound)"

declare-option -hidden -docstring "Set of mappings for Clojure filetype" \
str fzf_tag_clojure "
    <a-f>:  functions
    <a-n>:  namespaces"

declare-option -hidden -docstring "Set of mappings for CMake filetype" \
str fzf_tag_cmake "
    <a-f>:  functions
    <a-m>:  macros
    <a-t>:  targets
    <a-v>:  variable definitions
    <a-D>:  options specified with -D
    <a-p>:  projects
    <a-r>:  regex"

declare-option -hidden -docstring "Set of mappings for C filetype" \
str fzf_tag_c "
    <a-d>:  macro definitions
    <a-e>:  enumerators (values inside an enumeration)
    <a-f>:  function definitions
    <a-g>:  enumeration names
    <a-h>:  included header files
    <a-l>:  local variables [off]
    <a-m>:  struct, and union members
    <a-p>:  function prototypes [off]
    <a-s>:  structure names
    <a-t>:  typedefs
    <a-u>:  union names
    <a-v>:  variable definitions
    <a-x>:  external and forward variable declarations [off]
    <a-z>:  function parameters inside function definitions [off]
    <a-L>:  goto labels [off]"

declare-option -hidden -docstring "Set of mappings for C++ filetype" \
str fzf_tag_cpp "
    <a-d>:  macro definitions
    <a-e>:  enumerators (values inside an enumeration)
    <a-f>:  function definitions
    <a-g>:  enumeration names
    <a-h>:  included header files
    <a-l>:  local variables [off]
    <a-m>:  class, struct, and union members
    <a-p>:  function prototypes [off]
    <a-s>:  structure names
    <a-t>:  typedefs
    <a-u>:  union names
    <a-v>:  variable definitions
    <a-x>:  external and forward variable declarations [off]
    <a-z>:  function parameters inside function definitions [off]
    <a-L>:  goto labels [off]
    <a-c>:  classes
    <a-n>:  namespaces
    <a-A>:  namespace aliases [off]
    <a-N>:  names imported via using scope::symbol [off]
    <a-U>:  using namespace statements [off]"

declare-option -hidden -docstring "Set of mappings for CPreProcessor filetype" \
str fzf_tag_cpreprocessor "
    <a-d>:  macro definitions
    <a-h>:  included header files"

declare-option -hidden -docstring "Set of mappings for CSS filetype" \
str fzf_tag_css "
    <a-c>:  classes
    <a-s>:  selectors
    <a-i>:  identities"

declare-option -hidden -docstring "Set of mappings for C# filetype" \
str fzf_tag_csharp "
    <a-c>:  classes
    <a-d>:  macro definitions
    <a-e>:  enumerators (values inside an enumeration)
    <a-E>:  events
    <a-f>:  fields
    <a-g>:  enumeration names
    <a-i>:  interfaces
    <a-l>:  local variables [off]
    <a-m>:  methods
    <a-n>:  namespaces
    <a-p>:  properties
    <a-s>:  structure names
    <a-t>:  typedefs"

declare-option -hidden -docstring "Set of mappings for Ctags filetype" \
str fzf_tag_ctags "
    <a-l>:  language definitions
    <a-k>:  kind definitions"

declare-option -hidden -docstring "Set of mappings for Cobol filetype" \
str fzf_tag_cobol "
    <a-p>:  paragraphs
    <a-d>:  data items
    <a-S>:  source code file
    <a-f>:  file descriptions (FD, SD, RD)
    <a-g>:  group items
    <a-P>:  program ids
    <a-s>:  sections
    <a-D>:  divisions"

declare-option -hidden -docstring "Set of mappings for CUDA filetype" \
str fzf_tag_cuda "
    <a-d>:  macro definitions
    <a-e>:  enumerators (values inside an enumeration)
    <a-f>:  function definitions
    <a-g>:  enumeration names
    <a-h>:  included header files
    <a-l>:  local variables [off]
    <a-m>:  struct, and union members
    <a-p>:  function prototypes [off]
    <a-s>:  structure names
    <a-t>:  typedefs
    <a-u>:  union names
    <a-v>:  variable definitions
    <a-x>:  external and forward variable declarations [off]
    <a-z>:  function parameters inside function definitions [off]
    <a-L>:  goto labels [off]"

declare-option -hidden -docstring "Set of mappings for D filetype" \
str fzf_tag_d "
    <a-a>:  aliases
    <a-c>:  classes
    <a-g>:  enumeration names
    <a-e>:  enumerators (values inside an enumeration)
    <a-x>:  external variable declarations [off]
    <a-f>:  function definitions
    <a-i>:  interfaces
    <a-l>:  local variables [off]
    <a-m>:  class, struct, and union members
    <a-X>:  mixins
    <a-M>:  modules
    <a-n>:  namespaces
    <a-p>:  function prototypes [off]
    <a-s>:  structure names
    <a-T>:  templates
    <a-u>:  union names
    <a-v>:  variable definitions
    <a-V>:  version statements"

declare-option -hidden -docstring "Set of mappings for Diff filetype" \
str fzf_tag_diff "
    <a-m>:  modified files
    <a-n>:  newly created files
    <a-d>:  deleted files
    <a-h>:  hunks"

declare-option -hidden -docstring "Set of mappings for DTD filetype" \
str fzf_tag_dtd "
    <a-E>:  entities
    <a-p>:  parameter entities
    <a-e>:  elements
    <a-a>:  attributes
    <a-n>:  notations"

declare-option -hidden -docstring "Set of mappings for DTS filetype" \
str fzf_tag_dts "
    <a-p>:  phandlers
    <a-l>:  labels
    <a-r>:  regex"

declare-option -hidden -docstring "Set of mappings for DosBatch filetype" \
str fzf_tag_dosbatch "
    <a-l>:  labels
    <a-v>:  variables"

declare-option -hidden -docstring "Set of mappings for Eiffel filetype" \
str fzf_tag_eiffel "
    <a-c>:  classes
    <a-f>:  features
    <a-l>:  local entities [off]"

declare-option -hidden -docstring "Set of mappings for Elm filetype" \
str fzf_tag_elm "
    <a-m>:  Module
    <a-n>:  Renamed Imported Module
    <a-p>:  Port
    <a-t>:  Type Definition
    <a-c>:  Type Constructor
    <a-a>:  Type Alias
    <a-f>:  Functions"

declare-option -hidden -docstring "Set of mappings for Erlang filetype" \
str fzf_tag_erlang "
    <a-d>:  macro definitions
    <a-f>:  functions
    <a-m>:  modules
    <a-r>:  record definitions
    <a-t>:  type definitions"

declare-option -hidden -docstring "Set of mappings for Falcon filetype" \
str fzf_tag_falcon "
    <a-c>:  classes
    <a-f>:  functions
    <a-m>:  class members
    <a-v>:  variables
    <a-i>:  imports"

declare-option -hidden -docstring "Set of mappings for Flex filetype" \
str fzf_tag_flex "
    <a-f>:  functions
    <a-c>:  classes
    <a-m>:  methods
    <a-p>:  properties
    <a-v>:  global variables
    <a-x>:  mxtags"

declare-option -hidden -docstring "Set of mappings for Fortran filetype" \
str fzf_tag_fortran "
    <a-b>:  block data
    <a-c>:  common blocks
    <a-e>:  entry points
    <a-E>:  enumerations
    <a-f>:  functions
    <a-i>:  interface contents, generic names, and operators
    <a-k>:  type and structure components
    <a-l>:  labels
    <a-L>:  local, common block, and namelist variables [off]
    <a-m>:  modules
    <a-M>:  type bound procedures
    <a-n>:  namelists
    <a-N>:  enumeration values
    <a-p>:  programs
    <a-P>:  subprogram prototypes [off]
    <a-s>:  subroutines
    <a-t>:  derived types and structures
    <a-v>:  program (global) and module variables
    <a-S>:  submodules"

declare-option -hidden -docstring "Set of mappings for Fypp filetype" \
str fzf_tag_fypp "
    <a-m>:  macros"

declare-option -hidden -docstring "Set of mappings for Gdbinit filetype" \
str fzf_tag_gdbinit "
    <a-d>:  definitions
    <a-D>:  documents [off]
    <a-t>:  toplevel variables
    <a-l>:  local variables [off]"

declare-option -hidden -docstring "Set of mappings for Go filetype" \
str fzf_tag_go "
    <a-p>:  packages
    <a-f>:  functions
    <a-c>:  constants
    <a-t>:  types
    <a-v>:  variables
    <a-s>:  structs
    <a-i>:  interfaces
    <a-m>:  struct members
    <a-M>:  struct anonymous members
    <a-u>:  unknown
    <a-P>:  name for specifying imported package"

declare-option -hidden -docstring "Set of mappings for HTML filetype" \
str fzf_tag_html "
    <a-a>:  named anchors
    <a-h>:  H1 headings
    <a-i>:  H2 headings
    <a-j>:  H3 headings"

declare-option -hidden -docstring "Set of mappings for Iniconf filetype" \
str fzf_tag_iniconf "
    <a-s>:  sections
    <a-k>:  keys"

declare-option -hidden -docstring "Set of mappings for ITcl filetype" \
str fzf_tag_itcl "
    <a-c>:  classes
    <a-m>:  methods
    <a-v>:  object-specific variables
    <a-C>:  common variables
    <a-p>:  procedures within the  class  namespace"

declare-option -hidden -docstring "Set of mappings for Java filetype" \
str fzf_tag_java "
    <a-a>:  annotation declarations
    <a-c>:  classes
    <a-e>:  enum constants
    <a-f>:  fields
    <a-g>:  enum types
    <a-i>:  interfaces
    <a-l>:  local variables [off]
    <a-m>:  methods
    <a-p>:  packages"

declare-option -hidden -docstring "Set of mappings for JavaProperties filetype" \
str fzf_tag_javaproperties "
    <a-k>:  keys"

declare-option -hidden -docstring "Set of mappings for JavaScript filetype" \
str fzf_tag_javascript "
    <a-f>:  functions
    <a-c>:  classes
    <a-m>:  methods
    <a-p>:  properties
    <a-C>:  constants
    <a-v>:  global variables
    <a-g>:  generators"

declare-option -hidden -docstring "Set of mappings for JSON filetype" \
str fzf_tag_json "
    <a-o>:  objects
    <a-a>:  arrays
    <a-n>:  numbers
    <a-s>:  strings
    <a-b>:  booleans
    <a-z>:  nulls"

declare-option -hidden -docstring "Set of mappings for LdScript filetype" \
str fzf_tag_ldscript "
    <a-S>:  sections
    <a-s>:  symbols
    <a-v>:  versions
    <a-i>:  input sections"

declare-option -hidden -docstring "Set of mappings for Lisp filetype" \
str fzf_tag_lisp "
    <a-f>:  functions"

declare-option -hidden -docstring "Set of mappings for Lua filetype" \
str fzf_tag_lua "
    <a-f>:  functions"

declare-option -hidden -docstring "Set of mappings for M4 filetype" \
str fzf_tag_m4 "
    <a-d>:  macros
    <a-I>:  macro files"

declare-option -hidden -docstring "Set of mappings for Man filetype" \
str fzf_tag_man "
    <a-t>:  titles
    <a-s>:  sections"

declare-option -hidden -docstring "Set of mappings for Make filetype" \
str fzf_tag_make "
    <a-m>:  macros
    <a-t>:  targets
    <a-I>:  makefiles"

declare-option -hidden -docstring "Set of mappings for Markdown filetype" \
str fzf_tag_markdown "
    <a-c>:  chapsters
    <a-s>:  sections
    <a-S>:  subsections
    <a-t>:  subsubsections
    <a-T>:  level <a-4>: subsections
    <a-u>:  level <a-5>: subsections
    <a-r>:  regex"

declare-option -hidden -docstring "Set of mappings for MatLab filetype" \
str fzf_tag_matlab "
    <a-f>:  function
    <a-v>:  variable
    <a-c>:  class"

declare-option -hidden -docstring "Set of mappings for Myrddin filetype" \
str fzf_tag_myrddin "
    <a-f>:  functions
    <a-c>:  constants
    <a-v>:  variables
    <a-t>:  types
    <a-r>:  traits
    <a-p>:  packages"

declare-option -hidden -docstring "Set of mappings for ObjectiveC filetype" \
str fzf_tag_objectivec "
    <a-i>:  class interface
    <a-I>:  class implementation
    <a-P>:  Protocol
    <a-m>:  Object's method
    <a-c>:  Class' method
    <a-v>:  Global variable
    <a-E>:  Object field
    <a-f>:  <a-A>: function
    <a-p>:  <a-A>: property
    <a-t>:  <a-A>: type alias
    <a-s>:  <a-A>: type structure
    <a-e>:  An enumeration
    <a-M>:  <a-A>: preprocessor macro"

declare-option -hidden -docstring "Set of mappings for OldC++ [disabled] filetype" \
str fzf_tag_oldc++ [disabled] "
    <a-c>:  classes
    <a-d>:  macro definitions
    <a-e>:  enumerators (values inside an enumeration)
    <a-f>:  function definitions
    <a-g>:  enumeration names
    <a-h>:  included header files
    <a-l>:  local variables [off]
    <a-m>:  class, struct, and union members
    <a-n>:  namespaces
    <a-p>:  function prototypes [off]
    <a-s>:  structure names
    <a-t>:  typedefs
    <a-u>:  union names
    <a-v>:  variable definitions
    <a-x>:  external and forward variable declarations [off]
    <a-L>:  goto label [off]"

declare-option -hidden -docstring "Set of mappings for OldC [disabled] filetype" \
str fzf_tag_oldc [disabled] "
    <a-c>:  classes
    <a-d>:  macro definitions
    <a-e>:  enumerators (values inside an enumeration)
    <a-f>:  function definitions
    <a-g>:  enumeration names
    <a-h>:  included header files
    <a-l>:  local variables [off]
    <a-m>:  class, struct, and union members
    <a-n>:  namespaces
    <a-p>:  function prototypes [off]
    <a-s>:  structure names
    <a-t>:  typedefs
    <a-u>:  union names
    <a-v>:  variable definitions
    <a-x>:  external and forward variable declarations [off]
    <a-L>:  goto label [off]"

declare-option -hidden -docstring "Set of mappings for OCaml filetype" \
str fzf_tag_ocaml "
    <a-c>:  classes
    <a-m>:  Object's method
    <a-M>:  Module or functor
    <a-v>:  Global variable
    <a-p>:  Signature item
    <a-t>:  Type name
    <a-f>:  <a-A>: function
    <a-C>:  <a-A>: constructor
    <a-r>:  <a-A>: 'structure' field
    <a-e>:  An exception"

declare-option -hidden -docstring "Set of mappings for Passwd filetype" \
str fzf_tag_passwd "
    <a-u>:  user names"

declare-option -hidden -docstring "Set of mappings for Pascal filetype" \
str fzf_tag_pascal "
    <a-f>:  functions
    <a-p>:  procedures"

declare-option -hidden -docstring "Set of mappings for Perl filetype" \
str fzf_tag_perl "
    <a-c>:  constants
    <a-f>:  formats
    <a-l>:  labels
    <a-p>:  packages
    <a-s>:  subroutines
    <a-d>:  subroutine declarations [off]"

declare-option -hidden -docstring "Set of mappings for Perl6 filetype" \
str fzf_tag_perl6 "
    <a-c>:  classes
    <a-g>:  grammars
    <a-m>:  methods
    <a-o>:  modules
    <a-p>:  packages
    <a-r>:  roles
    <a-u>:  rules
    <a-b>:  submethods
    <a-s>:  subroutines
    <a-t>:  tokens"

declare-option -hidden -docstring "Set of mappings for PHP filetype" \
str fzf_tag_php "
    <a-c>:  classes
    <a-d>:  constant definitions
    <a-f>:  functions
    <a-i>:  interfaces
    <a-l>:  local variables [off]
    <a-n>:  namespaces
    <a-t>:  traits
    <a-v>:  variables
    <a-a>:  aliases"

declare-option -hidden -docstring "Set of mappings for Pod filetype" \
str fzf_tag_pod "
    <a-c>:  chapters
    <a-s>:  sections
    <a-S>:  subsections
    <a-t>:  subsubsections"

declare-option -hidden -docstring "Set of mappings for Protobuf filetype" \
str fzf_tag_protobuf "
    <a-p>:  packages
    <a-m>:  messages
    <a-f>:  fields
    <a-e>:  enum constants
    <a-g>:  enum types
    <a-s>:  services
    <a-r>:  RPC methods [off]"

declare-option -hidden -docstring "Set of mappings for PuppetManifest filetype" \
str fzf_tag_puppetmanifest "
    <a-c>:  classes
    <a-d>:  definitions
    <a-n>:  nodes
    <a-r>:  resources
    <a-v>:  variables"

declare-option -hidden -docstring "Set of mappings for Python filetype" \
str fzf_tag_python "
    <a-c>:  classes
    <a-f>:  functions
    <a-m>:  class members
    <a-v>:  variables
    <a-I>:  name referring <a-a>: module defined in other file
    <a-i>:  modules
    <a-x>:  name referring <a-a>: class/variable/function/module defined in other module
    <a-z>:  function parameters [off]
    <a-l>:  local variables [off]"

declare-option -hidden -docstring "Set of mappings for PythonLoggingConfig filetype" \
str fzf_tag_pythonloggingconfig "
    <a-L>:  logger sections
    <a-q>:  logger qualnames"

declare-option -hidden -docstring "Set of mappings for QemuHX filetype" \
str fzf_tag_qemuhx "
    <a-q>:  QEMU Management Protocol dispatch table entries
    <a-i>:  item in texinfo doc"

declare-option -hidden -docstring "Set of mappings for QtMoc filetype" \
str fzf_tag_qtmoc "
    <a-s>:  slots
    <a-S>:  signals
    <a-p>:  properties"

declare-option -hidden -docstring "Set of mappings for R filetype" \
str fzf_tag_r "
    <a-f>:  functions
    <a-l>:  libraries
    <a-s>:  sources
    <a-g>:  global variables
    <a-v>:  function variables"

declare-option -hidden -docstring "Set of mappings for RSpec filetype" \
str fzf_tag_rspec "
    <a-d>:  describes
    <a-c>:  contexts"

declare-option -hidden -docstring "Set of mappings for REXX filetype" \
str fzf_tag_rexx "
    <a-s>:  subroutines"

declare-option -hidden -docstring "Set of mappings for Robot filetype" \
str fzf_tag_robot "
    <a-t>:  testcases
    <a-k>:  keywords
    <a-v>:  variables"

declare-option -hidden -docstring "Set of mappings for RpmSpec filetype" \
str fzf_tag_rpmspec "
    <a-t>:  tags
    <a-m>:  macros
    <a-p>:  packages
    <a-g>:  global macros"

declare-option -hidden -docstring "Set of mappings for ReStructuredText filetype" \
str fzf_tag_restructuredtext "
    <a-c>:  chapters
    <a-s>:  sections
    <a-S>:  subsections
    <a-t>:  subsubsections
    <a-T>:  targets"

declare-option -hidden -docstring "Set of mappings for Ruby filetype" \
str fzf_tag_ruby "
    <a-c>:  classes
    <a-f>:  methods
    <a-m>:  modules
    <a-S>:  singleton methods"

declare-option -hidden -docstring "Set of mappings for Rust filetype" \
str fzf_tag_rust "
    <a-n>:  module
    <a-s>:  structural type
    <a-i>:  trait interface
    <a-c>:  implementation
    <a-f>:  Function
    <a-g>:  Enum
    <a-t>:  Type Alias
    <a-v>:  Global variable
    <a-M>:  Macro Definition
    <a-m>:  <a-A>: struct field
    <a-e>:  An enum variant
    <a-P>:  <a-A>: method"

declare-option -hidden -docstring "Set of mappings for Scheme filetype" \
str fzf_tag_scheme "
    <a-f>:  functions
    <a-s>:  sets"

declare-option -hidden -docstring "Set of mappings for Sh filetype" \
str fzf_tag_sh "
    <a-a>:  aliases
    <a-f>:  functions
    <a-s>:  script files
    <a-h>:  label for here document"

declare-option -hidden -docstring "Set of mappings for SLang filetype" \
str fzf_tag_slang "
    <a-f>:  functions
    <a-n>:  namespaces"

declare-option -hidden -docstring "Set of mappings for SML filetype" \
str fzf_tag_sml "
    <a-e>:  exception declarations
    <a-f>:  function definitions
    <a-c>:  functor definitions
    <a-s>:  signature declarations
    <a-r>:  structure declarations
    <a-t>:  type definitions
    <a-v>:  value bindings"

declare-option -hidden -docstring "Set of mappings for SQL filetype" \
str fzf_tag_sql "
    <a-c>:  cursors
    <a-d>:  prototypes [off]
    <a-f>:  functions
    <a-E>:  record fields
    <a-l>:  local variables [off]
    <a-L>:  block label
    <a-P>:  packages
    <a-p>:  procedures
    <a-r>:  records [off]
    <a-s>:  subtypes
    <a-t>:  tables
    <a-T>:  triggers
    <a-v>:  variables
    <a-i>:  indexes
    <a-e>:  events
    <a-U>:  publications
    <a-R>:  services
    <a-D>:  domains
    <a-V>:  views
    <a-n>:  synonyms
    <a-x>:  MobiLink Table Scripts
    <a-y>:  MobiLink Conn Scripts
    <a-z>:  MobiLink Properties "

declare-option -hidden -docstring "Set of mappings for SystemdUnit filetype" \
str fzf_tag_systemdunit "
    <a-u>:  units"

declare-option -hidden -docstring "Set of mappings for Tcl filetype" \
str fzf_tag_tcl "
    <a-p>:  procedures
    <a-n>:  namespaces"

declare-option -hidden -docstring "Set of mappings for TclOO filetype" \
str fzf_tag_tcloo "
    <a-c>:  classes
    <a-m>:  methods"

declare-option -hidden -docstring "Set of mappings for Tex filetype" \
str fzf_tag_tex "
    <a-p>:  parts
    <a-c>:  chapters
    <a-s>:  sections
    <a-u>:  subsections
    <a-b>:  subsubsections
    <a-P>:  paragraphs
    <a-G>:  subparagraphs
    <a-l>:  labels
    <a-i>:  includes"

declare-option -hidden -docstring "Set of mappings for TTCN filetype" \
str fzf_tag_ttcn "
    <a-M>:  module definition
    <a-t>:  type definition
    <a-c>:  constant definition
    <a-d>:  template definition
    <a-f>:  function definition
    <a-s>:  signature definition
    <a-C>:  testcase definition
    <a-a>:  altstep definition
    <a-G>:  group definition
    <a-P>:  module parameter definition
    <a-v>:  variable instance
    <a-T>:  timer instance
    <a-p>:  port instance
    <a-m>:  record/set/union member
    <a-e>:  enumeration value"

declare-option -hidden -docstring "Set of mappings for Vera filetype" \
str fzf_tag_vera "
    <a-c>:  classes
    <a-d>:  macro definitions
    <a-e>:  enumerators (values inside an enumeration)
    <a-f>:  function definitions
    <a-g>:  enumeration names
    <a-i>:  interfaces
    <a-l>:  local variables [off]
    <a-m>:  class, struct, and union members
    <a-p>:  programs
    <a-P>:  function prototypes [off]
    <a-s>:  signals
    <a-t>:  tasks
    <a-T>:  typedefs
    <a-v>:  variable definitions
    <a-x>:  external variable declarations [off]
    <a-h>:  included header files"

declare-option -hidden -docstring "Set of mappings for Verilog filetype" \
str fzf_tag_verilog "
    <a-c>:  constants (define, parameter, specparam)
    <a-e>:  events
    <a-f>:  functions
    <a-m>:  modules
    <a-n>:  net data types
    <a-p>:  ports
    <a-r>:  register data types
    <a-t>:  tasks
    <a-b>:  blocks"

declare-option -hidden -docstring "Set of mappings for SystemVerilog filetype" \
str fzf_tag_systemverilog "
    <a-c>:  constants (define, parameter, specparam, enum values)
    <a-e>:  events
    <a-f>:  functions
    <a-m>:  modules
    <a-n>:  net data types
    <a-p>:  ports
    <a-r>:  register data types
    <a-t>:  tasks
    <a-b>:  blocks
    <a-A>:  assertions
    <a-C>:  classes
    <a-V>:  covergroups
    <a-E>:  enumerators
    <a-I>:  interfaces
    <a-M>:  modports
    <a-K>:  packages
    <a-P>:  programs
    <a-Q>:  prototypes [off]
    <a-R>:  properties
    <a-S>:  structs and unions
    <a-T>:  type declarations"

declare-option -hidden -docstring "Set of mappings for VHDL filetype" \
str fzf_tag_vhdl "
    <a-c>:  constant declarations
    <a-t>:  type definitions
    <a-T>:  subtype definitions
    <a-r>:  record names
    <a-e>:  entity declarations
    <a-C>:  component declarations [off]
    <a-d>:  prototypes [off]
    <a-f>:  function prototypes and declarations
    <a-p>:  procedure prototypes and declarations
    <a-P>:  package definitions
    <a-l>:  local definitions [off]"

declare-option -hidden -docstring "Set of mappings for Vim filetype" \
str fzf_tag_vim "
    <a-a>:  autocommand groups
    <a-c>:  user-defined commands
    <a-f>:  function definitions
    <a-m>:  maps
    <a-v>:  variable definitions
    <a-n>:  vimball filename"

declare-option -hidden -docstring "Set of mappings for WindRes filetype" \
str fzf_tag_windres "
    <a-d>:  dialogs
    <a-m>:  menus
    <a-i>:  icons
    <a-b>:  bitmaps
    <a-c>:  cursors
    <a-f>:  fonts
    <a-v>:  versions
    <a-a>:  accelerators"

declare-option -hidden -docstring "Set of mappings for YACC filetype" \
str fzf_tag_yacc "
    <a-l>:  labels"

declare-option -hidden -docstring "Set of mappings for YumRepo filetype" \
str fzf_tag_yumrepo "
    <a-r>:  repository id"

declare-option -hidden -docstring "Set of mappings for Zephir filetype" \
str fzf_tag_zephir "
    <a-c>:  classes
    <a-d>:  constant definitions
    <a-f>:  functions
    <a-i>:  interfaces
    <a-l>:  local variables [off]
    <a-n>:  namespaces
    <a-t>:  traits
    <a-v>:  variables
    <a-a>:  aliases"

declare-option -hidden -docstring "Set of mappings for DBusIntrospect filetype" \
str fzf_tag_dbusintrospect "
    <a-i>:  interfaces
    <a-m>:  methods
    <a-s>:  signals
    <a-p>:  properties"

declare-option -hidden -docstring "Set of mappings for Glade filetype" \
str fzf_tag_glade "
    <a-i>:  identifiers
    <a-c>:  classes
    <a-h>:  handlers"

declare-option -hidden -docstring "Set of mappings for Maven2 filetype" \
str fzf_tag_maven2 "
    <a-g>:  group identifiers
    <a-a>:  artifact identifiers
    <a-p>:  properties
    <a-r>:  repository identifiers"

declare-option -hidden -docstring "Set of mappings for PlistXML filetype" \
str fzf_tag_plistxml "
    <a-k>:  keys"

declare-option -hidden -docstring "Set of mappings for RelaxNG filetype" \
str fzf_tag_relaxng "
    <a-e>:  elements
    <a-a>:  attributes
    <a-n>:  named patterns"

declare-option -hidden -docstring "Set of mappings for SVG filetype" \
str fzf_tag_svg "
    <a-i>:  id attributes"

declare-option -hidden -docstring "Set of mappings for XSLT filetype" \
str fzf_tag_xslt "
    <a-s>:  stylesheets
    <a-p>:  parameters
    <a-m>:  matched template
    <a-n>:  matched template
    <a-v>:  variables"

declare-option -hidden -docstring "Set of mappings for Yaml filetype" \
str fzf_tag_yaml "
    <a-a>:  anchors"

declare-option -hidden -docstring "Set of mappings for AnsiblePlaybook filetype" \
str fzf_tag_ansibleplaybook "
    <a-p>:  plays"

define-command -hidden fzf-tag-kind -params 1 %{ evaluate-commands %sh{
    case $1 in
    readtags*)
        cmd=$1 ;;
    *)
        cmd="readtags -Q \\\"(eq? \\\$kind \\\"$1\\\")\\\" -l | cut -f1" ;;
    esac
    echo "echo -debug %{$cmd}"
    title="fzf tag kind $1"
    [ ! -z "${kak_client_env_TMUX}" ] && additional_keybindings="
<c-s>: open tag in horizontal split
<c-v>: open tag in vertical split"
    message="Jump to a symbol''s definition.<ret>: open tag in new buffer.
<c-w>: open tag in new window $additional_keybindings"
    if [ "$kak_opt_filetype" = "ada" ]; then additional_keybindings="--expect alt-P --expect alt-p --expect alt-T --expect alt-t --expect alt-U --expect alt-u --expect alt-c --expect alt-l --expect alt-V --expect alt-v --expect alt-f --expect alt-n --expect alt-x --expect alt-R --expect alt-r --expect alt-K --expect alt-k --expect alt-O --expect alt-o --expect alt-E --expect alt-e --expect alt-b --expect alt-i --expect alt-a --expect alt-y --expect alt-S"; additional_message=$kak_opt_fzf_tag_ada ; fi
    if [ "$kak_opt_filetype" = "ant" ]; then additional_keybindings="--expect alt-p --expect alt-t --expect alt-P --expect alt-i"; additional_message=$kak_opt_fzf_tag_ant ; fi
    if [ "$kak_opt_filetype" = "asciidoc" ]; then additional_keybindings="--expect alt-c --expect alt-s --expect alt-S --expect alt-t --expect alt-T --expect alt-u --expect alt-a"; additional_message=$kak_opt_fzf_tag_asciidoc ; fi
    if [ "$kak_opt_filetype" = "asm" ]; then additional_keybindings="--expect alt-d --expect alt-l --expect alt-m --expect alt-t --expect alt-s"; additional_message=$kak_opt_fzf_tag_asm ; fi
    if [ "$kak_opt_filetype" = "asp" ]; then additional_keybindings="--expect alt-d --expect alt-c --expect alt-f --expect alt-s --expect alt-v"; additional_message=$kak_opt_fzf_tag_asp ; fi
    if [ "$kak_opt_filetype" = "autoconf" ]; then additional_keybindings="--expect alt-p --expect alt-t --expect alt-m --expect alt-w --expect alt-e --expect alt-s --expect alt-c --expect alt-d"; additional_message=$kak_opt_fzf_tag_autoconf ; fi
    if [ "$kak_opt_filetype" = "autoit" ]; then additional_keybindings="--expect alt-f --expect alt-r --expect alt-g --expect alt-l --expect alt-S"; additional_message=$kak_opt_fzf_tag_autoit ; fi
    if [ "$kak_opt_filetype" = "automake" ]; then additional_keybindings="--expect alt-d --expect alt-P --expect alt-M --expect alt-T --expect alt-L --expect alt-S --expect alt-D --expect alt-c"; additional_message=$kak_opt_fzf_tag_automake ; fi
    if [ "$kak_opt_filetype" = "awk" ]; then additional_keybindings="--expect alt-f"; additional_message=$kak_opt_fzf_tag_awk ; fi
    if [ "$kak_opt_filetype" = "basic" ]; then additional_keybindings="--expect alt-c --expect alt-f --expect alt-l --expect alt-t --expect alt-v --expect alt-g"; additional_message=$kak_opt_fzf_tag_basic ; fi
    if [ "$kak_opt_filetype" = "beta" ]; then additional_keybindings="--expect alt-f --expect alt-p --expect alt-s --expect alt-v"; additional_message=$kak_opt_fzf_tag_beta ; fi
    if [ "$kak_opt_filetype" = "clojure" ]; then additional_keybindings="--expect alt-f --expect alt-n"; additional_message=$kak_opt_fzf_tag_clojure ; fi
    if [ "$kak_opt_filetype" = "cmake" ]; then additional_keybindings="--expect alt-f --expect alt-m --expect alt-t --expect alt-v --expect alt-D --expect alt-p --expect alt-r"; additional_message=$kak_opt_fzf_tag_cmake ; fi
    if [ "$kak_opt_filetype" = "c" ]; then additional_keybindings="--expect alt-d --expect alt-e --expect alt-f --expect alt-g --expect alt-h --expect alt-l --expect alt-m --expect alt-p --expect alt-s --expect alt-t --expect alt-u --expect alt-v --expect alt-x --expect alt-z --expect alt-L"; additional_message=$kak_opt_fzf_tag_c ; fi
    if [ "$kak_opt_filetype" = "cpp" ]; then additional_keybindings="--expect alt-d --expect alt-e --expect alt-f --expect alt-g --expect alt-h --expect alt-l --expect alt-m --expect alt-p --expect alt-s --expect alt-t --expect alt-u --expect alt-v --expect alt-x --expect alt-z --expect alt-L --expect alt-c --expect alt-n --expect alt-A --expect alt-N --expect alt-U"; additional_message=$kak_opt_fzf_tag_cpp ; fi
    if [ "$kak_opt_filetype" = "cpreprocessor" ]; then additional_keybindings="--expect alt-d --expect alt-h"; additional_message=$kak_opt_fzf_tag_cpreprocessor ; fi
    if [ "$kak_opt_filetype" = "css" ]; then additional_keybindings="--expect alt-c --expect alt-s --expect alt-i"; additional_message=$kak_opt_fzf_tag_css ; fi
    if [ "$kak_opt_filetype" = "csharp" ]; then additional_keybindings="--expect alt-c --expect alt-d --expect alt-e --expect alt-E --expect alt-f --expect alt-g --expect alt-i --expect alt-l --expect alt-m --expect alt-n --expect alt-p --expect alt-s --expect alt-t"; additional_message=$kak_opt_fzf_tag_csharp ; fi
    if [ "$kak_opt_filetype" = "ctags" ]; then additional_keybindings="--expect alt-l --expect alt-k"; additional_message=$kak_opt_fzf_tag_ctags ; fi
    if [ "$kak_opt_filetype" = "cobol" ]; then additional_keybindings="--expect alt-p --expect alt-d --expect alt-S --expect alt-f --expect alt-g --expect alt-P --expect alt-s --expect alt-D"; additional_message=$kak_opt_fzf_tag_cobol ; fi
    if [ "$kak_opt_filetype" = "cuda" ]; then additional_keybindings="--expect alt-d --expect alt-e --expect alt-f --expect alt-g --expect alt-h --expect alt-l --expect alt-m --expect alt-p --expect alt-s --expect alt-t --expect alt-u --expect alt-v --expect alt-x --expect alt-z --expect alt-L"; additional_message=$kak_opt_fzf_tag_cuda ; fi
    if [ "$kak_opt_filetype" = "d" ]; then additional_keybindings="--expect alt-a --expect alt-c --expect alt-g --expect alt-e --expect alt-x --expect alt-f --expect alt-i --expect alt-l --expect alt-m --expect alt-X --expect alt-M --expect alt-n --expect alt-p --expect alt-s --expect alt-T --expect alt-u --expect alt-v --expect alt-V"; additional_message=$kak_opt_fzf_tag_d ; fi
    if [ "$kak_opt_filetype" = "diff" ]; then additional_keybindings="--expect alt-m --expect alt-n --expect alt-d --expect alt-h"; additional_message=$kak_opt_fzf_tag_diff ; fi
    if [ "$kak_opt_filetype" = "dtd" ]; then additional_keybindings="--expect alt-E --expect alt-p --expect alt-e --expect alt-a --expect alt-n"; additional_message=$kak_opt_fzf_tag_dtd ; fi
    if [ "$kak_opt_filetype" = "dts" ]; then additional_keybindings="--expect alt-p --expect alt-l --expect alt-r"; additional_message=$kak_opt_fzf_tag_dts ; fi
    if [ "$kak_opt_filetype" = "dosbatch" ]; then additional_keybindings="--expect alt-l --expect alt-v"; additional_message=$kak_opt_fzf_tag_dosbatch ; fi
    if [ "$kak_opt_filetype" = "eiffel" ]; then additional_keybindings="--expect alt-c --expect alt-f --expect alt-l"; additional_message=$kak_opt_fzf_tag_eiffel ; fi
    if [ "$kak_opt_filetype" = "elm" ]; then additional_keybindings="--expect alt-m --expect alt-n --expect alt-p --expect alt-t --expect alt-c --expect alt-a --expect alt-f"; additional_message=$kak_opt_fzf_tag_elm ; fi
    if [ "$kak_opt_filetype" = "erlang" ]; then additional_keybindings="--expect alt-d --expect alt-f --expect alt-m --expect alt-r --expect alt-t"; additional_message=$kak_opt_fzf_tag_erlang ; fi
    if [ "$kak_opt_filetype" = "falcon" ]; then additional_keybindings="--expect alt-c --expect alt-f --expect alt-m --expect alt-v --expect alt-i"; additional_message=$kak_opt_fzf_tag_falcon ; fi
    if [ "$kak_opt_filetype" = "flex" ]; then additional_keybindings="--expect alt-f --expect alt-c --expect alt-m --expect alt-p --expect alt-v --expect alt-x"; additional_message=$kak_opt_fzf_tag_flex ; fi
    if [ "$kak_opt_filetype" = "fortran" ]; then additional_keybindings="--expect alt-b --expect alt-c --expect alt-e --expect alt-E --expect alt-f --expect alt-i --expect alt-k --expect alt-l --expect alt-L --expect alt-m --expect alt-M --expect alt-n --expect alt-N --expect alt-p --expect alt-P --expect alt-s --expect alt-t --expect alt-v --expect alt-S"; additional_message=$kak_opt_fzf_tag_fortran ; fi
    if [ "$kak_opt_filetype" = "fypp" ]; then additional_keybindings="--expect alt-m"; additional_message=$kak_opt_fzf_tag_fypp ; fi
    if [ "$kak_opt_filetype" = "gdbinit" ]; then additional_keybindings="--expect alt-d --expect alt-D --expect alt-t --expect alt-l"; additional_message=$kak_opt_fzf_tag_gdbinit ; fi
    if [ "$kak_opt_filetype" = "go" ]; then additional_keybindings="--expect alt-p --expect alt-f --expect alt-c --expect alt-t --expect alt-v --expect alt-s --expect alt-i --expect alt-m --expect alt-M --expect alt-u --expect alt-P"; additional_message=$kak_opt_fzf_tag_go ; fi
    if [ "$kak_opt_filetype" = "html" ]; then additional_keybindings="--expect alt-a --expect alt-h --expect alt-i --expect alt-j"; additional_message=$kak_opt_fzf_tag_html ; fi
    if [ "$kak_opt_filetype" = "iniconf" ]; then additional_keybindings="--expect alt-s --expect alt-k"; additional_message=$kak_opt_fzf_tag_iniconf ; fi
    if [ "$kak_opt_filetype" = "itcl" ]; then additional_keybindings="--expect alt-c --expect alt-m --expect alt-v --expect alt-C --expect alt-p"; additional_message=$kak_opt_fzf_tag_itcl ; fi
    if [ "$kak_opt_filetype" = "java" ]; then additional_keybindings="--expect alt-a --expect alt-c --expect alt-e --expect alt-f --expect alt-g --expect alt-i --expect alt-l --expect alt-m --expect alt-p"; additional_message=$kak_opt_fzf_tag_java ; fi
    if [ "$kak_opt_filetype" = "javaproperties" ]; then additional_keybindings="--expect alt-k"; additional_message=$kak_opt_fzf_tag_javaproperties ; fi
    if [ "$kak_opt_filetype" = "javascript" ]; then additional_keybindings="--expect alt-f --expect alt-c --expect alt-m --expect alt-p --expect alt-C --expect alt-v --expect alt-g"; additional_message=$kak_opt_fzf_tag_javascript ; fi
    if [ "$kak_opt_filetype" = "json" ]; then additional_keybindings="--expect alt-o --expect alt-a --expect alt-n --expect alt-s --expect alt-b --expect alt-z"; additional_message=$kak_opt_fzf_tag_json ; fi
    if [ "$kak_opt_filetype" = "ldscript" ]; then additional_keybindings="--expect alt-S --expect alt-s --expect alt-v --expect alt-i"; additional_message=$kak_opt_fzf_tag_ldscript ; fi
    if [ "$kak_opt_filetype" = "lisp" ]; then additional_keybindings="--expect alt-f"; additional_message=$kak_opt_fzf_tag_lisp ; fi
    if [ "$kak_opt_filetype" = "lua" ]; then additional_keybindings="--expect alt-f"; additional_message=$kak_opt_fzf_tag_lua ; fi
    if [ "$kak_opt_filetype" = "m4" ]; then additional_keybindings="--expect alt-d --expect alt-I"; additional_message=$kak_opt_fzf_tag_m4 ; fi
    if [ "$kak_opt_filetype" = "man" ]; then additional_keybindings="--expect alt-t --expect alt-s"; additional_message=$kak_opt_fzf_tag_man ; fi
    if [ "$kak_opt_filetype" = "make" ]; then additional_keybindings="--expect alt-m --expect alt-t --expect alt-I"; additional_message=$kak_opt_fzf_tag_make ; fi
    if [ "$kak_opt_filetype" = "markdown" ]; then additional_keybindings="--expect alt-c --expect alt-s --expect alt-S --expect alt-t --expect alt-T --expect alt-u --expect alt-r"; additional_message=$kak_opt_fzf_tag_markdown ; fi
    if [ "$kak_opt_filetype" = "matlab" ]; then additional_keybindings="--expect alt-f --expect alt-v --expect alt-c"; additional_message=$kak_opt_fzf_tag_matlab ; fi
    if [ "$kak_opt_filetype" = "myrddin" ]; then additional_keybindings="--expect alt-f --expect alt-c --expect alt-v --expect alt-t --expect alt-r --expect alt-p"; additional_message=$kak_opt_fzf_tag_myrddin ; fi
    if [ "$kak_opt_filetype" = "objectivec" ]; then additional_keybindings="--expect alt-i --expect alt-I --expect alt-P --expect alt-m --expect alt-c --expect alt-v --expect alt-E --expect alt-f --expect alt-p --expect alt-t --expect alt-s --expect alt-e --expect alt-M"; additional_message=$kak_opt_fzf_tag_objectivec ; fi
    if [ "$kak_opt_filetype" = "oldc++ [disabled]" ]; then additional_keybindings="--expect alt-c --expect alt-d --expect alt-e --expect alt-f --expect alt-g --expect alt-h --expect alt-l --expect alt-m --expect alt-n --expect alt-p --expect alt-s --expect alt-t --expect alt-u --expect alt-v --expect alt-x --expect alt-L"; additional_message=$kak_opt_fzf_tag_oldc++ [disabled] ; fi
    if [ "$kak_opt_filetype" = "oldc [disabled]" ]; then additional_keybindings="--expect alt-c --expect alt-d --expect alt-e --expect alt-f --expect alt-g --expect alt-h --expect alt-l --expect alt-m --expect alt-n --expect alt-p --expect alt-s --expect alt-t --expect alt-u --expect alt-v --expect alt-x --expect alt-L"; additional_message=$kak_opt_fzf_tag_oldc [disabled] ; fi
    if [ "$kak_opt_filetype" = "ocaml" ]; then additional_keybindings="--expect alt-c --expect alt-m --expect alt-M --expect alt-v --expect alt-p --expect alt-t --expect alt-f --expect alt-C --expect alt-r --expect alt-e"; additional_message=$kak_opt_fzf_tag_ocaml ; fi
    if [ "$kak_opt_filetype" = "passwd" ]; then additional_keybindings="--expect alt-u"; additional_message=$kak_opt_fzf_tag_passwd ; fi
    if [ "$kak_opt_filetype" = "pascal" ]; then additional_keybindings="--expect alt-f --expect alt-p"; additional_message=$kak_opt_fzf_tag_pascal ; fi
    if [ "$kak_opt_filetype" = "perl" ]; then additional_keybindings="--expect alt-c --expect alt-f --expect alt-l --expect alt-p --expect alt-s --expect alt-d"; additional_message=$kak_opt_fzf_tag_perl ; fi
    if [ "$kak_opt_filetype" = "perl6" ]; then additional_keybindings="--expect alt-c --expect alt-g --expect alt-m --expect alt-o --expect alt-p --expect alt-r --expect alt-u --expect alt-b --expect alt-s --expect alt-t"; additional_message=$kak_opt_fzf_tag_perl6 ; fi
    if [ "$kak_opt_filetype" = "php" ]; then additional_keybindings="--expect alt-c --expect alt-d --expect alt-f --expect alt-i --expect alt-l --expect alt-n --expect alt-t --expect alt-v --expect alt-a"; additional_message=$kak_opt_fzf_tag_php ; fi
    if [ "$kak_opt_filetype" = "pod" ]; then additional_keybindings="--expect alt-c --expect alt-s --expect alt-S --expect alt-t"; additional_message=$kak_opt_fzf_tag_pod ; fi
    if [ "$kak_opt_filetype" = "protobuf" ]; then additional_keybindings="--expect alt-p --expect alt-m --expect alt-f --expect alt-e --expect alt-g --expect alt-s --expect alt-r"; additional_message=$kak_opt_fzf_tag_protobuf ; fi
    if [ "$kak_opt_filetype" = "puppetmanifest" ]; then additional_keybindings="--expect alt-c --expect alt-d --expect alt-n --expect alt-r --expect alt-v"; additional_message=$kak_opt_fzf_tag_puppetmanifest ; fi
    if [ "$kak_opt_filetype" = "python" ]; then additional_keybindings="--expect alt-c --expect alt-f --expect alt-m --expect alt-v --expect alt-I --expect alt-i --expect alt-x --expect alt-z --expect alt-l"; additional_message=$kak_opt_fzf_tag_python ; fi
    if [ "$kak_opt_filetype" = "pythonloggingconfig" ]; then additional_keybindings="--expect alt-L --expect alt-q"; additional_message=$kak_opt_fzf_tag_pythonloggingconfig ; fi
    if [ "$kak_opt_filetype" = "qemuhx" ]; then additional_keybindings="--expect alt-q --expect alt-i"; additional_message=$kak_opt_fzf_tag_qemuhx ; fi
    if [ "$kak_opt_filetype" = "qtmoc" ]; then additional_keybindings="--expect alt-s --expect alt-S --expect alt-p"; additional_message=$kak_opt_fzf_tag_qtmoc ; fi
    if [ "$kak_opt_filetype" = "r" ]; then additional_keybindings="--expect alt-f --expect alt-l --expect alt-s --expect alt-g --expect alt-v"; additional_message=$kak_opt_fzf_tag_r ; fi
    if [ "$kak_opt_filetype" = "rspec" ]; then additional_keybindings="--expect alt-d --expect alt-c"; additional_message=$kak_opt_fzf_tag_rspec ; fi
    if [ "$kak_opt_filetype" = "rexx" ]; then additional_keybindings="--expect alt-s"; additional_message=$kak_opt_fzf_tag_rexx ; fi
    if [ "$kak_opt_filetype" = "robot" ]; then additional_keybindings="--expect alt-t --expect alt-k --expect alt-v"; additional_message=$kak_opt_fzf_tag_robot ; fi
    if [ "$kak_opt_filetype" = "rpmspec" ]; then additional_keybindings="--expect alt-t --expect alt-m --expect alt-p --expect alt-g"; additional_message=$kak_opt_fzf_tag_rpmspec ; fi
    if [ "$kak_opt_filetype" = "restructuredtext" ]; then additional_keybindings="--expect alt-c --expect alt-s --expect alt-S --expect alt-t --expect alt-T"; additional_message=$kak_opt_fzf_tag_restructuredtext ; fi
    if [ "$kak_opt_filetype" = "ruby" ]; then additional_keybindings="--expect alt-c --expect alt-f --expect alt-m --expect alt-S"; additional_message=$kak_opt_fzf_tag_ruby ; fi
    if [ "$kak_opt_filetype" = "rust" ]; then additional_keybindings="--expect alt-n --expect alt-s --expect alt-i --expect alt-c --expect alt-f --expect alt-g --expect alt-t --expect alt-v --expect alt-M --expect alt-m --expect alt-e --expect alt-P"; additional_message=$kak_opt_fzf_tag_rust ; fi
    if [ "$kak_opt_filetype" = "scheme" ]; then additional_keybindings="--expect alt-f --expect alt-s"; additional_message=$kak_opt_fzf_tag_scheme ; fi
    if [ "$kak_opt_filetype" = "sh" ]; then additional_keybindings="--expect alt-a --expect alt-f --expect alt-s --expect alt-h"; additional_message=$kak_opt_fzf_tag_sh ; fi
    if [ "$kak_opt_filetype" = "slang" ]; then additional_keybindings="--expect alt-f --expect alt-n"; additional_message=$kak_opt_fzf_tag_slang ; fi
    if [ "$kak_opt_filetype" = "sml" ]; then additional_keybindings="--expect alt-e --expect alt-f --expect alt-c --expect alt-s --expect alt-r --expect alt-t --expect alt-v"; additional_message=$kak_opt_fzf_tag_sml ; fi
    if [ "$kak_opt_filetype" = "sql" ]; then additional_keybindings="--expect alt-c --expect alt-d --expect alt-f --expect alt-E --expect alt-l --expect alt-L --expect alt-P --expect alt-p --expect alt-r --expect alt-s --expect alt-t --expect alt-T --expect alt-v --expect alt-i --expect alt-e --expect alt-U --expect alt-R --expect alt-D --expect alt-V --expect alt-n --expect alt-x --expect alt-y --expect alt-z"; additional_message=$kak_opt_fzf_tag_sql ; fi
    if [ "$kak_opt_filetype" = "systemdunit" ]; then additional_keybindings="--expect alt-u"; additional_message=$kak_opt_fzf_tag_systemdunit ; fi
    if [ "$kak_opt_filetype" = "tcl" ]; then additional_keybindings="--expect alt-p --expect alt-n"; additional_message=$kak_opt_fzf_tag_tcl ; fi
    if [ "$kak_opt_filetype" = "tcloo" ]; then additional_keybindings="--expect alt-c --expect alt-m"; additional_message=$kak_opt_fzf_tag_tcloo ; fi
    if [ "$kak_opt_filetype" = "tex" ]; then additional_keybindings="--expect alt-p --expect alt-c --expect alt-s --expect alt-u --expect alt-b --expect alt-P --expect alt-G --expect alt-l --expect alt-i"; additional_message=$kak_opt_fzf_tag_tex ; fi
    if [ "$kak_opt_filetype" = "ttcn" ]; then additional_keybindings="--expect alt-M --expect alt-t --expect alt-c --expect alt-d --expect alt-f --expect alt-s --expect alt-C --expect alt-a --expect alt-G --expect alt-P --expect alt-v --expect alt-T --expect alt-p --expect alt-m --expect alt-e"; additional_message=$kak_opt_fzf_tag_ttcn ; fi
    if [ "$kak_opt_filetype" = "vera" ]; then additional_keybindings="--expect alt-c --expect alt-d --expect alt-e --expect alt-f --expect alt-g --expect alt-i --expect alt-l --expect alt-m --expect alt-p --expect alt-P --expect alt-s --expect alt-t --expect alt-T --expect alt-v --expect alt-x --expect alt-h"; additional_message=$kak_opt_fzf_tag_vera ; fi
    if [ "$kak_opt_filetype" = "verilog" ]; then additional_keybindings="--expect alt-c --expect alt-e --expect alt-f --expect alt-m --expect alt-n --expect alt-p --expect alt-r --expect alt-t --expect alt-b"; additional_message=$kak_opt_fzf_tag_verilog ; fi
    if [ "$kak_opt_filetype" = "systemverilog" ]; then additional_keybindings="--expect alt-c --expect alt-e --expect alt-f --expect alt-m --expect alt-n --expect alt-p --expect alt-r --expect alt-t --expect alt-b --expect alt-A --expect alt-C --expect alt-V --expect alt-E --expect alt-I --expect alt-M --expect alt-K --expect alt-P --expect alt-Q --expect alt-R --expect alt-S --expect alt-T"; additional_message=$kak_opt_fzf_tag_systemverilog ; fi
    if [ "$kak_opt_filetype" = "vhdl" ]; then additional_keybindings="--expect alt-c --expect alt-t --expect alt-T --expect alt-r --expect alt-e --expect alt-C --expect alt-d --expect alt-f --expect alt-p --expect alt-P --expect alt-l"; additional_message=$kak_opt_fzf_tag_vhdl ; fi
    if [ "$kak_opt_filetype" = "vim" ]; then additional_keybindings="--expect alt-a --expect alt-c --expect alt-f --expect alt-m --expect alt-v --expect alt-n"; additional_message=$kak_opt_fzf_tag_vim ; fi
    if [ "$kak_opt_filetype" = "windres" ]; then additional_keybindings="--expect alt-d --expect alt-m --expect alt-i --expect alt-b --expect alt-c --expect alt-f --expect alt-v --expect alt-a"; additional_message=$kak_opt_fzf_tag_windres ; fi
    if [ "$kak_opt_filetype" = "yacc" ]; then additional_keybindings="--expect alt-l"; additional_message=$kak_opt_fzf_tag_yacc ; fi
    if [ "$kak_opt_filetype" = "yumrepo" ]; then additional_keybindings="--expect alt-r"; additional_message=$kak_opt_fzf_tag_yumrepo ; fi
    if [ "$kak_opt_filetype" = "zephir" ]; then additional_keybindings="--expect alt-c --expect alt-d --expect alt-f --expect alt-i --expect alt-l --expect alt-n --expect alt-t --expect alt-v --expect alt-a"; additional_message=$kak_opt_fzf_tag_zephir ; fi
    if [ "$kak_opt_filetype" = "dbusintrospect" ]; then additional_keybindings="--expect alt-i --expect alt-m --expect alt-s --expect alt-p"; additional_message=$kak_opt_fzf_tag_dbusintrospect ; fi
    if [ "$kak_opt_filetype" = "glade" ]; then additional_keybindings="--expect alt-i --expect alt-c --expect alt-h"; additional_message=$kak_opt_fzf_tag_glade ; fi
    if [ "$kak_opt_filetype" = "maven2" ]; then additional_keybindings="--expect alt-g --expect alt-a --expect alt-p --expect alt-r"; additional_message=$kak_opt_fzf_tag_maven2 ; fi
    if [ "$kak_opt_filetype" = "plistxml" ]; then additional_keybindings="--expect alt-k"; additional_message=$kak_opt_fzf_tag_plistxml ; fi
    if [ "$kak_opt_filetype" = "relaxng" ]; then additional_keybindings="--expect alt-e --expect alt-a --expect alt-n"; additional_message=$kak_opt_fzf_tag_relaxng ; fi
    if [ "$kak_opt_filetype" = "svg" ]; then additional_keybindings="--expect alt-i"; additional_message=$kak_opt_fzf_tag_svg ; fi
    if [ "$kak_opt_filetype" = "xslt" ]; then additional_keybindings="--expect alt-s --expect alt-p --expect alt-m --expect alt-n --expect alt-v"; additional_message=$kak_opt_fzf_tag_xslt ; fi
    if [ "$kak_opt_filetype" = "yaml" ]; then additional_keybindings="--expect alt-a"; additional_message=$kak_opt_fzf_tag_yaml ; fi
    if [ "$kak_opt_filetype" = "ansibleplaybook" ]; then additional_keybindings="--expect alt-p"; additional_message=$kak_opt_fzf_tag_ansibleplaybook ; fi
    echo "info -title '$title' '$message'"
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    eval echo 'fzf \"ctags-search \$1\" \"$cmd\" \"--expect ctrl-w $additional_flags\"'
}}

nop %sh{
}
