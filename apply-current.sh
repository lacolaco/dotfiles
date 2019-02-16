#! /bin/sh

# .gitconfig

echo "=== .gitconfig ==="
echo 
FILE=`cat ~/.gitconfig`
echo "$FILE"
echo 
read -p "コピーしますか？ [y/N]" -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "$FILE" > ./.gitconfig
    echo "Updated!"
fi
echo 

# config.fish

echo "=== config.fish ==="
echo 
FILE=`cat ~/.config/fish/config.fish`
echo "$FILE"
echo 
read -p "コピーしますか？ [y/N]" -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "$FILE" > ./fish/config.fish
    echo "Updated!"
fi
echo 

# ph-my-fish

echo "=== oh-my-fish ==="
echo 
FILE=`cat ~/.config/omf/bundle`
echo "$FILE"
echo 
read -p "コピーしますか？ [y/N]" -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "$FILE" > ./omf/bundle
    echo "Updated!"
fi
echo 


echo "DONE!"