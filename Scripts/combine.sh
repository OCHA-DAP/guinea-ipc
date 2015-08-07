#!/bin/bash
########################################################################
# Combine all files on the command line, based on the template.
########################################################################

TEMPLATE="Templates/PCI modele 2015-07-27.xlsx"

cat "$TEMPLATE" > Working/temp1.csv

for file in "$@"; do
    echo "Adding $file ..." 1>&2
    hxlappend -x -a "$file" Working/temp1.csv > Working/temp2.csv
    mv Working/temp2.csv Working/temp1.csv
done

cat Working/temp1.csv

