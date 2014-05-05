$ = require './vendor/jquery-1.11.1'
Promise = require 'promise'

## Templates
templates =
  results: require '../templates/results.hbs'


$wrapper = ($ '.result-wrapper')

getResults = ->
  $wrapper.html 'Laddar...'
  $.get 'api/result'


renderResult = ->
  getResults()
    .done (results) ->
      $wrapper.html templates.results results
    .fail ->
      $wrapper.html 'Något blev fel'


$wrapper.html 'Laddar...'
do renderResult
