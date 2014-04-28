Template.postItem.helpers
  ownPost: ->
    @userId == Meteor.userId()
  domain: ->
    a = document.createElement('a')
    a.href = @url
    a.hostname
  commentsCount: ->
    Comments.find( postId: this._id ).count()
