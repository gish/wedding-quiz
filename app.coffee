express = require 'express'
path = require 'path'
mongoose = require 'mongoose'
bodyParser = require 'body-parser'
sass = require 'node-sass'
coffeeMiddleware = require 'coffee-middleware'
browserify = require 'browserify-middleware'
validator = require './validator.coffee'

app = express()


# database
#mongoose.connect 'mongodb://localhost/wedding-quiz'

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

numQuestions = 10


########
# Routes
## Help methods
sendJsonResponse = (res, response) ->
  res.format json: -> res.send response

app.get '/api', (req, res) ->
  res.send 'API is running'


# Submit answers
app.post '/api/response', (req, res) ->
  response = req.body
  result = validator.validate response, numQuestions
  sendJsonResponse res, result: if result then 'ok' else 'fail'

# Get all results
app.get '/api/result', (req, res) ->
  sendJsonResponse res,
    [
      name: 'Erik'
      score: 10
    ,
      name: 'Åsa'
      score: 12
    ]


# Get quiz information
app.get '/api/quiz', (req, res) ->
  sendJsonResponse res, num: numQuestions

module.exports = app
