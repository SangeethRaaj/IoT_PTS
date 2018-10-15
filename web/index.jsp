<%-- 
    Document   : index
    Created on : 14 Oct, 2018, 4:46:57 PM
    Author     : Sangeeth Raaj
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
    <head>
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
        <meta charset="utf-8">
        <link rel="stylesheet" type="text/css" href="css/main.css"/>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAUZb1UX_4HWwmeIwQBLRAdU7we8OyAWZ8&libraries=places"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        <script>
            var map;
            var x;
            var y;
            var geocoder;

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
                    document.getElementById("lat").value = x;
                    document.getElementById("lng").value = y;
                    geocoder = new google.maps.Geocoder;
                    geocodeLatLng(geocoder, x, y);
                });
                
            }
            
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
            
            function geocodeLatLng(geocoder, x, y) {
                while(x===null);
//                alert(x);alert(y);
                var latlng = {lat: Number(x), lng: Number(y)};
                geocoder.geocode({'location': latlng}, function(results, status) {
                  if (status === 'OK') {
                    if (results[0]) {
                      
                      document.getElementById("src").value = results[0].formatted_address;
//                      infowindow.open(map, marker);
                    } else {
                      window.alert('No results found');
                    }
                  } else {
                    window.alert('Geocoder failed due to: ' + status);
                  }
                });
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
        </script>
    </head>


    <body>
         <%
            if (request.getParameter("msg") != null) {
                out.print("<script type=\"text/javascript\">alert(\"" + request.getParameter("msg") + "\");</script>");
            }
            
        %>
        <h1>Package Transit System</h1>
        <form id = "pickupForm" method="POST" action="newTransit">
            <h2>Schedule a new pickup</h2>
            <div>
                <label for="device1">Device</label>
                <select id = "device1" name ="dev">
                    <option value="select">Select</option>
                    <option value="d1">d1</option>
                </select>
            </div>
            <br>
            <div>
                <label for="src">Current Location</label>

                <input id="src" type ="text" name="src" />
                <div class="small-group">
                    <input id="lat" type ="text" name="srcLat" hidden="true"/>
                    <input id ="lng" type ="text" name ="srcLng" hidden="true"/>
                </div>
                <div id="map"></div>
            </div>
            <br>
            <div>
                <label for="dest">Destination</label>
                <input id = "dest" onFocus="geolocate()" type="text" name="dest"/>
                <div class="small-group">
<!--                    <input id = "latInput" type ="text" name ="destLat" hidden="true"/>
                    <input id = "lngInput" type ="text" name ="destLng" hidden="true"/>-->
                    <input id = "latInput" type ="text" name ="destLat" />
                    <input id = "lngInput" type ="text" name ="destLng" />
                </div>
            </div>
            <br>
            <div>
                <input type="submit" class="btn" name="pickup" value="Pickup"/>
                <br>
            </div>
        </form>
        <h2>Or</h2>
        <form method="GET" action="track.jsp">
            <h2>Track a Device</h2>
            <div> 
                <label for="dev">Device</label>
                <select id = "dev" name = "dev">
                    <option value ="d1">d1</option>
                </select>
            </div>
            <div> 
                <label for="secret">Secret</label>
                <input type="password" name="secret" id ="secret"/>
            </div>
                <div>
                    <input type="submit" class="btn" name="pickup" value="Track"/>
                    <br>
                </div>
            </div>
        </form>
<!--         <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAUZb1UX_4HWwmeIwQBLRAdU7we8OyAWZ8&callback=initMap">
        </script>-->

<!--        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAUZb1UX_4HWwmeIwQBLRAdU7we8OyAWZ8&libraries=places&callback=initAutocomplete"
        async defer></script>-->
        <script type="text/javascript">loadmaps();initAutocomplete();</script>
    </body>
</html>
