#!/bin/sh

TEMPLATE="../PCI modele 2015-07-27.xlsx"
SOURCE="../../Tagged/Jhpiego IPC uploads/Activites des partenaires par prefectures et sous  prefectures _ 220615_Jhpiego.xlsx"
PREFECTURES=$HOME/gin-master-facilities/prefectures.csv
CORRECTIONS=../../Inputs/corrections-table.csv
REPLACEMENTS=../../replacements.csv

echo Processing public facilities ...

hxlclean --sheet 1 "$SOURCE" \
    | hxlselect -q 'org!~^$' \
    | hxlreplace -m $CORRECTIONS \
    | hxlreplace -m $REPLACEMENTS \
    | hxlrename -r org:org+name \
    | hxlrename -r adm2:adm2+name \
    | hxlrename -r adm3:adm3+name \
    | hxlrename -r loc:loc+name \
                > Working/temp1.csv

echo Processing private facilities ...

hxlclean --sheet 2 "$SOURCE" \
    | hxlselect -q 'org!~^$' \
    | hxlreplace --sheet 2 -m $CORRECTIONS \
    | hxlreplace -m $REPLACEMENTS \
    | hxlrename -r org:org+name \
    | hxlrename -r adm2:adm2+name \
    | hxlrename -r adm3:adm3+name \
    | hxlrename -r loc:loc+name \
    | hxladd -s status+private=o \
                > Working/temp2.csv

echo Merging data ...

cat "$TEMPLATE" \
    | hxlappend -x -a Working/temp1.csv \
    | hxlappend -x -a Working/temp2.csv \
    | hxlmerge -r -k adm2 -t adm1+name -m $PREFECTURES \
    | hxlsort \
                > jhpiego-example.csv


rm -rf Working/*

