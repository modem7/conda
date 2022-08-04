#!/usr/bin/env bash

set -e

# Set variables
echo "### Setting variables... ###"
CONDAENV="test"
PYTHONENV="3.8"
G_SLICE="always-malloc"
CONDAREQS="/data/conda-requirements.txt"
PIPREQS="/data/pip-requirements.txt"
ENVFILE="/data/environment.yml"
SECONDS=0

# Create .condarc file
echo "### Creating .condarc... ###"
f=/opt/conda/.condarc
cat > $f << EOF
channels:
  - defaults
  - conda-forge
  - anaconda
pip_interop_enabled: True
EOF

# Create trap for SIGINT
trap 'kill -TERM $PID' TERM INT
# Create environment
echo "### Creating environment... ###"
exec mamba create --name $CONDAENV -y --file $CONDAREQS python=$PYTHONENV &
PID=$!
wait $PID
trap - TERM INT
wait $PID
EXIT_STATUS=$?

# Initialise Shell
echo "### Initialising shell ###"
mamba init bash

# Reload Shell
echo "### Reloading shell ###"
source ~/.bashrc

# Activate environment and install additional packages
echo "### Activating environment and installing pip packages ###"
source activate $CONDAENV && \
python3 -m pip install --root-user-action=ignore -U pip setuptools wheel && \
python3 -m pip install --root-user-action=ignore -U -r $PIPREQS

# Export environment file
echo "### Exporting Conda env file ###"
mamba env export --no-builds > $ENVFILE

# Install additional packages that conflict otherwise
#mamba install -y libgfortran5==9.3.0

echo ""
echo "### Created environment file in $ENVFILE ###"
echo ""
date -ud "@$SECONDS" "+Time taken to run script: %H:%M:%S"

exit 0