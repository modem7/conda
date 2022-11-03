#!/bin/bash --login

source /venv/bin/activate

set -euo pipefail

# https://github.com/conda-forge/docker-images/blob/main/scripts/entrypoint

# Run whatever the user wants.
echo -e "\n\e[4m### Environment Activated ###\e[0m"
echo -e "$PATH\n"
echo -e "Python Version: $(python --version | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')\n"

# Add custom commands here:
echo "Import Numpy"
python -c "import numpy; print('success')"
echo ""

exec "$@"