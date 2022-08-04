#!/usr/bin/env bash

set -e

echo "Initialising dep build..."
echo "Please be patient, this can take 15-20 minutes"

exec docker run --rm --name Condabuild -v "$(pwd)":/data -w /data 'condaforge/mambaforge-pypy3:4.13.0-1' /bin/bash -c "./buildenv.sh"

exit 0

