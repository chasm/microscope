Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: ->
    Meteor.subscribe 'posts'

Router.map ->
  this.route 'postsList',
    path: '/'

Router.onBeforeAction 'loading'
