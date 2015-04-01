EventEmitter = require('events').EventEmitter
messageParser

class Session extends EventEmitter
  constructor: (socket, @supportedRoles) ->
    super()
    socket.on 'message', (data) =>
      @parse(data)

    socket.on 'error', (err) =>
      @close(null, null, false)

    # socket.on 'close', (code, reason)
    @socket = socket

  parse: (data) ->
