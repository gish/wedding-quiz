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
config = require './config'

# Schemas
QuizResponse = require './lib/models/response.coffee'

app = express()


# database
mongoose.connect 'mongodb://localhost/wedding-quiz'

###############
# Configuration
app.use bodyParser()
app.use sass.middleware
  src: "#{__dirname}/public/"
  dest: "#{__dirname}/public/"
  debug: true
app.use express.static path.join __dirname, 'public'

browserify.settings 'transform', ['coffeeify', 'hbsfy']
app.use '/javascripts/app.js', browserify 'public/javascripts/app.coffee'
app.use '/javascripts/result.js', browserify 'public/javascripts/result.coffee'


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
      else do reject

getMultiChoiceScore = (response) ->
  total = 0
  for answer, key in response.multiChoice
    if answer is config.multiChoice[key] then total++
  total

getChallengeScore = (response) ->
  Math.abs(config.challenge - response.challenge)

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
  result = validator.validate response, config.multiChoice.length

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
        challenge: getChallengeScore response

    results = sort.mergeSort results, (left, right) ->
      a =
        m: left.multiChoice
        c: left.challenge
      b =
        m: right.multiChoice
        c: right.challenge

      switch
        when a.m > b.m then -1
        when a.m is b.m then (if a.c > b.c then -1 else 1)
        when a.m < b.m then 1

    res.json 200, results

# Get quiz information
app.get '/api/quiz', (req, res) ->
  sendJsonResponse res, num: config.multiChoice.length

module.exports = app
