set -x LANG "ja_JP.UTF-8"

# direnv hook
direnv hook fish | source

# mise activation
mise activate fish | source

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

function p
  if test -f bun.lockb;
    command bun $argv
  else if test pnpm-lock.yaml;
    command pnpm $argv
  else if test -f yarn.lock;
    command yarn $argv
  else
    command npm $argv
  end
end

echo "config.fish is loaded."

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# pnpm
set -gx PNPM_HOME "/Users/lacolaco/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Added by Antigravity
fish_add_path /Users/lacolaco/.antigravity/antigravity/bin
