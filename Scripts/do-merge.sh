#!/bin/sh
########################################################################
# Merge all incoming files.
# Must be run from the root directory
########################################################################

cat Templates/PCI\ modele\ 2015-08-07.xlsx \
    | hxlappend -f source-files.list \
    | hxlreplace -m Inputs/replacements.csv \
    | hxlmerge -r -k adm1+name,adm2+name,adm3+name -t adm1+code,adm2+code,adm3+code -m Inputs/subprefectures.csv  \
    | hxlmerge -r -k adm1+name,adm2+name -t adm1+code,adm2+code -m Inputs/subprefectures.csv  \
    | hxlmerge -r -k adm1+name -t adm1+code -m Inputs/subprefectures.csv \
               > Staged/ipc-merged.csv

exit 0

