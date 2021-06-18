set -x LANG "ja_JP.UTF-8"

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
