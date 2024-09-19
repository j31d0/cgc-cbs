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
	    /home/user/FIBLE/_build/default/ocaml-core/src/tool/wrapper.exe $VNAME 
	    /home/user/FIBLE/_build/default/ocaml-core/src/tool/decompiler.exe $VNAME.elf_ext
	    popd > /dev/null
        fi
    done
else
    echo "Directory '$base_dir' not found."
fi

