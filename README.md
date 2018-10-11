# fzf.kak

[![GitHub release](https://img.shields.io/github/release/andreyorst/fzf.kak.svg)](https://github.com/andreyorst/fzf.kak/releases)
[![GitHub Release Date](https://img.shields.io/github/release-date/andreyorst/fzf.kak.svg)](https://github.com/andreyorst/fzf.kak/releases)
![Github commits (since latest release)](https://img.shields.io/github/commits-since/andreyorst/fzf.kak/latest.svg)
![license](https://img.shields.io/github/license/andreyorst/fzf.kak.svg)

> **fzf.kak** is a plugin for [Kakoune](https://github.com/mawww/kakoune) editor, that brings integration with [fzf](https://github.com/junegunn/fzf)
> tool. This plugin is being tested against Kakoune 2018.09.04.

![showcase](https://user-images.githubusercontent.com/19470159/46812837-3b580e00-cd7e-11e8-9d73-f53ed15f516b.gif)

### Dependencies
|Tool      |Information                                                                                        |
|:--------:|:--------------------------------------------------------------------------------------------------|
|tmux      |This plugin depends on [fzf-tmux](https://github.com/junegunn/fzf/blob/master/bin/fzf-tmux) script.|
|X11       |Script works with X11 via `termcmd` option.                                                        |
|GNU Screen|GNU Screen is not yet supported.                                                                   |

## Installation
Recommended way to install is to use [plug.kak](https://github.com/andreyorst/plug.kak)  plugin
manager. You can install **fzf.kak** by adding this to your `kakrc`:

```kak
plug andreyorst/fzf.kak
```

Then reload Kakoune config or restart Kakoune and run `:plug-install`. 

Or install this plugin any other preferred way.

## Usage
**fzf.kak** doesn't provide any mapping by default. Instead there's now a `fzf-mode` command
which intentionally was made to simplify user mappings. 
Each fzf command has mnemonic mapping, like `f` for opening files, `t` for tags and so on.

In this mode new mappings are available:
- <kbd>b</kbd> - Select buffer
- <kbd>c</kbd> - Switch servers working directory
- <kbd>f</kbd> - Search for file and open it
- <kbd>v</kbd> - Edit file in version control system tree
- <kbd>V</kbd> - Explicitly select which vcs command to run
- <kbd>s</kbd> - Search over buffer contents and jump to result line
- <kbd>t</kbd> - Browse ctags tags

You can set your own mapping to invoke `fzf-mode`:

```
map global normal <c-p> ': fzf-mode<ret>'
# note that the space after colon is intentional to suppess fzf-mode to show in command history
```

So for example pressing  <kbd>Ctrl+p</kbd><kbd>f</kbd>  will  open  fzf  at  the
bottom of the Kakoune buffer, showing you all possible files.

### Settings
#### Files
You can configure what command to use to search for files, and it's arguments.
Supported tools are [GNU Find](https://www.gnu.org/software/findutils/), [The Silver Searcher](https://github.com/ggreer/the_silver_searcher), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd). GNU find is used by default, but you can switch to another one. There are some default values for those, so you can go:

```kak
set-option global fzf_file_command 'rg' # 'ag', 'fd' or 'find' 
```

Or if you don't like default file arguments, which are `find -type f`, and would like to disable searching in, say `.git` directories you can set it like so:

```kak
set-option global fzf_file_command "find . \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type f -print"
```

The same pattern applies for other commands, except `buffer`, and `cd`.

#### VCS
This script supports these version control systems: Git, Subversion, GNU Bazaar, Mercurial.
By default <kbd>v</kbd> mapping from `fzf mode` will detect your version control system and open fzf for you.
If you wish to explicitly use some particular vcs command, you can use `V` mapping, which includes
all supported vcs shortcuts.

You also able to set parameters to vcs command to use to provide project files. Supported options:

* `fzf_git_command`
* `fzf_svn_command`
* `fzf_bzr_command`
* `fzf_hg_command`

Other VCS are not supported officially. Open a feature request if you want some unsupported VCS to be included.
You also can change one of options to contain your vcs command, and use this command explicitly from vcs submode.

#### ctags
It is also possible to add parameters to ctags search executable:

```kak
set-option global fzf_tag_command 'readtags -l | cut -f1 | sort -u | ... ' 
```

#### Preview
You can turn on the preview window in fzf window by setting `fzf_preview` option to `true`:

```kak
set-option global fzf_preview true
```

You also can specify which highlighter to use within the preview window with `fzf_highlighter` option. 
Supported tools are:

* Rouge
* Highlight
* Coderay

## Some demonstration gifs:
### Opening files:
![files](https://user-images.githubusercontent.com/19470159/45917778-3988e200-be85-11e8-890d-b180d013b99e.gif)

### Searching tags with universal-ctags
![ctags](https://user-images.githubusercontent.com/19470159/45917775-3988e200-be85-11e8-8959-d7ddf17961b7.gif)

### Browsing Git tree files
![git](https://user-images.githubusercontent.com/19470159/45917779-3988e200-be85-11e8-9136-c0c830e838bc.gif)

### Switching buffers
![buffers](https://user-images.githubusercontent.com/19470159/45917774-38f04b80-be85-11e8-963b-5721bd6364b3.gif)

### Changing directories
![dirs](https://user-images.githubusercontent.com/19470159/45917776-3988e200-be85-11e8-89bf-7c1453806c83.gif)

