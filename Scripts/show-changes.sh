#!/bin/bash
########################################################################
# Report any new or updated files under Uploads/
#
# Usage:
#   bash show-changes.sh
#
# Note: requires /bin/bash, not /bin/sh
# Note: must be run from this directory.
#
# Started by David Megginson, 2015-07-15
########################################################################

UPLOADS=`pwd`/Uploads
TAGGED=`pwd`/Tagged

cd "$UPLOADS"
find . -iname '*.xlsx' -print0 -o -iname '*.xls' -print0 -o -iname '*.csv' -print0 | while read -d $'\0' file; do
    if [ -f "$TAGGED/$file" ]; then
        if [ "$UPLOADS/$file" -nt "$TAGGED/$file" ]; then
            echo "File updated: $file"
        fi
    else
        echo "New file: $file"
    fi
done

exit

# end
