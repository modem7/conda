#!/usr/bin/env bash

echo "Initialising dep build..."

docker run --rm -v "$(pwd)":/data -w /data 'condaforge/mambaforge-pypy3:4.9.2-7' /bin/bash -c ./buildenv.sh