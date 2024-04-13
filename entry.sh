#!/bin/bash

# Setup the initial exports and PATH variables to bootstrap
# the rest of the scripts.
if [ -n "${DOT_ENV}" ]; then
    export DOT_ROOT="${HOME}/Development/Environment/Dotfiles"
fi

export EDITOR=vim
export PROMPT_COMMAND="history -a; history -n"
export LANG="en_US.UTF-8"

# Initialize the following module scripts
source ${DOT_ROOT}/env.sh

# If we did not load the windows SSH environment we will now load
# the environemnt from the SSH agent.
if [ -z "${GIT_SSH}" ]; then
    source ${DOT_ROOT}/ssh-agent.sh
fi
