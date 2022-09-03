#!/bin/bash

# Handle the complexities of dealing with SSH
# and starting the agent up automatically.

SSH_ENV="${HOME}/.ssh/environment"
SSH_CONFIG="${HOME}/.ssh/identities"


function ssh_load_identities() {
  ssh-add -l | grep "no identities" > /dev/null
  if [ $? -eq 0 ]; then
    ssh_reload_identities
  elif [ $? -eq 2 ]; then
    ssh_start_agent
    ssh_reload_indentities
  fi
}

function ssh_reload_identities() {
  if [ -f "${SSH_CONFIG}" ]; then
    for ident in `cat ${SSH_CONFIG}`; do
        echo "Loading identity: ${ident}"
        if [ -f "${ident}" ]; then
            cat ${ident} | ssh-add -
        fi
    done
  fi
}

function ssh_start_agent() {
  echo "Initializing SSH agent"
  ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
  echo "SSH Agent loaded"
  chmod 600 ${SSH_ENV}
  . "${SSH_ENV}" > /dev/null
  ssh-add
}

function ssh_test_identities() {
  ssh-add -l | grep "no identities" > /dev/null
  if [ $? -eq 0 ]; then
    ssh-add
    if [ $? -eq 2 ]; then
      echo "Starting new agent"
      ssh_start_agent
    fi
  elif [ $? -eq 2 ]; then
    echo "Failed to reach agent starting a new one"
    ssh_start_agent
  fi
}

# Check for an active ssh-agent with a valid SSH_AGENT_PID
# value set.
if [ -n "${SSH_AGENT_PID}" ]; then
  ps ef | grep "${SSH_AGENT_PID}" | grep ssh-agent > /dev/null
  if [ $? -eq 0 ]; then
    ssh_test_identities
  fi
else
  echo "Attempting to load ssh-agent from SSH environment"
  if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
  else
    echo "No SSH environment found. Starting new agent"
    ssh_start_agent
  fi
  ps -ef | grep "${SSH_AGENT_PID}" | grep -v grep | grep ssh-agent > /dev/null
  if [ $? -eq 0 ]; then
    ssh_test_identities
  else
    ssh_start_agent
  fi
fi
if [ -n "${SSH_AGENT_PID}" ]; then
  ps ef | grep "${SSH_AGENT_PID}" | grep ssh-agent > /dev/null
  if [ $? -eq 0 ]; then
    echo "Successfully loaded SSH agent"
    ssh_load_identities
  else
    echo "Failed to load SSH agent"
  fi
else
    echo "Failed to load SSH agent"
fi
