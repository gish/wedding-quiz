mongoose = require 'mongoose'

Schema = mongoose.Schema

ResponseSchema = new Schema
  multiChoice: [String]
  participantName:
    type: String
    required: true
  challenge:
    type: String
    required: true

module.exports = mongoose.model 'Response', ResponseSchema
