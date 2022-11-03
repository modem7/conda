#!/usr/bin/env bash

set -e

# Set system variables
echo "### Setting system variables..."
SECONDS="0"

# # Set user variables
# echo "### Setting user variables..."
# CONDAENV="tensorflow"
# PYTHONENV="3.7"
# CONDAREQS="/data/env_scripts/dependencies_ml.txt"
# #PIPUPGRADE="pip setuptools wheel"
# #PIPREQS="/data/pip-requirements.txt"
# ENVFILE="/data/environment_ml.yml"
# CONDARC="/opt/conda/.condarc"

# Create .condarc file
echo "### Creating .condarc..."
cat > $CONDARC << EOF
channels:
  - anaconda
  - defaults
EOF

# Create trap for SIGINT
trap 'kill -TERM $PID' TERM INT
# Create environment
echo "### Creating environment..."
mamba create -v --no-deps --name $CONDAENV -y --file $CONDAREQSCHILLER python=$PYTHONENV &
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
mamba env export --no-builds -n $CONDAENV > $ENVFILECHILLER

# Install additional packages that conflict otherwise
#mamba install -y libgfortran5==9.3.0

echo ""
echo "### Created environment file in $ENVFILECHILLER"
echo ""
date -ud "@$SECONDS" "+Time taken to run script: %H:%M:%S"

exit 0