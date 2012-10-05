/**
 * This plugin creates an Airbnb-style map (used on P3 and 'edit listing')
 *
 * To use:
 *   jQuery(selector).airbnbMap({
 *     position: hostingCoords
 *   });
 *
 * It supports the following options:
 *
 *   isFuzzy -- whether the position is accurate or not. If 'false', then
 *              this'll draw the pink circle in place of the marker.
 *   onMarkerClick -- a handler for when the marker is clicked
 *   accuracy -- the accuracy of the coordinates. use this in conjunction with
 *               'isFuzzy' to determine the initial map zoom
 *
 * Once initialized, you can call airnbnbMap() on the same jQ element and get
 * the AirbnbMap instance. You can access more properties this way, e.g.
 *
 * // grab the GMap v3 instance
 * var gMap = jQuery(selector).airbnbMap().map;
 */

(function($, window) {
  var AirbnbMap = function(el, options){
    if (el) {
      this.init(el, options);
    }
  };

  $.extend(AirbnbMap.prototype, {
    name: 'airbnbMap',
    init: function(el, options){
      this.element = $(el);
      $.data(el, this.name, this);

      var _ref = this;

      if (options.position) {
        this.position = options.position;
      }

      if (options.isFuzzy) {
        this.isFuzzy = options.isFuzzy;
      }

      if (options.onMarkerClick) {
        this.onMarkerClick = options.onMarkerClick;
      }

      if (options.accuracy) {
        this.accuracy = options.accuracy;
      }

      if (this.isFuzzy) {
        var startingZoom = 11;

        // determine the initial zoom of the listing
        if(this.accuracy >= 3 && this.accuracy <= 9) {
          startingZoom = this.accuracy + 6;
        } else if (this.accuracy == 2) {
          startingZoom = 6;
        } else if (this.accuracy == 1) {
          startingZoom = 4;
        } else {
          startingZoom = 1;
        }

        this.map = new google.maps.Map(el, {
          zoom: startingZoom,
          center: this.position,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          mapTypeControl: false,
          streetViewControl: false,
          scaleControl: true,
          scrollwheel: false
        });

        this.marker = new google.maps.Circle({
          center: this.position,
          map: this.map,
          fillColor: "rgb(255, 0, 162)",
          fillOpacity: 0.25,
          radius: AirbnbConstants.MapCircleSizes[startingZoom],
          strokeOpacity: 0.0,
          clickable: false
        });

        // hide the circle if the map view is zoomed in enough (i.e. that
        // the circle completely contains the bounds of the map view

        var checkHideCircle = function(){
          var circleBounds = _ref.marker.getBounds();
          var mapBounds = _ref.map.getBounds(); 

          if(circleBounds.contains &&
             circleBounds.contains(mapBounds.getNorthEast()) &&
             circleBounds.contains(mapBounds.getSouthWest())){
            if(!_ref.markerHidden){
              _ref.marker.setOptions({fillOpacity: 0});
              _ref.markerHidden = true;
            }
          }
          else if(_ref.markerHidden){
            _ref.marker.setOptions({fillOpacity: 0.25});
            _ref.markerHidden = false;
          }
        };

        var checkCircleSize = function() {
          _ref.marker.setRadius(AirbnbConstants.MapCircleSizes[_ref.map.getZoom()]);
        };

        google.maps.event.addListener(_ref.map, 'bounds_changed', checkHideCircle);
        google.maps.event.addListener(_ref.map, 'zoom_changed', checkCircleSize);
      } else {
        this.map = new google.maps.Map(el, {
          zoom: 15,
          center: this.position,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          mapTypeControl: false,
          streetViewControl: false,
          scrollwheel: false,
          scaleControl: true
        });

        this.marker = new google.maps.Marker({
          clickable: !!this.onMarkerClick,
          position: this.position,
          map: this.map,
          zIndex: 10,
          icon: new google.maps.MarkerImage(
            window.ImagePaths ? window.ImagePaths['guidebook/pin_home.png'] : '',
            null,
            null,
            new google.maps.Point(14, 32))
        });
      }

      if (this.onMarkerClick) {
        // pass the instance of the AirbnbMap object to the handler
        google.maps.event.addListener(this.marker, 'click', function(){
          _ref.onMarkerClick(_ref);
        });  
      }
    },

    setMarkerPosition: function(latlng) {
        if (this.isFuzzy) {
            this.marker.setCenter(latlng);
        } else {
            this.marker.setPosition(latlng);
        }
        this.map.panTo(latlng);
    },

    position: null,
    isFuzzy: false,
    map: null,
    marker: null,
    onMarkerClick: null,
    accuracy: 9,
    minZoom: 1,
    markerHidden: false
  });

  $.fn.airbnbMap = function(options){
    // get the arguments 
    var args = $.makeArray(arguments),
        after = args.slice(1);

    var instance;

    var collection = this.each(function() {
      // see if we have an instance
      instance = $.data(this, 'airbnbMap');

      if (instance) {
        // call a method on the instance
        if (typeof options === "string") {
          instance[options].apply(instance, after);
        } else if (instance.update) {
          // call update on the instance
          instance.update.apply(instance, args);
        }
      } else {
        // create the plugin
        new AirbnbMap(this, options);
      }
    });

    // return the AirbnbMap instance itself so that we can do things
    // like reference the GMaps object directly
    return instance ? instance : collection;
  };
})(jQuery, this);

if (!window.AirbnbConstants) {
  var AirbnbConstants = {};
}

//
// GMap circle radiuses for each zoom level (from 0 to 19)
//
AirbnbConstants.MapCircleSizes = [
  4096000, 2048000, 1024000, 512000, 256000, 
  128000, 64000, 32000, 16000, 8000,   
  4000, 2000, 1000, 500, 500,
  500, 500, 500, 500, 500 
];
