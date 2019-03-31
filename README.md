# fzf.kak

[![GitHub release][1]][2] [![GitHub Release Date][3]][4]
![Github commits (since latest release)][5] ![license][6]

**fzf.kak** is a plugin for [Kakoune][7] editor, that brings integration with
[fzf][8] tool.  This plugin is being tested against Kakoune 2018.09.04.
**fzf.kak** also supports [skim][9], which can be used via `fzf_implementation`
option.

![showcase][10]

## Installation
### With [plug.kak][11] (recommended)
Recommended way to install is to use plug.kak plugin manager.  You can install
**fzf.kak** by adding this to your `kakrc`:

```kak
plug "andreyorst/fzf.kak"
```

Then reload Kakoune config or restart Kakoune and run `:plug-install`.
Now you can proceed to the [configuration][23] section.

### Without plugin manager
This plugin consists of several parts which are "modules", that provide
different functions to plugin.  There's central module that must be loaded
before any other module, named `fzf.kak`, so in order to properly load
**fzf.kak** plugin, you need to source it in your `kakrc`.

```sh
source "/path/to/fzf.kak/rc/fzf.kak" # loading base fzf module
```

This will load base `fzf` module, but It can't do anything on it's own. You can
load only needed modules, to keep your configuration rather simple, or load
every module if you need all plugin abilities:

```sh
source "/path/to/fzf.kak/rc/modules/fzf-file.kak"   # fzf file chooser
source "/path/to/fzf.kak/rc/modules/fzf-buffer.kak" # switching buffers with fzf
source "/path/to/fzf.kak/rc/modules/fzf-search.kak" # search within file contents
source "/path/to/fzf.kak/rc/modules/fzf-cd.kak"     # change server's working directory
source "/path/to/fzf.kak/rc/modules/fzf-ctags.kak"  # search for tag in your project ctags file
```

The same principle is applied to handling different version control systems. You
need a base module for `fzf`, called `fzf-vcs.kak` and its sub-modules for each
VCS. There are plenty of version control systems, so modules come in handy.

```sh
source "/path/to/fzf.kak/rc/modules/fzf-vcs.kak" # VCS base module
```

So if you never work with, say, GNU Bazaar, or Mercurial you can remove them
from your configuration.

```sh
source "/path/to/fzf.kak/rc/modules/VCS/fzf-bzr.kak" # GNU Bazaar support
source "/path/to/fzf.kak/rc/modules/VCS/fzf-git.kak" # Git support module
source "/path/to/fzf.kak/rc/modules/VCS/fzf-hg.kak"  # Mercurial VCS
source "/path/to/fzf.kak/rc/modules/VCS/fzf-svn.kak" # Subversion module
```

Order of sourcing files should not matter, but it is preferable to source main
script first, and then the modules. This may look complex, but it makes plugin
more versatile.  And plugin managers, like [plug.kak][11] for example, just does
all those steps for you.

By the way, this structure makes it easy to extend plugin with new modules, and
you [can add modules on your own][20]!

## Usage
There's no default key binding to invoke `fzf`, but **fzf.kak** provides a
`fzf-mode` command that can be mapped to preferred key.  You can set your own
mapping to invoke `fzf-mode`:

```kak
map global normal <c-p> ': fzf-mode<ret>'
```

Note that space between colon and command is intentional and will strip this
command from command history.

Each `fzf` module defines mnemonic mapping, like <kbd>f</kbd> for opening files,
<kbd>t</kbd> for tags, <kbd>s</kbd> for search, and so on.  Available mappings:

- <kbd>b</kbd> - Select buffer.
- <kbd>c</kbd> - Switch server's working directory.
- <kbd>f</kbd> - Search for file and open it.
- <kbd>v</kbd> - Edit file in version control system tree.
- <kbd>Alt</kbd>+<kbd>v</kbd> - Explicitly select which VCS command to run.
- <kbd>s</kbd> - Search over buffer contents and jump to result line.
- <kbd>t</kbd> - Browse ctags tags.
- <kbd>Alt</kbd>+<kbd>t</kbd> - Select tag kind filter on per language basis.
- <kbd>g</kbd> - Interactive grep.
- <kbd>p</kbd> - Project selector.
- <kbd>Alt</kbd>+<kbd>p</kbd> - Project related commands.

So for example pressing <kbd>Ctrl</kbd>+<kbd>p</kbd> <kbd>f</kbd> will open
`fzf` window, showing you all files from current directory recursively.

When Kakoune is being run in Tmux, **fzf.kak** will use bottom split to display
`fzf`. Additional keybindings are available to open file in vertical or
horizontal split. When Kakoune is used in plain terminal, the `terminal` command
is being used to create new windows.

## Configuration
**fzf.kak** features a lot of settings via options that can be altered to change
how **fzf.kak** behaves.

### File command
You can configure what command to use to search for files, and it's arguments.
Supported tools are [GNU Find][12], [The Silver Searcher][13], [ripgrep][14],
[fd][15]. GNU find is used by default, but you can switch to another one. There
are some default values for those, so you can just state the name of the tool:

```kak
set-option global fzf_file_command 'rg' # 'ag', 'fd', or 'find'
```

Or if you don't like default arguments, which for `find` are `find -type f`, and
would like to disable searching in, say `.svn` and `.git` directories you can
set option like this:

```kak
set-option global fzf_file_command "find . \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type f -print"
```

This can give you the idea of how this plugin can be customized. Most of
**fzf.kak** modules provide settings for their commands, so you should check all
`fzf-optionname` available in prompt mode. All such options are well documented,
so listing those in readme would make it unnecessary long.

### Preview
**fzf.kak** tries to automatically detect where to show preview window,
depending on aspect ratio of new terminal window.  By default if the doubled
height is bigger than the width, preview occupies upper 60% of space. If height
is smaller than the width, preview is shown at the right side.

You can configure the amount of space for preview window with these options:
`fzf_preview_height` and `fzf_preview_width`.

When using **fzf.kak** inside `tmux`, bottom pane is used for all `fzf`
commands, and preview window is displayed on the right side. When preview is
turned on, height of `tmux` split is increased to provide more space. You can
configure split height with `fzf_preview_tmux_height`

Amount of lines in preview window can be changed with `fzf_preview_lines`
option.

If you don't want preview feature you can disable it by setting `fzf_preview`
option to `false`.

#### Highlighting preview window
You also can highlight contents of the file displayed within preview window. To
do so, you can specify which highlighter to use with `fzf_highlight_cmd` option.
Supported highlighters are:

* [Bat][16]
* [Coderay][17]
* [Highlight][18]
* [Rouge][19]

Although other tools are not supported by the script, then should work fine as
long as they work with `fzf`.

### VCS
This script supports these version control systems: Git, Subversion, GNU Bazaar,
and Mercurial.  By default <kbd>v</kbd> mapping from `fzf` mode will detect your
version control system and open `fzf` window for you.  If you wish to explicitly
use some particular VCS command, you can use <kbd>Alt</kbd>+<kbd>v</kbd>
mapping, which includes all supported VCS shortcuts.

You also able to set parameters to VCS command to use to provide project
files. Supported options:

* `fzf_git_command`
* `fzf_svn_command`
* `fzf_bzr_command`
* `fzf_hg_command`

Other VCS are not supported officially. Open a feature request if you want some
unsupported VCS to be included.  You also can change one of options to contain
your VCS command, and use this command explicitly from VCS sub-mode.

### Tmux
When using inside tmux, `fzf` will use bottom split. Height of this split can be
changed with `fzf_tmux_height` option.  `fzf_tmux_height_file_preview` option is
used to control height of the split when you do file searching with file-preview
turned on.

## `fzf` command
`fzf` command can be used from prompt mode and for [scripting][20]. It supports
these arguments:

- `-kak-cmd`: A Kakoune command that is applied to `fzf` resulting value, e.g.
  `edit -existing`, `change-directory`, e.t.c.
- `-multiple-cmd`: A Kakoune command that is applied when multiple items
  selected to every item but the first one.
- `-items-cmd`: A command that is used as a pipe to provide list of values to
  `fzf`.  For example, if we want to pass list of all files recursively in
  current directory, we would use `-items-cmd %{find .}` which will be piped to
  `fzf` tool.
- `-fzf-impl`: Override `fzf` implementation variable. Can be used if command
  needs to provide a different arguments to `fzf`. See [sk-grep.kak][21] as
  example.
- `-fzf-args`: Additional flags for `fzf` program.
- `-preview-cmd`:  A preview command.  Can be  used to override  default preview
  handling.
- `-preview`: If specified, command will ask for preview.
-  `-filter`: A pipe which will be applied to result provided by `fzf`.  For
  example, if we are returning such line `3 hello, world!` from `fzf`, and we
  are interested only in the first field which is `3`, we can use `-filter %{cut
  -f 1}`. Basically everything what `fzf` returns is piped to this filter
  command. See [fzf-search.kak][22] as example.
- `-post-action`: Extra commands that are preformed after `-kak-cmd` command.

## Contributing
If you want to contribute to **fzf.kak** by adding a module, you can submit one
by providing a pull request, or just open a feature request and we'll see what
can be done.

### Writing a module
You can write a module for **fzf.kak**.  To create one, simply define a function
in separate file, located in `rc/modules/`, and named after the
function. **fzf.kak** provides a general purpose command, that can be called
with some Kakoune command as first parameter, and command that provides list of
items for `fzf` as a second parameter. Third optional parameter is for defining
extra arguments for `fzf` itself, like additional keybindings.

Overall module structure is:
* Define a `fzf-command` command
* Prepare list of items for `fzf`, or define an item command
* call `fzf` command and pass needed arguments to it.

Of course modules can and will be more complex, since a good module checks if
command for providing item list is available on user's machine, and supports
various settings inside it. Feel free to look how existing modules are made.

[1]: https://img.shields.io/github/release/andreyorst/fzf.kak.svg
[2]: https://github.com/andreyorst/fzf.kak/releases
[3]: https://img.shields.io/github/release-date/andreyorst/fzf.kak.svg
[4]: https://github.com/andreyorst/fzf.kak/releases
[5]: https://img.shields.io/github/commits-since/andreyorst/fzf.kak/latest.svg
[6]: https://img.shields.io/github/license/andreyorst/fzf.kak.svg
[7]: https://github.com/mawww/kakoune
[8]: https://github.com/junegunn/fzf
[9]: https://github.com/lotabout/skim
[10]: https://user-images.githubusercontent.com/19470159/46813471-6ee76800-cd7f-11e8-89aa-123b3a5f9f1b.gif
[11]: https://github.com/andreyorst/plug.kak
[12]: https://www.gnu.org/software/findutils/
[13]: https://github.com/ggreer/the_silver_searcher
[14]: https://github.com/BurntSushi/ripgrep
[15]: https://github.com/sharkdp/fd
[16]: https://github.com/sharkdp/bat
[17]: https://github.com/rubychan/coderay
[18]: https://gitlab.com/saalen/highlight
[19]: https://github.com/jneen/rouge
[20]: #writing-a-module
[21]: rc/modules/sk-grep.kak
[22]: rc/modules/fzf-search.kak
[23]: #configuration
