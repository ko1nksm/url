# url

URL builder with URL encoding for CLI and portable shell scripts.
It is suitable for building URLs for `curl`, `wget`, etc.

## Usage

**The specification is not yet stable.**

```txt
Usage: url                   [-nSN] [--] URLPATH [PARAMETERS]...
Usage: url -p [-j DELIMITER] [-nSN] [--] FORMAT  [ARGUMENTS]...

  URLPATH: url path
  PARAMETERS: [ -KEY VALUE | =STRING | #FRAGMENT ]...

Global options:
  -n                      Do not print the trailing newline character
  -p, --printf            printf mode (default: build mode)

Printf mode options:
  -j, --join DELIMITER    Joins strings with the delimiter (default: '\n')

Character conversion Options:
  -S  Use + instead of %20
  -N  Normalize newline to \r\n
```

## Example

build mode:

```console
$ url "http://example.com/" -param1 あ -param2 "か" "#さ"
http://example.com/?param1=%E3%81%82&param2=%E3%81%8B#%E3%81%95

$ url "http://example.com/" =あいうえお
http://example.com/?%E3%81%82%E3%81%84%E3%81%86%E3%81%88%E3%81%8A
```

printf mode:

```console
$ url --printf "http://example.com/?param1=%s&param2=%s" あ ａ ア Ａ
http://example.com/?param1=%E3%81%82&param2=%EF%BD%81
http://example.com/?param1=%E3%82%A2&param2=%EF%BC%A1
```

## Use as a library

License is 0BSD. Feel free to copy and use the functions.

### urlbuild

```txt
urlbuild URLPATH [ARGUMENTS]...
  URLPATH: url path
  ARGUMENTS: [ -KEY VALUE | =STRING | #FRAGMENT ]...

  Variables:
    SHURL_SPACE: A character to use instead of %20
    SHURL_EOL: Characters used on new lines
```

### urlencode

```txt
urlencode [ARGUMENTS]...

  ARGUMENTS: argument to be URL-encoded

  Variables:
    SHURL_SPACE: A character to use instead of %20
    SHURL_EOL: Characters used on new lines
```

### urldecode

```txt
urldecode [ARGUMENTS]...

  ARGUMENTS: argument to be URL-decoded

  Variables:
    SHURL_SPACE: A character to use instead of %20
    SHURL_EOL: Characters used on new lines
```