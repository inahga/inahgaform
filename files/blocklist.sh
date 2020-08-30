#!/bin/bash
set -eou pipefail
curl --compressed https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt 2>/dev/null | grep -v "#" | grep -v -E "\s[1-2]$" | cut -f 1 > /etc/haproxy/auto_blocklist.txt
