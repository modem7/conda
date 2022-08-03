#!/usr/bin/env bash

# Set variables
CONDAENV=test
CHANNEL1=default CHANNEL2=conda-forge CHANNEL3=anaconda CHANNEL4=intel

# Create environment
mamba create --name $CONDAENV -y --file /data/conda-requirements.txt -c $CHANNEL1 -c $CHANNEL2 -c $CHANNEL3 -c $CHANNEL4

# Initialise Shell
conda init bash

# Reload Shell
source ~/.bashrc

# Activate environment and install additional packages
source activate $CONDAENV && \
python3 -m pip install --no-cache-dir -U pip setuptools wheel && \
python3 -m pip install -U -r ./pip-requirements.txt

# Export environment file
mamba env export --no-builds > ./environment.yml

# Install additional packages that conflict otherwise
mamba install -y -c $CHANNEL2 libgfortran5==9.3.0

echo "Created environment file"
exit