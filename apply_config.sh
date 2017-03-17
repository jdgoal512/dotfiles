#!/bin/bash

files=$(envsubst < FILE_LIST.txt)

save_dir="saved_config"

for f in $files; do
	if [[ $f == *":"* ]]; then #make sure the string was properly formatted
		original_location=$(echo $f | tr ":" " " | awk '{print$1}')
		local_location=$(echo $f | tr ":" " " | awk '{print$2}')
		if [ -e $save_dir/$local_location ]; then #make sure it exists
			if [ -d $save_dir/$local_location ]; then #it is a directory
				cp -r $save_dir/$local_location $original_location
				echo Applied $original_location
			else #it is a normal file
				cp $save_dir/$local_location $original_location
				echo Applied $original_location
			fi
		else
			echo "Error: $f does not exist"
		fi
	else
		echo "Error: $f is not properly formatted"
	fi
done
