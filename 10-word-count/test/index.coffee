assert = require 'assert'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count multiple lines', (done) ->
    input = 'this is line one\nthis is line two'
    expected = words: 8, lines: 2
    helper input, expected, done

  it 'should count camel case as multiple words', (done) ->
    input = 'this line has camelCase extraWords'
    expected = words: 7, lines: 1
    helper input, expected, done

  it 'should remove a word with one double quote', (done) ->
    input = 'this is "one quote test'
    expected = words: 4, lines: 1
    helper input, expected, done

  it 'should recognize numbers in text', (done) ->
    input = 'this is 4word line'
    expected = words: 4, lines: 1
    helper input, expected, done