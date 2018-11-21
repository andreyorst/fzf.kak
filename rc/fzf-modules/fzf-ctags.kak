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

map global fzf -docstring "find tag" 't' '<esc>: fzf-tag<ret>'

declare-option -hidden -docstring "A set of mappings for Ada filetype" \
str fzf_tag_ada "
<c-a-p>: package specifications
<a-p>:   packages
<a-t>:   types
<a-u>:   subtypes
<a-c>:   record type components
<a-l>:   enum type literals
<a-v>:   variables
<a-f>:   generic formal parameters
<a-n>:   constants
<a-x>:   user defined exceptions
<c-a-r>: subprogram specifications
<a-r>:   subprograms
<c-a-k>: task specifications
<a-k>:   tasks
<c-a-o>: protected data specifications
<a-o>:   protected data
<a-e>:   task/protected data entries
<a-b>:   labels
<a-i>:   loop/declare identifiers
<c-a-s>: (ctags internal use)"

declare-option -hidden -docstring "A set of mappings for Ant filetype" \
str fzf_tag_ant "
<a-p>:   projects
<a-t>:   targets
<c-a-p>: properties(global)
<a-i>:   antfiles"

declare-option -hidden -docstring "A set of mappings for Asciidoc filetype" \
str fzf_tag_asciidoc "
<a-c>:   chapters
<a-s>:   sections
<c-a-s>: level 2 sections
<a-t>:   level 3 sections
<c-a-t>: level 4 sections
<a-u>:   level 5 sections
<a-a>:   anchors"

declare-option -hidden -docstring "A set of mappings for Asm filetype" \
str fzf_tag_asm "
<a-d>: defines
<a-l>: labels
<a-m>: macros
<a-t>: types (structs and records)
<a-s>: sections"

declare-option -hidden -docstring "A set of mappings for Asp filetype" \
str fzf_tag_asp "
<a-d>: constants
<a-c>: classes
<a-f>: functions
<a-s>: subroutines
<a-v>: variables"

declare-option -hidden -docstring "A set of mappings for Autoconf filetype" \
str fzf_tag_autoconf "
<a-p>: packages
<a-t>: templates
<a-m>: autoconf macros
<a-w>: options specified with --with-...
<a-e>: options specified with --enable-...
<a-s>: substitution keys
<a-c>: automake conditions
<a-d>: definitions"

declare-option -hidden -docstring "A set of mappings for AutoIt filetype" \
str fzf_tag_autoit "
<a-f>:   functions
<a-r>:   regions
<a-g>:   global variables
<a-l>:   local variables
<c-a-s>: included scripts"

declare-option -hidden -docstring "A set of mappings for Automake filetype" \
str fzf_tag_automake "
<a-d>:   directories
<c-a-p>: programs
<c-a-m>: manuals
<c-a-t>: ltlibraries
<c-a-l>: libraries
<c-a-s>: scripts
<c-a-d>: datum
<a-c>:   conditions"

declare-option -hidden -docstring "A set of mappings for Awk filetype" \
str fzf_tag_awk "
<a-f>: functions"

declare-option -hidden -docstring "A set of mappings for Basic filetype" \
str fzf_tag_basic "
<a-c>: constants
<a-f>: functions
<a-l>: labels
<a-t>: types
<a-v>: variables
<a-g>: enumerations"

declare-option -hidden -docstring "A set of mappings for BETA filetype" \
str fzf_tag_beta "
<a-f>: fragment definitions
<a-s>: slots (fragment uses)
<a-v>: patterns (virtual or rebound)"

declare-option -hidden -docstring "A set of mappings for Clojure filetype" \
str fzf_tag_clojure "
<a-f>: functions
<a-n>: namespaces"

declare-option -hidden -docstring "A set of mappings for CMake filetype" \
str fzf_tag_cmake "
<a-f>:   functions
<a-m>:   macros
<a-t>:   targets
<a-v>:   variable definitions
<c-a-d>: options specified with -D
<a-p>:   projects
<a-r>:   regex"

declare-option -hidden -docstring "A set of mappings for C filetype" \
str fzf_tag_c "
<a-d>: macro definitions
<a-e>: enumerators (values inside an enumeration)
<a-f>: function definitions
<a-g>: enumeration names
<a-h>: included header files
<a-m>: struct, and union members
<a-s>: structure names
<a-t>: typedefs
<a-u>: union names
<a-v>: variable definitions"

declare-option -hidden -docstring "A set of mappings for C++ filetype" \
str fzf_tag_cpp "
<a-d>: macro definitions
<a-e>: enumerators (values inside an enumeration)
<a-f>: function definitions
<a-g>: enumeration names
<a-h>: included header files
<a-m>: class, struct, and union members
<a-s>: structure names
<a-t>: typedefs
<a-u>: union names
<a-v>: variable definitions
<a-c>: classes
<a-n>: namespaces"

declare-option -hidden -docstring "A set of mappings for CPreProcessor filetype" \
str fzf_tag_cpreprocessor "
<a-d>: macro definitions
<a-h>: included header files"

declare-option -hidden -docstring "A set of mappings for CSS filetype" \
str fzf_tag_css "
<a-c>: classes
<a-s>: selectors
<a-i>: identities"

declare-option -hidden -docstring "A set of mappings for C# filetype" \
str fzf_tag_csharp "
<a-c>:   classes
<a-d>:   macro definitions
<a-e>:   enumerators (values inside an enumeration)
<c-a-e>: events
<a-f>:   fields
<a-g>:   enumeration names
<a-i>:   interfaces
<a-m>:   methods
<a-n>:   namespaces
<a-p>:   properties
<a-s>:   structure names
<a-t>:   typedefs"

declare-option -hidden -docstring "A set of mappings for Ctags filetype" \
str fzf_tag_ctags "
<a-l>: language definitions
<a-k>: kind definitions"

declare-option -hidden -docstring "A set of mappings for Cobol filetype" \
str fzf_tag_cobol "
<a-p>:   paragraphs
<a-d>:   data items
<c-a-s>: source code file
<a-f>:   file descriptions (FD, SD, RD)
<a-g>:   group items
<c-a-p>: program ids
<a-s>:   sections
<c-a-d>: divisions"

declare-option -hidden -docstring "A set of mappings for CUDA filetype" \
str fzf_tag_cuda "
<a-d>: macro definitions
<a-e>: enumerators (values inside an enumeration)
<a-f>: function definitions
<a-g>: enumeration names
<a-h>: included header files
<a-m>: struct, and union members
<a-s>: structure names
<a-t>: typedefs
<a-u>: union names
<a-v>: variable definitions"

declare-option -hidden -docstring "A set of mappings for D filetype" \
str fzf_tag_d "
<a-a>:   aliases
<a-c>:   classes
<a-g>:   enumeration names
<a-e>:   enumerators (values inside an enumeration)
<a-f>:   function definitions
<a-i>:   interfaces
<a-m>:   class, struct, and union members
<c-a-x>: mixins
<c-a-m>: modules
<a-n>:   namespaces
<a-s>:   structure names
<c-a-t>: templates
<a-u>:   union names
<a-v>:   variable definitions
<c-a-v>: version statements"

declare-option -hidden -docstring "A set of mappings for Diff filetype" \
str fzf_tag_diff "
<a-m>: modified files
<a-n>: newly created files
<a-d>: deleted files
<a-h>: hunks"

declare-option -hidden -docstring "A set of mappings for DTD filetype" \
str fzf_tag_dtd "
<c-a-e>: entities
<a-p>:   parameter entities
<a-e>:   elements
<a-a>:   attributes
<a-n>:   notations"

declare-option -hidden -docstring "A set of mappings for DTS filetype" \
str fzf_tag_dts "
<a-p>: phandlers
<a-l>: labels
<a-r>: regex"

declare-option -hidden -docstring "A set of mappings for DosBatch filetype" \
str fzf_tag_dosbatch "
<a-l>: labels
<a-v>: variables"

declare-option -hidden -docstring "A set of mappings for Eiffel filetype" \
str fzf_tag_eiffel "
<a-c>: classes
<a-f>: features"

declare-option -hidden -docstring "A set of mappings for Elm filetype" \
str fzf_tag_elm "
<a-m>: Module
<a-n>: Renamed Imported Module
<a-p>: Port
<a-t>: Type Definition
<a-c>: Type Constructor
<a-a>: Type Alias
<a-f>: Functions"

declare-option -hidden -docstring "A set of mappings for Erlang filetype" \
str fzf_tag_erlang "
<a-d>: macro definitions
<a-f>: functions
<a-m>: modules
<a-r>: record definitions
<a-t>: type definitions"

declare-option -hidden -docstring "A set of mappings for Falcon filetype" \
str fzf_tag_falcon "
<a-c>: classes
<a-f>: functions
<a-m>: class members
<a-v>: variables
<a-i>: imports"

declare-option -hidden -docstring "A set of mappings for Flex filetype" \
str fzf_tag_flex "
<a-f>: functions
<a-c>: classes
<a-m>: methods
<a-p>: properties
<a-v>: global variables
<a-x>: mxtags"

declare-option -hidden -docstring "A set of mappings for Fortran filetype" \
str fzf_tag_fortran "
<a-b>:   block data
<a-c>:   common blocks
<a-e>:   entry points
<c-a-e>: enumerations
<a-f>:   functions
<a-i>:   interface contents, generic names, and operators
<a-k>:   type and structure components
<a-l>:   labels
<a-m>:   modules
<c-a-m>: type bound procedures
<a-n>:   namelists
<c-a-n>: enumeration values
<a-p>:   programs
<a-s>:   subroutines
<a-t>:   derived types and structures
<a-v>:   program (global) and module variables
<c-a-s>: submodules"

declare-option -hidden -docstring "A set of mappings for Fypp filetype" \
str fzf_tag_fypp "
<a-m>: macros"

declare-option -hidden -docstring "A set of mappings for Gdbinit filetype" \
str fzf_tag_gdbinit "
<a-d>: definitions
<a-t>: toplevel variables"

declare-option -hidden -docstring "A set of mappings for Go filetype" \
str fzf_tag_go "
<a-p>:   packages
<a-f>:   functions
<a-c>:   constants
<a-t>:   types
<a-v>:   variables
<a-s>:   structs
<a-i>:   interfaces
<a-m>:   struct members
<c-a-m>: struct anonymous members
<a-u>:   unknown
<c-a-p>: name for specifying imported package"

declare-option -hidden -docstring "A set of mappings for HTML filetype" \
str fzf_tag_html "
<a-a>: named anchors
<a-h>: H1 headings
<a-i>: H2 headings
<a-j>: H3 headings"

declare-option -hidden -docstring "A set of mappings for Iniconf filetype" \
str fzf_tag_iniconf "
<a-s>: sections
<a-k>: keys"

declare-option -hidden -docstring "A set of mappings for ITcl filetype" \
str fzf_tag_itcl "
<a-c>:   classes
<a-m>:   methods
<a-v>:   object-specific variables
<c-a-c>: common variables
<a-p>:   procedures within the  class  namespace"

declare-option -hidden -docstring "A set of mappings for Java filetype" \
str fzf_tag_java "
<a-a>: annotation declarations
<a-c>: classes
<a-e>: enum constants
<a-f>: fields
<a-g>: enum types
<a-i>: interfaces
<a-m>: methods
<a-p>: packages"

declare-option -hidden -docstring "A set of mappings for JavaProperties filetype" \
str fzf_tag_javaproperties "
<a-k>: keys"

declare-option -hidden -docstring "A set of mappings for JavaScript filetype" \
str fzf_tag_javascript "
<a-f>:   functions
<a-c>:   classes
<a-m>:   methods
<a-p>:   properties
<c-a-c>: constants
<a-v>:   global variables
<a-g>:   generators"

declare-option -hidden -docstring "A set of mappings for JSON filetype" \
str fzf_tag_json "
<a-o>: objects
<a-a>: arrays
<a-n>: numbers
<a-s>: strings
<a-b>: booleans
<a-z>: nulls"

declare-option -hidden -docstring "A set of mappings for LdScript filetype" \
str fzf_tag_ldscript "
<c-a-s>: sections
<a-s>:   symbols
<a-v>:   versions
<a-i>:   input sections"

declare-option -hidden -docstring "A set of mappings for Lisp filetype" \
str fzf_tag_lisp "
<a-f>: functions"

declare-option -hidden -docstring "A set of mappings for Lua filetype" \
str fzf_tag_lua "
<a-f>: functions"

declare-option -hidden -docstring "A set of mappings for M4 filetype" \
str fzf_tag_m4 "
<a-d>:   macros
<c-a-i>: macro files"

declare-option -hidden -docstring "A set of mappings for Man filetype" \
str fzf_tag_man "
<a-t>: titles
<a-s>: sections"

declare-option -hidden -docstring "A set of mappings for Make filetype" \
str fzf_tag_make "
<a-m>:   macros
<a-t>:   targets
<c-a-i>: makefiles"

declare-option -hidden -docstring "A set of mappings for Markdown filetype" \
str fzf_tag_markdown "
<a-c>:   chapsters
<a-s>:   sections
<c-a-s>: subsections
<a-t>:   subsubsections
<c-a-t>: level 4 subsections
<a-u>:   level 5 subsections
<a-r>:   regex"

declare-option -hidden -docstring "A set of mappings for MatLab filetype" \
str fzf_tag_matlab "
<a-f>: function
<a-v>: variable
<a-c>: class"

declare-option -hidden -docstring "A set of mappings for Myrddin filetype" \
str fzf_tag_myrddin "
<a-f>: functions
<a-c>: constants
<a-v>: variables
<a-t>: types
<a-r>: traits
<a-p>: packages"

declare-option -hidden -docstring "A set of mappings for ObjectiveC filetype" \
str fzf_tag_objectivec "
<a-i>:   class interface
<c-a-i>: class implementation
<c-a-p>: Protocol
<a-m>:   Object's method
<a-c>:   Class' method
<a-v>:   Global variable
<c-a-e>: Object field
<a-f>:   A function
<a-p>:   A property
<a-t>:   A type alias
<a-s>:   A type structure
<a-e>:   An enumeration
<c-a-m>: A preprocessor macro"

declare-option -hidden -docstring "A set of mappings for OCaml filetype" \
str fzf_tag_ocaml "
<a-c>:   classes
<a-m>:   Object's method
<c-a-m>: Module or functor
<a-v>:   Global variable
<a-p>:   Signature item
<a-t>:   Type name
<a-f>:   A function
<c-a-c>: A constructor
<a-r>:   A 'structure' field
<a-e>:   An exception"

declare-option -hidden -docstring "A set of mappings for Passwd filetype" \
str fzf_tag_passwd "
<a-u>: user names"

declare-option -hidden -docstring "A set of mappings for Pascal filetype" \
str fzf_tag_pascal "
<a-f>: functions
<a-p>: procedures"

declare-option -hidden -docstring "A set of mappings for Perl filetype" \
str fzf_tag_perl "
<a-c>: constants
<a-f>: formats
<a-l>: labels
<a-p>: packages
<a-s>: subroutines"

declare-option -hidden -docstring "A set of mappings for Perl6 filetype" \
str fzf_tag_perl6 "
<a-c>: classes
<a-g>: grammars
<a-m>: methods
<a-o>: modules
<a-p>: packages
<a-r>: roles
<a-u>: rules
<a-b>: submethods
<a-s>: subroutines
<a-t>: tokens"

declare-option -hidden -docstring "A set of mappings for PHP filetype" \
str fzf_tag_php "
<a-c>: classes
<a-d>: constant definitions
<a-f>: functions
<a-i>: interfaces
<a-n>: namespaces
<a-t>: traits
<a-v>: variables
<a-a>: aliases"

declare-option -hidden -docstring "A set of mappings for Pod filetype" \
str fzf_tag_pod "
<a-c>:   chapters
<a-s>:   sections
<c-a-s>: subsections
<a-t>:   subsubsections"

declare-option -hidden -docstring "A set of mappings for Protobuf filetype" \
str fzf_tag_protobuf "
<a-p>: packages
<a-m>: messages
<a-f>: fields
<a-e>: enum constants
<a-g>: enum types
<a-s>: services"

declare-option -hidden -docstring "A set of mappings for PuppetManifest filetype" \
str fzf_tag_puppetmanifest "
<a-c>: classes
<a-d>: definitions
<a-n>: nodes
<a-r>: resources
<a-v>: variables"

declare-option -hidden -docstring "A set of mappings for Python filetype" \
str fzf_tag_python "
<a-c>:   classes
<a-f>:   functions
<a-m>:   class members
<a-v>:   variables
<c-a-i>: name referring a module defined in other file
<a-i>:   modules
<a-x>:   name referring a class/variable/function/module defined in other module"

declare-option -hidden -docstring "A set of mappings for PythonLoggingConfig filetype" \
str fzf_tag_pythonloggingconfig "
<c-a-l>: logger sections
<a-q>:   logger qualnames"

declare-option -hidden -docstring "A set of mappings for QemuHX filetype" \
str fzf_tag_qemuhx "
<a-q>: QEMU Management Protocol dispatch table entries
<a-i>: item in texinfo doc"

declare-option -hidden -docstring "A set of mappings for QtMoc filetype" \
str fzf_tag_qtmoc "
<a-s>:   slots
<c-a-s>: signals
<a-p>:   properties"

declare-option -hidden -docstring "A set of mappings for R filetype" \
str fzf_tag_r "
<a-f>: functions
<a-l>: libraries
<a-s>: sources
<a-g>: global variables
<a-v>: function variables"

declare-option -hidden -docstring "A set of mappings for RSpec filetype" \
str fzf_tag_rspec "
<a-d>: describes
<a-c>: contexts"

declare-option -hidden -docstring "A set of mappings for REXX filetype" \
str fzf_tag_rexx "
<a-s>: subroutines"

declare-option -hidden -docstring "A set of mappings for Robot filetype" \
str fzf_tag_robot "
<a-t>: testcases
<a-k>: keywords
<a-v>: variables"

declare-option -hidden -docstring "A set of mappings for RpmSpec filetype" \
str fzf_tag_rpmspec "
<a-t>: tags
<a-m>: macros
<a-p>: packages
<a-g>: global macros"

declare-option -hidden -docstring "A set of mappings for ReStructuredText filetype" \
str fzf_tag_restructuredtext "
<a-c>:   chapters
<a-s>:   sections
<c-a-s>: subsections
<a-t>:   subsubsections
<c-a-t>: targets"

declare-option -hidden -docstring "A set of mappings for Ruby filetype" \
str fzf_tag_ruby "
<a-c>:   classes
<a-f>:   methods
<a-m>:   modules
<c-a-s>: singleton methods"

declare-option -hidden -docstring "A set of mappings for Rust filetype" \
str fzf_tag_rust "
<a-n>:   module
<a-s>:   structural type
<a-i>:   trait interface
<a-c>:   implementation
<a-f>:   Function
<a-g>:   Enum
<a-t>:   Type Alias
<a-v>:   Global variable
<c-a-m>: Macro Definition
<a-m>:   A struct field
<a-e>:   An enum variant
<c-a-p>: A method"

declare-option -hidden -docstring "A set of mappings for Scheme filetype" \
str fzf_tag_scheme "
<a-f>: functions
<a-s>: sets"

declare-option -hidden -docstring "A set of mappings for Sh filetype" \
str fzf_tag_sh "
<a-a>: aliases
<a-f>: functions
<a-s>: script files
<a-h>: label for here document"

declare-option -hidden -docstring "A set of mappings for SLang filetype" \
str fzf_tag_slang "
<a-f>: functions
<a-n>: namespaces"

declare-option -hidden -docstring "A set of mappings for SML filetype" \
str fzf_tag_sml "
<a-e>: exception declarations
<a-f>: function definitions
<a-c>: functor definitions
<a-s>: signature declarations
<a-r>: structure declarations
<a-t>: type definitions
<a-v>: value bindings"

declare-option -hidden -docstring "A set of mappings for SQL filetype" \
str fzf_tag_sql "
<a-c>:   cursors
<a-f>:   functions
<c-a-e>: record fields
<c-a-l>: block label
<c-a-p>: packages
<a-p>:   procedures
<a-s>:   subtypes
<a-t>:   tables
<c-a-t>: triggers
<a-v>:   variables
<a-i>:   indexes
<a-e>:   events
<c-a-u>: publications
<c-a-r>: services
<c-a-d>: domains
<c-a-v>: views
<a-n>:   synonyms
<a-x>:   MobiLink Table Scripts
<a-y>:   MobiLink Conn Scripts
<a-z>:   MobiLink Properties "

declare-option -hidden -docstring "A set of mappings for SystemdUnit filetype" \
str fzf_tag_systemdunit "
<a-u>: units"

declare-option -hidden -docstring "A set of mappings for Tcl filetype" \
str fzf_tag_tcl "
<a-p>: procedures
<a-n>: namespaces"

declare-option -hidden -docstring "A set of mappings for TclOO filetype" \
str fzf_tag_tcloo "
<a-c>: classes
<a-m>: methods"

declare-option -hidden -docstring "A set of mappings for Tex filetype" \
str fzf_tag_tex "
<a-p>:   parts
<a-c>:   chapters
<a-s>:   sections
<a-u>:   subsections
<a-b>:   subsubsections
<c-a-p>: paragraphs
<c-a-g>: subparagraphs
<a-l>:   labels
<a-i>:   includes"

declare-option -hidden -docstring "A set of mappings for TTCN filetype" \
str fzf_tag_ttcn "
<c-a-m>: module definition
<a-t>:   type definition
<a-c>:   constant definition
<a-d>:   template definition
<a-f>:   function definition
<a-s>:   signature definition
<c-a-c>: testcase definition
<a-a>:   altstep definition
<c-a-g>: group definition
<c-a-p>: module parameter definition
<a-v>:   variable instance
<c-a-t>: timer instance
<a-p>:   port instance
<a-m>:   record/set/union member
<a-e>:   enumeration value"

declare-option -hidden -docstring "A set of mappings for Vera filetype" \
str fzf_tag_vera "
<a-c>:   classes
<a-d>:   macro definitions
<a-e>:   enumerators (values inside an enumeration)
<a-f>:   function definitions
<a-g>:   enumeration names
<a-i>:   interfaces
<a-m>:   class, struct, and union members
<a-p>:   programs
<a-s>:   signals
<a-t>:   tasks
<c-a-t>: typedefs
<a-v>:   variable definitions
<a-h>:   included header files"

declare-option -hidden -docstring "A set of mappings for Verilog filetype" \
str fzf_tag_verilog "
<a-c>: constants (define, parameter, specparam)
<a-e>: events
<a-f>: functions
<a-m>: modules
<a-n>: net data types
<a-p>: ports
<a-r>: register data types
<a-t>: tasks
<a-b>: blocks"

declare-option -hidden -docstring "A set of mappings for SystemVerilog filetype" \
str fzf_tag_systemverilog "
<a-c>:   constants (define, parameter, specparam, enum values)
<a-e>:   events
<a-f>:   functions
<a-m>:   modules
<a-n>:   net data types
<a-p>:   ports
<a-r>:   register data types
<a-t>:   tasks
<a-b>:   blocks
<c-a-a>: assertions
<c-a-c>: classes
<c-a-v>: covergroups
<c-a-e>: enumerators
<c-a-i>: interfaces
<c-a-m>: modports
<c-a-k>: packages
<c-a-p>: programs
<c-a-r>: properties
<c-a-s>: structs and unions
<c-a-t>: type declarations"

declare-option -hidden -docstring "A set of mappings for VHDL filetype" \
str fzf_tag_vhdl "
<a-c>:   constant declarations
<a-t>:   type definitions
<c-a-t>: subtype definitions
<a-r>:   record names
<a-e>:   entity declarations
<a-f>:   function prototypes and declarations
<a-p>:   procedure prototypes and declarations
<c-a-p>: package definitions"

declare-option -hidden -docstring "A set of mappings for Vim filetype" \
str fzf_tag_vim "
<a-a>: autocommand groups
<a-c>: user-defined commands
<a-f>: function definitions
<a-m>: maps
<a-v>: variable definitions
<a-n>: vimball filename"

declare-option -hidden -docstring "A set of mappings for WindRes filetype" \
str fzf_tag_windres "
<a-d>: dialogs
<a-m>: menus
<a-i>: icons
<a-b>: bitmaps
<a-c>: cursors
<a-f>: fonts
<a-v>: versions
<a-a>: accelerators"

declare-option -hidden -docstring "A set of mappings for YACC filetype" \
str fzf_tag_yacc "
<a-l>: labels"

declare-option -hidden -docstring "A set of mappings for YumRepo filetype" \
str fzf_tag_yumrepo "
<a-r>: repository id"

declare-option -hidden -docstring "A set of mappings for Zephir filetype" \
str fzf_tag_zephir "
<a-c>: classes
<a-d>: constant definitions
<a-f>: functions
<a-i>: interfaces
<a-n>: namespaces
<a-t>: traits
<a-v>: variables
<a-a>: aliases"

declare-option -hidden -docstring "A set of mappings for DBusIntrospect filetype" \
str fzf_tag_dbusintrospect "
<a-i>: interfaces
<a-m>: methods
<a-s>: signals
<a-p>: properties"

declare-option -hidden -docstring "A set of mappings for Glade filetype" \
str fzf_tag_glade "
<a-i>: identifiers
<a-c>: classes
<a-h>: handlers"

declare-option -hidden -docstring "A set of mappings for Maven2 filetype" \
str fzf_tag_maven2 "
<a-g>: group identifiers
<a-a>: artifact identifiers
<a-p>: properties
<a-r>: repository identifiers"

declare-option -hidden -docstring "A set of mappings for PlistXML filetype" \
str fzf_tag_plistxml "
<a-k>: keys"

declare-option -hidden -docstring "A set of mappings for RelaxNG filetype" \
str fzf_tag_relaxng "
<a-e>: elements
<a-a>: attributes
<a-n>: named patterns"

declare-option -hidden -docstring "A set of mappings for SVG filetype" \
str fzf_tag_svg "
<a-i>: id attributes"

declare-option -hidden -docstring "A set of mappings for XSLT filetype" \
str fzf_tag_xslt "
<a-s>: stylesheets
<a-p>: parameters
<a-m>: matched template
<a-n>: matched template
<a-v>: variables"

declare-option -hidden -docstring "A set of mappings for Yaml filetype" \
str fzf_tag_yaml "
<a-a>: anchors"

declare-option -hidden -docstring "A set of mappings for AnsiblePlaybook filetype" \
str fzf_tag_ansibleplaybook "
<a-p>: plays"

define-command -hidden fzf-tag -params ..1 %{ evaluate-commands %sh{
    case $kak_opt_filetype in
        ada)
            additional_keybindings="--expect ctrl-alt-p --expect alt-p --expect ctrl-alt-t --expect alt-t --expect ctrl-alt-u --expect alt-u --expect alt-c --expect alt-l --expect ctrl-alt-v --expect alt-v --expect alt-f --expect alt-n --expect alt-x --expect ctrl-alt-r --expect alt-r --expect ctrl-alt-k --expect alt-k --expect ctrl-alt-o --expect alt-o --expect ctrl-alt-e --expect alt-e --expect alt-b --expect alt-i --expect alt-a --expect alt-y --expect ctrl-alt-s"
            additional_message=$kak_opt_fzf_tag_ada ;;
        ant)
            additional_keybindings="--expect alt-p --expect alt-t --expect ctrl-alt-p --expect alt-i"
            additional_message=$kak_opt_fzf_tag_ant ;;
        asciidoc)
            additional_keybindings="--expect alt-c --expect alt-s --expect ctrl-alt-s --expect alt-t --expect ctrl-alt-t --expect alt-u --expect alt-a"
            additional_message=$kak_opt_fzf_tag_asciidoc ;;
        asm)
            additional_keybindings="--expect alt-d --expect alt-l --expect alt-m --expect alt-t --expect alt-s"
            additional_message=$kak_opt_fzf_tag_asm ;;
        asp)
            additional_keybindings="--expect alt-d --expect alt-c --expect alt-f --expect alt-s --expect alt-v"
            additional_message=$kak_opt_fzf_tag_asp ;;
        autoconf)
            additional_keybindings="--expect alt-p --expect alt-t --expect alt-m --expect alt-w --expect alt-e --expect alt-s --expect alt-c --expect alt-d"
            additional_message=$kak_opt_fzf_tag_autoconf ;;
        autoit)
            additional_keybindings="--expect alt-f --expect alt-r --expect alt-g --expect alt-l --expect ctrl-alt-s"
            additional_message=$kak_opt_fzf_tag_autoit ;;
        automake)
            additional_keybindings="--expect alt-d --expect ctrl-alt-p --expect ctrl-alt-m --expect ctrl-alt-t --expect ctrl-alt-l --expect ctrl-alt-s --expect ctrl-alt-d --expect alt-c"
            additional_message=$kak_opt_fzf_tag_automake ;;
        awk)
            additional_keybindings="--expect alt-f"
            additional_message=$kak_opt_fzf_tag_awk ;;
        basic)
            additional_keybindings="--expect alt-c --expect alt-f --expect alt-l --expect alt-t --expect alt-v --expect alt-g"
            additional_message=$kak_opt_fzf_tag_basic ;;
        beta)
            additional_keybindings="--expect alt-f --expect alt-p --expect alt-s --expect alt-v"
            additional_message=$kak_opt_fzf_tag_beta ;;
        clojure)
            additional_keybindings="--expect alt-f --expect alt-n"
            additional_message=$kak_opt_fzf_tag_clojure ;;
        cmake)
            additional_keybindings="--expect alt-f --expect alt-m --expect alt-t --expect alt-v --expect ctrl-alt-d --expect alt-p --expect alt-r"
            additional_message=$kak_opt_fzf_tag_cmake ;;
        c)
            additional_keybindings="--expect alt-d --expect alt-e --expect alt-f --expect alt-g --expect alt-h --expect alt-l --expect alt-m --expect alt-p --expect alt-s --expect alt-t --expect alt-u --expect alt-v --expect alt-x --expect alt-z --expect ctrl-alt-l"
            additional_message=$kak_opt_fzf_tag_c ;;
        cpp)
            additional_keybindings="--expect alt-d --expect alt-e --expect alt-f --expect alt-g --expect alt-h --expect alt-l --expect alt-m --expect alt-p --expect alt-s --expect alt-t --expect alt-u --expect alt-v --expect alt-x --expect alt-z --expect ctrl-alt-l --expect alt-c --expect alt-n --expect ctrl-alt-a --expect ctrl-alt-n --expect ctrl-alt-u"
            additional_message=$kak_opt_fzf_tag_cpp ;;
        cpreprocessor)
            additional_keybindings="--expect alt-d --expect alt-h"
            additional_message=$kak_opt_fzf_tag_cpreprocessor ;;
        css)
            additional_keybindings="--expect alt-c --expect alt-s --expect alt-i"
            additional_message=$kak_opt_fzf_tag_css ;;
        csharp)
            additional_keybindings="--expect alt-c --expect alt-d --expect alt-e --expect ctrl-alt-e --expect alt-f --expect alt-g --expect alt-i --expect alt-l --expect alt-m --expect alt-n --expect alt-p --expect alt-s --expect alt-t"
            additional_message=$kak_opt_fzf_tag_csharp ;;
        ctags)
            additional_keybindings="--expect alt-l --expect alt-k"
            additional_message=$kak_opt_fzf_tag_ctags ;;
        cobol)
            additional_keybindings="--expect alt-p --expect alt-d --expect ctrl-alt-s --expect ctrl-alt-F --expect alt-g --expect ctrl-alt-p --expect alt-s --expect ctrl-alt-d"
            additional_message=$kak_opt_fzf_tag_cobol ;;
        cuda)
            additional_keybindings="--expect alt-d --expect alt-e --expect alt-f --expect alt-g --expect alt-h --expect alt-l --expect alt-m --expect alt-p --expect alt-s --expect alt-t --expect alt-u --expect alt-v --expect alt-x --expect alt-z --expect ctrl-alt-l"
            additional_message=$kak_opt_fzf_tag_cuda ;;
        d)
            additional_keybindings="--expect alt-a --expect alt-c --expect alt-g --expect alt-e --expect alt-x --expect alt-f --expect alt-i --expect alt-l --expect alt-m --expect ctrl-alt-x --expect ctrl-alt-m --expect alt-n --expect alt-p --expect alt-s --expect ctrl-alt-t --expect alt-u --expect alt-v --expect ctrl-alt-v"
            additional_message=$kak_opt_fzf_tag_d ;;
        diff)
            additional_keybindings="--expect alt-m --expect alt-n --expect alt-d --expect alt-h"
            additional_message=$kak_opt_fzf_tag_diff ;;
        dtd)
            additional_keybindings="--expect ctrl-alt-e --expect alt-p --expect alt-e --expect alt-a --expect alt-n"
            additional_message=$kak_opt_fzf_tag_dtd ;;
        dts)
            additional_keybindings="--expect alt-p --expect alt-l --expect alt-r"
            additional_message=$kak_opt_fzf_tag_dts ;;
        dosbatch)
            additional_keybindings="--expect alt-l --expect alt-v"
            additional_message=$kak_opt_fzf_tag_dosbatch ;;
        eiffel)
            additional_keybindings="--expect alt-c --expect alt-f --expect alt-l"
            additional_message=$kak_opt_fzf_tag_eiffel ;;
        elm)
            additional_keybindings="--expect ctrl-alt-M --expect ctrl-alt-N --expect ctrl-alt-P --expect ctrl-alt-T --expect ctrl-alt-C --expect ctrl-alt-A --expect ctrl-alt-F"
            additional_message=$kak_opt_fzf_tag_elm ;;
        erlang)
            additional_keybindings="--expect alt-d --expect alt-f --expect alt-m --expect alt-r --expect alt-t"
            additional_message=$kak_opt_fzf_tag_erlang ;;
        falcon)
            additional_keybindings="--expect alt-c --expect alt-f --expect alt-m --expect alt-v --expect alt-i"
            additional_message=$kak_opt_fzf_tag_falcon ;;
        flex)
            additional_keybindings="--expect alt-f --expect alt-c --expect alt-m --expect alt-p --expect alt-v --expect alt-x"
            additional_message=$kak_opt_fzf_tag_flex ;;
        fortran)
            additional_keybindings="--expect alt-b --expect alt-c --expect alt-e --expect ctrl-alt-e --expect alt-f --expect alt-i --expect alt-k --expect alt-l --expect ctrl-alt-l --expect alt-m --expect ctrl-alt-m --expect alt-n --expect ctrl-alt-n --expect alt-p --expect ctrl-alt-p --expect alt-s --expect alt-t --expect alt-v --expect ctrl-alt-s"
            additional_message=$kak_opt_fzf_tag_fortran ;;
        fypp)
            additional_keybindings="--expect alt-m"
            additional_message=$kak_opt_fzf_tag_fypp ;;
        gdbinit)
            additional_keybindings="--expect alt-d --expect ctrl-alt-d --expect alt-t --expect alt-l"
            additional_message=$kak_opt_fzf_tag_gdbinit ;;
        go)
            additional_keybindings="--expect alt-p --expect alt-f --expect alt-c --expect alt-t --expect alt-v --expect alt-s --expect alt-i --expect alt-m --expect ctrl-alt-m --expect alt-u --expect ctrl-alt-p"
            additional_message=$kak_opt_fzf_tag_go ;;
        html)
            additional_keybindings="--expect alt-a --expect ctrl-alt-H --expect ctrl-alt-I --expect ctrl-alt-J"
            additional_message=$kak_opt_fzf_tag_html ;;
        iniconf)
            additional_keybindings="--expect alt-s --expect alt-k"
            additional_message=$kak_opt_fzf_tag_iniconf ;;
        itcl)
            additional_keybindings="--expect alt-c --expect alt-m --expect alt-v --expect ctrl-alt-c --expect alt-p"
            additional_message=$kak_opt_fzf_tag_itcl ;;
        java)
            additional_keybindings="--expect alt-a --expect alt-c --expect alt-e --expect alt-f --expect alt-g --expect alt-i --expect alt-l --expect alt-m --expect alt-p"
            additional_message=$kak_opt_fzf_tag_java ;;
        javaproperties)
            additional_keybindings="--expect alt-k"
            additional_message=$kak_opt_fzf_tag_javaproperties ;;
        javascript)
            additional_keybindings="--expect alt-f --expect alt-c --expect alt-m --expect alt-p --expect ctrl-alt-c --expect alt-v --expect alt-g"
            additional_message=$kak_opt_fzf_tag_javascript ;;
        json)
            additional_keybindings="--expect alt-o --expect alt-a --expect alt-n --expect alt-s --expect alt-b --expect alt-z"
            additional_message=$kak_opt_fzf_tag_json ;;
        ldscript)
            additional_keybindings="--expect ctrl-alt-s --expect alt-s --expect alt-v --expect alt-i"
            additional_message=$kak_opt_fzf_tag_ldscript ;;
        lisp)
            additional_keybindings="--expect alt-f"
            additional_message=$kak_opt_fzf_tag_lisp ;;
        lua)
            additional_keybindings="--expect alt-f"
            additional_message=$kak_opt_fzf_tag_lua ;;
        m4)
            additional_keybindings="--expect alt-d --expect ctrl-alt-i"
            additional_message=$kak_opt_fzf_tag_m4 ;;
        man)
            additional_keybindings="--expect alt-t --expect alt-s"
            additional_message=$kak_opt_fzf_tag_man ;;
        make)
            additional_keybindings="--expect alt-m --expect alt-t --expect ctrl-alt-i"
            additional_message=$kak_opt_fzf_tag_make ;;
        markdown)
            additional_keybindings="--expect alt-c --expect alt-s --expect ctrl-alt-s --expect alt-t --expect ctrl-alt-t --expect alt-u --expect alt-r"
            additional_message=$kak_opt_fzf_tag_markdown ;;
        matlab)
            additional_keybindings="--expect alt-f --expect alt-v --expect alt-c"
            additional_message=$kak_opt_fzf_tag_matlab ;;
        myrddin)
            additional_keybindings="--expect alt-f --expect alt-c --expect alt-v --expect alt-t --expect alt-r --expect alt-p"
            additional_message=$kak_opt_fzf_tag_myrddin ;;
        objectivec)
            additional_keybindings="--expect alt-i --expect ctrl-alt-i --expect ctrl-alt-p --expect ctrl-alt-M --expect ctrl-alt-C --expect ctrl-alt-V --expect ctrl-alt-e --expect ctrl-alt-F --expect ctrl-alt-P --expect ctrl-alt-T --expect ctrl-alt-S --expect ctrl-alt-E --expect ctrl-alt-m"
            additional_message=$kak_opt_fzf_tag_objectivec ;;
        ocaml)
            additional_keybindings="--expect alt-c --expect ctrl-alt-M --expect ctrl-alt-m --expect ctrl-alt-V --expect ctrl-alt-P --expect ctrl-alt-T --expect ctrl-alt-F --expect ctrl-alt-c --expect ctrl-alt-R --expect ctrl-alt-E"
            additional_message=$kak_opt_fzf_tag_ocaml ;;
        passwd)
            additional_keybindings="--expect alt-u"
            additional_message=$kak_opt_fzf_tag_passwd ;;
        pascal)
            additional_keybindings="--expect alt-f --expect alt-p"
            additional_message=$kak_opt_fzf_tag_pascal ;;
        perl)
            additional_keybindings="--expect alt-c --expect alt-f --expect alt-l --expect alt-p --expect alt-s --expect alt-d"
            additional_message=$kak_opt_fzf_tag_perl ;;
        perl6)
            additional_keybindings="--expect alt-c --expect alt-g --expect alt-m --expect alt-o --expect alt-p --expect alt-r --expect alt-u --expect alt-b --expect alt-s --expect alt-t"
            additional_message=$kak_opt_fzf_tag_perl6 ;;
        php)
            additional_keybindings="--expect alt-c --expect alt-d --expect alt-f --expect alt-i --expect alt-l --expect alt-n --expect alt-t --expect alt-v --expect alt-a"
            additional_message=$kak_opt_fzf_tag_php ;;
        pod)
            additional_keybindings="--expect alt-c --expect alt-s --expect ctrl-alt-s --expect alt-t"
            additional_message=$kak_opt_fzf_tag_pod ;;
        protobuf)
            additional_keybindings="--expect alt-p --expect alt-m --expect alt-f --expect alt-e --expect alt-g --expect alt-s --expect ctrl-alt-R"
            additional_message=$kak_opt_fzf_tag_protobuf ;;
        puppetmanifest)
            additional_keybindings="--expect alt-c --expect alt-d --expect alt-n --expect alt-r --expect alt-v"
            additional_message=$kak_opt_fzf_tag_puppetmanifest ;;
        python)
            additional_keybindings="--expect alt-c --expect alt-f --expect alt-m --expect alt-v --expect ctrl-alt-i --expect alt-i --expect alt-x --expect alt-z --expect alt-l"
            additional_message=$kak_opt_fzf_tag_python ;;
        pythonloggingconfig)
            additional_keybindings="--expect ctrl-alt-l --expect alt-q"
            additional_message=$kak_opt_fzf_tag_pythonloggingconfig ;;
        qemuhx)
            additional_keybindings="--expect ctrl-alt-Q --expect alt-i"
            additional_message=$kak_opt_fzf_tag_qemuhx ;;
        qtmoc)
            additional_keybindings="--expect alt-s --expect ctrl-alt-s --expect alt-p"
            additional_message=$kak_opt_fzf_tag_qtmoc ;;
        r)
            additional_keybindings="--expect alt-f --expect alt-l --expect alt-s --expect alt-g --expect alt-v"
            additional_message=$kak_opt_fzf_tag_r ;;
        rspec)
            additional_keybindings="--expect alt-d --expect alt-c"
            additional_message=$kak_opt_fzf_tag_rspec ;;
        rexx)
            additional_keybindings="--expect alt-s"
            additional_message=$kak_opt_fzf_tag_rexx ;;
        robot)
            additional_keybindings="--expect alt-t --expect alt-k --expect alt-v"
            additional_message=$kak_opt_fzf_tag_robot ;;
        rpmspec)
            additional_keybindings="--expect alt-t --expect alt-m --expect alt-p --expect alt-g"
            additional_message=$kak_opt_fzf_tag_rpmspec ;;
        restructuredtext)
            additional_keybindings="--expect alt-c --expect alt-s --expect ctrl-alt-s --expect alt-t --expect ctrl-alt-t"
            additional_message=$kak_opt_fzf_tag_restructuredtext ;;
        ruby)
            additional_keybindings="--expect alt-c --expect alt-f --expect alt-m --expect ctrl-alt-s"
            additional_message=$kak_opt_fzf_tag_ruby ;;
        rust)
            additional_keybindings="--expect alt-n --expect alt-s --expect alt-i --expect alt-c --expect ctrl-alt-F --expect ctrl-alt-G --expect ctrl-alt-T --expect ctrl-alt-V --expect ctrl-alt-m --expect ctrl-alt-M --expect ctrl-alt-E --expect ctrl-alt-p"
            additional_message=$kak_opt_fzf_tag_rust ;;
        scheme)
            additional_keybindings="--expect alt-f --expect alt-s"
            additional_message=$kak_opt_fzf_tag_scheme ;;
        sh)
            additional_keybindings="--expect alt-a --expect alt-f --expect alt-s --expect alt-h"
            additional_message=$kak_opt_fzf_tag_sh ;;
        slang)
            additional_keybindings="--expect alt-f --expect alt-n"
            additional_message=$kak_opt_fzf_tag_slang ;;
        sml)
            additional_keybindings="--expect alt-e --expect alt-f --expect alt-c --expect alt-s --expect alt-r --expect alt-t --expect alt-v"
            additional_message=$kak_opt_fzf_tag_sml ;;
        sql)
            additional_keybindings="--expect alt-c --expect alt-d --expect alt-f --expect ctrl-alt-e --expect alt-l --expect ctrl-alt-l --expect ctrl-alt-p --expect alt-p --expect alt-r --expect alt-s --expect alt-t --expect ctrl-alt-t --expect alt-v --expect alt-i --expect alt-e --expect ctrl-alt-u --expect ctrl-alt-r --expect ctrl-alt-d --expect ctrl-alt-v --expect alt-n --expect ctrl-alt-X --expect ctrl-alt-Y --expect ctrl-alt-Z"
            additional_message=$kak_opt_fzf_tag_sql ;;
        systemdunit)
            additional_keybindings="--expect alt-u"
            additional_message=$kak_opt_fzf_tag_systemdunit ;;
        tcl)
            additional_keybindings="--expect alt-p --expect alt-n"
            additional_message=$kak_opt_fzf_tag_tcl ;;
        tcloo)
            additional_keybindings="--expect alt-c --expect alt-m"
            additional_message=$kak_opt_fzf_tag_tcloo ;;
        tex)
            additional_keybindings="--expect alt-p --expect alt-c --expect alt-s --expect alt-u --expect alt-b --expect ctrl-alt-p --expect ctrl-alt-g --expect alt-l --expect alt-i"
            additional_message=$kak_opt_fzf_tag_tex ;;
        ttcn)
            additional_keybindings="--expect ctrl-alt-m --expect alt-t --expect alt-c --expect alt-d --expect alt-f --expect alt-s --expect ctrl-alt-c --expect alt-a --expect ctrl-alt-g --expect ctrl-alt-p --expect alt-v --expect ctrl-alt-t --expect alt-p --expect alt-m --expect alt-e"
            additional_message=$kak_opt_fzf_tag_ttcn ;;
        vera)
            additional_keybindings="--expect alt-c --expect alt-d --expect alt-e --expect alt-f --expect alt-g --expect alt-i --expect alt-l --expect alt-m --expect alt-p --expect ctrl-alt-p --expect alt-s --expect alt-t --expect ctrl-alt-t --expect alt-v --expect alt-x --expect alt-h"
            additional_message=$kak_opt_fzf_tag_vera ;;
        verilog)
            additional_keybindings="--expect alt-c --expect alt-e --expect alt-f --expect alt-m --expect alt-n --expect alt-p --expect alt-r --expect alt-t --expect alt-b"
            additional_message=$kak_opt_fzf_tag_verilog ;;
        systemverilog)
            additional_keybindings="--expect alt-c --expect alt-e --expect alt-f --expect alt-m --expect alt-n --expect alt-p --expect alt-r --expect alt-t --expect alt-b --expect ctrl-alt-a --expect ctrl-alt-c --expect ctrl-alt-v --expect ctrl-alt-e --expect ctrl-alt-i --expect ctrl-alt-m --expect ctrl-alt-k --expect ctrl-alt-p --expect ctrl-alt-q --expect ctrl-alt-r --expect ctrl-alt-s --expect ctrl-alt-t"
            additional_message=$kak_opt_fzf_tag_systemverilog ;;
        vhdl)
            additional_keybindings="--expect alt-c --expect alt-t --expect ctrl-alt-t --expect alt-r --expect alt-e --expect ctrl-alt-c --expect alt-d --expect alt-f --expect alt-p --expect ctrl-alt-p --expect alt-l"
            additional_message=$kak_opt_fzf_tag_vhdl ;;
        vim)
            additional_keybindings="--expect alt-a --expect alt-c --expect alt-f --expect alt-m --expect alt-v --expect alt-n"
            additional_message=$kak_opt_fzf_tag_vim ;;
        windres)
            additional_keybindings="--expect alt-d --expect alt-m --expect alt-i --expect alt-b --expect alt-c --expect alt-f --expect alt-v --expect alt-a"
            additional_message=$kak_opt_fzf_tag_windres ;;
        yacc)
            additional_keybindings="--expect alt-l"
            additional_message=$kak_opt_fzf_tag_yacc ;;
        yumrepo)
            additional_keybindings="--expect alt-r"
            additional_message=$kak_opt_fzf_tag_yumrepo ;;
        zephir)
            additional_keybindings="--expect alt-c --expect alt-d --expect alt-f --expect alt-i --expect alt-l --expect alt-n --expect alt-t --expect alt-v --expect alt-a"
            additional_message=$kak_opt_fzf_tag_zephir ;;
        dbusintrospect)
            additional_keybindings="--expect alt-i --expect alt-m --expect alt-s --expect alt-p"
            additional_message=$kak_opt_fzf_tag_dbusintrospect ;;
        glade)
            additional_keybindings="--expect alt-i --expect alt-c --expect alt-h"
            additional_message=$kak_opt_fzf_tag_glade ;;
        maven2)
            additional_keybindings="--expect alt-g --expect alt-a --expect alt-p --expect alt-r"
            additional_message=$kak_opt_fzf_tag_maven2 ;;
        plistxml)
            additional_keybindings="--expect alt-k"
            additional_message=$kak_opt_fzf_tag_plistxml ;;
        relaxng)
            additional_keybindings="--expect alt-e --expect alt-a --expect alt-n"
            additional_message=$kak_opt_fzf_tag_relaxng ;;
        svg)
            additional_keybindings="--expect alt-i"
            additional_message=$kak_opt_fzf_tag_svg ;;
        xslt)
            additional_keybindings="--expect alt-s --expect alt-p --expect alt-m --expect alt-n --expect alt-v"
            additional_message=$kak_opt_fzf_tag_xslt ;;
        yaml)
            additional_keybindings="--expect alt-a"
            additional_message=$kak_opt_fzf_tag_yaml ;;
        ansibleplaybook)
            additional_keybindings="--expect alt-p"
            additional_message=$kak_opt_fzf_tag_ansibleplaybook ;;
        *)
            additional_keybindings=
            additional_message=
            ;;
    esac

    path=$PWD
    while [ "$path" != "$HOME" ]; do
        if [ -e "./${kak_opt_tagfile:-tags}" ]; then
            break
        else
            cd ..
            path=$PWD
        fi
    done
    if [ "$path" = "$HOME" ] && [ ! -e "./${kak_opt_tagfile:-tags}" ]; then
        echo "echo -markup %{{Information}No '${kak_opt_tagfile:-tags}' found}"
        exit
    elif [ "$path" = "$HOME" ] && [ -e "./${kak_opt_tagfile:-tags}" ]; then
        echo "echo -markup %{{Information}'${kak_opt_tagfile:-tags}' found at $HOME. Check if it is right tag file}"
    fi

    if [ ! -z "$1" ]; then
        mode=$(echo "$additional_message" | grep "<a-$1>:" | awk '{$1=""; print}' | sed "s/\(.*\)/:\1/")
        cmd="cd $path; readtags -Q '(eq? \$kind \"$1\")' -l | cut -f1"
    else
        cmd="cd $path; readtags -l | cut -f1"
    fi
    [ ! -z "${kak_client_env_TMUX}" ] && tmux_keybindings="
<c-s>: open tag in horizontal split
<c-v>: open tag in vertical split"

    message="Jump to a symbol''s definition
<ret>: open tag in new buffer
<c-w>: open tag in new window"

    [ ! -z "$additional_message" ] && message="$message $tmux_keybindings

Additional filters for $kak_opt_filetype filetype: $additional_message"

    echo "info -title 'fzf tag$mode' '$message'"

    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect ctrl-v --expect ctrl-s"
    echo "set-option window ctagsfiles %{$path/${kak_opt_tagfile:-tags}}"
    echo "fzf %{ctags-search \$1} %{$cmd | awk '!a[\$0]++'} %{--expect ctrl-w $additional_flags $additional_keybindings}"
}}
