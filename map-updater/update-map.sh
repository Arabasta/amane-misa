#!/usr/bin/env bash

set -euo pipefail

DB_URL="http://database:3003/"
TMP_MAP="/tmp/node-master.map.tmp"
FINAL_MAP="/usr/local/etc/haproxy/node-master.map"
HAP_SOCK="/var/run/haproxy/admin.sock"

# pull JSON from database
curl -s "$DB_URL" \
  | jq -r 'to_entries[] | "\(.key) \(.value)"' \
  > "$TMP_MAP"

# swap the file (so restart still has latest see reference 6)
cat "$TMP_MAP" > "$FINAL_MAP"

# Start Runtime API
# start map transaction
VER=$( echo "prepare map $FINAL_MAP" \
       | socat stdio "$HAP_SOCK" \
       | awk '/New version created:/ { print $NF }' )

# clear old map
echo "clear map @$VER $FINAL_MAP" \
  | socat stdio "$HAP_SOCK"

# add all map entries to new version (can probably optimize this)
while read NODE MASTER; do
  echo "add map @$VER $FINAL_MAP $NODE $MASTER" \
    | socat stdio "$HAP_SOCK"
done < "$FINAL_MAP"

# atomic update
echo "commit map @$VER $FINAL_MAP" \
  | socat stdio "$HAP_SOCK"
echo "Committed map $VER into runtime"
# End Runtime API

# view updated map
echo "show map /usr/local/etc/haproxy/node-master.map" | socat stdio /var/run/haproxy/admin.sock

# references
# 1. https://www.haproxy.com/documentation/haproxy-runtime-api/reference/prepare-map/
# 2. https://www.haproxy.com/documentation/haproxy-runtime-api/reference/add-map/
# 3. https://www.haproxy.com/blog/introduction-to-haproxy-maps
# 4. https://www.haproxy.com/blog/dynamic-configuration-haproxy-runtime-api
# 5. https://www.haproxy.com/documentation/haproxy-configuration-tutorials/proxying-essentials/custom-rules/map-files/#match-a-domain
# 6. https://www.haproxy.com/documentation/haproxy-runtime-api/
# 7. https://www.haproxy.com/documentation/haproxy-runtime-api/installation/