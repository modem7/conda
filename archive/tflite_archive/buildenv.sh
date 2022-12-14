#!/usr/bin/env bash

set -e

# Set system variables
echo "### Setting system variables..."
SECONDS="0"
PIP_ROOT_USER_ACTION='ignore'

# Set user variables
echo "### Setting user variables..."
CONDAENV="tensorflow"
PYTHONENV="3.7"
CONDAREQS="/data/conda-requirements.txt"
#PIPUPGRADE="pip setuptools wheel"
#PIPREQS="/data/pip-requirements.txt"
ENVFILE="/data/environment.yml"
CONDARC="/opt/conda/.condarc"

# Create .condarc file
echo "### Creating .condarc..."
cat > $CONDARC << EOF
channels:
  - anaconda
  - intel
  - defaults
#pip_interop_enabled: True
EOF

# Create trap for SIGINT
trap 'kill -TERM $PID' TERM INT
# Create environment
echo "### Creating environment..."
mamba create -v --name $CONDAENV -y --file $CONDAREQS python=$PYTHONENV &
PID=$!
wait $PID
trap - TERM INT
wait $PID
EXIT_STATUS=$?

# # Initialise Shell
# echo "### Initialising shell..."
# mamba init bash

# # Reload Shell
# echo "### Reloading shell..."
# source ~/.bashrc

# # Activate environment and install additional packages
# echo "### Activating environment..."
# source activate $CONDAENV
# echo ""

# Export environment file
echo "### Exporting Conda env file..."
mamba env export --no-builds -n $CONDAENV > $ENVFILE

# Install additional packages that conflict otherwise
#mamba install -y libgfortran5==9.3.0

echo ""
echo "### Created environment file in $ENVFILE"
echo ""
date -ud "@$SECONDS" "+Time taken to run script: %H:%M:%S"

exit 0