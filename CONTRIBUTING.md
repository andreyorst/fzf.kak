# Contribution guidelines

Before writing additional functionality to fzf.kak please refer to
[Kakoune's scripting guidelines](https://github.com/mawww/kakoune/blob/master/doc/writing_scripts.asciidoc).

## Adding new command
When adding commands to fzf.kak script please ensure to provide meaningful names,
and prefer full command definitions. Also ensure that code must be resourceable, so if user
want to resource kakrc plugin would not provide any warnings.

Good code:
```kak
define-command -hidden -docstring \
"This is an example of adding new fzf-mode command.
If shell scripting is involved please follow POSIX standards, and test
your code in POSIX shells, like 'dash', 'ash', and popular POSIX-compatible
shells, like 'bash' and 'zsh' You earn bonus points if your script works in 'fish'.
    Also notice that '-hidden' is used since all commands of fzf should be accessible from
fzf-mode key bindings. User should not remember all possible commands.
" \ fzf-good-example %{
    # This script features fzf command that accepts two arguments:
    # First argument is the command that should be used by Kakoune
    # after fzf returns its result
    # Second argument is a command to the fzf itself, which will be used
    # to provide list for fzf to show.
    fzf "echo $1" "echo 'this is an example' | tr ' ' '\n'"
}

map global fzf -docstring "fzf example command" e '<esc>: fzf-good-example<ret>'
# Note that space after column is intentional and prevents showing 'fzf-good-example' in command history
```

Bad code:
```kak
# example
def fzf-good-exmpl %{ fzf "echo $1" "echo 'actually I''m bad example' | tr ' ' '\n'" }
```

Although such code is short, the main idea of programming language is being a language, and speak
with the one who writes the code later. This may not be the best example of code that was made short
by sacrificing readability, but can give you an idea what kind of code is welcomed in this project,
and what isn't. "Write-only" code should be avoided in projects of any size and any task.

Also user doesn't know about all fzf commands, and by not adding command to `fzf-mode` you force
user to search for fzf commands in command-line which isn't the way how plugin should work. And even
if user finds this command in command-line, there's no documentation, and name is short and may be not
meaningful enough for user to understand what this command actually does. The name may also be misleading
like in this example - command says that it is good, but the result will be bad for the user.

## Shell scripting
Shell scripting should be POSIX compatible. Please avoid bashisms. You can refer to
[Kakoune's common shell patterns](https://github.com/mawww/kakoune/blob/master/doc/writing_scripts.asciidoc#common-shell-patterns), but reading 'POSIX programmers manual' will give more complete knowledge.
Please test your code in POSIX shells, like [dash](https://packages.debian.org/stretch/dash),
[ash](https://www.in-ulm.de/~mascheck/various/ash/), and in [Busybox](https://www.busybox.net/) environment
if possible. Also please test in popular POSIX-compatible shells, e.g. [bash](https://www.gnu.org/software/bash/),
[zsh](https://www.zsh.org/).

Sometimes it is not possible to use `fzf` command directly, like in previous example. Some preparations may
be needed. For example, you would like to check if tool that would be used to provide list for fzf is installed,
and fallback to another if not. Is so `fzf` can be called from shell expansion `%sh{ }`. Consider some examples:

Good code:
```kak
define-command -hidden -docstring \
"This is an example of using fzf command from shell expansion.
    Note that first argument should be used with escaped '$1'. This is intentional
because you will echo whole command out of shell expansion and without escaping '$1'
will be expanded to nothing.
    Also notice that we need to escape quotes and use shell 'eval' command to actually
expand '$cmd' to it's value.
" \ fzf-ripgrep-good %{ 
    evaluate-commands %sh{
        if [ -z $(command -v rg) ]; then
            echo "echo -markup '{Information}''rg'' is not installed. Falling back to ''find'''"
            cmd="find -type f"
        else
            cmd="rg --files"
        fi
        eval echo 'fzf \"edit \$1\" \"$cmd\"'
    }
}

map global fzf -docstring "use ripgrep to search for files" s '<esc>: fzf-ripgrep-good<ret>'
```

Bad code:
```kak
def fzf-ripgrep-bad %{ eval %sh{
    cmd="rg --files"
    [[ "$(which rg)" =~ "not found" ]] && cmd="find -type f"
    eval echo 'fzf \"edit \$1\" \"$cmd\"'
}}

map global fzf -docstring "use ripgrep to search for files" r '<esc>: fzf-shell-example<ret>'
```

Not only bashisms are being used here, but also everything what happens here is obscured from user. This command
says that it will use ripgrep to form file list for fzf. But If `rg` is not installed, user will be misleaded by
the fact that `fzf-shell-bad` works, but don't act like it should work when `rg` is installed. And nothing seems
to be wrong when this function if executed.

Although it may be good in some cases to obscure well-handled errors, this is not the case, and a warning should
be shown.

This code also uses `which` program, however this program is should be avoided. Because is it an external process
for doing very little thing (`hash` or `command` are way cheaper). `which` also is an external command, so it may
be not installed.

---

This document may be extended, so please check it from time to time.
