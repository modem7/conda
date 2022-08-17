#!/bin/bash --login

# https://github.com/conda-forge/docker-images/blob/main/scripts/entrypoint

source /venv/bin/activate

# Run whatever the user wants.
echo "Import Numpy"
python -c "import numpy; print('success')"
echo ""
echo "Try Tensorflow calculation"
python -c "import os; os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2' ; import tensorflow as tf; print(tf.reduce_sum(tf.random.normal([1000, 1000])))"

exec "$@"