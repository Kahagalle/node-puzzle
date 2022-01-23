through2 = require 'through2'


module.exports = ->
    words = 0
    lines = 1

    transform = (chunk, encoding, cb) ->
        lineData = chunk.split('\n')

        for line in lineData
            line = line.replace(/"((?:""|[^"])*)"/g, "word")
            lineWords = line.split(' ')

            for word in lineWords
                camelCaseWordMatch = word.match(/([a-zA-Z0-9]+)([A-Z]{1}[a-zA-Z0-9]+)/g)
                wordMatch = word.match(/[a-z0-9]+/gi)

                if camelCaseWordMatch && camelCaseWordMatch.length && camelCaseWordMatch[0] == word
                    words += 2
                else if wordMatch && wordMatch.length && wordMatch[0] == word
                    words += 1
            
        lines = lineData.length
        return cb()

    flush = (cb) ->
        this.push {words, lines}
        this.push null
        return cb()

    return through2.obj transform, flush
