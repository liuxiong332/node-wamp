_ = require 'lodash'

class Topic
  constructor: ->
    @id = _.random(0, Math.pow(0, 53))
    @sessions = new Set

  addSession: (session) ->
    @sessions.add session

  removeSession: (session) ->
    @sessions.delete session

  forEach: (callback) ->
    @sessions.forEach callback

class TopicSet
  constructor: ->
    @idTopics = new Map
    @uriTopics = new Map

  createTopic: (uri) ->
    topic = new Topic
    @idTopics.add topic.id, topic
    @uriTopics.add uri, topic
    topic

  getTopicByUri: (uri) ->
    topic = @uriTopics[uri]
    topic = @createTopic(uri) unless topic?
    topic

  getTopicById: (id) ->
    @idTopics[id]

class Realm
  constructor: ->
    @sessions = new Set
    @topics = new TopicSet

  addSession: (session) ->
    @sessions.add session

  removeSession: (session) ->
    @sessions.delete session

  getTopic: (uri) ->
    @topics.getTopicByUri(uri)

  subscribe: (topicUri, session) ->
    topic = @topics.getTopicByUri(topicUri)
    topic.addSession(session)
    topic.id

  unsubscribe: (id, session) ->
    topic = @topics.getTopicById(id)
    topic.removeSession(session)

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
