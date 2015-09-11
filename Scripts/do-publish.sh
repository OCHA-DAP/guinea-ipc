#!/bin/sh
########################################################################
# Publish a tagged and non-tagged version of the IPC data
########################################################################

STAGED=Staged
PUBLIC=Public

cp -v "$STAGED/ipc-merged.csv" "$PUBLIC"
cp -v "$STAGED/ipc-facility-coverage-adm1.csv" "$PUBLIC"
cp -v "$STAGED/ipc-facility-coverage-adm2.csv" "$PUBLIC"
cp -v "$STAGED/ipc-facility-coverage-adm3.csv" "$PUBLIC"

exit 0

# end
