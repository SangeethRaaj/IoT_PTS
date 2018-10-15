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

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    static Connection currentCon = null;
    static ResultSet rs = null;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Statement stmt = null;
        String searchQuery = "SELECT * FROM `devices` WHERE `DevID` Like '"+request.getParameter("dev")+"'";
        String insertQuery = "";
        String updateQry = "UPDATE `devices` SET `Status`='inTransit' WHERE `DevID` LIKE "+request.getParameter("dev");

        try {
            //connect to DB 
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
                }
            }
        } catch (Exception ex) {
            System.out.println("SignUp failed: An Exception has occurred! " + ex);
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
