# fzf.kak

**fzf.kak** is a plugin for Kakoune editor, that brings integration with fzf
tool. This plugin is being tested against Kakoune 2018.09.04.

## Installation

Assuming you're using [plug.kak](https://github.com/andreyorst/plug.kak)  plugin
manager, add this to your `.kakrc`:

```kak
plug andreyorst/fzf.kak
```

Reload Kakoune config by and run `:plug-install`. Or install this plugin any other preferred way.

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
You can configure what command to use to search for files, and it's arguments.
Supported tools are [GNU Find](https://www.gnu.org/software/findutils/), [The Silver Searcher](https://github.com/ggreer/the_silver_searcher), [ripgrep](https://github.com/BurntSushi/ripgrep). GNU find is used by default, but you can switch to another one. There are some default values for those, so you can go:

```kak
set-option global fzf_file_command 'rg' # 'ag' or 'find' 
```

Or if you don't like default file arguments, which are `find -type f`, and would like to disable searching in, say `.git` directories you can set it like so:

```kak
set-option global fzf_file_command "find . \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type f -print"
```

Also fzf.kak supports setting different path to your `tmp` folder so you can use it an any system, or with different path:

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
