# url

URL builder with URL encoding for portable shell scripts

## Usage

**The specification is not yet stable.**

```txt
Usage: url                 [-s | -n] [--] URLPATH [PARAMETERS]...
Usage: url <-p | --printf> [-s | -n] [--] FORMAT [ARGUMENTS]...

  -s                Use + instead of %20
  -n                Normalize newline to \r\n
  -p, --printf      printf mode

  URLPATH: url path
  PARAMETERS: [ -KEY VALUE | =STRING | #FRAGMENT ]...
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

### urlprintf

```txt
urlprintf FORMAT [ARGUMENTS]...

  FORMAT: printf format
  ARGUMENTS: printf argument to be URL-encoded

  Variables:
    SHURL_SPACE: A character to use instead of %20
    SHURL_EOL: Characters used on new lines
```

## Example

```console
$ url "http://example.com/" -param1 あ -param2 "か" "#さ"
http://example.com/?param1=%E3%81%82&param2=%E3%81%8B#%E3%81%95

$ url "http://example.com/" =あいうえお
http://example.com/?%E3%81%82%E3%81%84%E3%81%86%E3%81%88%E3%81%8A

$ url --printf "http://example.com/?param1=%s&param2=%s\n" あ ａ ア Ａ
http://example.com/?param1=%E3%81%82&param2=%EF%BD%81
http://example.com/?param1=%E3%82%A2&param2=%EF%BC%A1
```
