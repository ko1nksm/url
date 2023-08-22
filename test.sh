#!/bin/sh

set -eu

. ./urllib.sh

urlprintf "http://example.com/?param1=%s&param2=%s\n" あ ａ ア Ａ
urlbuild "http://example.com/" -param1 あ -param2 "か" "#さ"
urlbuild "http://example.com/" =あいうえお

