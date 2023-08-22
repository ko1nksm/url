# shellcheck shell=sh

##########################################################################
# urlprintf is released under the BSD Zero Clause License
# https://github.com/ko1nksm/sh-urllib
##########################################################################
urlprintf() {
  [ $# -eq 0 ] && echo "urlprintf: not enough arguments" >&2 && return 1
  {
    shift
    LC_ALL=C awk '
      function encode(map, str,   i, len, ret) {
        len = length(str); ret = ""
        for (i = 1; i <= len; i++) ret = ret map[substr(str, i, 1)]
        return ret
      }
      BEGIN {
        for(i = 0; i < 256; i++) {
          k = sprintf("%c", i); v = sprintf("%%%02X", i)
          url[k] = (k ~ /[A-Za-z0-9_.~-]/) ? k : v
        }
        for (i = 1; i < ARGC; i++) print encode(url, ARGV[i])
      }
    ' "$@"
  } | (
    set -- "$1"
    while IFS= read -r line; do
      set -- "$@" "$line"
    done
    # shellcheck disable=SC2059
    printf -- "$@"
  )
}

##########################################################################
# urlbuild is released under the BSD Zero Clause License
# https://github.com/ko1nksm/sh-urllib
##########################################################################
urlbuild() {
  LC_ALL=C awk '
    function encode(map, str,   i, len, ret) {
      len = length(str); ret = ""
      for (i = 1; i <= len; i++) ret = ret map[substr(str, i, 1)]
      return ret
    }
    function parse_options(i) {
      i = 1; space = 0; newline = 0
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
    BEGIN {
      for(i = 0; i < 256; i++) {
        k = sprintf("%c", i); v = sprintf("%%%02X", i)
        uri[k] = (k ~ /[A-Za-z0-9_.!~*\47();\/?:@&=+$,#-]/) ? k : v
        url[k] = (k ~ /[A-Za-z0-9_.~-]/) ? k : v
      }

      i = parse_options()
      if (space) uri[" "] = url[" "] = "+"
      if (newline) tocrlf()
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
  ' "$@"
}
