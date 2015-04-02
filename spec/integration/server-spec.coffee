Router = require '../../lib/router'
should = require 'should'

describe 'RouteServer', ->
  router = null
  beforeEach ->
    router = new Router

  afterEach ->
    router.close()

  it 'autobahn can connect to server', ->
    router.sessions.size.should.equal 0
