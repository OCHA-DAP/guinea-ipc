#!/bin/sh

for org in ACF CRS "Expertise France" Jhpiego "PU AMI" TDH WAHA; do
    echo "Processing $org ..." 1>&2
    find "Tagged/$org IPC uploads/" -name '*Activit*' -print0 | xargs -0 cat | sh Scripts/convert-to-new-template.sh "$org" > "Staged/$org-converted.csv"
done
