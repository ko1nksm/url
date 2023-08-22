# sh-urllib

URL build and URL encoding library for portable shell scripts

## Example

```sh
#!/bin/sh

set -eu

. ./urllib.sh

urlprintf "http://example.com/?param1=%s&param2=%s\n" あ ａ ア Ａ
# => http://example.com/?param1=%E3%81%82&param2=%EF%BD%81
# => http://example.com/?param1=%E3%82%A2&param2=%EF%BC%A1

urlbuild "http://example.com/" -param1 あ -param2 "か" "#さ"
# => http://example.com/?param1=%E3%81%82&param2=%E3%81%8B#%E3%81%95

urlbuild "http://example.com/" =あいうえお
# => http://example.com/?%E3%81%82%E3%81%84%E3%81%86%E3%81%88%E3%81%8A
```

