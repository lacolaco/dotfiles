# Init PATH
set -x PATH /usr/local/bin /usr/bin /bin /usr/sbin /sbin

set -x LANG "ja_JP.UTF-8"

# Node
set -x PATH $PATH ~/.nodebrew/current/bin

# Fish

set -x fish_greeting ""

# Git

function commit_empty 
  git commit --allow-empty -m "NOPR: squash me [ci skip]"
end

function gitco
  set argv $argv "-"
  git checkout $argv[1]
end

function hp
  history | peco
end

echo "config.fish is loaded."
