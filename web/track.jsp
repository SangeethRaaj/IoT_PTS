<%-- 
    Document   : track
    Created on : 14 Oct, 2018, 10:09:31 PM
    Author     : Sangeeth Raaj
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/main.css"/>
        <title>Track...</title>
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
                    <input type="button" class="btn" name="pickup" value="Track"/>
                    <br>
                </div>
            </div>
        </form>
        <% 
            }else{
        %>
         <form method="POST" action="validate">
            <h2>Tracking Device d1</h2>
            <h3>Current Location</h3>
            <%
            
            %>
            <div> 
                <label for="device2">Device</label>
                <select id = "device2">
                    <option value ="d1">d1</option>
                </select>
            </div>
                <div>
                    <input type="button" class="btn" name="pickup" value="Track"/>
                    <br>
                </div>
            </div>
        </form>
         
         <%
            }
         %>
    </body>
</html>
