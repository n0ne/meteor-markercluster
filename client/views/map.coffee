
$(window).resize(->
  h = $(window).height()
  offsetTop = 90
  $mc = $("#map_canvas")
  $mc.css "height", (h - offsetTop)
).resize()


map = undefined
markers = []
markersGroup = undefined
#
initialize = (element, centroid, zoom, features) ->
  map = L.map(element,
    scrollWheelZoom: true
    doubleClickZoom: false
    boxZoom: false
    touchZoom: false
  ).setView(new L.LatLng(centroid[0], centroid[1]), zoom)

  L.tileLayer("http://{s}.tile.cloudmade.com/61dfa55b4c7d4dc984310e66b3090afd/997/256/{z}/{x}/{y}.png",
    attribution: "Map data &copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"http://cloudmade.com\">CloudMade</a>"
  ).addTo map
  map.attributionControl.setPrefix ""



Template.map.rendered = ->

  $(window).resize(->
    h = $(window).height()
    offsetTop = 90
    $("#map_canvas").css "height", (h - offsetTop)
  ).resize()

  # initialize map events
  unless map
    initialize $("#map_canvas")[0], [46.466667, 30.733333], 13

    markersGroup = L.markerClusterGroup(
      maxClusterRadius: 100
      spiderfyOnMaxZoom: true
      showCoverageOnHover: false
      zoomToBoundsOnClick: true
    )

    Markers.find({}).observe
      added: (marker) ->

        myIcon = L.icon(
          iconUrl: "packages/leaflet/images/marker-icon.png"
          shadowUrl: "packages/leaflet/images/marker-shadow.png"
        )


        newMarker = L.marker(
          marker.latlng
        {
          icon: myIcon
          _id:  marker._id
        }
        ).on("click", (e) ->
          console.log "Marker ID: " + e.target.options._id
        )

        #      markers.push(marker)

        markersGroup.addLayer newMarker

        map.addLayer markersGroup

    map.on "dblclick", (e) ->

      markerAttributes= {
        latlng: e.latlng
      }


      Meteor.call('addMarker', markerAttributes, (error, id) ->

        if error
          console.log "Error Add marker..........."
      )