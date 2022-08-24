#!/bin/bash --login

set -e

# https://github.com/conda-forge/docker-images/blob/main/scripts/entrypoint

source /venv/bin/activate

# Run whatever the user wants.
echo -e "\n\e[4m### Environment Activated ###\e[0m"
echo -e "$PATH\n"
echo -e "Python Version: $(python --version | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')\n"

# Add custom commands here:
echo "Creating 10 random files in /config to simulate data entry"
cd /config
for n in {1..10}; do
    dd if=/dev/urandom of=file$( printf %03d "$n" ).bin bs=1 count=$(( RANDOM + 1024 ))
done

# List files in /config
ls -la /config

# Run example script in /config
echo ""
sh /config/example2.sh
echo ""

exec "$@"