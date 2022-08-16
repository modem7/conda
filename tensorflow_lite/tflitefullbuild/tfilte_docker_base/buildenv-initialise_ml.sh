#!/usr/bin/env bash

set -e

echo "### Initialising dep build..."
echo "### Please be patient, this can take 15-20 minutes..."

# Global Envs
export CONDAENV="tensorflow"
export PYTHONENV="3.7"
export CONDARC="/opt/conda/.condarc"

# Image Specific Envs
# ML
export CONDAREQSML="/data/env_scripts/dependencies_ml.txt"
export ENVFILEML="/data/environment_ml.yml"

exec docker run --rm -v "$(pwd)":/data -e CONDAENV -e PYTHONENV -e CONDARC -e CONDAREQSML -e ENVFILEML 'condaforge/mambaforge-pypy3:4.13.0-1' /bin/bash -c "/data/env_scripts/buildenv_ml.sh"

exit 0
