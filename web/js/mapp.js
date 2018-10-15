 var map;
var x;
var y;
function loadmaps() {
    $.getJSON("https://api.thingspeak.com/channels/601415/fields/1/last.json?api_key=CB71JD6GMF38UCJU", function (result) {
        var m = result;
        x = Number(m.field1);
    });
    $.getJSON("https://api.thingspeak.com/channels/601415/fields/2/last.json?api_key=CB71JD6GMF38UCJU", function (result) {
        var m = result;
        y = Number(m.field2);
    }).done(function () {
        initialize();
    });

}
window.setInterval(function () {
    loadmaps();
}, 90000);

 var marker2;
   var placeSearch, autocomplete;
function initialize() {
    var mapOptions = {
        zoom: 18,
        center: {lat: x, lng: y}                    
    };
    map = new google.maps.Map(document.getElementById('map'),
            mapOptions);

    var marker = new google.maps.Marker({
        position: {lat: x, lng: y},
        map: map,
        label: 'S',
        title: "Source"
    });

   marker2 = new google.maps.Marker({
        position: {lat: (x), lng: (y+0.0001)},
        map: map,
        label:'D',
        draggable:true,
        title:"Destination"
    });

    //get marker position and store in hidden input
    google.maps.event.addListener(marker2, 'dragend', function (evt) {
        document.getElementById("latInput").value = evt.latLng.lat().toFixed(3);
        document.getElementById("lngInput").value = evt.latLng.lng().toFixed(3);
    });

    var infowindow = new google.maps.InfoWindow({
        content: '<p>Marker Location:' + marker.getPosition() + '</p>'
    });

    google.maps.event.addListener(marker, 'click', function () {
        infowindow.open(map, marker);
    });
}

google.maps.event.addDomListener(window, 'load', initialize);


function initAutocomplete() {
    autocomplete = new google.maps.places.Autocomplete(
      (document.getElementById('dest')),
        {types: ['geocode']});
    autocomplete.addListener('place_changed', ff);
}

function ff(){
    var place = autocomplete.getPlace();
    if(place.geometry){
        document.getElementById("latInput").value = place.geometry.location.lat().toFixed(3);
        document.getElementById("lngInput").value = place.geometry.location.lng().toFixed(3);
        marker2.setPosition(place.geometry.location);
    }
}

function geolocate() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        var geolocation = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };
        var circle = new google.maps.Circle({
          center: geolocation,
          radius: position.coords.accuracy
        });
        autocomplete.setBounds(circle.getBounds());
      });
    }
}