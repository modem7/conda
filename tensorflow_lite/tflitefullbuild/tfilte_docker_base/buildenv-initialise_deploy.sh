#!/usr/bin/env bash

set -e

echo "### Initialising dep build..."
echo "### Please be patient, this can take 15-20 minutes..."

# Global Envs
export CONDAENV="tensorflow"
export PYTHONENV="3.7"
export CONDARC="/opt/conda/.condarc"

# Image Specific Envs
# Deploy
export CONDAREQSDEPLOY="/data/env_scripts/dependencies_deploy.txt"
export ENVFILEDEPLOY="/data/environment_deploy.yml"

exec docker run --rm -v "$(pwd)":/data -e CONDAENV -e PYTHONENV -e CONDARC -e CONDAREQSDEPLOY -e ENVFILEDEPLOY 'condaforge/mambaforge-pypy3:4.13.0-1' /bin/bash -c "/data/env_scripts/buildenv_deploy.sh"

exit 0
