#!/bin/sh

TMP1=/tmp/hxl-ipc1$$.csv
TMP2=/tmp/hxl-ipc2$$.csv

INDIR=Inputs
OUTDIR=Staged

FACILITIES=$INDIR/facilities.csv
MERGED=$OUTDIR/ipc-merged.csv

if [ ! -r $FACILITIES ]; then
    echo $FACILITIES missing
    exit 2
fi

if [ ! -r $MERGED ]; then
    echo $MERGED missing
    echo Must generate first
    exit 2
fi

for type in "PCI Ebola" Triage WASH; do

    # Reduce each training to a simple status
    echo Flagging facilities with training ...
    cat $MERGED \
        | hxlselect -q "output+type=$type" \
        | hxlcut -i adm2,adm3,loc \
        | hxladd -s 'Formation?#status+training=y' > $TMP1

    # Merge statuses with master list
    # facilities with training will have 'y' in the #status+training column
    # facilities without training will have that column blank
    echo Merging with full facilities list ...
    cat $FACILITIES \
        | hxlcut -i adm2,adm3,loc \
        | hxlmerge -m $TMP1 -k adm2,adm3,loc -t status+training > $TMP2

    # Count facilities with training by prefecture (ADM2)
    echo Generating per-prefecture numbers ...
    cat $TMP2 \
        | hxlselect -q status+training=y \
        | hxlcount -t adm2 \
        | hxlrename -r 'meta+count:Facilités avec formation#output+training' > $TMP1

    # Merge with total facilities to show numbers side-by-side (ADM2)
    echo Merging with full prefecture list ...
    cat $FACILITIES \
        | hxlcount -t adm2 \
        | hxlrename -r 'meta+count:Facilités au total#loc+num' \
        | hxlmerge -m $TMP1 -k adm2 -t output+training \
        | hxlreplace -p '^$' -s '0' -r -t output+training > "$OUTDIR/ipc-coverage-prefecture-$type.csv"

    # Count facilities with training by subprefecture (ADM3)
    echo Generating per-subprefecture numbers ...
    cat $TMP2 \
        | hxlselect -q status+training=y \
        | hxlcount -t adm2,adm3 \
        | hxlrename -r 'meta+count:Facilités avec formation#output+training' > $TMP1

    # Merge with total facilities to show numbers side-by-side (ADM3)
    echo Merging with full subprefecture list ...
    cat $FACILITIES \
        | hxlcount -t adm2,adm3 \
        | hxlrename -r 'meta+count:Facilités au total#loc+num' \
        | hxlmerge -m $TMP1 -k adm2,adm3 -t output+training \
        | hxlreplace -p '^$' -s '0' -r -t output+training > "$OUTDIR/ipc-coverage-sousprefecture-$type.csv"

done

echo Done - output in $OUTDIR/

# Remove the temporary files
rm -f $TMP1 $TMP2
