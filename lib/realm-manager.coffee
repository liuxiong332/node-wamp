
class Realm
  constructor: ->
    @sessions = new Set

  addSession: (session) ->
    @sessions.add session

  removeSession: (session) ->
    @sessions.delete session

class RealmManager
  constructor: ->
    @realms = {}

  get: (uri) ->
    realm = @realms[uri]
    unless realm?
      @realms[uri] = realm = new Realm
    realm

module.exports = new RealmManager
