#! /bin/sh

K_dir="/data/game/kinght/30008"
zip_K_dir=/opt/update/update.zip


if [ ! -d "$K_dir" ];then
    mkdir -p "$K_dir"
else
     rm -rf "$K_dir"/* 
fi

if [ -f  /"$zip_K_dir" ];then

   echo "The file zip"
else
   echo "The file doesn't zip"

fi



cd "$K_dir"

cp -f /$zip_K_dir /$K_dir

unzip update.zip

find  -name "*.bak" | awk '{new=gensub(".bak", "''",1);system("mv "$0" "new)}'    

chmod a+x *.sh

find  -name "*.sh" | xargs dos2unix

