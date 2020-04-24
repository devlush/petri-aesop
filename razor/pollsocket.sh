#!/bin/sh
# pollsocket.sh

set -e

host="$1"
port="$2"

until nc -z $host $port; do
  >&2 echo "$host:$port is unavailable - sleeping"
  sleep 1
done

sleep 2
>&2 echo "$host:$port is up - exiting"

