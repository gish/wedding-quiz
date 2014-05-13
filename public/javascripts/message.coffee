template = require '../templates/message.hbs'
$ = require './vendor/jquery-1.11.1'

class Message
  constructor: (@type, @message) ->
    @template = template
    @$el = $ '<div>'
    @setupListeners()


  setupListeners: ->
    @$el.on 'click', =>
      @remove()


  render: ->
    @$el.html (@template type: @type, message: @message)
    @


  remove: ->
    @$el.remove()
    @

module.exports = Message
