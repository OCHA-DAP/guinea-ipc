#!/bin/sh
########################################################################
# Publish a tagged and non-tagged version of the IPC data
########################################################################

STAGED=Staged
PUBLIC=Public

cp -v "$STAGED/ipc-merged.csv" "$PUBLIC"
hxlclean --strip-tags "$PUBLIC/ipc-merged.csv" > "$PUBLIC/ips-merged-notags.csv"

cd $PUBLIC
echo "Generating facility counts ..."

hxlcount -t adm1+name,adm1+code ipc-merged.csv \
    | hxlrename -r 'meta+count:Facilities#inneed+num' \
                > facility-counts-adm1.csv

hxlcount -t adm1+name,adm1+code ipc-merged.csv \
    | hxlrename -r 'meta+count:Facilities#inneed+num' \
    | hxlclean --strip-tags \
               > facility-counts-adm1-notags.csv

hxlcount -t adm1+name,adm1+code,adm2+name,adm2+code ipc-merged.csv \
    | hxlrename -r 'meta+count:Facilities#inneed+num' \
         > facility-counts-adm2.csv

hxlcount -t adm1+name,adm1+code,adm2+name,adm2+code ipc-merged.csv \
    | hxlrename -r 'meta+count:Facilities#inneed+num' \
    | hxlclean --strip-tags \
               > facility-counts-adm2-notags.csv

hxlcount -t adm1+name,adm1+code,adm2+name,adm2+code,adm3+name,adm3+code ipc-merged.csv \
    | hxlrename -r 'meta+count:Facilities#inneed+num' \
         > facility-counts-adm3.csv

hxlcount -t adm1+name,adm1+code,adm2+name,adm2+code,adm3+name,adm3+code ipc-merged.csv \
    | hxlrename -r 'meta+count:Facilities#inneed+num' \
    | hxlclean --strip-tags \
               > facility-counts-adm3-notags.csv

exit 0

# end
