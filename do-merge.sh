#!/bin/bash
########################################################################
# Merge all cleaned HXL sheets into a master dataset.
########################################################################

#
# Now append all of them into a single dataset.
#
cp merge-master.csv ipc-merged.csv

for file in Working/*.csv; do
    echo Merging $file
    hxlappend -x -a $file ipc-merged.csv > temp.csv
    mv temp.csv ipc-merged.csv
done

exit

# end
