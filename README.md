# fzf.kak

**fzf.kak** is a plugin for Kakoune editor, that brings integration with fzf
tool. This plugin is being tested against Kakoune 2018.09.04.

## Installation

Assuming you're using [plug.kak](https://github.com/andreyorst/plug.kak)  plugin
manager, add this to your `.kakrc`:

```kak
plug andreyorst/fzf.kak
```

Reload Kakoune and run `:plug-install`. Next time you launch Kakoune plugin will
be loaded automatically.

## Usage

This plugin brings new command: `:fzf-mode` that is better should be  mapped  to
some mapping.  **fzf.kak** doesn't provide any mapping by default  so  user  may
configure it along with user's preference. For example:

```kak
map global normal <c-p> ':fzf-mode<ret>'
```

In this mode new mappings are available:
- <kbd>f</kbd> - Search for file and open it
- <kbd>b</kbd> - Select buffer
- <kbd>t</kbd> - Browse ctags tags
- <kbd>g</kbd> - Edit file in Git tree

So for example pressing  <kbd>Ctrl+p</kbd><kbd>f</kbd>  will  open  fzf  at  the
bottom of the Kakoune buffer, showing you all possible files.

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
