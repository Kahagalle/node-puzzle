fs = require 'fs'
readline = require('readline')

exports.countryIpCounter = (countryCode, cb) ->
    return cb() unless countryCode

    fileStream = fs.createReadStream("#{__dirname}/../data/geo.txt")
    lineReader = readline.createInterface(
        input: fileStream
    )
    
    counter = 0

    lineReader.on "line", (line) ->
        line = line.split '\t'
        # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
        # line[0],       line[1],       line[3]

        if line[3] == countryCode then counter += +line[1] - +line[0]
        return

    lineReader.on "close", ->
        cb null, counter

    return