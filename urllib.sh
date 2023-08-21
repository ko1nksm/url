# shellcheck shell=sh

##########################################################################
# Base64 decoder is released under the BSD Zero Clause License
# https://github.com/ko1nksm/sh-urllib
##########################################################################
urlprintf() {
  [ $# -eq 0 ] && echo "urlprintf: not enough arguments" >&2 && return 1
  {
    shift
    LC_ALL=C awk '
      function urlencode(uri,  i, len, ret) {
        len = length(uri); ret = ""
        for (i = 1; i <= len; i++) ret = ret t[substr(uri, i, 1)]
        return ret
      }
      BEGIN {
        for(i = 0; i < 256; i++) {
          k = sprintf("%c", i); v = sprintf("%%%02X", i)
          t[k] = (k ~ /[A-Za-z0-9_.~-]/) ? k : v
        }
        for (i = 1; i < ARGC; i++) print urlencode(ARGV[i])
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
# Base64 decoder is released under the BSD Zero Clause License
# https://github.com/ko1nksm/sh-urllib
##########################################################################
urlbuild() {
  LC_ALL=C awk '
    function urlencode(uri,  i, len, ret) {
      len = length(uri); ret = ""
      for (i = 1; i <= len; i++) ret = ret t[substr(uri, i, 1)]
      return ret
    }
    BEGIN {
      for(i = 0; i < 256; i++) {
        k = sprintf("%c", i); v = sprintf("%%%02X", i)
        t[k] = (k ~ /[A-Za-z0-9_.~-]/) ? k : v
      }
      url = ARGV[1]; params = ""; fragment = ""
      for (i = 2; i < ARGC; i++) {
        if (sub(/^-/, "", ARGV[i])) {
          if (params) params = params "&"
          params = params urlencode(ARGV[i]) "=" urlencode(ARGV[++i])
        } else if (sub(/^=/, "", ARGV[i])) {
          params = params urlencode(ARGV[i])
        } else if (sub(/^#/, "", ARGV[i])) {
          fragment = fragment "#" urlencode(ARGV[i])
        }
      }
      print url (params ? "?" : "") params fragment
    }
  ' "$@"
}
