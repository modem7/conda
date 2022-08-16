#!/usr/bin/env bash

set -e

echo "### Initialising dep build..."
echo "### Please be patient, this can take 15-20 minutes..."

# Global Envs
SECONDS="0"
IMGNAME="condaforge/mambaforge-pypy3:4.13.0-1"
export CONDAENV="tensorflow"
export PYTHONENV="3.7"
export CONDARC="/opt/conda/.condarc"
VOLUME=CONDACACHE

# Image Specific Envs
# Connect
export CONDAREQSCONNECT="/data/env_scripts/dependencies_connect.txt"
export ENVFILECONNECT="/data/environment_connect.yml"

# Deploy
export CONDAREQSDEPLOY="/data/env_scripts/dependencies_deploy.txt"
export ENVFILEDEPLOY="/data/environment_deploy.yml"

# ML
export CONDAREQSML="/data/env_scripts/dependencies_ml.txt"
export ENVFILEML="/data/environment_ml.yml"

# Generate Environment files
docker pull $IMGNAME
docker run --rm -v $VOLUME:/opt/conda/pkgs:cached -v "$(pwd)":/data -e CONDAENV -e PYTHONENV -e CONDARC -e CONDAREQSCONNECT -e ENVFILECONNECT $IMGNAME /bin/bash -c "/data/env_scripts/buildenv_connect.sh" &
docker run --rm -v $VOLUME:/opt/conda/pkgs:cached -v "$(pwd)":/data -e CONDAENV -e PYTHONENV -e CONDARC -e CONDAREQSDEPLOY -e ENVFILEDEPLOY $IMGNAME /bin/bash -c "/data/env_scripts/buildenv_deploy.sh" &
docker run --rm -v $VOLUME:/opt/conda/pkgs:cached -v "$(pwd)":/data -e CONDAENV -e PYTHONENV -e CONDARC -e CONDAREQSML -e ENVFILEML $IMGNAME /bin/bash -c "/data/env_scripts/buildenv_ml.sh" &
wait

# If the above breaks due to the cache, try this instead
# docker pull $IMGNAME
# docker run --rm -v $VOLUME1:/opt/conda/pkgs -v "$(pwd)":/data -e CONDAENV -e PYTHONENV -e CONDARC -e CONDAREQSCONNECT -e ENVFILECONNECT $IMGNAME /bin/bash -c "/data/env_scripts/buildenv_connect.sh" &
# docker run --rm -v $VOLUME2:/opt/conda/pkgs -v "$(pwd)":/data -e CONDAENV -e PYTHONENV -e CONDARC -e CONDAREQSDEPLOY -e ENVFILEDEPLOY $IMGNAME /bin/bash -c "/data/env_scripts/buildenv_deploy.sh" &
# docker run --rm -v $VOLUME3:/opt/conda/pkgs -v "$(pwd)":/data -e CONDAENV -e PYTHONENV -e CONDARC -e CONDAREQSML -e ENVFILEML $IMGNAME /bin/bash -c "/data/env_scripts/buildenv_ml.sh" &
# wait

echo ""
echo "###################"
date -ud "@$SECONDS" "+Time taken to build all environments: %H:%M:%S"
echo "###################"
echo "You can remove the conda cache with: 'docker volume rm $VOLUME'. It will be recreated at next run."
echo "###################"

exit 0
