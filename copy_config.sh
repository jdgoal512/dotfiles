#!/bin/bash

files=$(envsubst < FILE_LIST.txt)
save_dir="saved_config"

for f in $files; do
	if [[ $f == *":"* ]]; then #make sure the string was properly formatted
		original_location=$(echo $f | tr ":" " " | awk '{print$1}')
		local_location=$(echo $f | tr ":" " " | awk '{print$2}')
		if [ -e $original_location ]; then #make sure it exists
			if [ -d $orginal_location ]; then #it is a directory
				rm -rf $save_dir/$local_location
				cp -r $original_location $save_dir/$local_location
				echo Copied $original_location
			else #it is a normal file
				cp $original_location $save_dir/$local_location
				echo Copied $original_location
			fi
		else
			echo "Error: $f does not exist"
		fi
	else
		echo "Error: $f is not properly formatted"
	fi
done
