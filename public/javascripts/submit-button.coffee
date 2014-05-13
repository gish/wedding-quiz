class SubmitButton
  constructor: (@$el) ->
    @defaultText = @$el.text()

  setDefault: ->
    @$el.text @defaultText
      .prop 'disabled', false
      .removeClass 'is-error'

  setSubmitting: ->
    @$el.text 'Skickar in svar'
      .prop 'disabled', true
      .removeClass 'is-error'

  setSubmitted: ->
    @$el.text 'Ditt svar är lämnat'

  setMissingData: ->
    @$el.text 'Du har inte fyllt i alla svar'
      .prop 'disabled', false
      .addClass 'is-error'

module.exports = SubmitButton
