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

### Without plugin manager
This plugin consists of several parts which are "modules", that provide
different functions to plugin.  There's central module that must be loaded
before any other module, named `fzf.kak`, so in order to properly load
**fzf.kak** plugin, you need to source it in your `kakrc`.

Assuming that you've cloned **fzf.kak** repository to your Kakoune configuration
folder:

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

You can see that we load less nested modules first, and then go deeper and
deeper.  Besides that order of files within single depth level doesn't
matter. This may look complex, but it makes plugin more versatile.  And plugin
managers, like [plug.kak][11] for example, just does all those steps for you.

By the way, this structure makes it easy to extend plugin with new modules, and
you [can add modules on your own][20]!

## Usage
There's no default key binding to invoke `fzf`, but **fzf.kak** provides a
`fzf-mode` command that can be mapped to preferred key.  You can set your own
mapping to invoke `fzf-mode`:

```kak
map global normal <c-p> ': fzf-mode<ret>'
```

Each `fzf` sub-command has mnemonic mapping, like `f` for opening files, `t` for
tags and so on.  Available mappings:

- <kbd>b</kbd> - Select buffer.
- <kbd>c</kbd> - Switch server's working directory.
- <kbd>f</kbd> - Search for file and open it.
- <kbd>v</kbd> - Edit file in version control system tree.
- <kbd>Alt</kbd>+<kbd>v</kbd> - Explicitly select which VCS command to run.
- <kbd>s</kbd> - Search over buffer contents and jump to result line.
- <kbd>t</kbd> - Browse ctags tags.
- <kbd>Alt</kbd>+<kbd>t</kbd> - Select tag kind filter on per language basis.

So for example pressing <kbd>Ctrl</kbd>+<kbd>p</kbd> <kbd>f</kbd> will open
`fzf` at the bottom of the Kakoune buffer, showing you all possible files.

### Configuration
**fzf.kak** features a lot of settings via options that can be altered to change
how **fzf.kak** behaves.

#### Tmux
When using inside tmux, `fzf` will use bottom split. Height of this split can be
changed with `fzf_tmux_height` option.  `fzf_tmux_height_file_preview` option is
used to control height of the split when you do file searching with file-preview
turned on.

#### File with preview window
You can configure what command to use to search for files, and it's arguments.
Supported tools are [GNU Find][12], [The Silver Searcher][13], [ripgrep][14],
[fd][15]. GNU find is used by default, but you can switch to another one. There
are some default values for those, so you can go:

```kak
set-option global fzf_file_command 'rg' # 'ag', 'fd', or 'find'
```

Or if you don't like default file arguments, which are `find -type f`, and would
like to disable searching in, say `.svn` or `.git` directories you can set it
like so:

```kak
set-option global fzf_file_command "find . \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type f -print"
```

The same pattern applies for other commands, except `buffer`, and `cd`.

#### VCS
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

#### ctags
It is also possible to add parameters to ctags search executable. like `sort -u`
and others:

```kak
set-option global fzf_tag_command 'readtags -l | cut -f1 | sort -u | ... '
```

Though it is not recommended, since `sort` may slowdown `fzf-tag` on huge
projects.

##### Filtering tags
Since ctags supports showing particular kind of tag for many languages,
`fzf-tag` dynamically defines mappings for those languages with <kbd>Alt</kbd>
key based on current filetype.  For example to show only functions while
`fzf-tag` is active press <kbd>Alt</kbd>+<kbd>f</kbd>.  It will reload `fzf`
window and only function tags will be listed.

#### Preview
When using X11 **fzf.kak** automatically tries to detect where to show preview
window, depending on aspect ratio of new terminal window.  By default if the
height is bigger than the width, preview occupies upper 60% of space. If height
is smaller than the width, preview is shown at the right side.

You can configure the amount of space for preview window with these options:
`fzf_preview_height` and `fzf_preview_width`.

When **fzf.kak** is used in tmux, it will show preview on the right side. Height
of preview split can be adjusted with `fzf_tmux_height_file_preview`

Amount of lines in preview window can be changed with `fzf_preview_lines`
option.

You also can specify which highlighter to use within the preview window with
`fzf_highlighter` option.  Supported tools are:

* [Bat][16]
* [Coderay][17]
* [Highlight][18]
* [Rouge][19]

You can disable the preview window in `fzf` window by setting `fzf_preview`
option to `false`.

### `fzf` command
`fzf` command can be used from prompt mode and for [scripting][20]. It supports
these arguments:

- `-kak-cmd`: A Kakoune command that is applied to `fzf` resulting value, e.g.
  `edit -existing`, `change-directory`, e.t.c.
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
[23]:
