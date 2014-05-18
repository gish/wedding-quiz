$ = require './vendor/jquery-1.11.1.js'


class QuizStorage
  listen: ->
    ($ 'input').on 'change', =>
      do @store
    @


  store: ->
    serializedForm = do ($ 'form').serializeArray
    answers = ({name: prop.name, value: prop.value} for prop in serializedForm)
    window.localStorage?.setItem 'answers', (JSON.stringify answers)
    @


  load: ->
    answers = window.localStorage?.getItem 'answers'

    if answers
      for answer in (JSON.parse answers)
        name = answer.name
        value = answer.value

        if /^option/.test name
          ($ "[name='#{name}'][value='#{value}']").prop 'checked', true
        else
          ($ "[name='#{name}']").val value
    @

module.exports = new QuizStorage()
