#!/bin/bash --login

# https://github.com/conda-forge/docker-images/blob/main/scripts/entrypoint

source /venv/bin/activate

# Run whatever the user wants.
echo "Environment Activated"
echo ""
echo -e "Current environment is \n$PATH"

# echo "Import Numpy"
# python -c "import numpy; print('success')"
# echo ""

exec "$@"