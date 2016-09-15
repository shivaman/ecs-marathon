#!/bin/bash
HOSTNAME=$(curl -s --connect-timeout 3 -m 1 169.254.169.254/latest/meta-data/local-hostname || echo "127.0.0.1")
exec 2>&1
exec ./bin/start "$@" --hostname $HOSTNAME
