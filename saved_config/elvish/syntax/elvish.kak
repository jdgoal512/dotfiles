# http://elvish.io/
#
# Based on d.kak

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*\.elv %{
    set-option buffer filetype elvish
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/elvish regions
add-highlighter shared/elvish/code default-region group
add-highlighter shared/elvish/dquotestring region '"' (\\\\)*" fill string
add-highlighter shared/elvish/squotestring region "'" (\\\\)*' fill string
add-highlighter shared/elvish/comment      region '#' '$' fill comment
add-highlighter shared/elvish/code/ regex (([A-Za-z0-9_-]+:)*([A-Za-z0-9_-]+)~?)\h*(=|\[) 1:variable
add-highlighter shared/elvish/code/ regex (\$@?)((?:[A-Za-z0-9_-]+:)*([A-Za-z0-9_-]+)) 1:operator 2:variable
add-highlighter shared/elvish/code/ regex (\]?\h*=)|(\b\||[12]?>|>>|<|&|\;) 0:operator
add-highlighter shared/elvish/code/ regex [(){}[\]] 0:operator
add-highlighter shared/elvish/code/ regex (\;|\||^|\(|\{)\h*\K(fn\h+|external\h+)([\w-]+) 0:function                   # fn function_name []{...
add-highlighter shared/elvish/code/ regex (\;|\||^|\(|\{)\h*\K([\w-_]+(:[\w-_]+)*)((?=[\|\;\n\)])|\h+(?!=)) 0:function # any command
add-highlighter shared/elvish/code/ regex \$([A-Za-z0-9_-]+:)*([A-Za-z0-9_-]+)~ 0:function                             # $function:name~

evaluate-commands %sh{
    # Grammar
    builtins="${builtins}|use|fn|(edit|builtin|le):[a-z]+(:[a-z0-9]+)*"
    builtins="${builtins}|assoc|bool|cd|constantly|count|dissoc|drop"
    builtins="${builtins}|each|eawk|echo|else|elsif|eq|except|exec|exit|explode|external"
    builtins="${builtins}|fail|for|fclose|fopen|from-json|has-external|has-prefix|has-suffix"
    builtins="${builtins}|is|if|joins|keys|kind-of|nop|not|not-eq"
    builtins="${builtins}|ord|path-abs|path-base|path-clean|path-dir|path-ext|peach"
    builtins="${builtins}|pipe|prclose|put|pprint|print|pwclose|range"
    builtins="${builtins}|rand|randint|repeat|replaces|repr|resolve|return|run-parallel"
    builtins="${builtins}|search-external|slurp|splits|src|styled|take|tilde-abbr|to-json"
    builtins="${builtins}|try|wcswidth|-gc|-ifaddrs|-log|-stack|-source|-time"

    # Add the language's grammar to the static completion list
    printf %s\\n "hook global WinSetOption filetype=elvish %{
        set-option window static_words ${builtins}
    }" | tr '|' ' '

    # Highlight keywords
    printf %s " add-highlighter shared/elvish/code/ regex \b(${builtins})\h 0:keyword"
}

# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden elvish-indent-on-new-line %~
    evaluate-commands -draft -itersel %=
        # preserve previous line indent
        try %{ execute-keys -draft \;K<a-&> }
        # indent after lines ending with { or (
        try %[ execute-keys -draft k<a-x> <a-k> [{(|]\h*$ <ret> j<a-gt> ]
        # cleanup trailing white spaces on the previous line
        try %{ execute-keys -draft k<a-x> s \h+$ <ret>d }
        # align to opening paren of previous line
        try %{ execute-keys -draft [( <a-k> \A\([^\n]+\n[^\n]*\n?\z <ret> s \A\(\h*.|.\z <ret> '<a-;>' & }
        # copy # comments prefix
        try %{ execute-keys -draft \;<c-s>k<a-x> s ^\h*\K# <ret> y<c-o><c-o>P<esc> }
    =
~

define-command -hidden elvish-indent-on-opening-curly-brace %[
    # align indent with opening paren when { is entered on a new line after the closing paren
    try %[ execute-keys -draft -itersel h<a-F>)M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
]

define-command -hidden elvish-indent-on-closing-curly-brace %[
    # align to opening curly brace when alone on a line
    try %[ execute-keys -itersel -draft <a-h><a-k>^\h+\}$<ret>hms\A|.\z<ret>1<a-&> ]
]

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook -group elvish-highlight global WinSetOption filetype=elvish %{ add-highlighter window/ ref elvish }

hook global WinSetOption filetype=elvish %{
    # cleanup trailing whitespaces when exiting insert mode
    hook window InsertEnd .* -group elvish-hooks %{ try %{ execute-keys -draft <a-x>s^\h+$<ret>d } }
    hook window InsertChar \n -group elvish-indent elvish-indent-on-new-line
    hook window InsertChar \{ -group elvish-indent elvish-indent-on-opening-curly-brace
    hook window InsertChar \} -group elvish-indent elvish-indent-on-closing-curly-brace

    # Save extra_word_chars option for restoring when buffer filetype changes to other than 'elvish'
    declare-option -hidden str extra_word_chars_save %opt{extra_word_chars}

    # Consider $, ~, and - characters as parts of words
    set -add buffer extra_word_chars '$' '~' '-'
}

hook -group elvish-highlight global WinSetOption filetype=(?!elvish).* %{ remove-highlighter window/elvish }

hook global WinSetOption filetype=(?!elvish).* %{
    remove-hooks window elvish-hooks
    remove-hooks window elvish-indent

    # Restore extra_word_chars
    try %{ set buffer extra_word_chars %opt{extra_word_chars_save} }
}

