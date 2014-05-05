$ = require './vendor/jquery-1.11.1'
Promise = require 'promise'

class Results
  constructor: ->
    @template = require '../templates/results.hbs'
    @$wrapper = ($ '.result-wrapper')

  getResults: ->
    @$wrapper.html 'Laddar...'
    $.get 'api/result'

  renderResults: ->
    @getResults()
      .done (results) =>
        @$wrapper.html @template results
      .fail =>
        @$wrapper.html 'Något blev fel'


results = new Results
do results.renderResults
