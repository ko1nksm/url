#!/bin/sh

set -eu

./url --printf "http://example.com/?param1=%s&param2=%s\n" あ ａ ア Ａ
./url "http://example.com/" -param1 あ -param2 "か" "#さ"
./url "http://example.com/" =あいうえお
