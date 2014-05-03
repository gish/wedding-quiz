class SubmitButton
  constructor: (@$el) ->

  setSubmitting: ->
    @$el.text 'Skickar in svar'
      .prop 'disabled', true

  setSubmitted: ->
    @$el.text 'Ditt svar är lämnat'

module.exports = SubmitButton
