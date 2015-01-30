
    stream = require 'stream'
    os = require 'os'

LineStream implements Read/Writable stream such that it recognizes lines of text in
the input and emits 'data' events for each line.

Normally, you want to pipe your input stream into an instance of `LineStream`,
while either listening for `data` event on it or pipe it further.

    class LineStream extends stream.Transform

Initializes an instance of `LineStream` with options given. See `stream.Transform`
for details.

        constructor: (options = {}) ->

            @chunkBuffer = new Buffer(LineStream::CHUNKBUF_LEN)
            @lastLine = ''

            options.highWaterMark = LineStream::CHUNKBUF_LEN
            super options


        _transform: (chunk, encoding, callback) ->
            lenReqd = chunk.length + @lastLine.length

            @chunkBuffer = new Buffer(lenReqd) if @chunkBuffer.length < lenReqd

            @chunkBuffer.write(@lastLine)

            if Buffer.isBuffer(chunk)
                chunk.copy(@chunkBuffer, @lastLine.length)
            else
                @chunkBuffer.write(chunk, @lastLine.length)

            [lines..., @lastLine] = String::split.call(@chunkBuffer.slice(0, lenReqd), os.EOL)

            callback()


        _flush: (callback) ->
            @push @lastLine if @lastLine
            callback()

    LineStream::CHUNKBUF_LEN = 4096


    module.exports = LineStream
