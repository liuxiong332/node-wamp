
WebSocketServer = require('ws').Server
http = require('http')
util = require('util')

class Router extends WebSocketServer
  constructor: (opts = {}) ->
    server = opts.server ? http.createServer (req, res) ->
      res.writeHead(404)
      res.end('This is WAMP transport. Please connect over WebSocket!')

    server.on 'error', (err) ->
      throw new Error('httpServer error: ' + err.stack)

    port = opts.port ? 8080
    server.listen port, ->
      util.log('bound and listen at: ' + port)

    super {server: server, path: '/'}
    @server = server
    @operateEvent

  operateEvent: ->
    @on 'error', (err) ->
      throw new Error('webSocketServer error: ' + err.stack)

    @on 'connection', (socket) ->
      util.log 'connection'

  close: ->
    @server.close()
    super()

module.exports = Router
