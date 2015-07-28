#!/bin/sh

TEMPLATE="../PCI modele 2015-07-27.xlsx"
SOURCE="../../Tagged/CRS IPC uploads/Activites des partenaires par prefectures et sous prefectures _ CRS.xlsx"
PREFECTURES=$HOME/gin-master-facilities/prefectures.csv
CORRECTIONS=../../Inputs/corrections-table.csv
REPLACEMENTS=../../Inputs/replacements.csv

echo Processing public facilities ...

hxlclean --sheet 1 "$SOURCE" \
    | hxlselect -q 'org!~^$' \
    | hxladd -b -s 'org+code=CRS' \
    | hxlreplace -m $CORRECTIONS \
    | hxlreplace -m $REPLACEMENTS \
    | hxlrename -r adm2:adm2+name \
    | hxlrename -r adm3:adm3+name \
    | hxlrename -r loc:loc+name \
    | hxladd -b -s status+sector=public \
                > Working/temp1.csv

echo Processing private facilities ...
hxlclean --sheet 2 "$SOURCE" \
    | hxlselect -q 'org!~^$' \
    | hxladd -b -s '#org+code=CRS' \
    | hxlreplace --sheet 2 -m $CORRECTIONS \
    | hxlreplace -m $REPLACEMENTS \
    | hxlrename -r adm2:adm2+name \
    | hxlrename -r adm3:adm3+name \
    | hxlrename -r loc:loc+name \
    | hxladd -b -s status+sector=prive \
                > Working/temp2.csv

echo Merging data ...

cat "$TEMPLATE" \
    | hxlappend -x -a Working/temp1.csv \
    | hxlappend -x -a Working/temp2.csv \
    | hxlmerge -r -k adm2 -t adm1+name -m $PREFECTURES \
    | hxlsort \
                > crs-example.csv


#rm -rf Working/*

