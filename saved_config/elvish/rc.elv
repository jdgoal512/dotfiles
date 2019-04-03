use builtin
use re
use epm
epm:install &silent-if-installed=$true   \
  github.com/zzamboni/elvish-modules     \
  github.com/zzamboni/elvish-completions \
  github.com/xiaq/edit.elv               \
  github.com/muesli/elvish-libs          \
  github.com/iwoloschin/elvish-packages

#use github.com/zzamboni/elvish-modules/long-running-notifications
use github.com/zzamboni/elvish-modules/bang-bang

fn ls [@args]{ e:ls --color=auto $@args }
fn l [@args]{ e:ls --color=auto -lah $@args }
fn sl [@args]{ ls $@args }
fn LS [@args]{ ls $@args }
fn grep [@args]{ e:grep --color=auto --exclude-dir={env,site-packages,.bzr,CVS,.git,.hg,.svn} $@args }

fn cd [@args]{
    dir = "" 
    if (eq $args []) {
        dir = ~
    } else {
        dir = $args[0]
        while (re:match '\.\.\.' $dir) {
            dir = (re:replace '\.\.\.' '../..' $dir)
        }
    }
    try {
        builtin:cd $dir
        e:ls --color=auto
    } except {
            echo "No such file or directory:" $dir
    }
}

paths = [
  ~/bin
  /usr/local/bin
  /usr/local/sbin
  /usr/sbin
  /sbin
  /usr/bin
  /bin
]

#use readline-binding

#edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~
#edit:insert:binding[Alt-d] = $edit:kill-small-word-right~

#Vim bindings in file manager
edit:navigation:binding[h] = $edit:navigation:left~
edit:navigation:binding[j] = $edit:navigation:down~
edit:navigation:binding[k] = $edit:navigation:up~
edit:navigation:binding[l] = $edit:navigation:right~
edit:insert:binding[Ctrl-A] = $edit:move-dot-sol~
edit:insert:binding[Ctrl-E] = $edit:move-dot-eol~

use github.com/zzamboni/elvish-modules/alias
use github.com/xiaq/edit.elv/smart-matcher
smart-matcher:apply
use github.com/zzamboni/elvish-completions/ssh
use github.com/zzamboni/elvish-completions/builtins

#use github.com/zzamboni/elvish-completions/git
#git:git-command = hub
#git:init

use github.com/zzamboni/elvish-completions/comp
use theme
theme:bold-prompt = $true
theme:prompt-pwd-dir-length = 0 #Don't abbreviate working directory in prompt


edit:prompt-stale-transform = { each [x]{ styled $x[text] "gray" } }

edit:-prompt-eagerness = 10

#use github.com/zzamboni/elvish-modules/dir
#edit:insert:binding[Alt-i] = $dir:history-chooser~
#edit:insert:binding[Alt-b] = $dir:left-small-word-or-prev-dir~
#edit:insert:binding[Alt-f] = $dir:right-small-word-or-next-dir~

use github.com/zzamboni/elvish-modules/terminal-title

private-loaded = ?(use private)

use github.com/zzamboni/elvish-modules/atlas
use github.com/zzamboni/elvish-modules/opsgenie
use github.com/zzamboni/elvish-modules/leanpub

E:LESS = "-i -R"
E:EDITOR = "vim"
E:LC_ALL = "en_US.UTF-8"

use github.com/zzamboni/elvish-modules/util
use github.com/muesli/elvish-libs/git
use github.com/iwoloschin/elvish-packages/update
update:curl-timeout = 3
#update:check-commit &verbose

#use swisscom

#-exports- = (alias:export)

use hex
fn fromhex [@args]{ hex:fromhex $@args }
fn tohex [@args]{ hex:tohex $@args }
