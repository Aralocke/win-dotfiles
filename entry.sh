#!/bin/bash

# Setup the initial exports and PATH variables to bootstrap
# the rest of the scripts.
if [ -n "${DOT_ENV}" ]; then
    export DOT_ROOT="${HOME}/Development/Environment/Dotfiles"
fi

export LANG="en_US.UTF-8"

# Initialize the following module scripts
source ${DOT_ROOT}/env.sh
source ${DOT_ROOT}/ssh-agent.sh