Session = require './session'
WebSocketServer = require('ws').Server
http = require 'http'
_ = require 'lodash'
util = require 'util'

class Router extends WebSocketServer
  constructor: (opts = {}, callback) ->
    if _.isFunction opts
      callback = opts
      opts = {}

    @server = opts.server ? @createServer opts, callback
    super {server: @server}
    @operateEvent()
    @sessions = new Set

  createServer: (opts, callback) ->
    server = opts.server ? http.createServer (req, res) ->
      res.writeHead(404)
      res.end('This is WAMP transport. Please connect over WebSocket!')

    port = opts.port ? 8080
    server.listen port, ->
      util.log('bound and listen at: ' + port)
      callback()
    server

  operateEvent: ->
    @on 'error', (err) ->
      throw new Error('webSocketServer error: ' + err.stack)

    @on 'connection', (socket) =>
      util.log 'a client connect to this server'
      session = new Session socket, {broker: {}, dealer: {}}
      @sessions.add session
      @operateSessionEvent session

  operateSessionEvent: (session) ->
    session.on 'did-close', =>
      @sessions.delete session
      @emit 'did-close', session

    session.on 'did-attach', => @emit 'did-attach', session

  onDidAttachSession: (callback) ->
    @on 'did-attach', callback

  onDidCloseSession: (callback) ->
    @on 'did-close', callback

  close: (callback) ->
    @server.close(callback)
    super()

module.exports = Router
