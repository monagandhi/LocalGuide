jQuery(document).ready(function() {

  var icons = new Array();
  icons["red"] = new google.maps.MarkerImage("//maps.gstatic.com/mapfiles/ridefinder-images/mm_20_red.png",
    // This marker is 20 pixels wide by 32 pixels tall.
    new google.maps.Size(12, 20),
    // The origin for this image is 0,0.
    new google.maps.Point(0,0),
    // The anchor for this image is the base of the flagpole at 0,32.
    new google.maps.Point(6, 20));
  
  icons["bar"] = new google.maps.MarkerImage("/pins/pin_bar.png",
    null,
    new google.maps.Point(0,0),
    new google.maps.Point(6, 20),
    new google.maps.Size(20, 20));
    
  icons["restaurant"] = new google.maps.MarkerImage("/pins/restaurant.png",
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

  var map = new google.maps.Map(document.getElementById('map_canvas'), {
    zoom: 10,
    center: new google.maps.LatLng(-33.92, 151.25),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  var markers = [];
  var $form = $('#map_tool_form');

  $form.submit(function(e) {
    e.preventDefault();

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
    var text = $(this).children('#lat_lng').val();
    var latLngBounds = new google.maps.LatLngBounds();

    $.each(text.split('\n'), function(i, line) {
      var tokens = line.split(',');
      var lat = parseFloat(tokens[0]);
      var lng = parseFloat(tokens[1]);
      var color = $.trim(tokens[2]);
      if(color.length == 0) {color = undefined;}
      var zindex = 99;
      if(color == 'gray') {zindex = 1;}
      var latLng = new google.maps.LatLng(lat, lng);
      latLngBounds.extend(latLng);
      var marker = new google.maps.Marker({
        position: latLng,
        map: map,
        shadow: getShadow(color),
        icon: getMarkerImage(color),
        shape: iconShape,
        zIndex: zindex
      });
      markers.push(marker);
    });

    map.fitBounds(latLngBounds);
  });

  $('#lat_lng').val('37.75, 237.6, blue\n37.7, 280');
  $form.submit();
});
