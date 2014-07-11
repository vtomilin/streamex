
    stream = require 'stream'
    os = require 'os'

**LineStream** implements `stream.Writable` such that it recognizes lines of text
in the input and emits `lines` event, carrying an array of recognized lines of
text.

Normally, you want to pipe your input stream into an instance of `LineStream`,
while listening for `lines` event on the latter.

    class LineStream extends stream.Writable

Initializes an instance of `LineStream` with options given. See `stream.Writable`
for details.

        constructor: (options = {}) ->
            @chunkBuffer = new Buffer(LineStream::CHUNKBUF_LEN)
            @lastLine = ''
            @on 'finish', =>
                @emit 'lines', [ @lastLine ] if @lastLine

            options.highWaterMark = LineStream::CHUNKBUF_LEN
            super options


        _write: (chunk, encoding, callback) ->
            lenReqd = chunk.length + @lastLine.length

            @chunkBuffer = new Buffer(lenReqd) if @chunkBuffer.length < lenReqd

            @chunkBuffer.write(@lastLine)

            if Buffer.isBuffer(chunk)
                chunk.copy(@chunkBuffer, @lastLine.length)
            else
                @chunkBuffer.write(chunk, @lastLine.length)

            [lines..., @lastLine] = String::split.call(@chunkBuffer.slice(0, lenReqd), os.EOL)

            @emit 'lines', lines

            callback(null)


    LineStream::CHUNKBUF_LEN = 4096


    module.exports = LineStream
