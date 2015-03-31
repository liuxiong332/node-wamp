_ = require 'lodash'

class MessageConstruct
  constructor: (@structure) ->

  add: (property, type) ->
    @structure.push [property, type]
    this

  clear: ->
    @structure = []

  encode: (message) ->

  decode: (data) ->
    resValue = {}
    @structure.forEach ([property]) ->
      value = data.shift() if data.length > 0
      if not value? and property.match /kwargs/
        value = {}
      else if not value? and property.match /args/
        value = []
      _.merge resValue, MessageConstruct.getDeepObj(property, value) if value?
    resValue

  @getDeepObj: (path, value) ->
    _.reduceRight path.split('.'), ((obj, e) -> {"#{e}": obj}), value

module.exports =
  MessageConstruct: MessageConstruct
