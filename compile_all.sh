#!/bin/bash

SCRIPTDIR=$(pwd)
echo $SCRIPTDIR
base_dir="final-passed-challenges"
if [ -d "$base_dir" ]; then
    # Iterate over each item in the directory
    for entry in "$base_dir"/*; do
	if [ -d "$entry" ]; then
            # Echo the directory name
	    pushd $entry > /dev/null
	    VNAME="$(basename $entry)"
	    $SCRIPTDIR/bin/build.sh $VNAME clang -O0 -Wl,--allow-multiple-definition 1>/dev/null 2>/dev/null
	    popd > /dev/null
            if [ ! -f "$entry/$VNAME" ]; then
                    rm -r $entry
		    echo "$VNAME: compile failed"
            fi
        fi
    done
else
    echo "Directory '$base_dir' not found."
fi
