#!/bin/bash --login

# https://github.com/conda-forge/docker-images/blob/main/scripts/entrypoint

source /venv/bin/activate

# Run whatever the user wants.
echo "Import Numpy"
python -c "import numpy; print('success')"
echo ""

exec "$@"