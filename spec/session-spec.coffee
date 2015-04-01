Session = require '../lib/session'
sinon = require 'sinon'
EventEmitter = require('events').EventEmitter

describe 'in Session', ->
  it 'should parse hello message', ->
    socket = new EventEmitter
    session = new Session(socket, {})

    sendStub = sinon.stub(session, 'send')
    session.hello({realm: 'new-realm'})
    sendStub.calledWith('welcome')
