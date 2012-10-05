if (!window.airbnb) {window.airbnb = {};}

airbnb.MarkerImage = function(type) {
	google.maps.MarkerImage.call(
		this,
		Airbnb.MarkerImagePaths[type] || Airbnb.MarkerImagePaths.other,
		null, null, new google.maps.Point(11, 36)
	);
};

airbnb.MarkerImage.prototype = new google.maps.MarkerImage();
airbnb.MarkerImage.prototype.constructor = airbnb.MarkerImage;

$(document).ready(function() {
	var editingMarker, editingRec, gmap, newMarker, placesService;

	var geocoder = new google.maps.Geocoder();
	var createForm = $(".new_place_recommendation");
	var mapDiv = $("#map");
	var hostingCoords = new google.maps.LatLng(
		mapDiv.attr("data-hosting-lat"),
		mapDiv.attr("data-hosting-lng"));
	var bounds = new google.maps.LatLngBounds();
	var editingInfoWindow = new google.maps.InfoWindow({
		maxWidth: 250
	});

	bounds.extend(hostingCoords);
	$('#map').airbnbMap({
		position: hostingCoords
	});

	gmap = $('#map').airbnbMap().map;
	placesService = new google.maps.places.PlacesService(gmap);

	$(".search-form").submit(function() {
		var $b = $(this).find(":submit");
		var q = $(this).find("input").val();
		var r = {bounds: gmap.getBounds(), name: q};
		placesService.search(r, function(results, status) {
			if (google.maps.places.PlacesServiceStatus.OK === status) {
				placesService.getDetails(
					{reference: results[0].reference},
					function(details, detailsStatus) {
						if (google.maps.places.PlacesServiceStatus.OK === detailsStatus) {
							setEditingPlace(details);
						} else {
							CreateForm.reset();
						}
					});
			}
			$b.removeAttr("disabled");
			$b = q = r = null;
		});
		return false;
	});

	createForm.find("#place_recommendation_question").each(function() {
		var icon = $(this).nextAll("#form-icon-container")[0];
		$(this).change(function() {
			var type = $($(this)[0].options[$(this).val()]).attr("data-pin-icon");
			icon.className = ("place-" + type);

			var marker = newMarker || editingMarker;
			if (marker) {
				marker.setIcon(new airbnb.MarkerImage(type));
			}
		});
	});

	createForm.find(".cancel-link").click(function() {
		CreateForm.reset();

		if (editingRec) {
			editingRec.removeClass("selected");
			editingMarker.setIcon(new airbnb.MarkerImage(editingRec.find("address").attr("data-pin-icon")));
			editingRec = editingMarker = null;
		} else {
			newMarker.setVisible(false);
		}

		editingInfoWindow.close();
		return false;
	});

	google.maps.event.addListener(editingInfoWindow, "closeclick", function() {
		if (editingRec) {
			createForm.find(".cancel-link").click();
		} else {
			CreateForm.reset();
		}

		if (newMarker) {
			newMarker.setVisible(false);
		}
	});

	var addresses = $("#recommendations address");
	if (addresses.length > 0) {
		addresses.each(function() {
			var a = $(this);
			var coords = new google.maps.LatLng(
				a.attr("data-place-lat"),
				a.attr("data-place-lng"));
			bounds.extend(coords);

			var marker = new google.maps.Marker({
				position: coords,
				map: gmap,
				icon: new airbnb.MarkerImage(a.attr("data-pin-icon"))
			});

			a.data("marker", marker);
			google.maps.event.addListener(marker, "click", function() {
				var li = a.closest("li");
				li.find(".edit-link").click();
				$("#recommendations").scrollTop(li.position().top);
				editingInfoWindow.open(gmap, marker);
			});
		});

		gmap.fitBounds(bounds);
	}

	$("#center-link").click(function(e) {
		gmap.panTo(hostingCoords);
		gmap.setZoom(15);
		e.preventDefault();
	});

	$("#recommendations").delegate("h2", "click", function() {
		var $li = $(this).closest("li");
		$li.toggleClass("collapsed");
		return false;
	});

	$("#recommendations").delegate(".delete-link", "click", function() {
		var answer = $(this).closest("li");
		var marker = answer.find("address").data("marker");
		answer.find(".recommendation-scrim").show();

		if (marker === editingMarker) {
			editingMarker = null;
			editingRec = null;
			editingInfoWindow.close();
			google.maps.event.clearInstanceListeners(marker);
			CreateForm.reset();
		}

		$.post($(this)[0].href,
			{ _method: "delete"},
			function() {
				answer.slideUp(function() {
					answer.remove();
					marker.setMap(null);
					if ($("#recommendations li").length < 1) {
						$("#recommendations-message").fadeIn();
					}
				});
			}
		);

		return false;
	});

	$("#recommendations").delegate(".edit-link", "click", function() {
		var address, question;
		var action = createForm.attr("action");

		if (editingRec) {
			editingRec.removeClass("selected");
		}

		if (newMarker) {
			newMarker.setVisible(false);
		}

		editingRec = $(this).closest("li");
		editingRec.addClass("selected");
		address = editingRec.find("address");
    editingMarker = address.data("marker");
		editingMarker.setIcon(new airbnb.MarkerImage(address.attr("data-pin-icon")));
		CreateForm.setRecommendation(editingRec);

		editingInfoWindow.setContent(
			editingRec.find(".recommendation-bubble")[0].cloneNode(true));
		editingInfoWindow.open(gmap, editingMarker);
		return false;
	});

	createForm.submit(function() {
		var form = $(this);
		var doneButton = form.find(".done-button");
		var saveButton = form.find(".save-button");
		var spinner = form.find(".spinner").show();
		var cancelLink = form.find(".cancel-link").hide();

		saveButton.attr("disabled", "disabled");
		doneButton.attr("disabled", "disabled");

		$.post(form[0].action,
			form.serialize(),
			function(data) {
				spinner.hide();
				cancelLink.show();
				spinner = null;
				if (data.success === true) {
					var li = editingRec || $(document.createElement("li"));
					li.html(data.html);
					if (editingRec) {
						editingRec.addClass("selected");
					} else {
						li.hide();
						$("#recommendations").prepend(li);
					}

					var address = $(li).find("address");
					var marker = newMarker || editingMarker;
					newMarker = null;

					marker.setDraggable(false);
					marker.setIcon(new airbnb.MarkerImage(address.attr("data-pin-icon")));
					google.maps.event.clearInstanceListeners(marker);
					google.maps.event.addListener(marker, "click", function() {
						var li = address.closest("li").click();
						editingInfoWindow.open(gmap, marker);
					});
					address.data("marker", marker);

					editingInfoWindow.close();
					$("#recommendations-message").fadeOut();
					doneButton.removeAttr("disabled");
					saveButton.removeAttr("disabled");

					$("#reason_error").html('');
					$(li).slideDown("slow");
					CreateForm.reset();
					CharacterCounter.resetCounter();

					if (editingRec) {
						editingRec.find(".edit-link").click();
					}
				} else {
					if (data.reason) {
						$("#reason_error").html(data.reason).show();
					} else if (data.errors.reason && data.errors.reason.length > 0) {
						if (data.errors.reason[0] === "TOO_LONG") {
							$("#reason_error").html("Too long! Shorten to save.").show();
						} else if (data.errors.reason[0] === "TOO_SHORT") {
							$("#reason_error").html("Write a recommendation to save.").show();
						}
					}
					if (data.errors && data.errors.place_id && data.errors.place_id.length > 0) {
						if (data.errors.place_id[0] === "ALREADY_RECOMMENDED") {
							$("#place_error").show().html("You have already recommended this place.");
						}
					}
					doneButton.removeAttr("disabled");
				}
			}
		);
		return false;
	});

	function normalizeGeocodeResponse(response) {
		var comps = response.address_components;
		if (response.geometry.location_type ===
				google.maps.GeocoderLocationType.APPROXIMATE) {
			return [comps[0], comps[1], comps[4], comps[6]];
		} else {
			return [comps[1], comps[2], comps[5], comps[7]];
		}
	}

	function setEditingPlace(place) {
		if (place.geometry.viewport) {
			gmap.fitBounds(place.geometry.viewport);
		} else {
			gmap.setCenter(place.geometry.location);
			gmap.setZoom(17);
		}

		if (newMarker) {
			newMarker.setVisible(false);
		} else {
			newMarker = new google.maps.Marker({map: gmap});
		}

		newMarker.setIcon(new airbnb.MarkerImage(place.types[0]));
		newMarker.setPosition(place.geometry.location);
		newMarker.setVisible(true);
		editingInfoWindow.setContent(
			place.name + '<br />' + place.formatted_address
		);
		editingInfoWindow.open(gmap, newMarker);

		createForm.find("#place_recommendation_question").each(function() {
			var len = this.options.length;
			for (var i = 0; i < len; i++) {
				if (this.options[i].getAttribute("data-pin-icon") === place.types[0]) {
					this.selectedIndex = i;
					$(this).change();
					return;
				}
			}
			this.selectedIndex = (len - 1);
			$(this).change();
		});
		createForm.find("#place_recommendation_name").val(place.name);
		createForm.find(".done-button").removeAttr("disabled");
		createForm.find("#reference").val(place.reference);
		createForm.css("visibility", "visible");
	}

	$('.place_name').each(function() {
		var autocomplete;
		autocomplete = new google.maps.places.Autocomplete(this);
		autocomplete.bindTo("bounds", gmap);

		$(this).keypress(function(e) {
			if (13 === e.keyCode && $(".pac-container:visible")) {
				e.preventDefault();
			}
		});

		google.maps.event.addListener(autocomplete, "place_changed", function() {
			setEditingPlace(autocomplete.getPlace());
		});
	});

	var CreateForm = (function() {
		var question, initted, doneButton,
			saveButton;
		var F = {};
		var form = $(".new_place_recommendation");
		var originalAction = form.attr("action");

		form.change(makeDirty);
		form.keyup(makeDirty);
		form.keydown(makeDirty);

		function init() {
			if (!initted) {
				question = form.find("#place_recommendation_question");
				doneButton = form.find(".done-button");
				saveButton = form.find(".save-button");
				initted = true;
			}
		}

		function makeDirty() {
			saveButton.removeAttr("disabled");
		}

		F.setRecommendation = function(rec) {
			var action = form.attr("action");
			var bubble = rec.find(".recommendation-bubble");
			var place_uuid = bubble.attr("data-api-id");

			if (place_uuid) {
				form.find("#place_uuid").val(place_uuid).removeAttr("disabled");
			}

			form.append('<input type="hidden" name="_method" value="put" />');
			form.attr("action",
				(action.lastIndexOf("/") > 0 ? action.slice(0, action.lastIndexOf("/")) : action) +
				"/" + bubble.attr("data-place-id"));
			form.find(".reason").val(rec.find(".reason").text()).keydown();
			form.find("#place_recommendation_name").val(rec.find(".name").text());
			question[0].selectedIndex = parseInt(bubble.attr("data-question"), 10);
			question.change(); // Force "onchange" to fire since it doesn't by default

			doneButton.hide();
			saveButton.attr("disabled", "disabled").show();
			form.css("visibility", "visible");
		};

		F.reset = function() {
			$("#reason_error").hide();
			createForm.find("#reference").val("");
			doneButton.show().attr("disabled", "disabled");
			saveButton.hide();
			CharacterCounter.resetCounter();
			form.find("input[name=_method]").remove();
			form.attr("action", originalAction);
			form[0].reset();
			question.change();
			CharacterCounter.resetCounter();
			$("#place_error").hide();
			form.css("visibility", "hidden");
		};

		init();
		return F;
	})();

	var CharacterCounter = (function() {
		var C = {};
		var reason = $(".reason");

		var CHAR_LIMIT = reason.attr("data-max-length");
		var counter = reason.prevAll(".character-count");
		var submitButton = reason.nextAll(".done-button");

		function updateCounter() {
			var charsLeft = CHAR_LIMIT - reason.val().length;
			counter.text(charsLeft);
			counter.toggleClass("bad", (charsLeft <= 10));

			if (charsLeft < 0) {
				submitButton.attr("disabled", "disabled");
			} else {
				submitButton.removeAttr("disabled");
			}
		}

		C.resetCounter = function() {
			counter.text(CHAR_LIMIT);
			updateCounter();
		};

		reason.keydown(updateCounter);
		reason.keyup(updateCounter);

		return C;
	})();
});
