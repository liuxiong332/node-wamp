_ = require 'lodash'
{messageTypeMap, messageDef} = require './message-types'

class MessageParser
  constructor: (@structure) ->

  add: (property, type, opt) ->
    @structure.push [property, type, opt]
    this

  clear: ->
    @structure = []

  trim: (data) ->
    cur = @structure.length - 1
    loop
      lastValue = _.last(data)
      [property, type, opt] = @structure[cur]

      if opt?.optional and MessageParser.isEmpty(type, lastValue)
        data.pop()
        cur--
      else
        break
    data

  encode: (message) ->
    resValue = []
    @structure.forEach ([property, type, opt]) ->
      val = MessageParser.getDeepVal(message, property)
      unless val? or opt.optional
        throw new Error("#{property} value can't null")
      resValue.push val
    @trim resValue

  decode: (data) ->
    resValue = {}
    @structure.forEach ([property, type, opt]) ->
      value = data.shift() if data.length > 0
      if not value? and opt?.optional
        value = if type is 'dict' then {} else if type is 'list' then []
      _.merge resValue, MessageParser.getDeepObj(property, value) if value?
    resValue

  @isEmpty: (type, value) ->
    type is 'dict' and _.isEqual(value, {}) or
    type is 'list' and _.isEqual(value, []) or not value?

  # transfer the {'e1.e2': value} to {e1: {e2: value}}
  @getDeepObj: (path, value) ->
    _.reduceRight path.split('.'), ((obj, e) -> {"#{e}": obj}), value

  @getDeepVal: (obj, path) ->
    _.reduce path.split('.'), ((obj, e) -> obj[e]), obj

  @decode: (data) ->
    type = messageTypeMap[data.shift()]
    throw new Error('the message type cannot recognize') unless type?
    construct = new MessageParser messageDef[type]
    _.assign construct.decode(data), {type: type}

  @encode: (message) ->
    construct = new MessageParser messageDef[message.type]
    [@getTypeKey(message.type)].concat construct.encode(message)

  @getTypeKey: (val) ->
    parseInt _.findKey(messageTypeMap, (type) -> type is val)

module.exports = MessageParser
