Router = require '../../lib/router'
should = require 'should'
autobahn = require 'autobahn'
util = require 'util'
q = require 'q'

WebSocketServer = require('ws').Server
http = require 'http'

describe 'in RouteServer', ->
  router = null

  beforeEach (done) ->
    router = new Router done

  afterEach (done) ->
    router.close done

  it 'connect to server', (done) ->
    WebSocket = require('ws')
    ws = new WebSocket 'ws://localhost:8080/'
    ws.on 'open', ->
      done()

  it 'autobahn can connect to server', (done) ->
    router.sessions.size.should.equal 0
    conn = new autobahn.Connection {url: 'ws://localhost:8080/', realm: 'r1'}
    # connDefer = q.defer()
    conn.open()
    conn.onopen = (session) ->
      util.log 'connect to localhost successfully!'
      router.sessions.size.should.equal 1
      conn.close()

    conn.onclose = (reason, details) ->
      done()
