# Init PATH
set -x PATH /usr/local/bin /usr/bin /bin /usr/sbin /sbin

# Node
set -x PATH $PATH ~/.nodebrew/current/bin

set -x LANG "ja_JP.UTF-8"

# Fish

set -x fish_greeting ""

# Ruby

set -x RBENV_ROOT /usr/local/var/rbenv
status --is-interactive; and source (rbenv init -|psub)

# Dart
set -x PATH $PATH ~/.pub-cache/bin

# Git

function commit_empty 
  git commit --allow-empty -m "NOPR: squash me [ci skip]"
end

function gitco
  set argv $argv "-"
  git checkout $argv[1]
end

echo "config.fish is loaded."
