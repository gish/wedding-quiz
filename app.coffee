express = require 'express'
path = require 'path'
app = express()
mongoose = require 'mongoose'
bodyParser = require 'body-parser'

# database
mongoose.connect 'mongodb://localhost/wedding-quiz'

app.use bodyParser()
app.use express.static path.join __dirname, 'public'

app.get '/api', (req, res) ->
  res.send 'API is running'



module.exports = app
