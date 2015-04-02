_ = require 'lodash'

class Topic
  constructor: ->
    @id = _.random(0, Math.pow(2, 53))
    @sessions = new Set

  getId: -> @id

  addSession: (session) ->
    @sessions.add session

  removeSession: (session) ->
    @sessions.delete session

  forEach: (callback) ->
    @sessions.forEach callback

  hasSession: (session) ->
    @sessions.has session

class TopicSet
  constructor: ->
    @idTopics = new Map
    @uriTopics = new Map

  createTopic: (uri) ->
    topic = new Topic
    @idTopics.set topic.id, topic
    @uriTopics.set uri, topic
    topic

  getTopicByUri: (uri) ->
    topic = @uriTopics.get uri
    topic = @createTopic(uri) unless topic?
    topic

  getTopicById: (id) ->
    @idTopics.get id

class Realm
  constructor: ->
    @sessions = new Set
    @topics = new TopicSet

  addSession: (session) ->
    @sessions.add session

  removeSession: (session) ->
    @sessions.delete session

  hasSession: (session) ->
    @sessions.has session

  getTopic: (uri) ->
    @topics.getTopicByUri(uri)

  subscribe: (topicUri, session) ->
    topic = @topics.getTopicByUri(topicUri)
    topic.addSession(session)
    topic

  unsubscribe: (id, session) ->
    topic = @topics.getTopicById(id)
    topic.removeSession(session)
    topic

  publish: (uri) ->
    @topics.getTopicByUri(uri)

class RealmManager
  constructor: ->
    @realms = {}

  get: (uri) ->
    realm = @realms[uri]
    unless realm?
      @realms[uri] = realm = new Realm
    realm

module.exports = new RealmManager
