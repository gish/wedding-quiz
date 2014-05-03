class SubmitButton
  constructor: (@$el) ->

  setSubmitting: ->
    @$el.val 'Skickar in svar'
      .prop 'disabled', true

  setSubmitted: ->
    @$el.val 'Ditt svar är lämnat'

module.exports = SubmitButton
