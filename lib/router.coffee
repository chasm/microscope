@PostsListController = RouteController.extend
  template: 'postsList'
  increment: 10
  limit: ->
    parseInt(@params.postsLimit) || @increment
  findOptions: ->
    sort:
      submitted: -1
    limit: @limit()
  waitOn: ->
    Meteor.subscribe 'posts',
      @findOptions()
  posts: ->
    Posts.find {},
      @findOptions()
  data: ->
    hasMore = @posts().count() == @limit()
    nextPath = @route.path
      postsLimit: @limit() + @increment

    posts: @posts()
    nextPath: if hasMore then nextPath else null

@NewPostsListController = PostsListController.extend
  sort:
    submitted: -1
    _id: -1
  nextPath: ->
    Router.routes.newPosts.path
      postsLimit: @limit() + @increment

@BestPostsListController = PostsListController.extend
  sort:
    votes: -1
    submitted: -1
    _id: -1
  nextPath: ->
    Router.routes.bestPosts.path
      postsLimit: @limit() + @increment

Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: -> [ Meteor.subscribe 'notifications' ]

Router.map ->
  @route 'home',
    path: '/'
    controller: NewPostsListController

  @route 'newPosts',
    path: '/new/:postsLimit?'
    controller: NewPostsListController

  @route 'bestPosts',
    path: '/best/:postsLimit?'
    controller: BestPostsListController

  @route 'postPage',
    path: '/posts/:_id'
    waitOn: -> [
      Meteor.subscribe 'singlePost', @params._id
      Meteor.subscribe 'comments', @params._id
    ]
    data: ->
      Posts.findOne @params._id

  @route 'postEdit',
    path: '/posts/:_id/edit'
    waitOn: ->
      Meteor.subscribe 'singlePost', @params._id
    data: -> Posts.findOne @params._id

  @route 'postSubmit',
    path: '/submit'
    disableProgress: true

requireLogin = (pause) ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render 'accessDenied'
    pause()

Router.onBeforeAction 'loading'
Router.onBeforeAction requireLogin, only: 'postSubmit'
Router.onBeforeAction -> Errors.clearSeen()
