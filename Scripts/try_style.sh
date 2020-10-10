!/bin/bash

tmp=$(mktemp)

curl $1 > $tmp

if [ "$2" == "--light" ]
then
	theme_style="light"
	wal -i $tmp -l -a $3
else
	theme_style="dark"
	wal -i $tmp -a $3
fi

dconf load /com/gexperts/Tilix/ < ~/.cache/wal/tilix.dconf

file_ending=$(echo $1 | sed 's/^.*\.//')

echo "Export style? Please enter name (enter nothing to skip):" 
read theme_name

if [ -z "$theme_name" ]
then 
	echo "Skipping export"
	exit 1
else
	mkdir ~/themes/$theme_name && cd ~/themes/$theme_name	
	mv $tmp ~/themes/$theme_name/$theme_name.$file_ending

	#finding correct file
	file_search_pattern=$(echo $tmp | sed "s/\//_/g" | sed "s/\./_/g")
	file_name="$file_search_pattern"_"$theme_style"_None_None_1.1.0.json
	mv ~/.cache/wal/schemes/$file_name ~/themes/$theme_name/$theme_name.json

	#fixing wallpaper location
	replaced_home=$(printf '%s\n' "$HOME" | sed -e 's/[\/&]/\\&/g')
	sed -i "s/\"wallpaper\".*/\"wallpaper\": \"$replaced_home\/themes\/$theme_name\/$theme_name\.$file_ending\",/g" ~/themes/$theme_name/$theme_name.json
	echo "Saved theme under $theme_name/$theme_name"
fi


