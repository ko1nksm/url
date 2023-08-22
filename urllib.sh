# shellcheck shell=sh

##########################################################################
# sh-urllib is released under the BSD Zero Clause License
# https://github.com/ko1nksm/sh-urllib
##########################################################################

# urlprintf [-s | -n | -f] [--] FORMAT [ARGUMENTS]...
#   -s: Use + instead of %20
#   -n: Normalize newline to \r\n
#   -f: form-urlencoded (equivalent to -sn)
#   FORMAT: printf format
urlprintf() {
  [ $# -eq 0 ] && echo "urlprintf: not enough arguments" >&2 && return 1
  _urllib_urlencode printf "$@" | (
    while [ $# -gt 0 ]; do
      case $1 in
        --) shift && break ;;
        -*) shift ;;
        *) break ;;
      esac
    done
    set -- "$1"
    while IFS= read -r line; do
      set -- "$@" "$line"
    done
    # shellcheck disable=SC2059
    printf -- "$@"
  )
}

# urlbuild [-s | -n | -f] [--] URLPATH [ARGUMENTS]...
#   -s: Use + instead of %20
#   -n: Normalize newline to \r\n
#   -f: form-urlencoded (equivalent to -sn)
#   URLPATH: url path
#   ARGUMENTS: [ -KEY VALUE | =STRING | #FRAGMENT ]...
urlbuild() {
  _urllib_urlencode build "$@"
}

_urllib_urlencode() {
  LC_ALL=C awk '
    function encode(map, str,   i, len, ret) {
      len = length(str); ret = ""
      for (i = 1; i <= len; i++) ret = ret map[substr(str, i, 1)]
      return ret
    }

    function parse_options(i) {
      space = 0; newline = 0
      while (ARGV[i] ~ /^-/ && i < ARGC) {
        if (ARGV[i] ~ /s/) space = 1
        if (ARGV[i] ~ /n/) newline = 1
        if (ARGV[i] ~ /f/) space = newline = 1
        if (ARGV[i++] == "--") break
      }
      return i
    }

    function tocrlf(i) {
      for (i = 1; i < ARGC; i++) {
        gsub(/\r\n/, "\n", ARGV[i])
        gsub(/\n/, "\r\n", ARGV[i])
      }
    }

    function urlprintf() {
      for (i++; i < ARGC; i++) print encode(url, ARGV[i])
    }

    function urlbuild() {
      path = encode(uri, ARGV[i++]); params = fragment = ""
      for (; i < ARGC; i++) {
        if (sub(/^-/, "", ARGV[i])) {
          if (params) params = params "&"
          params = params encode(url, ARGV[i]) "=" encode(url, ARGV[++i])
        } else if (sub(/^=/, "", ARGV[i])) {
          params = params encode(url, ARGV[i])
        } else if (sub(/^#/, "", ARGV[i])) {
          fragment = fragment "#" encode(url, ARGV[i])
        }
      }
      printf "%s%s%s\n", path, (params ? "?" : "") params, fragment
    }

    BEGIN {
      for(i = 0; i < 256; i++) {
        k = sprintf("%c", i); v = sprintf("%%%02X", i)
        uri[k] = (k ~ /[A-Za-z0-9_.!~*\47();\/?:@&=+$,#-]/) ? k : v
        url[k] = (k ~ /[A-Za-z0-9_.~-]/) ? k : v
      }

      mode = ARGV[1]
      i = parse_options(2)
      if (space) uri[" "] = url[" "] = "+"
      if (newline) tocrlf()

      if (mode == "printf") urlprintf()
      if (mode == "build") urlbuild()
    }
  ' "$@"
}
