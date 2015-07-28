#!/bin/bash
########################################################################
# Produce activity reports for Jhpiego and CRS.
#
# Must be run from the root of the shared Guinea IPC folder.
#
########################################################################

function do_reports {

         echo Generating reports for "$2"

         cat "$1" \
             | sh Scripts/add-pcodes.sh \
             | hxlselect -q 'adm3+name!~^$' \
             | hxlselect -q 'date!~^$' \
             | hxlcount -t adm1+name,adm1+code,adm2+name,adm2+code,adm3+name,adm3+code \
                      > "Reports/$2-adm3-all.csv"

         cat "$1" \
             | sh Scripts/add-pcodes.sh \
             | hxlselect -q 'adm2+name!~^$' \
             | hxlselect -q 'date!~^$' \
             | hxlcount -t adm1+name,adm1+code,adm2+name,adm2+code \
                      > "Reports/$2-adm2-all.csv"

         cat "$1" \
             | sh Scripts/add-pcodes.sh \
             | hxlselect -q 'adm1+name!~^$' \
             | hxlselect -q 'date!~^$' \
             | hxlcount -t adm1+name,adm1+code \
                      > "Reports/$2-adm1-all.csv"

}

do_reports "Templates/Examples/PCI Jhpiego.xlsx" jhpiego
do_reports "Templates/Examples/PCI CRS.xlsx" crs
