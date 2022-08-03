#!/usr/bin/env bash

CONDAENV=test
CHANNEL1=default
CHANNEL2=conda-forge
CHANNEL3=anaconda

# Create environment
mamba create --name $CONDAENV -y --file /data/conda-requirements.txt -c $CHANNEL1 -c $CHANNEL2 -c $CHANNEL3

# Initialise Shell
conda init bash

# Reload Shell
#bash ~/.bashrc && . ~/.bashrc && source ~/.bashrc
source ~/.bashrc

# Activate environment and install additional packages
source activate $CONDAENV && \
python3 -m pip install --no-cache-dir -U pip setuptools wheel && \
python3 -m pip install -U -r ./pip-requirements.txt

# Export environment file
mamba env export --no-builds > ./environment.yml

# Install additional packages that conflict otherwise
mamba install -y -c $CHANNEL2 -c $CHANNEL3 -c $CHANNEL1 libgfortran5==9.3.0



echo "Created environment file"
exit