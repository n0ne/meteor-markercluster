Meteor.publish 'markers', () ->
  return Markers.find()

