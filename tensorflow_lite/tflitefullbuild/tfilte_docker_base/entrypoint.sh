#!/bin/bash --login

set -e

# https://github.com/conda-forge/docker-images/blob/main/scripts/entrypoint

source /venv/bin/activate

# Run whatever the user wants.
echo -e "\n\e[4m### Environment Activated ###\e[0m"
echo -e "$PATH\n"
echo -e "Python Version: $(python --version | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')\n"

# echo "Import Numpy"
# python -c "import numpy; print('success')"
# echo ""

exec "$@"