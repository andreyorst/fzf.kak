# ╭─────────────╥──────────────────────────╮
# │ Author:     ║ File:                    │
# │ Andrey Orst ║ fzf-ctags.kak            │
# ╞═════════════╩══════════════════════════╡
# │ Module for searching tags with fzf     │
# │ and universal-ctags for fzf.kak plugin │
# ╞════════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak          │
# ╰────────────────────────────────────────╯

declare-option -docstring "command to provide list of ctags to fzf. Arguments are supported
Supported tools:
    <package>:       <value>:
    universal-ctags: ""readtags""

Default arguments:
    ""readtags -l | cut -f1""
" \
str fzf_tag_command "readtags"

declare-option -docstring "file that should be used by fzf-tag to provide tags.
Default value: tags" \
str fzf_tag_file "tags"

map global fzf -docstring "find tag" 't' '<esc>: fzf-tag<ret>'

# this huge try block defines filetype aware filter mappings for separate fzf-ctags mode
try %{
    declare-user-mode fzf-ctags

    map global fzf -docstring "select tag type" '<a-t>' '<esc>: enter-user-mode fzf-ctags<ret>'

    hook global WinSetOption filetype=ada %{
        map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'package specifications'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'packages'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'types'
        map global fzf-ctags 'u'     ': fzf-tag u<ret>' -docstring 'subtypes'
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'record type components'
        map global fzf-ctags 'l'     ': fzf-tag l<ret>' -docstring 'enum type literals'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'variables'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'generic formal parameters'
        map global fzf-ctags 'n'     ': fzf-tag n<ret>' -docstring 'constants'
        map global fzf-ctags 'x'     ': fzf-tag x<ret>' -docstring 'user defined exceptions'
        map global fzf-ctags '<a-r>' ': fzf-tag R<ret>' -docstring 'subprogram specifications'
        map global fzf-ctags 'r'     ': fzf-tag r<ret>' -docstring 'subprograms'
        map global fzf-ctags '<a-k>' ': fzf-tag K<ret>' -docstring 'task specifications'
        map global fzf-ctags 'k'     ': fzf-tag k<ret>' -docstring 'tasks'
        map global fzf-ctags '<a-o>' ': fzf-tag O<ret>' -docstring 'protected data specifications'
        map global fzf-ctags 'o'     ': fzf-tag o<ret>' -docstring 'protected data'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'task/protected data entries'
        map global fzf-ctags 'b'     ': fzf-tag b<ret>' -docstring 'labels'
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'loop/declare identifiers'
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring '(ctags internal use)'
    }
    hook global WinSetOption filetype=ant %{
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'projects'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'targets'
        map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'properties(global)'
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'antfiles'
    }
    hook global WinSetOption filetype=asciidoc %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'chapters'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'sections'
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'level 2 sections'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'level 3 sections'
        map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'level 4 sections'
        map global fzf-ctags 'u'     ': fzf-tag u<ret>' -docstring 'level 5 sections'
        map global fzf-ctags 'a'     ': fzf-tag a<ret>' -docstring 'anchors'
    }
    hook global WinSetOption filetype=asm %{
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'defines'
        map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'labels'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'macros'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'types (structs and records)'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'sections'
    }
    hook global WinSetOption filetype=asp %{
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'constants'
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'subroutines'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
    }
    hook global WinSetOption filetype=autoconf %{
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'templates'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'autoconf macros'
        map global fzf-ctags 'w' ': fzf-tag w<ret>' -docstring 'options specified with --with-...'
        map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'options specified with --enable-...'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'substitution keys'
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'automake conditions'
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'definitions'
    }
    hook global WinSetOption filetype=autoit %{
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'r'     ': fzf-tag r<ret>' -docstring 'regions'
        map global fzf-ctags 'g'     ': fzf-tag g<ret>' -docstring 'global variables'
        map global fzf-ctags 'l'     ': fzf-tag l<ret>' -docstring 'local variables'
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'included scripts'
    }
    hook global WinSetOption filetype=automake %{
        map global fzf-ctags 'd'     ': fzf-tag d<ret>' -docstring 'directories'
        map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'programs'
        map global fzf-ctags '<a-m>' ': fzf-tag M<ret>' -docstring 'manuals'
        map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'ltlibraries'
        map global fzf-ctags '<a-l>' ': fzf-tag L<ret>' -docstring 'libraries'
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'scripts'
        map global fzf-ctags '<a-d>' ': fzf-tag D<ret>' -docstring 'datum'
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'conditions'
    }
    hook global WinSetOption filetype=awk %{
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
    }
    hook global WinSetOption filetype=basic %{
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'constants'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'labels'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'types'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
        map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'enumerations'
    }
    hook global WinSetOption filetype=beta %{
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'fragment definitions'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'slots (fragment uses)'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'patterns (virtual or rebound)'
    }
    hook global WinSetOption filetype=clojure %{
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'namespaces'
    }
    hook global WinSetOption filetype=cmake %{
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'macros'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'targets'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'variable definitions'
        map global fzf-ctags '<a-d>' ': fzf-tag D<ret>' -docstring 'options specified with -<a-d>'
        map global fzf-ctags 'p'     ': fzf-tag P<ret>' -docstring 'projects'
        map global fzf-ctags 'r'     ': fzf-tag r<ret>' -docstring 'regex'
    }
    hook global WinSetOption filetype=c %{
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'macro definitions'
        map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'enumerators (values inside an enumeration)'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'function definitions'
        map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'enumeration names'
        map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'included header files'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'struct, and union members'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'structure names'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'typedefs'
        map global fzf-ctags 'u' ': fzf-tag u<ret>' -docstring 'union names'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variable definitions'
    }
    hook global WinSetOption filetype=cpp %{
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'macro definitions'
        map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'enumerators (values inside an enumeration)'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'function definitions'
        map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'enumeration names'
        map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'included header files'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'class, struct, and union members'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'structure names'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'typedefs'
        map global fzf-ctags 'u' ': fzf-tag u<ret>' -docstring 'union names'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variable definitions'
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'namespaces'
    }
    hook global WinSetOption filetype=cpreprocessor %{
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'macro definitions'
        map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'included header files'
    }
    hook global WinSetOption filetype=css %{
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'selectors'
        map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'identities'
    }
    hook global WinSetOption filetype=csharp %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'd'     ': fzf-tag d<ret>' -docstring 'macro definitions'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'enumerators (values inside an enumeration)'
        map global fzf-ctags '<a-e>' ': fzf-tag E<ret>' -docstring 'events'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'fields'
        map global fzf-ctags 'g'     ': fzf-tag g<ret>' -docstring 'enumeration names'
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'interfaces'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'methods'
        map global fzf-ctags 'n'     ': fzf-tag n<ret>' -docstring 'namespaces'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'properties'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'structure names'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'typedefs'
    }
    hook global WinSetOption filetype=ctags %{
        map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'language definitions'
        map global fzf-ctags 'k' ': fzf-tag k<ret>' -docstring 'kind definitions'
    }
    hook global WinSetOption filetype=cobol %{
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'paragraphs'
        map global fzf-ctags 'd'     ': fzf-tag d<ret>' -docstring 'data items'
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'source code file'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'file descriptions (f<a-d>, <a-s><a-d>, <a-r><a-d>)'
        map global fzf-ctags 'g'     ': fzf-tag G<ret>' -docstring 'group items'
        map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'program ids'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'sections'
        map global fzf-ctags '<a-d>' ': fzf-tag D<ret>' -docstring 'divisions'
    }
    hook global WinSetOption filetype=cuda %{
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'macro definitions'
        map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'enumerators (values inside an enumeration)'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'function definitions'
        map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'enumeration names'
        map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'included header files'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'struct, and union members'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'structure names'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'typedefs'
        map global fzf-ctags 'u' ': fzf-tag u<ret>' -docstring 'union names'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variable definitions'
    }
    hook global WinSetOption filetype=d %{
        map global fzf-ctags 'a'     ': fzf-tag a<ret>' -docstring 'aliases'
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'g'     ': fzf-tag g<ret>' -docstring 'enumeration names'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'enumerators (values inside an enumeration)'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'function definitions'
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'interfaces'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'class, struct, and union members'
        map global fzf-ctags '<a-x>' ': fzf-tag X<ret>' -docstring 'mixins'
        map global fzf-ctags '<a-m>' ': fzf-tag M<ret>' -docstring 'modules'
        map global fzf-ctags 'n'     ': fzf-tag n<ret>' -docstring 'namespaces'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'structure names'
        map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'templates'
        map global fzf-ctags 'u'     ': fzf-tag u<ret>' -docstring 'union names'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'variable definitions'
        map global fzf-ctags '<a-v>' ': fzf-tag V<ret>' -docstring 'version statements'
    }
    hook global WinSetOption filetype=diff %{
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'modified files'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'newly created files'
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'deleted files'
        map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'hunks'
    }
    hook global WinSetOption filetype=dtd %{
        map global fzf-ctags '<a-e>' ': fzf-tag E<ret>' -docstring 'entities'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'parameter entities'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'elements'
        map global fzf-ctags 'a'     ': fzf-tag a<ret>' -docstring 'attributes'
        map global fzf-ctags 'n'     ': fzf-tag n<ret>' -docstring 'notations'
    }
    hook global WinSetOption filetype=dts %{
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'phandlers'
        map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'labels'
        map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'regex'
    }
    hook global WinSetOption filetype=dosbatch %{
        map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'labels'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
    }
    hook global WinSetOption filetype=eiffel %{
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'features'
    }
    hook global WinSetOption filetype=elm %{
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'module'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'renamed <a-i>mported <a-m>odule'
        map global fzf-ctags 'p' ': fzf-tag P<ret>' -docstring 'port'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'type <a-d>efinition'
        map global fzf-ctags 'c' ': fzf-tag C<ret>' -docstring 'type <a-c>onstructor'
        map global fzf-ctags 'a' ': fzf-tag A<ret>' -docstring 'type <a-a>lias'
        map global fzf-ctags 'f' ': fzf-tag F<ret>' -docstring 'functions'
    }
    hook global WinSetOption filetype=erlang %{
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'macro definitions'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'modules'
        map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'record definitions'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'type definitions'
    }
    hook global WinSetOption filetype=falcon %{
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'class members'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
        map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'imports'
    }
    hook global WinSetOption filetype=flex %{
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'methods'
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'properties'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'global variables'
        map global fzf-ctags 'x' ': fzf-tag x<ret>' -docstring 'mxtags'
    }
    hook global WinSetOption filetype=fortran %{
        map global fzf-ctags 'b'     ': fzf-tag b<ret>' -docstring 'block data'
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'common blocks'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'entry points'
        map global fzf-ctags '<a-e>' ': fzf-tag E<ret>' -docstring 'enumerations'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'interface contents, generic names, and operators'
        map global fzf-ctags 'k'     ': fzf-tag k<ret>' -docstring 'type and structure components'
        map global fzf-ctags 'l'     ': fzf-tag l<ret>' -docstring 'labels'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'modules'
        map global fzf-ctags '<a-m>' ': fzf-tag M<ret>' -docstring 'type bound procedures'
        map global fzf-ctags 'n'     ': fzf-tag n<ret>' -docstring 'namelists'
        map global fzf-ctags '<a-n>' ': fzf-tag N<ret>' -docstring 'enumeration values'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'programs'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'subroutines'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'derived types and structures'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'program (global) and module variables'
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'submodules'
    }
    hook global WinSetOption filetype=fypp %{
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'macros'
    }
    hook global WinSetOption filetype=gdbinit %{
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'definitions'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'toplevel variables'
    }
    hook global WinSetOption filetype=go %{
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'packages'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'constants'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'types'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'variables'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'structs'
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'interfaces'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'struct members'
        map global fzf-ctags '<a-m>' ': fzf-tag M<ret>' -docstring 'struct anonymous members'
        map global fzf-ctags 'u'     ': fzf-tag u<ret>' -docstring 'unknown'
        map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'name for specifying imported package'
    }
    hook global WinSetOption filetype=html %{
        map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'named anchors'
        map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'h1 headings'
        map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'h2 headings'
        map global fzf-ctags 'j' ': fzf-tag j<ret>' -docstring 'h3 headings'
    }
    hook global WinSetOption filetype=iniconf %{
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'sections'
        map global fzf-ctags 'k' ': fzf-tag k<ret>' -docstring 'keys'
    }
    hook global WinSetOption filetype=itcl %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'methods'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'object-specific variables'
        map global fzf-ctags '<a-c>' ': fzf-tag C<ret>' -docstring 'common variables'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'procedures within the  class  namespace'
    }
    hook global WinSetOption filetype=java %{
        map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'annotation declarations'
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'enum constants'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'fields'
        map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'enum types'
        map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'interfaces'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'methods'
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
    }
    hook global WinSetOption filetype=javaproperties %{
        map global fzf-ctags 'k' ': fzf-tag k<ret>' -docstring 'keys'
    }
    hook global WinSetOption filetype=javascript %{
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'methods'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'properties'
        map global fzf-ctags '<a-c>' ': fzf-tag C<ret>' -docstring 'constants'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'global variables'
        map global fzf-ctags 'g'     ': fzf-tag g<ret>' -docstring 'generators'
    }
    hook global WinSetOption filetype=json %{
        map global fzf-ctags 'o' ': fzf-tag o<ret>' -docstring 'objects'
        map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'arrays'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'numbers'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'strings'
        map global fzf-ctags 'b' ': fzf-tag b<ret>' -docstring 'booleans'
        map global fzf-ctags 'z' ': fzf-tag z<ret>' -docstring 'nulls'
    }
    hook global WinSetOption filetype=ldscript %{
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'sections'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'symbols'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'versions'
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'input sections'
    }
    hook global WinSetOption filetype=lisp %{
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
    }
    hook global WinSetOption filetype=lua %{
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
    }
    hook global WinSetOption filetype=m4 %{
        map global fzf-ctags 'd'     ': fzf-tag d<ret>' -docstring 'macros'
        map global fzf-ctags '<a-i>' ': fzf-tag I<ret>' -docstring 'macro files'
    }
    hook global WinSetOption filetype=man %{
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'titles'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'sections'
    }
    hook global WinSetOption filetype=make %{
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'macros'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'targets'
        map global fzf-ctags '<a-i>' ': fzf-tag I<ret>' -docstring 'makefiles'
    }
    hook global WinSetOption filetype=markdown %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'chapsters'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'sections'
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'subsections'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'subsubsections'
        map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'level 4 subsections'
        map global fzf-ctags 'u'     ': fzf-tag u<ret>' -docstring 'level 5 subsections'
        map global fzf-ctags 'r'     ': fzf-tag r<ret>' -docstring 'regex'
    }
    hook global WinSetOption filetype=matlab %{
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'function'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variable'
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'class'
    }
    hook global WinSetOption filetype=myrddin %{
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'constants'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'types'
        map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'traits'
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
    }
    hook global WinSetOption filetype=objectivec %{
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'class interface'
        map global fzf-ctags '<a-i>' ': fzf-tag I<ret>' -docstring 'class implementation'
        map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring '<a-p>rotocol'
        map global fzf-ctags 'm'     ': fzf-tag M<ret>' -docstring 'object's method'
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'class' method'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'global variable'
        map global fzf-ctags '<a-e>' ': fzf-tag E<ret>' -docstring '<a-o>bject field'
        map global fzf-ctags 'f'     ': fzf-tag F<ret>' -docstring 'a function'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'a property'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'a type alias'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'a type structure'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'an enumeration'
        map global fzf-ctags '<a-m>' ': fzf-tag M<ret>' -docstring '<a-a> preprocessor macro'
    }
    hook global WinSetOption filetype=ocaml %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'object's method'
        map global fzf-ctags '<a-m>' ': fzf-tag M<ret>' -docstring '<a-m>odule or functor'
        map global fzf-ctags 'v'     ': fzf-tag V<ret>' -docstring 'global variable'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'signature item'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'type name'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'a function'
        map global fzf-ctags '<a-c>' ': fzf-tag C<ret>' -docstring '<a-a> constructor'
        map global fzf-ctags 'r'     ': fzf-tag R<ret>' -docstring 'a 'structure' field'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'an exception'
    }
    hook global WinSetOption filetype=passwd %{
        map global fzf-ctags 'u' ': fzf-tag u<ret>' -docstring 'user names'
    }
    hook global WinSetOption filetype=pascal %{
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'procedures'
    }
    hook global WinSetOption filetype=perl %{
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'constants'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'formats'
        map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'labels'
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'subroutines'
    }
    hook global WinSetOption filetype=perl6 %{
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'grammars'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'methods'
        map global fzf-ctags 'o' ': fzf-tag o<ret>' -docstring 'modules'
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
        map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'roles'
        map global fzf-ctags 'u' ': fzf-tag u<ret>' -docstring 'rules'
        map global fzf-ctags 'b' ': fzf-tag b<ret>' -docstring 'submethods'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'subroutines'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'tokens'
    }
    hook global WinSetOption filetype=php %{
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'constant definitions'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'interfaces'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'namespaces'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'traits'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
        map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'aliases'
    }
    hook global WinSetOption filetype=pod %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'chapters'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'sections'
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'subsections'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'subsubsections'
    }
    hook global WinSetOption filetype=protobuf %{
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'messages'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'fields'
        map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'enum constants'
        map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'enum types'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'services'
    }
    hook global WinSetOption filetype=puppetmanifest %{
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'definitions'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'nodes'
        map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'resources'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
    }
    hook global WinSetOption filetype=python %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'class members'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'variables'
        map global fzf-ctags '<a-i>' ': fzf-tag I<ret>' -docstring 'name referring a module defined in other file'
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'modules'
        map global fzf-ctags 'x'     ': fzf-tag x<ret>' -docstring 'name referring a class/variable/function/module defined in other module'
    }
    hook global WinSetOption filetype=pythonloggingconfig %{
        map global fzf-ctags '<a-l>' ': fzf-tag L<ret>' -docstring 'logger sections'
        map global fzf-ctags 'q'     ': fzf-tag q<ret>' -docstring 'logger qualnames'
    }
    hook global WinSetOption filetype=qemuhx %{
        map global fzf-ctags 'q' ': fzf-tag q<ret>' -docstring 'q<a-e><a-m><a-u> <a-m>anagement <a-p>rotocol dispatch table entries'
        map global fzf-ctags 'i' ': fzf-tag I<ret>' -docstring 'item in texinfo doc'
    }
    hook global WinSetOption filetype=qtmoc %{
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'slots'
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'signals'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'properties'
    }
    hook global WinSetOption filetype=r %{
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'libraries'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'sources'
        map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'global variables'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'function variables'
    }
    hook global WinSetOption filetype=rspec %{
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'describes'
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'contexts'
    }
    hook global WinSetOption filetype=rexx %{
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'subroutines'
    }
    hook global WinSetOption filetype=robot %{
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'testcases'
        map global fzf-ctags 'k' ': fzf-tag k<ret>' -docstring 'keywords'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
    }
    hook global WinSetOption filetype=rpmspec %{
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'tags'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'macros'
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
        map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'global macros'
    }
    hook global WinSetOption filetype=restructuredtext %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'chapters'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'sections'
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'subsections'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'subsubsections'
        map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'targets'
    }
    hook global WinSetOption filetype=ruby %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'methods'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'modules'
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'singleton methods'
    }
    hook global WinSetOption filetype=rust %{
        map global fzf-ctags 'n'     ': fzf-tag n<ret>' -docstring 'module'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'structural type'
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'trait interface'
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'implementation'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'function'
        map global fzf-ctags 'g'     ': fzf-tag g<ret>' -docstring 'enum'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'type <a-a>lias'
        map global fzf-ctags 'v'     ': fzf-tag V<ret>' -docstring 'global variable'
        map global fzf-ctags '<a-m>' ': fzf-tag M<ret>' -docstring '<a-m>acro <a-d>efinition'
        map global fzf-ctags 'm'     ': fzf-tag M<ret>' -docstring 'a struct field'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'an enum variant'
        map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring '<a-a> method'
    }
    hook global WinSetOption filetype=scheme %{
        map global fzf-ctags 'f' ': fzf-tag F<ret>' -docstring 'functions'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'sets'
    }
    hook global WinSetOption filetype=sh %{
        map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'aliases'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'script files'
        map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'label for here document'
    }
    hook global WinSetOption filetype=slang %{
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'namespaces'
    }
    hook global WinSetOption filetype=sml %{
        map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'exception declarations'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'function definitions'
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'functor definitions'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'signature declarations'
        map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'structure declarations'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'type definitions'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'value bindings'
    }
    hook global WinSetOption filetype=sql %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'cursors'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags '<a-e>' ': fzf-tag E<ret>' -docstring 'record fields'
        map global fzf-ctags '<a-l>' ': fzf-tag L<ret>' -docstring 'block label'
        map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'packages'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'procedures'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'subtypes'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'tables'
        map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'triggers'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'variables'
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'indexes'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'events'
        map global fzf-ctags '<a-u>' ': fzf-tag U<ret>' -docstring 'publications'
        map global fzf-ctags '<a-r>' ': fzf-tag R<ret>' -docstring 'services'
        map global fzf-ctags '<a-d>' ': fzf-tag D<ret>' -docstring 'domains'
        map global fzf-ctags '<a-v>' ': fzf-tag V<ret>' -docstring 'views'
        map global fzf-ctags 'n'     ': fzf-tag n<ret>' -docstring 'synonyms'
        map global fzf-ctags 'x'     ': fzf-tag x<ret>' -docstring 'mobi<a-l>ink <a-t>able <a-s>cripts'
        map global fzf-ctags 'y'     ': fzf-tag Y<ret>' -docstring 'mobi<a-l>ink <a-c>onn <a-s>cripts'
        map global fzf-ctags 'z'     ': fzf-tag Z<ret>' -docstring 'mobi<a-l>ink <a-p>roperties '
    }
    hook global WinSetOption filetype=systemdunit %{
        map global fzf-ctags 'u' ': fzf-tag U<ret>' -docstring 'units'
    }
    hook global WinSetOption filetype=tcl %{
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'procedures'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'namespaces'
    }
    hook global WinSetOption filetype=tcloo %{
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'methods'
    }
    hook global WinSetOption filetype=tex %{
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'parts'
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'chapters'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'sections'
        map global fzf-ctags 'u'     ': fzf-tag u<ret>' -docstring 'subsections'
        map global fzf-ctags 'b'     ': fzf-tag b<ret>' -docstring 'subsubsections'
        map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'paragraphs'
        map global fzf-ctags '<a-g>' ': fzf-tag G<ret>' -docstring 'subparagraphs'
        map global fzf-ctags 'l'     ': fzf-tag l<ret>' -docstring 'labels'
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'includes'
    }
    hook global WinSetOption filetype=ttcn %{
        map global fzf-ctags '<a-m>' ': fzf-tag M<ret>' -docstring 'module definition'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'type definition'
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'constant definition'
        map global fzf-ctags 'd'     ': fzf-tag d<ret>' -docstring 'template definition'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'function definition'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'signature definition'
        map global fzf-ctags '<a-c>' ': fzf-tag C<ret>' -docstring 'testcase definition'
        map global fzf-ctags 'a'     ': fzf-tag a<ret>' -docstring 'altstep definition'
        map global fzf-ctags '<a-g>' ': fzf-tag G<ret>' -docstring 'group definition'
        map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'module parameter definition'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'variable instance'
        map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'timer instance'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'port instance'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'record/set/union member'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'enumeration value'
    }
    hook global WinSetOption filetype=vera %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'd'     ': fzf-tag d<ret>' -docstring 'macro definitions'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'enumerators (values inside an enumeration)'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'function definitions'
        map global fzf-ctags 'g'     ': fzf-tag g<ret>' -docstring 'enumeration names'
        map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'interfaces'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'class, struct, and union members'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'programs'
        map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'signals'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'tasks'
        map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'typedefs'
        map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'variable definitions'
        map global fzf-ctags 'h'     ': fzf-tag h<ret>' -docstring 'included header files'
    }
    hook global WinSetOption filetype=verilog %{
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'constants (define, parameter, specparam)'
        map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'events'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'modules'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'net data types'
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'ports'
        map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'register data types'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'tasks'
        map global fzf-ctags 'b' ': fzf-tag b<ret>' -docstring 'blocks'
    }
    hook global WinSetOption filetype=systemverilog %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'constants (define, parameter, specparam, enum values)'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'events'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'modules'
        map global fzf-ctags 'n'     ': fzf-tag n<ret>' -docstring 'net data types'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'ports'
        map global fzf-ctags 'r'     ': fzf-tag r<ret>' -docstring 'register data types'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'tasks'
        map global fzf-ctags 'b'     ': fzf-tag b<ret>' -docstring 'blocks'
        map global fzf-ctags '<a-a>' ': fzf-tag A<ret>' -docstring 'assertions'
        map global fzf-ctags '<a-c>' ': fzf-tag C<ret>' -docstring 'classes'
        map global fzf-ctags '<a-v>' ': fzf-tag V<ret>' -docstring 'covergroups'
        map global fzf-ctags '<a-e>' ': fzf-tag E<ret>' -docstring 'enumerators'
        map global fzf-ctags '<a-i>' ': fzf-tag I<ret>' -docstring 'interfaces'
        map global fzf-ctags '<a-m>' ': fzf-tag M<ret>' -docstring 'modports'
        map global fzf-ctags '<a-k>' ': fzf-tag K<ret>' -docstring 'packages'
        map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'programs'
        map global fzf-ctags '<a-r>' ': fzf-tag R<ret>' -docstring 'properties'
        map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'structs and unions'
        map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'type declarations'
    }
    hook global WinSetOption filetype=vhdl %{
        map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'constant declarations'
        map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'type definitions'
        map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'subtype definitions'
        map global fzf-ctags 'r'     ': fzf-tag r<ret>' -docstring 'record names'
        map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'entity declarations'
        map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'function prototypes and declarations'
        map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'procedure prototypes and declarations'
        map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'package definitions'
    }
    hook global WinSetOption filetype=vim %{
        map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'autocommand groups'
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'user-defined commands'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'function definitions'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'maps'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variable definitions'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'vimball filename'
    }
    hook global WinSetOption filetype=windres %{
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'dialogs'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'menus'
        map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'icons'
        map global fzf-ctags 'b' ': fzf-tag b<ret>' -docstring 'bitmaps'
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'cursors'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'fonts'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'versions'
        map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'accelerators'
    }
    hook global WinSetOption filetype=yacc %{
        map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'labels'
    }
    hook global WinSetOption filetype=yumrepo %{
        map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'repository id'
    }
    hook global WinSetOption filetype=zephir %{
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'constant definitions'
        map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
        map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'interfaces'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'namespaces'
        map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'traits'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
        map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'aliases'
    }
    hook global WinSetOption filetype=dbusintrospect %{
        map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'interfaces'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'methods'
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'signals'
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'properties'
    }
    hook global WinSetOption filetype=glade %{
        map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'identifiers'
        map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
        map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'handlers'
    }
    hook global WinSetOption filetype=maven2 %{
        map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'group identifiers'
        map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'artifact identifiers'
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'properties'
        map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'repository identifiers'
    }
    hook global WinSetOption filetype=plistxml %{
        map global fzf-ctags 'k' ': fzf-tag k<ret>' -docstring 'keys'
    }
    hook global WinSetOption filetype=relaxng %{
        map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'elements'
        map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'attributes'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'named patterns'
    }
    hook global WinSetOption filetype=svg %{
        map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'id attributes'
    }
    hook global WinSetOption filetype=xslt %{
        map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'stylesheets'
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'parameters'
        map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'matched template'
        map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'matched template'
        map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
    }
    hook global WinSetOption filetype=yaml %{
        map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'anchors'
    }
    hook global WinSetOption filetype=ansibleplaybook %{
        map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'plays'
    }
} catch %{
    echo -debug "Error while declaring 'fzf-ctags' mode"
}

define-command -hidden fzf-tag -params ..2 %{ evaluate-commands %sh{
    path=$PWD
    while [ "$path" != "$HOME" ]; do
        if [ -e "./$kak_opt_fzf_tag_file" ]; then
            break
        else
            cd ..
            path=$PWD
        fi
    done

    if [ "$path" = "$HOME" ] && [ ! -e "./$kak_opt_fzf_tag_file" ]; then
        printf "%s\n" "echo -markup %{{Information}No '$kak_opt_fzf_tag_file' file found}"
        exit
    elif [ "$path" = "$HOME" ] && [ -e "./$kak_opt_fzf_tag_file" ]; then
        printf "%s\n" "echo -markup %{{Information}'$kak_opt_fzf_tag_file' file found at $HOME. Check if it is right tag file}"
    fi

    if [ -n "$1" ]; then
        cmd="cd $path; readtags -Q '(eq? \$kind \"$1\")' -l | cut -f1"
    else
        cmd="cd $path; readtags -l | cut -f1"
    fi

    message="Jump to a symbol''s definition
<ret>: open tag in new buffer
<c-w>: open tag in new window"

    [ -n "${kak_client_env_TMUX}" ] && tmux_keybindings="
<c-s>: open tag in horizontal split
<c-v>: open tag in vertical split"

    printf "%s\n" "info -title 'fzf tag' '$message$tmux_keybindings'"

    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    printf "%s\n" "set-option -add window ctagsfiles %{$path/$kak_opt_fzf_tag_file}"
    printf "%s\n" "fzf %{ctags-search} %{$cmd | awk '!a[\$0]++'} %{--expect ctrl-w $additional_flags}"
}}
