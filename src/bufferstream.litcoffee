    stream = require 'stream'


**BufferStream** implements `stream.Writable` such that the output is
accumulated in memory until reclaimed with `BufferStream.toBuffer()`.

Data, written to the stream, can be obtained in two ways:
1. by accessing `buffer` property. In this way you will obtain a copy of the
data, meanwhile keeping original data, stored in the buffer, intact.
2. by calling `toBuffer()` method. Purges the data from the stream and returns
it.

    class BufferStream extends stream.Writable

Initializes an instance of `BufferStream`

        constructor: ->
            super()
            @sizeBytes = 0
            @buffers = []


Obtains `Buffer` object, filled with data, previously written to this
stream. Then releases memory, purging locally accumulated data. Returns
buffer object, containing the data.

        toBuffer: ->
            buffer = @buffer
            @buffers.length = 0 # Release memory
            buffer


        Object.defineProperties @prototype,

Returns current data size in bytes.

            length:
                get: -> @sizeBytes

Returns a new `Buffer` object, filled with data, written to this stream.

            buffer:
                get: ->
                    buffer = new Buffer @sizeBytes
                    offset = 0

                    for b in @buffers
                        b.copy(buffer, offset)
                        offset += b.length

                    buffer


        _write: (data, encoding, callback) ->
            data = new Buffer(data, encoding) if typeof data is 'string'

            @buffers.push data
            @sizeBytes += data.length

            callback null


    module.exports = BufferStream