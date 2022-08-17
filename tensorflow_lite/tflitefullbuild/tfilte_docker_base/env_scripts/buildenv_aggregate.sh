#!/usr/bin/env bash

set -e

# Set system variables
echo "### Setting system variables..."
SECONDS="0"

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
mamba create -v --no-deps --name $CONDAENV -y --file=$CONDAREQSCONNECT --file=$CONDAREQSDEPLOY --file=$CONDAREQSML python=$PYTHONENV &
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
mamba env export --from-history -n $CONDAENV > $ENVFILEAGG

echo ""
echo "### Created environment file in $ENVFILEAGG"
echo ""
date -ud "@$SECONDS" "+Time taken to run script: %H:%M:%S"

exit 0