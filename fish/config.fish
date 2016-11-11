# Init PATH
set -x PATH ~/bin /usr/local/bin /usr/bin /bin /usr/sbin /sbin

# Node
set -x PATH ~/.nodebrew/current/bin

# Golang
set -x GOPATH ~/gopath
set -x GOROOT (brew --prefix go)"/libexec"
set -x PATH $PATH $GOPATH/bin $GOROOT/bin

# GCP
set -x PATH $PATH ~/go_appengine ~/google-cloud-sdk/bin

set -x LANG "ja_JP.UTF-8"

# Fish

set -e fish_greeting # erase greeting

# $(npm bin) の代わりに使う。
# npmbin tsc --help
function npmbin
  eval (pwd)"/node_modules/.bin/"(echo $argv)
end