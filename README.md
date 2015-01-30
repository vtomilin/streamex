STREAM EXTENSIONS LIBRARAY
==========================
*Copyright Vitaly Tomilin, 2015*

**StreamEx** library contains two classes at the moment: `LineStream` and
`BufferStream`, both being `stream` implementations.

**`LineStream`** is a `stream.Transform` implementation, which tokenizes
input, written or piped to it into lines of text and then for each line emits
`data` event. It can also be piped from.

```javascript
    var LineStream = require('streamex').linestream,
        ls = new LineStream();

    ls.on('data', function(line) {
        console.log('Got some lines:', line);
    }).on('finish', function() {
        console.log('Done reading lines');
    }).on('error', function(error) {
        console.error('Error reading lines:', error);
    });

    process.stdin.pipe(ls);
```

**`BufferStream`** accumulates data, written to it in memory in a form of a `Buffer`
object.

```javascript
    var BufferStream = require('streamex').bufferstream,
        bs = new BufferStream();

     process.stdin.on('data', function() {
        console.log('Got', bs.length, 'bytes of data');
        // Data is available in bs.buffer
    });

    process.stdin.pipe(bs);
```
`BufferStream.buffer` provides a copy of data every time, retaining the original
in the stream. To purge the original use `BufferStream.toBuffer()` instead.