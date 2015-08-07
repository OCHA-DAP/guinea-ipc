#!/bin/sh

ORG=$1

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <orgcode>"
    exit 1
fi

TEMPLATE="Templates/PCI modele 2015-07-27.xlsx"
PREFECTURES=Inputs/prefectures.csv
CORRECTIONS=Inputs/corrections-table.csv
REPLACEMENTS=Inputs/replacements.csv
SOURCE=Working/temp-source.csv

cat > "$SOURCE"

echo Processing public facilities ... 1>&2

hxlclean --sheet 1 "$SOURCE" \
    | hxlselect -q 'org!~^$' \
    | hxladd -b -s "org+code=$ORG" \
    | hxlreplace -m $CORRECTIONS \
    | hxlreplace -m $REPLACEMENTS \
    | hxlrename -r adm2:adm2+name \
    | hxlrename -r adm3:adm3+name \
    | hxlrename -r loc:loc+name \
    | hxladd -b -s status+sector=public \
                > Working/temp1.csv

echo Processing private facilities ... 1>&2
hxlclean --sheet 2 "$SOURCE" \
    | hxlselect -q 'org!~^$' \
    | hxladd -b -s "#org+code=$ORG" \
    | hxlreplace --sheet 2 -m $CORRECTIONS \
    | hxlreplace -m $REPLACEMENTS \
    | hxlrename -r adm2:adm2+name \
    | hxlrename -r adm3:adm3+name \
    | hxlrename -r loc:loc+name \
    | hxladd -b -s status+sector=prive \
                > Working/temp2.csv

echo Merging data ... 1>&2
cat "$TEMPLATE" \
    | hxlappend -x -a Working/temp1.csv \
    | hxlappend -x -a Working/temp2.csv \
    | hxlmerge -r -k adm2 -t adm1+name -m $PREFECTURES \
    | hxlsort

rm -rf Working/*

