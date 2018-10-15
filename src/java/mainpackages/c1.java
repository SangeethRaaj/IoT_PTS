/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mainpackages;

import conn.ConnectionManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;


/**
 *
 * @author Sangeeth Raaj
 */
public class c1 {
    
    
    static Connection currentCon = null;
    static ResultSet rs = null;
    
    
    public static String getDest(){
        Statement stmt = null;
        String searchQuery = "SELECT `DestLat`,`DestLng` FROM `transits` WHERE `Fulfilled` LIKE 'no'";
        try {
            currentCon = ConnectionManager.getConnection();
            stmt = currentCon.createStatement();
            rs = stmt.executeQuery(searchQuery);
            boolean more = rs.next();
            if (more) {
                return rs.getString("DestLat")+","+rs.getString("DestLng");
            }
        }catch(Exception e){
            System.out.println(e);
        }
    
        return "";
    } 
    
    public static boolean completeTransit(String dev){
        
        Statement stmt = null;
        String updateQuery = "UPDATE `transits` SET `Fulfilled`='yes' WHERE `Fulfilled` LIKE 'no'";
        String updateQry = "UPDATE `devices` SET `Status`= 'available' WHERE `DevID` LIKE '"+dev+"'";
        try {
            currentCon = ConnectionManager.getConnection();
            stmt = currentCon.createStatement();
            int res = stmt.executeUpdate(updateQry);
            int rees = stmt.executeUpdate(updateQuery);
            return true;
        }catch(Exception e){
            System.out.println(e);
        }
        
        return false;
    }
    
}
