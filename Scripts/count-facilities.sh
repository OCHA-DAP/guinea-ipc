#!/bin/sh
########################################################################
# This script counts facilities at all ADM levels.
#
# It's a bit tricky, because it has to look at any new facilities
# that partners have defined as well as the ones in the template.
#
# Creates datasets at the ADM1, ADM2, and ADM3 levels.
########################################################################

REPORTED_TRAININGS=Working/reported-trainings.csv
KNOWN_FACILITIES=Working/known-facilities.csv

echo
echo "************************************************************************"
echo "* Stage 1: prepare the training-report data"
echo "************************************************************************"
echo

echo Generating list of unique known facility/type trainings ...
cat Public/ipc-merged.csv \
    | hxlselect -q 'date~.' \
    | hxlcut -i adm1+name,adm1+code,adm2+name,adm2+code,adm3+name,adm3+code,output+type,loc+name \
    | hxldedup \
    > $REPORTED_TRAININGS

echo 'Counting trainings by region (ADM1) ...'
cat $REPORTED_TRAININGS \
    | hxlcount -t adm1+code,output+type \
    | hxlrename -r 'meta+count:Établissements formées#reached' \
    > Working/trainings-by-adm1.csv

echo 'Counting trainings by prefecture (ADM2) ...'
cat $REPORTED_TRAININGS \
    | hxlcount -t adm1+code,adm2+code,output+type \
    | hxlrename -r 'meta+count:Établissements formées#reached' \
    > Working/trainings-by-adm2.csv

echo 'Counting trainings by subprefecture (ADM3) ...'
cat $REPORTED_TRAININGS \
    | hxlcount -t adm1+code,adm2+code,adm3+code,output+type \
    | hxlrename -r 'meta+count:Établissements formées#reached' \
    > Working/trainings-by-adm3.csv


echo
echo "************************************************************************"
echo "* Stage 2: generate list of facilities in need of training."
echo "************************************************************************"
echo

echo Generating list of unique known facilities ...
cat Inputs/facilities.csv \
    | hxlcut -i 'loc+name,adm1+name,adm1+code,adm2+name,adm2+code,adm3+name,adm3+code' \
    | hxlappend -x -a Public/ipc-merged.csv \
    | hxldedup \
    > $KNOWN_FACILITIES

echo 'Counting facilities by region (ADM1) ...'
cat $KNOWN_FACILITIES \
    | hxlselect -q 'adm1+code!~^$' \
    | hxlcount -t adm1+name,adm1+code \
    | hxlrename -r 'meta+count:Total des établissements#inneed' \
    > Working/ipc-facility-counts-adm1.csv

echo 'Counting facilities by prefecture (ADM2) ...'
cat $KNOWN_FACILITIES \
    | hxlselect -q 'adm2+code!~^$' \
    | hxlcount -t adm1+name,adm1+code,adm2+name,adm2+code \
    | hxlrename -r 'meta+count:Total des établissements#inneed' \
    > Working/ipc-facility-counts-adm2.csv

echo 'Counting facilities by subprefecture (ADM3) ...'
cat $KNOWN_FACILITIES \
    | hxlselect -q 'adm3+code!~^$' \
    | hxlcount -t adm1+name,adm1+code,adm2+name,adm2+code,adm3+name,adm3+code \
    | hxlrename -r 'meta+count:Total des établissements#inneed' \
    > Working/ipc-facility-counts-adm3.csv

for level in adm1 adm2 adm3; do
    echo "Adding different types for $level..."
    basefile="Working/ipc-facility-counts-$level.csv"
    for type in 'PCI Ebola' Triage WASH; do
        outfile="Working/ipc-facility-counts-$level-$type.csv"
        cat $basefile \
            | hxladd -b -s "Type de formation#output+type=$type" \
                     > $outfile
    done
    cat "Working/ipc-facility-counts-$level-PCI Ebola.csv" \
        | hxlappend -a "Working/ipc-facility-counts-$level-Triage.csv" \
        | hxlappend -a "Working/ipc-facility-counts-$level-WASH.csv" \
        > $basefile
done

echo
echo "************************************************************************"
echo "* Merging in number of facilities with training"
echo "************************************************************************"
echo

echo "Merging for regions (ADM1) ..."
cat Working/ipc-facility-counts-adm1.csv \
    | hxlmerge -m Working/trainings-by-adm1.csv -k output+type,adm1+code -t reached \
    | hxlreplace -p '^$' -s '0' -r -t reached \
    > Public/ipc-facility-coverage-adm1.csv

echo "Merging for prefectures (ADM2) ..."
cat Working/ipc-facility-counts-adm2.csv \
    | hxlmerge -m Working/trainings-by-adm2.csv -k output+type,adm1+code,adm2+code -t reached \
    | hxlreplace -p '^$' -s '0' -r -t reached \
    > Public/ipc-facility-coverage-adm2.csv

echo "Merging for prefectures (ADM3) ..."
cat Working/ipc-facility-counts-adm3.csv \
    | hxlmerge -m Working/trainings-by-adm3.csv -k output+type,adm1+code,adm2+code,adm3+code -t reached \
    | hxlreplace -p '^$' -s '0' -r -t reached \
    > Public/ipc-facility-coverage-adm3.csv

echo Done.

exit
