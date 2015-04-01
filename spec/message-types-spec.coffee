
messageParser = require '../lib/message-parser'
should = require 'should'
util = require 'util'
_ = require 'lodash'

describe 'in MessageConstruct', ->

  it 'method getDeepObj run correctly', ->
    getDeepObj = messageParser.MessageConstruct.getDeepObj

    getDeepObj('e1', 'value').should.eql {'e1': 'value'}
    getDeepObj('e1.e2', 'value').should.eql {'e1': {e2: 'value'}}
    getDeepObj('e1.e2.e3', 'value').should.eql {'e1': {e2: {e3: 'value'}}}

  it 'should decode the json data', ->
    struct = new messageParser.MessageConstruct [['prop1', 'id'], ['prop2', 'id']]
    res = struct.decode ['hello', 'world']
    res.should.eql {prop1: 'hello', prop2: 'world'}

    struct = new messageParser.MessageConstruct [['a.b', 'id'], ['a.a', 'id'], ['b', 'id']]
    res = struct.decode ['val1', 'val2', 'val3']
    res.should.eql {a: {b: 'val1', a: 'val2'}, b: 'val3'}

    struct.add('args', 'list', {optional: true}).add('kwargs', 'dict', {optional: true})
    res = struct.decode ['val1', 'val2', 'val3']
    res.should.eql {a: {b: 'val1', a: 'val2'}, b: 'val3', args: [], kwargs: {}}

  it 'should encode the message', ->
    message = {a: {b: 'val1', a: 'val2'}, b: 'val3'}
    struct = new messageParser.MessageConstruct [['a.b', 'string'], ['a.a', 'string'], ['b', 'string']]
    struct.encode(message).should.eql ['val1', 'val2', 'val3']

  describe 'in MessageConstruct class context', ->
    it 'should decode and encode the message', ->
      require('./fixture/messages').messages.forEach (data) ->
        msg = messageParser.MessageConstruct.decode _.cloneDeep(data)
        messageParser.MessageConstruct.encode(msg).should.eql(data)
