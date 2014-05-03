$ = require './vendor/jquery-1.11.1'
Promise = require 'promise'
SubmitButton = require './submit-button.coffee'

## Templates
templates =
  multiChoice: require '../templates/multichoice.hbs'

submitButton = new SubmitButton ($ '[type="submit"]')


getQuizQuestions = ->
  promise = new Promise (resolve, reject) ->
    $.get 'api/quiz', (data) ->
      resolve data


renderQuizQuestion = (num) ->
  ($ '[data-type="multichoice"]').append templates.multiChoice
    num: num
    options: ['1', 'x', '2']


renderQuiz = ->
  getQuizQuestions().then (questions) ->
    total = questions.num
    renderQuizQuestion num for num in [1..total] by 1


getMultiChoiceAnswers = ->
  answers = {}
  $multiChoice = ($ '[name^="option"]:checked')
  $multiChoice.each ->
    $choice = ($ this)
    num = ($choice.attr 'name').replace 'option-', ''
    choice = $choice.attr 'value'
    answers[num] = choice
  answers


submitQuiz = ->
  answers =
    multiChoice: do getMultiChoiceAnswers
    challenge: ($ '[name="challenge"]').val()
    participantName: ($ '[name="participant-name"]').val()

  do submitButton.setSubmitting

  $.post '/api/response', answers, (response) ->
    setTimeout ->
      console.log 'Submitted'
      if response.result is 'ok'
        do submitButton.setSubmitted
      else
        do submitButton.setMissingData
    , 300


setupListeners = ->
  ($ document).ready ->
    do renderQuiz

  ($ 'form').on 'submit', (e) ->
    e.preventDefault()
    do submitQuiz


do setupListeners
