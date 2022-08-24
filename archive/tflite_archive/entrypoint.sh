#!/bin/bash -il

# https://github.com/conda-forge/docker-images/blob/main/scripts/entrypoint

source /venv/bin/activate

# Run whatever the user wants.
python -c "import numpy; print('success')"

exec "$@"