
messageTypes = require '../lib/message-types'
should = require 'should'
util = require 'util'

describe 'message-types', ->

  it 'method getDeepObj run correctly', ->
    getDeepObj = messageTypes.MessageStruct.getDeepObj
    util.log getDeepObj('e1', 'value')

    getDeepObj('e1', 'value').should.eql {'e1': 'value'}
    getDeepObj('e1.e2', 'value').should.eql {'e1': {e2: 'value'}}
    getDeepObj('e1.e2.e3', 'value').should.eql {'e1': {e2: {e3: 'value'}}}
