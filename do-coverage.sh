#!/bin/sh

TMP1=/tmp/hxl-ipc1$$.csv
TMP2=/tmp/hxl-ipc2$$.csv

# Reduce each training to a simple status
cat ipc-merged.csv \
    | hxlcut -i adm2,adm3,loc \
    | hxladd -s 'Formation?#status+training=y' > $TMP1

# Merge with master list
cat ipc-facilities.csv \
    | hxlcut -i adm2,adm3,loc \
    | hxlmerge -m $TMP1 -k adm2,adm3,loc -t status+training > $TMP2

# Count facilities with training by prefecture (ADM2)
cat $TMP2 \
    | hxlselect -q status+training=y \
    | hxlcount -t adm2 \
    | hxlrename -r 'meta+count:Facilités avec formation#output+training' > $TMP1

# Merge with total facilities to show numbers side-by-side (ADM2)
cat ipc-facilities.csv \
    | hxlcount -t adm2 \
    | hxlrename -r 'meta+count:Facilités au total#loc+num' \
    | hxlmerge -m $TMP1 -k adm2 -t output+training \
    | hxlreplace -p '^$' -s '0' -r -t output+training > ipc-coverage-prefecture.csv

# Count facilities with training by subprefecture (ADM3)
cat $TMP2 \
    | hxlselect -q status+training=y \
    | hxlcount -t adm2,adm3 \
    | hxlrename -r 'meta+count:Facilités avec formation#output+training' > $TMP1

# Merge with total facilities to show numbers side-by-side (ADM3)
cat ipc-facilities.csv \
    | hxlcount -t adm2,adm3 \
    | hxlrename -r 'meta+count:Facilités au total#loc+num' \
    | hxlmerge -m $TMP1 -k adm2,adm3 -t output+training \
    | hxlreplace -p '^$' -s '0' -r -t output+training > ipc-coverage-sousprefecture.csv

# Remove the temporary files
rm -f $TMP1 $TMP2
