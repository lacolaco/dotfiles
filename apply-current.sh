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

# fishfile

echo "=== fishfile ==="
echo 
FILE=`cat ~/.config/fish/fishfile`
echo "$FILE"
echo 
read -p "コピーしますか？ [y/N]" -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "$FILE" > ./fish/fishfile
    echo "Updated!"
fi
echo 


echo "DONE!"