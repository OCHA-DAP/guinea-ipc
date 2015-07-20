#!/bin/sh
########################################################################
# Publish a tagged and non-tagged version of the IPC data
########################################################################

cp ipc-merged.csv Public
hxlclean --strip-tags ipc-merged.csv > Public/ipc-merged-notags.csv

cp ipc-coverage-prefecture.csv Public
hxlclean --strip-tags ipc-coverage-prefecture.csv > Public/ipc-coverage-prefecture-notags.csv

cp ipc-coverage-sousprefecture.csv Public
hxlclean --strip-tags ipc-coverage-sousprefecture.csv > Public/ipc-coverage-sousprefecture-notags.csv
