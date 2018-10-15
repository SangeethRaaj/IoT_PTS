/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mainpackages;

import conn.ConnectionManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Sangeeth Raaj
 */
public class newTransit extends HttpServlet {

    
    static Connection currentCon = null;
    static ResultSet rs = null;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Statement stmt = null;
        String searchQuery = "SELECT * FROM `devices` WHERE `DevID` Like '"+request.getParameter("dev")+"'";
        String insertQuery = "INSERT INTO `transits`(`DevID`, `Dest`, `DestLat`, `DestLng`, `Source`, `SrcLat`, `SrcLng`, `Fulfilled`) VALUES "
                + "('"+request.getParameter("dev")+"','"+request.getParameter("dest")+"',"+request.getParameter("destLat")+","+request.getParameter("destLng")+",'"
                +request.getParameter("src")+"',"+request.getParameter("srcLat")+","+request.getParameter("srcLng")+",'no')";
        String updateQry = "UPDATE `devices` SET `Status`='inTransit' WHERE `DevID` LIKE '"+request.getParameter("dev")+"'";
        System.out.println(searchQuery);
        System.out.println(insertQuery);
        System.out.println(updateQry);
        try {
            currentCon = ConnectionManager.getConnection();
            stmt = currentCon.createStatement();
            rs = stmt.executeQuery(searchQuery);
            boolean more = rs.next();
            if (!more) {
                response.sendRedirect("index.jsp?msg=device not deployed");
            }
            else if (more) {
                if(rs.getString("Status").equals("inTransit")){
                    response.sendRedirect("index.jsp?msg=device in use");
                }
                else{
                    stmt.executeUpdate(updateQry);
                    stmt.execute(insertQuery);
                    response.sendRedirect("index.jsp?msg=PickUp on the way... Track with \ndevice : d1\nsecret : d1secret");
                }
            }
        } catch (Exception ex) {
            System.out.println(" failed: An Exception has occurred! " + ex);
            response.sendRedirect("index.jsp?msg=failed:-(");
        } 
        finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (Exception e) {
                }
                rs = null;
            }
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (Exception e) {
                }
                stmt = null;
            }

            if (currentCon != null) {
                try {
                    currentCon.close();
                } catch (Exception e) {
                }

                currentCon = null;
            }
        }
        

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
