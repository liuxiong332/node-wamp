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
    session.realm.should.ok
    sendStub.calledWith('welcome')

  it 'should subscribe and unsubscribe event', ->
    session.subscribe {topic: 'test-topic', request: id: 11}
    sendStub.calledWith('subscribed')
    topic = session.realm.getTopic('test-topic')
    topic.hasSession(session).should.true

    sendStub.reset()
    session.unsubscribe
      subscribed: subscription: id: topic.id
      request: id: 11
    sendStub.calledWith 'unsubscribed'
    topic.hasSession(session).should.false

  it 'should publish event', ->
    session.subscribe {topic: 'test-topic', request: id: 11}
    topic = session.realm.getTopic('test-topic')

    sendStub.reset()
    session.publish
      topic: 'test-topic'
      options: acknowledge: true
      request: id: 122
    sendStub.calledWith 'event'
    sendStub.args[0][1].subscribed.subscription.id.should.equal topic.id
    sendStub.calledWith 'published'
    sendStub.args[1][1].publish.request.id.should.equal 122
