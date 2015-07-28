#!/bin/sh
########################################################################
# Pipeline script to p-code IPC data (assuming names are normalised).
#
# Must be run from the root of the shared Guinea IPC folder.
#
# Usage:
#   cat dataset.csv | sh Scripts/add-pcodes.sh > dataset-pcoded.csv
########################################################################

hxlclean --sheet 1 \
    | hxlmerge -r -k adm1+name,adm2+name,adm3+name -t adm1+code,adm2+code,adm3+code -m Inputs/subprefectures.csv  \
    | hxlmerge -r -k adm1+name,adm2+name -t adm1+code,adm2+code -m Inputs/subprefectures.csv  \
    | hxlmerge -r -k adm1+name -t adm1+code -m Inputs/subprefectures.csv

exit

# end

