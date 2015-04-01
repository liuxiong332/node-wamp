Session = require '../lib/session'
sinon = require 'sinon'
EventEmitter = require('events').EventEmitter

describe 'in Session', ->
  [session, sendStub] = []
  beforeEach ->
    session = new Session(new EventEmitter, {})
    sendStub = sinon.stub(session, 'send')
    session.hello({realm: 'new-realm'})

  it 'should parse hello message', ->
    sendStub.calledWith('welcome')

  it 'should subscribe and unsubscribe event', ->

