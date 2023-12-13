#!/bin/bash

SCRIPTDIR=$(pwd)
echo $SCRIPTDIR
PYTHONPATH=$PYTHONPATH:$SCRIPTDIR/tools/cb-testing/lib $SCRIPTDIR/tools/cb-testing/cb-test
base_dir="final-passed-challenges"
if [ -d "$base_dir" ]; then
    # Iterate over each item in the directory
    for entry in "$base_dir"/*; do
	if [ -d "$entry" ]; then
            # Echo the directory name
	    pushd $entry > /dev/null
	    VNAME="$(basename $entry)"
	    $SCRIPTDIR/bin/build.sh $VNAME clang -O0
	    readelf -a -W $VNAME | grep -e "FUNC\s*GLOBAL\s*DEFAULT\s*[0-9]" -e "FUNC\s*LOCAL\s*DEFAULT\s*[0-9]" | awk '{print $8}' > $VNAME.funcs
	    popd > /dev/null
        fi
    done
else
    echo "Directory '$base_dir' not found."
fi
