#!/bin/bash

#echo $@

#monitor=$(i3-msg -t get_outputs | jq '.[] | select(.active == true and .current_workspace == '`i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name'`') | .name' | cut -d"\"" -f2)
size=3
wrap=false

left() {
	base_position=$((($1-1)/$size*$size+1))
	new_position=$(($1-1))
	if (( $base_position > $new_position )); then
		if [ $wrap = true ]; then
                	new_position=$(($base_position+$size-1))
		else
			new_position=invalid
		fi
	fi
	echo $new_position
}

right() {
	base_position=$((($1-1)/$size*$size+$size))
	new_position=$(($1+1))
    	if (($base_position < $new_position)); then
		if [ $wrap = true ]; then
                	new_position=$(($base_position-$size+1))
		else
			new_position=invalid
		fi
	fi
	echo $new_position
}

up() {
	new_position=$(($1-$size))
	if (($new_position < 1)); then
		if [ $wrap = true ]; then
        		new_position=$(($size*$size+$new_position))
		else
			new_position=invalid
		fi
	fi
	echo "$new_position"
}

down() {
	new_position=$(($1+$size))
	if (($size*$size < $new_position)); then
		if [ $wrap = true ]; then
        		new_position=$(($new_position-$size*$size))
		else
			new_position=invalid
		fi
	fi
	echo "$new_position"
}

current_workspace=$(bspc query -D -d focused --names)


#echo "Current workspace: "$current_workspace

if [ "$2" == "left" ]; then
	new_workspace=$(left $current_workspace)
elif [ "$2" == "right" ]; then
	new_workspace=$(right $current_workspace)
elif [ "$2" == "up" ]; then
	new_workspace=$(up $current_workspace)
elif [ "$2" == "down" ]; then
	new_workspace=$(down $current_workspace)
else
	printf "Invalid direction (%s)\n" "$2"
	exit
fi

#echo "Next workspace: "$new_workspace
if [ $new_workspace != invalid ]; then
    if [ "$1" == desktop ]; then
        bspc desktop -f $new_workspace
        ~/.config/i3/notify "Workspace $new_workspace"
    elif [ "$1" == window ]; then
        bspc node -f -d ^$new_workspace --follow && ~/.config/i3/notify "Workspace $new_workspace"
    else
	printf "Invalid command (%s)\n" "$1"
    fi
fi
