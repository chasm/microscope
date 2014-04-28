@Errors = new Meteor.Collection(null)

throwError = (message) ->
  Errors.insert
    message: message

Template.errors.helpers
  errors: ->
    Errors.find()
