# fzf.kak

[![GitHub release](https://img.shields.io/github/release/andreyorst/fzf.kak.svg)](https://github.com/andreyorst/SimpleSnippets.vim/releases)
[![GitHub Release Date](https://img.shields.io/github/release-date/andreyorst/fzf.kak.svg)](https://github.com/andreyorst/SimpleSnippets.vim/releases)
![Github commits (since latest release)](https://img.shields.io/github/commits-since/andreyorst/fzf.kak/latest.svg)
![license](https://img.shields.io/github/license/andreyorst/fzf.kak.svg)

> **fzf.kak** is a plugin for Kakoune editor, that brings integration with fzf
> tool. This plugin is being tested against Kakoune 2018.09.04.

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
- <kbd>f</kbd> - Search for file and open it
- <kbd>b</kbd> - Select buffer
- <kbd>t</kbd> - Browse ctags tags
- <kbd>g</kbd> - Edit file in Git tree

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
Supported tools are [GNU Find](https://www.gnu.org/software/findutils/), [The Silver Searcher](https://github.com/ggreer/the_silver_searcher), [ripgrep](https://github.com/BurntSushi/ripgrep). GNU find is used by default, but you can switch to another one. There are some default values for those, so you can go:

```kak
set-option global fzf_file_command 'rg' # 'ag' or 'find' 
```

Or if you don't like default file arguments, which are `find -type f`, and would like to disable searching in, say `.git` directories you can set it like so:

```kak
set-option global fzf_file_command "find . \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type f -print"
```

The same pattern applies for other commands, except `buffer`, and `cd`.

#### Git
You also able to set what git command to use to provide git-tree. These are default argumens:

```kak
set-option global fzf_git_command 'git ls-tree --name-only -r HEAD' 
```

Other VCS are not supported officially, but might work.

#### ctags
It is also possible to add parametees to ctags search executable:

```kak
set-option global fzf_tag_command 'readtags -l | cut -f1 | sort -u | ... ' 
```

#### Misc
**fzf.kak** relies on tmp folder to work with all possible environments, however not every system features
the same path to `tmp`. You can set different path to your or to any other directory with:

```kak
set-option global fzf_tmp //path/to/tmp'
```


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

## Special thanks
Original script, that current implementation is based on, was implemented by [topisani](https://github.com/topisani). If you are here, thank you for your work, it is awesome!
