#!/bin/sh
########################################################################
# Publish a tagged and non-tagged version of the IPC data
########################################################################

cp ipc-merged.csv Public
hxlclean -r ipc-merged.csv > Public/ipc-merged-notags.csv
