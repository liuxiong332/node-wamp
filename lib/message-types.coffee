_ = require 'lodash'

class MessageStruct
  constructor: ->
    @info = []

  member: (property, type) ->
    @info.push [property, type]
    this

  encode: (message) ->

  decode: (data) ->
    resValue = {}
    for [property] in @info
      value = data.shift() if data.length > 0
      value = value ? {} if property.match /kwargs/ ? [] if property.match /args/
      _.merge resValue, @getDeepObj(property, value) if value?
    resValue

  @getDeepObj: (path, value) ->
    _.reduceRight path.split('.'), ((obj, e) -> {"#{e}": obj}), value

module.exports =
  MessageStruct: MessageStruct
