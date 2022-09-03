#!/bin/bash

export DEV_ENV="${HOME}/Development/Environment"
export DEV_CACHE="${HOME}/Development/Cache"

GO_VERSION="go1.17"
JAVA_VERSION="java-11-openjdk-11.0.12-1"
PY_VERSION="Python39"

# We include the DOtfiles "bin" folder to the DEV path first.
# This gives something we can always append to safely when
# building the PATH.
DEV_ENV_PATH="${DEV_ENV}/Dotfiles/bin"

# Setup the GO environment
if [ -d "${DEV_ENV}/Go" ]; then
    DEV_ENV_PATH="${DEV_ENV_PATH}:${DEV_ENV}/Go/${GO_VERSION}/bin"

    export GO11MODULE=on
    export GOCACHE="${DEV_CACHE}/Go/${GO_VERSION}/build"
    export GOPATH="${DEV_CACHE}/Go/${GO_VERSION}"
fi

# Setup the JAVA environment
if [ -d "${DEV_ENV}/Java" ]; then
    DEV_ENV_PATH="${DEV_ENV_PATH}:${DEV_ENV}/Java/RedHat/${JAVA_VERSION}/bin"
fi

# Setup the Python Environment
if [ -d "${DEV_ENV}/Python" ]; then
    PYTHON_PATH="${DEV_ENV}/Python/${PY_VERSION}"

    if [ -d "${PYTHON_PATH}/Scripts" ]; then
        # Ensure that the scripts directory for Python global modules
        # gets added to the PATH variable correctly.
        PYTHON_PATH="${PYTHON_PATH}/Scripts:${PYTHON_PATH}"
    fi

    DEV_ENV_PATH="${DEV_ENV_PATH}:${PYTHON_PATH}"
fi

# Setup the optional ENV components
if [ -d "${DEV_ENV}/CMake" ]; then
    DEV_ENV_PATH="${DEV_ENV_PATH}:${DEV_ENV}/CMake/bin"
fi
if [ -d "${DEV_ENV}/GnuWin32" ]; then
    DEV_ENV_PATH="${DEV_ENV_PATH}:${DEV_ENV}/GnuWin32/bin"
fi
if [ -d "${DEV_ENV}/NASM" ]; then
    DEV_ENV_PATH="${DEV_ENV_PATH}:${DEV_ENV}/NASM"
fi
if [ -d "${DEV_ENV}/Rust" ]; then
    export CARGO_HOME="${DEV_ENV}/Rust"
    export RUSTUP_HOME="${DEV_ENV}/Rust"
    DEV_ENV_PATH="${DEV_ENV_PATH}:${DEV_ENV}/Rust/bin"
fi

# Export the final PATH variable to the environment
export PATH="${DEV_ENV_PATH}:${PATH}"