#!/bin/sh

set -eu

# build mode
./url "http://example.com/" -param1 あ -param2 "か" "#さ"
./url "http://example.com/" =あいうえお

# printf mode

./url --printf "http://example.com/?param1=%s&param2=%s" あ ａ ア Ａ
