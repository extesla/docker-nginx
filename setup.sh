#!/bin/sh
# Copyright (c) 2015, Extesla LLC.
#
# It is illegal to use, reproduce or distribute any part of this
# Intellectual Property without prior written authorization from
# Extesla LLC.
set -e

#: ==========================================================================
#: Global Variables
#: ==========================================================================

#: The directory that the shell script is located in.
SCRIPT_DIR="$(cd $(dirname $0) && pwd)"

#: The location of the docker file.
DOCKERFILE="$(dirname $SCRIPT_DIR/.)"

#: The fully qualified Docker image tag, e.g. extesla/alpine:latest
IMAGE_TAG=$(cat $SCRIPT_DIR/TAG)

#: ==========================================================================
#: Functions
#: ==========================================================================

print_status() {
    echo
    echo "## $1"
    echo
}

bail() {
    echo 'Error executing command, exiting'
    exit 1
}

exec_cmd_nobail() {
  user="$(id -un 2>/dev/null || true)"
  sh_c="sh -c"

  echo "+ $1"
  $sh_c "$1"
}

exec_cmd() {
    exec_cmd_nobail "$1" || bail
}

#: The command to be run, we define the command in a variable to easily
#: reference it (and it also allows us to make changes with as few code
#: modifications as possible!).
cmd="docker build --force-rm --tag='$IMAGE_TAG' $DOCKERFILE"
exec_cmd "$cmd"
