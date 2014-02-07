Router.configure
  layoutTemplate: "layout"


Router.map ->

  @route "home",
    path: "/"
    waitOn: ->
      Meteor.subscribe "markers"
