express = require 'express'
path = require 'path'
app = express()
mongoose = require 'mongoose'
bodyParser = require 'body-parser'

# database
mongoose.connect 'mongodb://localhost/wedding-quiz'

sendJsonResponse = (res, response) ->
  res.format json: -> res.send response

app.use bodyParser()
app.use express.static path.join __dirname, 'public'

app.get '/api', (req, res) ->
  res.send 'API is running'


# Submit answers
app.post '/api/response', (req, res) ->
  console.log req.data
  res.send 'OK'


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
  sendJsonResponse res, numQuestions: 10

module.exports = app
