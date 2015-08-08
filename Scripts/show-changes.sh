#!/bin/bash
########################################################################
# Report any new or updated files under Uploads/
#
# Usage:
#   bash show-changes.sh
#
# Looks only into one level of subdirectories, so that it won't see
# files in Archive/ subdirectories (etc.).  Accepts only the extensions
# *.xls, *.xlsx, or *.csv
#
# Note: requires /bin/bash, not /bin/sh
# Note: must be run from this directory.
#
# Started by David Megginson, 2015-07-15
########################################################################

UPLOADS=`pwd`/Uploads
RECEIVED=`pwd`/Received

cd "$UPLOADS"
find . -maxdepth 2 -iname '*.xlsx' -print0 -o -iname '*.xls' -print0 -o -iname '*.csv' -print0 | while read -d $'\0' file; do
    if [ -f "$RECEIVED/$file" ]; then
        if [ "$UPLOADS/$file" -nt "$RECEIVED/$file" ]; then
            echo "File updated: $file"
        fi
    else
        echo "New file: $file"
    fi
done

exit

# end
