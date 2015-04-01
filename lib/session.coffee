EventEmitter = require('events').EventEmitter
MessageParser = require './message-parser'
realmManager = require './realm-manager'
_ = require 'lodash'

module.exports =
class Session extends EventEmitter
  constructor: (socket, @roles) ->
    super()
    socket.on 'message', (data) =>
      @parse(data)

    socket.on 'error', (err) =>
      @close(null, null, false)

    # socket.on 'close', (code, reason)
    @socket = socket

  close: (reason, wasClean) ->
    @send 'goodbye', details: {message: 'Close connection'}, reason: reason

  parse: (data) ->
    msg = MessageParser.decode data
    this[msg.type].call(this, msg)

  send: (type, args) ->
    data = MessageParser.encode _.assign(args, type: type)
    @socket.send data, (err) ->
      console.error "send #{type} message error, #{err}"

  hello: (msg) ->
    @id = _.random(0, Math.pow(2, 53))
    # bind the session and realm
    @realm = realmManager.get(msg.realm)
    @realm.addSession(this)

    @send 'welcome',
      session: id: @id
      details: roles: @roles

  goodbye: (msg) ->
    @close(msg.reason)

  subscribe: (msg) ->
    topicId = @realm.subscribe msg.topic, this
    @send 'subscribed',
      subscribe: request: id: msg.request.id
      subscription: id: topicId

  unsubscribe: (msg) ->
    @realm.unsubscribe(msg.subscribed.subscription.id, this)
    @send 'unsubscribed',
      unsubscribe: request: id: message

  publish: (msg) ->
    publicationId = _.random(0, Math.pow(2, 53))
    topic = @realm.publish(msg.topic)
    topic.forEach (session) ->
      session.send 'event',
        subscribed: subscription: id: topic.id
        published: publication: id: publicationId
        details: {}
        publish: {args: msg.args, kwargs: msg.kwargs}
    if msg.options?.acknowledge
      @send 'published',
        publish: request: id: msg.request.id
        publication: id: publicationId
