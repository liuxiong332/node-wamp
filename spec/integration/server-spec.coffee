Router = require '../../lib/router'
should = require 'should'
autobahn = require 'autobahn'
util = require 'util'
q = require 'q'
realmManager = require '../../lib/realm-manager'

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
    ws.on 'open', -> done()

  it 'autobahn can connect to server', (done) ->
    router.sessions.size.should.equal 0
    conn = new autobahn.Connection {url: 'ws://localhost:8080/', realm: 'r1'}
    # connDefer = q.defer()
    conn.open()
    conn.onopen = (session) ->
      util.log 'client connect to localhost successfully!'
      conn.close()

    conn.onclose = (reason, details) ->
      util.log 'client close completely!'

    router.onDidAttachSession (session) ->
      router.sessions.size.should.equal 1
      session.getRealm().should.equal realmManager.get('r1')
      realmManager.get('r1').hasSession(session).should.true

    router.onDidCloseSession (session) ->
      router.sessions.size.should.equal 0
      realmManager.get('r1').hasSession(session).should.false
      done()

  describe 'subscribe and publish feature', ->
    [conn, clientSession, serverSession] = []

    beforeEach (done) ->
      conn = new autobahn.Connection {url: 'ws://localhost:8080/', realm: 'r1'}
      conn.onopen = (session) ->
        clientSession = session
        done()
      router.onDidAttachSession (session) ->
        serverSession = session
      conn.open()

    afterEach (done) ->
      conn.close()
      router.onDidCloseSession (session) -> done()

    it 'subscribe and unsubscribe', (done) ->
      serverSession.should.be.ok

      clientSession.subscribe 'myapp.hello', (args) ->
        args.should.eql ['array']
      .then (subscription) ->
        clientSession.unsubscribe subscription

      clientSession.publish 'myapp.hello', ['array']

      serverSession.onDidSubscribe (topic) ->
        topic.hasSession(serverSession).should.true
        realmManager.get('r1').getTopic('myapp.hello').should.equal topic

      serverSession.onDidUnsubscribe (topic) ->
        topic.hasSession(serverSession).should.false
        done()

  describe 'many client subscribe and unsubscribe can work', ->
    [conns, clientSessions, clientCount] = [[], [], 20]

    beforeEach (done) ->
      defers = []
      [0...clientCount].forEach ->
        openDefer = q.defer()
        defers.push openDefer
        conn = new autobahn.Connection {url: 'ws://localhost:8080/', realm: 'r1'}
        conn.onopen = (session) ->
          clientSessions.push session
          openDefer.resolve()
        conn.open()
        conns.push conn

      q.all(defers.map (defer) -> defer.promise).then -> done()

    afterEach (done) ->
      defers = []
      conns.forEach (conn) ->
        closeDefer = q.defer()
        defers.push closeDefer
        conn.close()
        conn.onclose = ->
          closeDefer.resolve()
      q.all(defers.map (defer) -> defer.promise).then -> done()

    it 'many clients to subscribe', (done) ->
      defers = []
      clientSessions[0...clientCount - 1].forEach (session) ->
        subscribeDefer = q.defer()
        defers.push subscribeDefer
        session.subscribe 'new-topic', (args) ->
          args.should.be.eql ["invoke"]
          subscribeDefer.resolve()

      clientSessions[clientCount - 1].publish 'new-topic', ["invoke"]
      q.all(defers.map (defer) -> defer.promise).then -> done()
