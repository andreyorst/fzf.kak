# Author: Andrey Listopadov
# Module for searching tags with fzf and universal-ctags for fzf.kak plugin
# https://github.com/andreyorst/fzf.kak

hook global ModuleLoaded fzf %{
    map global fzf -docstring "find tag" 't' '<esc>: require-module fzf-ctags; fzf-tag<ret>'
}

provide-module fzf-ctags %§

declare-option -docstring "file that should be used by fzf-tag to provide tags.
Default value: tags" \
str fzf_tag_file_name "tags"


declare-option -hidden bool fzf_tag_filters_defined false

try %{
    declare-user-mode fzf-ctags
    map global fzf -docstring "select tag type" '<a-t>' '<esc>: fzf-setup-filter-tags; enter-user-mode fzf-ctags<ret>'
}

# this huge try block defines filetype aware filter mappings for separate fzf-ctags mode
define-command -hidden fzf-setup-filter-tags %{
    evaluate-commands %sh{
        [ "${kak_opt_fzf_tag_filters_defined:-}" = "true" ] && exit

        case ${kak_opt_filetype:-} in
            (ada) printf "%s\n" "
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
                map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'loop/set identifers'
                map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring '(ctags internal use)'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (ant) printf "%s\n" "
                map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'projects'
                map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'targets'
                map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'properties(global)'
                map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'antfiles'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (asciidoc) printf "%s\n" "
                map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'chapters'
                map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'sections'
                map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'level 2 sections'
                map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'level 3 sections'
                map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'level 4 sections'
                map global fzf-ctags 'u'     ': fzf-tag u<ret>' -docstring 'level 5 sections'
                map global fzf-ctags 'a'     ': fzf-tag a<ret>' -docstring 'anchors'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (asm) printf "%s\n" "
                map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'defines'
                map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'labels'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'macros'
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'types (structs and records)'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'sections'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (asp) printf "%s\n" "
                map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'constants'
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'subroutines'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (autoconf) printf "%s\n" "
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'templates'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'autoconf macros'
                map global fzf-ctags 'w' ': fzf-tag w<ret>' -docstring 'options specified with --with-...'
                map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'options specified with --enable-...'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'substitution keys'
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'automake conditions'
                map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'definitions'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (autoit) printf "%s\n" "
                map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'r'     ': fzf-tag r<ret>' -docstring 'regions'
                map global fzf-ctags 'g'     ': fzf-tag g<ret>' -docstring 'global variables'
                map global fzf-ctags 'l'     ': fzf-tag l<ret>' -docstring 'local variables'
                map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'included scripts'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (automake) printf "%s\n" "
                map global fzf-ctags 'd'     ': fzf-tag d<ret>' -docstring 'directories'
                map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'programs'
                map global fzf-ctags '<a-m>' ': fzf-tag M<ret>' -docstring 'manuals'
                map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'ltlibraries'
                map global fzf-ctags '<a-l>' ': fzf-tag L<ret>' -docstring 'libraries'
                map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'scripts'
                map global fzf-ctags '<a-d>' ': fzf-tag D<ret>' -docstring 'datum'
                map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'conditions'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (awk) printf "%s\n" "
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (basic) printf "%s\n" "
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'constants'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'labels'
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'types'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
                map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'enumerations'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (beta) printf "%s\n" "
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'fragment definitions'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'slots (fragment uses)'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'patterns (virtual or rebound)'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (clojure) printf "%s\n" "
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'namespaces'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (cmake) printf "%s\n" "
                map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'macros'
                map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'targets'
                map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'variable definitions'
                map global fzf-ctags '<a-d>' ': fzf-tag D<ret>' -docstring 'options specified with -<a-d>'
                map global fzf-ctags 'p'     ': fzf-tag P<ret>' -docstring 'projects'
                map global fzf-ctags 'r'     ': fzf-tag r<ret>' -docstring 'regex'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (c) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (cpp) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (cpreprocessor) printf "%s\n" "
                map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'macro definitions'
                map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'included header files'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (css) printf "%s\n" "
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'selectors'
                map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'identities'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (csharp) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (ctags) printf "%s\n" "
                map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'language definitions'
                map global fzf-ctags 'k' ': fzf-tag k<ret>' -docstring 'kind definitions'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (cobol) printf "%s\n" "
                map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'paragraphs'
                map global fzf-ctags 'd'     ': fzf-tag d<ret>' -docstring 'data items'
                map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'source code file'
                map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'file descriptions (f<a-d>, <a-s><a-d>, <a-r><a-d>)'
                map global fzf-ctags 'g'     ': fzf-tag G<ret>' -docstring 'group items'
                map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'program ids'
                map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'sections'
                map global fzf-ctags '<a-d>' ': fzf-tag D<ret>' -docstring 'divisions'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (cuda) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (d) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (diff) printf "%s\n" "
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'modified files'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'newly created files'
                map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'deleted files'
                map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'hunks'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (dtd) printf "%s\n" "
                map global fzf-ctags '<a-e>' ': fzf-tag E<ret>' -docstring 'entities'
                map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'parameter entities'
                map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'elements'
                map global fzf-ctags 'a'     ': fzf-tag a<ret>' -docstring 'attributes'
                map global fzf-ctags 'n'     ': fzf-tag n<ret>' -docstring 'notations'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (dts) printf "%s\n" "
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'phandlers'
                map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'labels'
                map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'regex'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (dosbatch) printf "%s\n" "
                map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'labels'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (eiffel) printf "%s\n" "
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'features'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (elm) printf "%s\n" "
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'module'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'renamed <a-i>mported <a-m>odule'
                map global fzf-ctags 'p' ': fzf-tag P<ret>' -docstring 'port'
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'type <a-d>efinition'
                map global fzf-ctags 'c' ': fzf-tag C<ret>' -docstring 'type <a-c>onstructor'
                map global fzf-ctags 'a' ': fzf-tag A<ret>' -docstring 'type <a-a>lias'
                map global fzf-ctags 'f' ': fzf-tag F<ret>' -docstring 'functions'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (erlang) printf "%s\n" "
                map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'macro definitions'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'modules'
                map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'record definitions'
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'type definitions'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (falcon) printf "%s\n" "
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'class members'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
                map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'imports'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (flex) printf "%s\n" "
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'methods'
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'properties'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'global variables'
                map global fzf-ctags 'x' ': fzf-tag x<ret>' -docstring 'mxtags'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (fortran) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (fypp) printf "%s\n" "
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'macros'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (gdbinit) printf "%s\n" "
                map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'definitions'
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'toplevel variables'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (go) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (html) printf "%s\n" "
                map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'named anchors'
                map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'h1 headings'
                map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'h2 headings'
                map global fzf-ctags 'j' ': fzf-tag j<ret>' -docstring 'h3 headings'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (iniconf) printf "%s\n" "
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'sections'
                map global fzf-ctags 'k' ': fzf-tag k<ret>' -docstring 'keys'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (itcl) printf "%s\n" "
                map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'methods'
                map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'object-specific variables'
                map global fzf-ctags '<a-c>' ': fzf-tag C<ret>' -docstring 'common variables'
                map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'procedures within the  class  namespace'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (java) printf "%s\n" "
                map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'annotation declarations'
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'enum constants'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'fields'
                map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'enum types'
                map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'interfaces'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'methods'
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (javaproperties) printf "%s\n" "
                map global fzf-ctags 'k' ': fzf-tag k<ret>' -docstring 'keys'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (javascript) printf "%s\n" "
                map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'methods'
                map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'properties'
                map global fzf-ctags '<a-c>' ': fzf-tag C<ret>' -docstring 'constants'
                map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'global variables'
                map global fzf-ctags 'g'     ': fzf-tag g<ret>' -docstring 'generators'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (json) printf "%s\n" "
                map global fzf-ctags 'o' ': fzf-tag o<ret>' -docstring 'objects'
                map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'arrays'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'numbers'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'strings'
                map global fzf-ctags 'b' ': fzf-tag b<ret>' -docstring 'booleans'
                map global fzf-ctags 'z' ': fzf-tag z<ret>' -docstring 'nulls'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (ldscript) printf "%s\n" "
                map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'sections'
                map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'symbols'
                map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'versions'
                map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'input sections'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (lisp) printf "%s\n" "
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (lua) printf "%s\n" "
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (m4) printf "%s\n" "
                map global fzf-ctags 'd'     ': fzf-tag d<ret>' -docstring 'macros'
                map global fzf-ctags '<a-i>' ': fzf-tag I<ret>' -docstring 'macro files'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (man) printf "%s\n" "
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'titles'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'sections'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (make) printf "%s\n" "
                map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'macros'
                map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'targets'
                map global fzf-ctags '<a-i>' ': fzf-tag I<ret>' -docstring 'makefiles'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (markdown) printf "%s\n" "
                map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'chapsters'
                map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'sections'
                map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'subsections'
                map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'subsubsections'
                map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'level 4 subsections'
                map global fzf-ctags 'u'     ': fzf-tag u<ret>' -docstring 'level 5 subsections'
                map global fzf-ctags 'r'     ': fzf-tag r<ret>' -docstring 'regex'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (matlab) printf "%s\n" "
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'function'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variable'
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'class'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (myrddin) printf "%s\n" "
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'constants'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'types'
                map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'traits'
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (objectivec) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (ocaml) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (passwd) printf "%s\n" "
                map global fzf-ctags 'u' ': fzf-tag u<ret>' -docstring 'user names'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (pascal) printf "%s\n" "
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'procedures'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (perl) printf "%s\n" "
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'constants'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'formats'
                map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'labels'
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'subroutines'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (perl6) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (php) printf "%s\n" "
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'constant definitions'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'interfaces'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'namespaces'
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'traits'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
                map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'aliases'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (pod) printf "%s\n" "
                map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'chapters'
                map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'sections'
                map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'subsections'
                map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'subsubsections'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (protobuf) printf "%s\n" "
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'messages'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'fields'
                map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'enum constants'
                map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'enum types'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'services'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (puppetmanifest) printf "%s\n" "
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'definitions'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'nodes'
                map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'resources'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (python) printf "%s\n" "
                map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'class members'
                map global fzf-ctags 'v'     ': fzf-tag v<ret>' -docstring 'variables'
                map global fzf-ctags '<a-i>' ': fzf-tag I<ret>' -docstring 'name referring a module defined in other file'
                map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'modules'
                map global fzf-ctags 'x'     ': fzf-tag x<ret>' -docstring 'name referring a class/variable/function/module defined in other module'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (pythonloggingconfig) printf "%s\n" "
                map global fzf-ctags '<a-l>' ': fzf-tag L<ret>' -docstring 'logger sections'
                map global fzf-ctags 'q'     ': fzf-tag q<ret>' -docstring 'logger qualnames'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (qemuhx) printf "%s\n" "
                map global fzf-ctags 'q' ': fzf-tag q<ret>' -docstring 'q<a-e><a-m><a-u> <a-m>anagement <a-p>rotocol dispatch table entries'
                map global fzf-ctags 'i' ': fzf-tag I<ret>' -docstring 'item in texinfo doc'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (qtmoc) printf "%s\n" "
                map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'slots'
                map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'signals'
                map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'properties'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (r) printf "%s\n" "
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'libraries'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'sources'
                map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'global variables'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'function variables'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (rspec) printf "%s\n" "
                map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'describes'
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'contexts'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (rexx) printf "%s\n" "
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'subroutines'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (robot) printf "%s\n" "
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'testcases'
                map global fzf-ctags 'k' ': fzf-tag k<ret>' -docstring 'keywords'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (rpmspec) printf "%s\n" "
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'tags'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'macros'
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'packages'
                map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'global macros'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (restructuredtext) printf "%s\n" "
                map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'chapters'
                map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'sections'
                map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'subsections'
                map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'subsubsections'
                map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'targets'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (ruby) printf "%s\n" "
                map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'methods'
                map global fzf-ctags 'm'     ': fzf-tag m<ret>' -docstring 'modules'
                map global fzf-ctags '<a-s>' ': fzf-tag S<ret>' -docstring 'singleton methods'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (rust) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (scheme) printf "%s\n" "
                map global fzf-ctags 'f' ': fzf-tag F<ret>' -docstring 'functions'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'sets'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (sh) printf "%s\n" "
                map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'aliases'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'script files'
                map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'label for here document'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (slang) printf "%s\n" "
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'namespaces'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (sml) printf "%s\n" "
                map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'exception declarations'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'function definitions'
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'functor definitions'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'signature declarations'
                map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'structure declarations'
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'type definitions'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'value bindings'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (sql) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (systemdunit) printf "%s\n" "
                map global fzf-ctags 'u' ': fzf-tag U<ret>' -docstring 'units'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (tcl) printf "%s\n" "
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'procedures'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'namespaces'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (tcloo) printf "%s\n" "
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'methods'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (tex) printf "%s\n" "
                map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'parts'
                map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'chapters'
                map global fzf-ctags 's'     ': fzf-tag s<ret>' -docstring 'sections'
                map global fzf-ctags 'u'     ': fzf-tag u<ret>' -docstring 'subsections'
                map global fzf-ctags 'b'     ': fzf-tag b<ret>' -docstring 'subsubsections'
                map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'paragraphs'
                map global fzf-ctags '<a-g>' ': fzf-tag G<ret>' -docstring 'subparagraphs'
                map global fzf-ctags 'l'     ': fzf-tag l<ret>' -docstring 'labels'
                map global fzf-ctags 'i'     ': fzf-tag i<ret>' -docstring 'includes'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (ttcn) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (vera) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (verilog) printf "%s\n" "
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'constants (define, parameter, specparam)'
                map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'events'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'modules'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'net data types'
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'ports'
                map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'register data types'
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'tasks'
                map global fzf-ctags 'b' ': fzf-tag b<ret>' -docstring 'blocks'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (systemverilog) printf "%s\n" "
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
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (vhdl) printf "%s\n" "
                map global fzf-ctags 'c'     ': fzf-tag c<ret>' -docstring 'constant declarations'
                map global fzf-ctags 't'     ': fzf-tag t<ret>' -docstring 'type definitions'
                map global fzf-ctags '<a-t>' ': fzf-tag T<ret>' -docstring 'subtype definitions'
                map global fzf-ctags 'r'     ': fzf-tag r<ret>' -docstring 'record names'
                map global fzf-ctags 'e'     ': fzf-tag e<ret>' -docstring 'entity declarations'
                map global fzf-ctags 'f'     ': fzf-tag f<ret>' -docstring 'function prototypes and declarations'
                map global fzf-ctags 'p'     ': fzf-tag p<ret>' -docstring 'procedure prototypes and declarations'
                map global fzf-ctags '<a-p>' ': fzf-tag P<ret>' -docstring 'package definitions'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (vim) printf "%s\n" "
                map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'autocommand groups'
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'user-defined commands'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'function definitions'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'maps'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variable definitions'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'vimball filename'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (windres) printf "%s\n" "
                map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'dialogs'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'menus'
                map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'icons'
                map global fzf-ctags 'b' ': fzf-tag b<ret>' -docstring 'bitmaps'
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'cursors'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'fonts'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'versions'
                map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'accelerators'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (yacc) printf "%s\n" "
                map global fzf-ctags 'l' ': fzf-tag l<ret>' -docstring 'labels'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (yumrepo) printf "%s\n" "
                map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'repository id'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (zephir) printf "%s\n" "
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'd' ': fzf-tag d<ret>' -docstring 'constant definitions'
                map global fzf-ctags 'f' ': fzf-tag f<ret>' -docstring 'functions'
                map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'interfaces'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'namespaces'
                map global fzf-ctags 't' ': fzf-tag t<ret>' -docstring 'traits'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
                map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'aliases'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (dbusintrospect) printf "%s\n" "
                map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'interfaces'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'methods'
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'signals'
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'properties'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (glade) printf "%s\n" "
                map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'identifiers'
                map global fzf-ctags 'c' ': fzf-tag c<ret>' -docstring 'classes'
                map global fzf-ctags 'h' ': fzf-tag h<ret>' -docstring 'handlers'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (maven2) printf "%s\n" "
                map global fzf-ctags 'g' ': fzf-tag g<ret>' -docstring 'group identifiers'
                map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'artifact identifiers'
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'properties'
                map global fzf-ctags 'r' ': fzf-tag r<ret>' -docstring 'repository identifiers'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (plistxml) printf "%s\n" "
                map global fzf-ctags 'k' ': fzf-tag k<ret>' -docstring 'keys'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (relaxng) printf "%s\n" "
                map global fzf-ctags 'e' ': fzf-tag e<ret>' -docstring 'elements'
                map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'attributes'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'named patterns'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (svg) printf "%s\n" "
                map global fzf-ctags 'i' ': fzf-tag i<ret>' -docstring 'id attributes'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (xslt) printf "%s\n" "
                map global fzf-ctags 's' ': fzf-tag s<ret>' -docstring 'stylesheets'
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'parameters'
                map global fzf-ctags 'm' ': fzf-tag m<ret>' -docstring 'matched template'
                map global fzf-ctags 'n' ': fzf-tag n<ret>' -docstring 'matched template'
                map global fzf-ctags 'v' ': fzf-tag v<ret>' -docstring 'variables'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (yaml) printf "%s\n" "
                map global fzf-ctags 'a' ': fzf-tag a<ret>' -docstring 'anchors'
                set-option buffer fzf_tag_filters_defined true
            " ;;
            (ansibleplaybook) printf "%s\n" "
                map global fzf-ctags 'p' ': fzf-tag p<ret>' -docstring 'plays'
                set-option buffer fzf_tag_filters_defined true
            " ;;
        esac
    }
}

define-command -hidden fzf-tag -params ..2 %{ evaluate-commands %sh{
    path=$PWD
    while [ "$path" != "$HOME" ]; do
        if [ -e "./${kak_opt_fzf_tag_file_name:-}" ]; then
            break
        else
            cd ..
            path=$PWD
        fi
    done

    if [ "$path" = "$HOME" ] && [ ! -e "./$kak_opt_fzf_tag_file_name" ]; then
        printf "%s\n" "echo -markup %{{Information}No '$kak_opt_fzf_tag_file_name' file found}"
        exit
    elif [ "$path" = "$HOME" ] && [ -e "./$kak_opt_fzf_tag_file_name" ]; then
        printf "%s\n" "echo -markup %{{Information}'$kak_opt_fzf_tag_file_name' file found at $HOME. Check if it is right tag file}"
    fi

    cmd="cd $path;"
    if [ -n "$(command -v "${kak_opt_readtagscmd%% *}")" ]; then
        if [ -n "$1" ]; then
            cmd="${cmd} ${kak_opt_readtagscmd} -t $kak_opt_fzf_tag_file_name -Q '(eq? \$kind \"$1\")' -l"
        else
            cmd="${cmd} ${kak_opt_readtagscmd} -t $kak_opt_fzf_tag_file_name -l"
        fi
    else
        printf "%s\n" "echo -markup %{{Error}'${kak_opt_readtagscmd}' executable not found. Check if '${kak_opt_readtagscmd}' is installed}"
        exit
    fi
    cmd="${cmd} | cut -f1"

    message="Jump to a symbol''s definition
<ret>: open tag in new buffer
${kak_opt_fzf_window_map:-ctrl-w}: open tag in new terminal"

    [ -n "${kak_client_env_TMUX:-}" ] && tmux_keybindings="
${kak_opt_fzf_horizontal_map:-ctrl-s}: open tag in horizontal split
${kak_opt_fzf_vertical_map:-ctrl-v}: open tag in vertical split"

    printf "%s\n" "info -title 'fzf tag' '$message$tmux_keybindings'"

    [ -n "${kak_client_env_TMUX}" ] && additional_flags="--expect ${kak_opt_fzf_vertical_map:-ctrl-v} --expect ${kak_opt_fzf_horizontal_map:-ctrl-s}"
    printf "%s\n" "set-option -add window ctagsfiles %{$path/$kak_opt_fzf_tag_file_name}"
    printf "%s\n" "fzf -kak-cmd %{ctags-search} -items-cmd %{$cmd | awk '!a[\$0]++'} -fzf-args %{--expect ${kak_opt_fzf_window_map:-ctrl-w} $additional_flags}"
}}

§
