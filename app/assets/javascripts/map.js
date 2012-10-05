/*
 * Moving these into their own files.
 * Need refactoring.
 */

var map_loaded = false;
function load_map_wrapper(callback) {
    if (map_loaded) {
      if (callback && window[callback]) {window[callback]();}
    } else {
      (function() {
        var gmaps = document.createElement("script");
        gmaps.type = "text/javascript";
        gmaps.async = true;
        gmaps.src = document.location.protocol +
          "//maps.googleapis.com/maps/api/js?v=3.5&sensor=false&callback=" + callback +
          "&language=en";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(gmaps, s);
      })();
      map_loaded = true;
    }
}

var load_pano = function(){
  var pano = $('#pano').data('streetView');
  var timer;

  if(!pano){
    var lat = $('#pano').data('lat');
    var lng = $('#pano').data('lng');
    var hostingCoords = new google.maps.LatLng(lat, lng);

    // create the panorama object
    var panorama = new google.maps.StreetViewPanorama(document.getElementById("pano"), {
      position: hostingCoords,
      visible: false,
      scrollwheel: false,
      enableCloseButton: false
    });

    // see if we can find a street view for this coordinate
    new google.maps.StreetViewService().getPanoramaByLocation(hostingCoords, 50, function(data, status){
      // if not, then display the error message
      if(status !== google.maps.StreetViewStatus.OK){
        $('#pano_error').show();
        $('#pano_no_error').hide();
        return;
      }

      // otherwise, set the best position and display street view
      panorama.setPosition(data.location.latLng);
      panorama.setVisible(true);

      // set up the panning
      timer = window.setInterval(function(){
        if($('#auto_pan_pano').is(':checked')){
          var pov = panorama.getPov();
          pov.heading += 2;
          panorama.setPov(pov);
        }
      }, 200);
    });

    $('#pano').data('streetView', panorama);
  }
};

function load_google_map() {
  var MAX_ZOOM = 14;
  var MIN_ZOOM = 11;

  var map;
  var markers = []; // index 0 will be hosting location
  var place_recommendations = [], point;
  var hostingCoords = new google.maps.LatLng($('#map').data('lat'), $('#map').data('lng'));
  var bounds = new google.maps.LatLngBounds();
  bounds.extend(hostingCoords);

  $('#map').airbnbMap({
    position: hostingCoords,
    isFuzzy: true
  });

  var gMap = $('#map').airbnbMap().map;
    
  // create infowindow
  var supportInfoWindow = new google.maps.InfoWindow({
    maxWidth: 160,
    zIndex: 0
  });

  google.maps.event.addListener(gMap, 'click', function(){
    supportInfoWindow.close();
  });

  var hasRecommendations = false;

  $('#guidebook-recommendations li').each(function(idx, rec){
    hasRecommendations = true;
    var $rec = $(rec);
    var point = new google.maps.LatLng($rec.data('lat'), $rec.data('lng'));

    var marker = new google.maps.Marker({
      clickable: true,
      position: point,
      map: gMap,
      zIndex: 1,
      icon: new google.maps.MarkerImage(
        $('img', $rec).attr('src'),
        null,
        null,
        new google.maps.Point(11, 37))
    });

    google.maps.event.addListener(marker, 'click', function(){
      supportInfoWindow.setContent('<address style="color:#808080"><p style="color:#E0007A;font-weight:bold;">' + $('h2', $rec).html() + '</p>' +
          '<p>' + $('span.location', $rec).html() + '</p>' +
          '<p><span>' + $('span.city', $rec).html() + '</span>' +
          ', <span>' + $('span.state', $rec).html() + '</span>' +
          ' <span>' + $('span.zipcode', $rec).html() + '</span></p></address>' +
          '<p style="margin-top: 10px">' + $('div.description', $rec).html() + '</p>');
      
      supportInfoWindow.open(gMap, marker);
    });

    markers.push(marker);
    bounds.extend(point);
  });
  
  // finally, make sure the zoom level isn't too far back, so that we can
  // see the pink location circle
  if(hasRecommendations){
    gMap.fitBounds(bounds);

    google.maps.event.addListenerOnce(gMap, 'bounds_changed', function(){
      if (this.getZoom() > 14) {
        this.setZoom(14);
      }
    });
  }
}
