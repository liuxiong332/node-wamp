_ = require 'lodash'
{messageTypeMap, messageDef} = require 'message-types'

typeConversion =
  'typekey': (val) -> _.findKey(messageTypeMap, val)
  'dict': (val, opt) ->
    if opt.optional and _.isEqual(val, {}) then undefined else val
  'list': (val, opt) ->
    if opt.optional and _.isEqual(val, []) then undefined else val

class MessageConstruct
  constructor: (@structure) ->

  add: (property, type, opt) ->
    @structure.push [property, type, opt]
    this

  clear: ->
    @structure = []

  encode: (message) ->
    resValue = []
    @structure.forEach ([property, type, opt]) ->
      val = message[property]
      convert = typeConversion[type]
      val = convert(val, opt) if convert?
      throw new Error("#{property} value can't null") unless val? or opt.optional
      resValue.push val if val?
    resValue

  decode: (data) ->
    resValue = {}
    @structure.forEach ([property, type, opt]) ->
      value = data.shift() if data.length > 0
      if not value? and opt?.optional
        value = if type is 'dict' then {} else if type is 'list' then []
      _.merge resValue, MessageConstruct.getDeepObj(property, value) if value?
    resValue

  # transfer the {'e1.e2': value} to {e1: {e2: value}}
  @getDeepObj: (path, value) ->
    _.reduceRight path.split('.'), ((obj, e) -> {"#{e}": obj}), value

  @decode: (data) ->
    type = messageTypeMap[data.pop()]
    throw new Error('the message type cannot recognize') unless type?
    construct = new MessageConstruct messageDef[type]
    _.assign construct.decode(data), {type: type}

  @encode: (message) ->
    construct = new MessageConstruct message.type
    [typeConversion.typekey(message.type)].concat construct.encode(message)

module.exports =
  MessageConstruct: MessageConstruct
