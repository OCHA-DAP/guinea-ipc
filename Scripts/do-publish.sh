#!/bin/sh
########################################################################
# Publish a tagged and non-tagged version of the IPC data
########################################################################

STAGED=Staged
PUBLIC=Public

SOURCES="ipc-merged.csv ipc-coverage-prefecture.csv ipc-coverage-sousprefecture.csv"

# Sanity check on Staged, first
for source in $SOURCES; do
    if [ ! -r $STAGED/$source ]; then
        echo Missing $STAGED/$source
        exit 2
    fi
done

# OK, do the publishing run
for source in $SOURCES; do
    notags=`basename $source .csv`-notags.csv
    echo Publishing $PUBLIC/$source
    cp $STAGED/$source $PUBLIC
    echo Publishing $PUBLIC/$notags
    hxlclean --strip-tags $STAGED/$source > $PUBLIC/$notags
done

exit 0

# end
