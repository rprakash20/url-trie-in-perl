# url-trie-in-perl

trie implementation to get optimized URL set from a large list of URLs 

https://en.wikipedia.org/wiki/Trie

# Prerequisites
- A file containing list of URL Spaces, each URL separated by new line. For e.g. :

```
/abc.php
/test_notes.txt
/bot
/bot/
/bot/pages/
/bot/pages/page1.html
/bot/pages/page2.html
/test-5.0.0/build/examples/app/nested-loading/resources/json/products.json
/test-5.0.0/build/examples/calendar/index.html
/test-5.0.0/build/examples/charts-kitchensink/
/tmp/a/b/ab.php
/tmp/c/d/r.html
/tmp/a/c/q.php
/a/b/abcd.html
/a/z/
/z/z/
/a/
/a
/d
/d/e/f/
/d/e/f/g
/d/
```
Output:
```
Optimized URLs: $VAR1 = [
          '/bot/*',
          '/test-5.0.0/build/*',
          '/tmp/*',
          '/a/*',
          '/z/z/*',
          '/d/*'
        ];
```
