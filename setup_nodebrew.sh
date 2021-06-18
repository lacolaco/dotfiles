#! /bin/zsh -eux

echo "=== install nodebrew"

curl -L git.io/nodebrew | perl - setup
nodebrew install-binary v16
nodebrew use latest v16
npm set progress=false # raise performance
