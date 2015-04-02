Session = require './session'
WebSocketServer = require('ws').Server
http = require('http')
util = require('util')

class Router extends WebSocketServer
  constructor: (opts = {}) ->
    @createServer opts
    super {server: @server, path: '/'}
    @operateEvent
    @sessions = new Set

  createServer: (opts) ->
    server = opts.server ? http.createServer (req, res) ->
      res.writeHead(404)
      res.end('This is WAMP transport. Please connect over WebSocket!')

    port = opts.port ? 8080
    server.listen port, ->
      util.log('bound and listen at: ' + port)
    @server = server

  operateEvent: ->
    @on 'error', (err) ->
      throw new Error('webSocketServer error: ' + err.stack)

    @on 'connection', (socket) ->
      util.log 'connection'
      session = new Session socket, {broker: {}, dealer: {}}
      @sessions.add session
      session.on 'close', => @sessions.delete session

  close: ->
    @server.close()
    super()

module.exports = Router
