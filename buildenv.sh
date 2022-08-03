#!/usr/bin/env bash

set -e

# Set variables
echo "Settings variables..."
CONDAENV=test
PYTHONENV=3.8
G_SLICE=always-malloc

# Create .condarc file
echo "Creating .condarc..."
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
echo "Creating environment..."
exec mamba create -v --name $CONDAENV -y --file /data/conda-requirements.txt python=$PYTHONENV &
PID=$!
wait $PID
trap - TERM INT
wait $PID
EXIT_STATUS=$?

# Initialise Shell
mamba init bash

# Reload Shell
source ~/.bashrc

# Activate environment and install additional packages
source activate $CONDAENV && \
python3 -m pip install --no-cache-dir -U pip setuptools wheel && \
python3 -m pip install --no-cache-dir -U -r /data/pip-requirements.txt

# Export environment file
mamba env export --no-builds > /data/environment.yml

# Install additional packages that conflict otherwise
#mamba install -y libgfortran5==9.3.0

echo "Created environment file"
exit 0