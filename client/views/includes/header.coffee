Template.header.helpers
  activeRouteClass: (args...) ->
    args.pop()

    active = _.any args, (name) ->
      Router.current() && Router.current().route.name == name

    active && 'active'
