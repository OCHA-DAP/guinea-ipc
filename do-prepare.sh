#!/bin/bash
########################################################################
# Prepare clean HXL copies of all input sheets.
########################################################################

# Counter for creating filenames
counter=1000


# Filter an input Excel file, and produce a normalised output with only
# rows where an #org is present. If the filtering fails, then remove
# the empty output file (e.g. there is no second sheet in an Excel file)
function filter_file {
    infile="$1"
    sheet=$2
    outfile=Working/out$counter.csv

    # select and correct
    hxlselect --sheet $sheet -q org~. "$infile" | hxlreplace -m corrections-table.csv > "$outfile"
    if [[ -s "$outfile" ]]; then
        echo Filtered sheet $sheet of $infile
        let counter=counter+1
    else
        echo No HXL tags in sheet $sheet of $infile
        rm -f "$outfile"
    fi
}

#
# Filter all Excel or CSV files under Tagged/, including only rows with a value for #org
# Put filtered data under Working/ (removing any existing files there).
#

rm -rf Working/*.csv

find Tagged -iname '*.xlsx' -print0 -o -iname '*.xls' -print0 -o -iname '*.csv' -print0 | while read -d $'\0' file;
do
     filter_file "$file" 1
     filter_file "$file" 2
done

exit

# end
