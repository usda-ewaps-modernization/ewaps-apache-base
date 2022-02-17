#!/bin/bash
# THIS FILE IS NO LONGER USED, PROVIDED FOR ROLLBACK INSURANCE ONLY


# Start supervisord in foreground with given configuration
/bin/supervisord \
  --nodaemon \
  --configuration=/etc/supervisord.conf
