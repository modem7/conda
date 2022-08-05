#!/usr/bin/env bash

set -e

# Set system variables
echo "### Setting system variables..."
PYTHONDONTWRITEBYTECODE="true"
SECONDS=0

# Set user variables
echo "### Setting user variables..."
CONDAENV="test"
PYTHONENV="3.8"
CONDAREQS="/data/conda-requirements.txt"
PIPUPGRADE="pip setuptools wheel"
PIPREQS="/data/pip-requirements.txt"
ENVFILE="/data/environment.yml"
CONDARC="/opt/conda/.condarc"

# Create .condarc file
echo "### Creating .condarc..."
cat > $CONDARC << EOF
channels:
  - conda-forge
  - anaconda
  - fastchan
  - intel
  - defaults
pip_interop_enabled: True
EOF

# Create environment
echo "### Creating environment..."
exec mamba create -v --name $CONDAENV -y --file $CONDAREQS python=$PYTHONENV

# Initialise Shell
echo "### Initialising shell..."
mamba init bash

# Reload Shell
echo "### Reloading shell..."
source ~/.bashrc

# Activate environment and install additional packages
echo "### Activating environment and installing pip packages..."
source activate $CONDAENV && \
#python3 -m pip install --root-user-action=ignore -U $PIPUPGRADE
python3 -m pip install --root-user-action=ignore -U -r $PIPREQS
echo ""

# Export environment file
echo "### Exporting Conda env file..."
mamba env export --no-builds > $ENVFILE

# Install additional packages that conflict otherwise
#mamba install -y libgfortran5==9.3.0

echo ""
echo "### Created environment file in $ENVFILE"
echo ""
date -ud "@$SECONDS" "+Time taken to run script: %H:%M:%S"

exit 0