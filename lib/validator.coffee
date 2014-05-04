validateResponse = (response, numQuestions) ->
  (validateMultiChoice response.multiChoice, numQuestions) and (validateChallenge response.challenge) and (validateParticipantName response.participantName)

validateMultiChoice = (multiChoice, numQuestions) ->
  num = 0
  if multiChoice
    num++ for own choice of multiChoice
  multiChoice? and num is numQuestions

validateChallenge = (challenge) ->
  challenge?.length > 0

validateParticipantName = (participantName) ->
  participantName?.length > 0

module.exports =
  validate: validateResponse
