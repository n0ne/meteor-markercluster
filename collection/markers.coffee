@Markers = new Meteor.Collection('markers')


Meteor.methods(

  addMarker: (markerAttribute) ->

    markerId = Markers.insert(markerAttribute)

    markerId
)