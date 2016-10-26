#!/bin/sh
set -e

ENTRYPOINT=/usr/bin/supervisord
SITES_AVAILABLE_DIR=/etc/nginx/sites-available
SITES_ENABLED_DIR=/etc/nginx/sites-enabled

#: <summary>
#: </summary>
log() {
  message=$1
  time=$(date +"%F %T %Z")
  echo -e $time $1
}

#: <summary>
#: Enable all of the available sites under nginx.
#:
#: This will iterate over all non-directories in `/etc/nginx/sites-available`
#: and create a symlink to the file from the `/etc/nginx/sites-enabled`
#: directory.
#: </summary>
enable_available_sites() {
  for target in $(find $SITES_AVAILABLE_DIR); do
    if [ ! -d $target ]; then
      link=$SITES_ENABLED_DIR/$(basename $target)
      log "[DEBUG] Enabling site: $link -> $target"
      ln -sf $target $link
    fi
  done
}

#: Visually separate breaks in log activity.
echo -e "\n\n"

log "[INFO ] Activating available nginx sites"
enable_available_sites

log "[INFO ] Starting web server"
log "[INFO ] $(date +"%b %d, %Y %H:%M:%S %z (%l:%M:%S %p %Z)")"
log "[DEBUG] > $ENTRYPOINT $@"
$ENTRYPOINT "$@"
