#!/bin/sh
########################################################################
# Merge all incoming files.
# Must be run from the root directory
########################################################################

echo "\nChecking input files ...\n"

has_errors=0
while IFS='' read -r file; do
    if [ ! -r "$file" ]; then
        echo "* Error: $file does not exist"
        has_errors=1
    else
        hxlvalidate "$file" > /dev/null 2>&1 
        if [ "$?" -ne "0" ]; then
            echo "* Error: $file is not valid HXL"
            has_errors=1
        else
            echo "$file is OK"
        fi
    fi
done < source-files.list

if [ "$has_errors" -ne "0" ]; then
    echo "*** Errors: aborting ***"
    exit 2
fi

echo "\nCleaning and merging data...\n"

cat Templates/PCI\ modele\ 2015-08-07.xlsx \
    | hxlappend -f source-files.list \
    | hxlreplace -m Inputs/replacements.csv \
    | hxlmerge -r -k adm1+name,adm2+name,adm3+name -t adm1+code,adm2+code,adm3+code -m Inputs/subprefectures.csv  \
    | hxlmerge -r -k adm1+name,adm2+name -t adm1+code,adm2+code -m Inputs/subprefectures.csv  \
    | hxlmerge -r -k adm1+name -t adm1+code -m Inputs/subprefectures.csv \
    | hxlclean -W \
               > Staged/ipc-merged.csv

echo "\nDone merge.\n"

exit 0

