express = require 'express'
path = require 'path'
mongoose = require 'mongoose'
bodyParser = require 'body-parser'
sass = require 'node-sass'
coffeeMiddleware = require 'coffee-middleware'
browserify = require 'browserify-middleware'
validator = require './lib/validator.coffee'
sort = new (require 'node-sort')()
Promise = require 'promise'

# Schemas
QuizResponse = require './lib/models/response.coffee'

app = express()


# database
mongoose.connect 'mongodb://localhost/wedding-quiz'

###############
# Configuration
app.use bodyParser()
app.use express.static path.join __dirname, 'public'
app.use sass.middleware
  src: "#{__dirname}/public/"
  dest: "#{__dirname}/public/"
  debug: true

browserify.settings 'transform', ['coffeeify', 'hbsfy']
app.use '/javascripts/app.js', browserify 'public/javascripts/app.coffee'
app.use '/javascripts/result.js', browserify 'public/javascripts/result.coffee'

numQuestions = 3
multiChoiceAnswers = ['1','x','2']


saveResponse = (response) ->
  quizResponse = new QuizResponse
    participantName: response.participantName
    challenge: response.challenge
    multiChoice: response.multiChoice
  do quizResponse.save


getAllResponses = ->
  dfd = new Promise (resolve, reject) ->
    QuizResponse.find (err, responses) ->
      if not err then resolve responses

getMultiChoiceScore = (response) ->
  total = 0
  for answer, key in response.multiChoice
    if answer is multiChoiceAnswers[key] then total++
  total

########
# Routes
## Help methods
sendJsonResponse = (res, response, code = 200) ->
  res.json code, response

app.get '/api', (req, res) ->
  res.send 'API is running'


# Submit answers
app.post '/api/response', (req, res) ->
  response = req.body
  result = validator.validate response, numQuestions

  if result
    saveResponse response
    res.json 200, result: 'ok'
  else
    res.json 400, result: 'missingData'


# Get all results
app.get '/api/result', (req, res) ->
  getAllResponses().then (responses) ->
    results = []
    for response in responses
      results.push
        name: response.participantName
        multiChoice: getMultiChoiceScore response

    results = sort.mergeSort results, (left, right) ->
      a = left.multiChoice
      b = right.multiChoice
      switch
        when a > b then -1
        when a is b then 0
        when a < b then 1

    res.json 200, results

# Get quiz information
app.get '/api/quiz', (req, res) ->
  sendJsonResponse res, num: numQuestions

module.exports = app
