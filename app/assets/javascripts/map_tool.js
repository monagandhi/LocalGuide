$(document).ready(function() {

  var icons = new Array();
  icons["red"] = new google.maps.MarkerImage("//maps.gstatic.com/mapfiles/ridefinder-images/mm_20_red.png",
    new google.maps.Size(12, 20),
    new google.maps.Point(0,0),
    new google.maps.Point(6, 20));

  icons["blue"] = new google.maps.MarkerImage("/pins/pin_cafe.png",
    null,
    new google.maps.Point(0,0),
    new google.maps.Point(6, 20),
    new google.maps.Size(20, 20));

  icons["restaurant"] = new google.maps.MarkerImage("/pins/pin_restaurant.png",
    null,
    new google.maps.Point(0,0),
    new google.maps.Point(6, 20),
    new google.maps.Size(20, 20));

  var iconShadow = new google.maps.MarkerImage('//maps.gstatic.com/mapfiles/ridefinder-images/mm_20_shadow.png',
    // The shadow image is larger in the horizontal dimension
    // while the position and offset are the same as for the main image.
    new google.maps.Size(22, 20),
    new google.maps.Point(0,0),
    new google.maps.Point(6, 20));

  function getMarkerImage(iconColor) {
    if ((typeof(iconColor)=="undefined") || (iconColor==null)) { 
      iconColor = "red"; 
    }
    if (!icons[iconColor]) {
      icons[iconColor] = new google.maps.MarkerImage("//maps.gstatic.com/mapfiles/ridefinder-images/mm_20_"+ iconColor +".png",
      // This marker is 20 pixels wide by 32 pixels tall.
      new google.maps.Size(12, 20),
      // The origin for this image is 0,0.
      new google.maps.Point(0,0),
      // The anchor for this image is the base of the flagpole at 0,32.
      new google.maps.Point(6, 20));
    } 
    return icons[iconColor];
  }

  function getShadow(iconColor) {
    if (iconColor == "bar" || iconColor == "restaurant")
      return null;
    else
      return iconShadow;
  }

  var infoWindow = new google.maps.InfoWindow;

  var onMarkerClick = function() {
    globalmarker = $(this);
    var marker = this;
    var popup = $('#p'+marker.customid);
    if (popup.html()) {
      infoWindow.setContent(popup.html());
    } else {
      popup = $('#h'+marker.customid);
      //console.log('popup: ' + popup.html())
      //console.log("id: "+ marker.customid)
      if (popup.html()) {
        var id = popup.attr("data-id");
        var name = popup.attr("data-nm");
        var reviews = popup.attr("data-rv");
        var price = popup.attr("data-pr");
      
        infoWindow.setContent("<a class='map_info_window_link_image' href='https://www.airbnb.com/rooms/"+id+"'>"+
  "<img width='210' height='140' class='map_info_window_thumbnail' src='http://i0.muscache.com/pictures/"+id+"/small.jpg'>"+
  "</a><p class='map_info_window_details'>"+
  "<a class='map_info_window_link' href='https://www.airbnb.com/rooms/"+id+"'>"+name+"</a>"+
  "<span class='map_info_window_review_count'>"+reviews+" reviews</span>"+
  "<span class='map_info_window_price'>$"+price+"</span></p>");
      } else {
        var latLng = marker.getPosition();
        infoWindow.setContent('<h3>Marker position is:</h3>' +
          latLng.lat() + ', ' + latLng.lng());
      }
    }
    infoWindow.open(map, marker);
  };

  var map = new google.maps.Map(document.getElementById('map_canvas'), {
    zoom: 10,
    center: new google.maps.LatLng(-33.92, 151.25),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  var markers = [];
  var $form = $('#map_tool_form');

  function paintMarkers() {
    //e.preventDefault();

    // Clear old markers
    $.each(markers, function(i, marker) {
      marker.setMap(null);
    });

    // Add markers to the map
    
    // Marker sizes are expressed as a Size of X,Y
    // where the origin of the image (0,0) is located
    // in the top left of the image.
   
    // Origins, anchor positions and coordinates of the marker
    // increase in the X direction to the right and in
    // the Y direction down.
    var iconImage = new google.maps.MarkerImage('//maps.gstatic.com/mapfiles/ridefinder-images/mm_20_red.png',
      // This marker is 20 pixels wide by 32 pixels tall.
      new google.maps.Size(12, 20),
      // The origin for this image is 0,0.
      new google.maps.Point(0,0),
      // The anchor for this image is the base of the flagpole at 0,32.
      new google.maps.Point(6, 20));
      // Shapes define the clickable region of the icon.
      // The type defines an HTML &lt;area&gt; element 'poly' which
      // traces out a polygon as a series of X,Y points. The final
      // coordinate closes the poly by connecting to the first
      // coordinate.
    var iconShape = {
      coord: [4,0,0,4,0,7,3,11,4,19,7,19,8,11,11,7,11,4,7,0],
      type: 'poly'
    };

    markers = [];
    var latLngBounds = new google.maps.LatLngBounds();

    $('#markers li').each(function(index) {
      $this = $(this)
      var lat = parseFloat($this.attr("data-lat"));
      var lng = parseFloat($this.attr("data-lng"));
      var color = $.trim($this.attr("data-color"));
      var id = parseFloat($this.attr("data-id"));
      //console.log(lat + "," + lng + "," + color);
      if(color.length == 0) {color = undefined;}
      var zindex = 99;
      if(color == 'gray') {zindex = 1;}
      var latLng = new google.maps.LatLng(lat, lng);
      latLngBounds.extend(latLng);
      //console.log(latLngBounds);
      var marker = new google.maps.Marker({
        position: latLng,
        map: map,
        shadow: getShadow(color),
        icon: getMarkerImage(color),
        shape: iconShape,
        zIndex: zindex
      });
      marker.customid = id;
      lastMarker = marker;
      google.maps.event.addListener(marker, 'click', onMarkerClick);
      markers.push(marker);
    });

    map.fitBounds(latLngBounds);
  }

  //$('#lat_lng').val('37.75, 237.6, blue\n37.7, 280');
  paintMarkers();
});
