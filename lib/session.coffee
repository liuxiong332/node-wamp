EventEmitter = require('events').EventEmitter
MessageParser = require './message-parser'
realmManager = require './realm-manager'
_ = require 'lodash'
util = require 'util'

module.exports =
class Session extends EventEmitter
  constructor: (socket, @roles) ->
    super()
    socket.on 'message', (data) =>
      @parse(data)

    socket.on 'error', (err) ->
      console.error("websocket error, #{err.stack}")

    socket.on 'close', (code, reason) =>
      @onDidClose(code, reason)

    @socket = socket
    @subscribeTopics = new Set

  onDidClose: (code, reason) ->
    @realm?.removeSession this
    @realm = null
    @subscribeTopics.forEach (topic) => topic.removeSession this
    @subscribeTopics.clear()
    @emit 'did-close'

  onDidSubscribe: (callback) ->
    @on 'did-subscribe', callback

  onDidUnsubscribe: (callback) ->
    @on 'did-unsubscribe', callback

  onDidPublish: (callback) ->
    @on 'did-publish', callback

  parse: (data) ->
    data = JSON.parse(data)
    msg = MessageParser.decode data
    this[msg.type].call(this, msg)

  getRealm: -> @realm

  send: (type, args) ->
    data = MessageParser.encode _.assign(args, type: type)
    @socket.send JSON.stringify(data), (err) ->
      throw new Error("send #{type} message error, #{err}") if err?

  hello: (msg) ->
    @id = _.random(0, Math.pow(2, 53))
    # bind the session and realm
    @realm = realmManager.get(msg.realm)
    @realm.addSession(this)

    @emit 'did-attach'
    @send 'welcome',
      session: id: @id
      details: roles: @roles

  goodbye: (msg) ->
    @send 'goodbye', details: {message: 'Close connection'}, reason: msg.reason
    @socket.close(1000, msg.reason)

  subscribe: (msg) ->
    topic = @realm.subscribe msg.topic, this
    @subscribeTopics.add topic
    @emit 'did-subscribe', topic
    @send 'subscribed',
      subscribe: request: id: msg.request.id
      subscription: id: topic.id

  unsubscribe: (msg) ->
    topic = @realm.unsubscribe(msg.subscribed.subscription.id, this)
    @subscribeTopics.delete topic
    @emit 'did-unsubscribe', topic
    @send 'unsubscribed',
      unsubscribe: request: id: msg.request.id

  publish: (msg) ->
    publicationId = _.random(0, Math.pow(2, 53))
    topic = @realm.publish(msg.topic)
    topic.forEach (session) ->
      session.send 'event',
        subscribed: subscription: id: topic.id
        published: publication: id: publicationId
        details: {}
        publish: {args: msg.args, kwargs: msg.kwargs}

    @emit 'did-publish', topic
    if msg.options?.acknowledge
      @send 'published',
        publish: request: id: msg.request.id
        publication: id: publicationId
