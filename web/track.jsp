<%-- 
    Document   : track
    Created on : 14 Oct, 2018, 10:09:31 PM
    Author     : Sangeeth Raaj
--%>

<%@page import="mainpackages.c1"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/main.css"/>
        <title>Track...</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        
    </head>
    <body>
        <h1>Package Tracker</h1>
        <%
            if(request.getParameter("dev") == null || !request.getParameter("secret").equals("d1secret")){
             %>
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
        <% 
            }else{

            String s = c1.getDest();
            String slat = s.substring(0, s.indexOf(','));
            String slng = s.substring(s.indexOf(',')+1, s.length());
            
        %>
        
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
                });
                
            }
            
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
                    position: {lat: (<%= slat%>), lng: (<%= slng%>)},
                    map: map,
                    label:'D',
                    title:"Destination"
                });

                
                
                var infowindow = new google.maps.InfoWindow({
                    content: '<p>Marker Location:' + marker.getPosition() + '</p>'
                });

                google.maps.event.addListener(marker, 'click', function () {
                    infowindow.open(map, marker);
                });
            }
            
            
            </script>
         <form method="POST" action="validate" onsubmit="confirm(\"Are you sure to complete the transit and wish to open the box\")">
            <h2>Tracking Device d1</h2>
            <input type='text' name='dev' hidden="true" value='d1'/>
            <h3>Current Location</h3>
            
            <div id="map">
            </div>
            <br>
            <input type="submit" class="btn" name="pickup" value="Complete Transit and Open Box"/>
        </form>
         <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAUZb1UX_4HWwmeIwQBLRAdU7we8OyAWZ8">
        </script>
        <script>loadmaps();</script>
         <%
            }
         %>
    </body>
</html>
