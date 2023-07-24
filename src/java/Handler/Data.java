
package Handler;

import java.io.IOException;
import javax.servlet.ServletException;
import java.io.PrintWriter;
import java.lang.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

public class Data extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try{
            Class.forName("com.mysql.jdbc.Driver");
            
            String user = "root";
            String pass = "80855";
            String url = "jdbc:mysql://localhost:3307/mydb1";
            
            Connection con = DriverManager.getConnection(url,user,pass);
            PreparedStatement stmt=con.prepareStatement("insert into accounts values(?,?,?,?,?,?,?,?);"); 
            stmt.setInt(1,Integer.parseInt(req.getParameter("accid")));
            stmt.setString(2,req.getParameter("cname"));
            stmt.setDouble(3,0);
            stmt.setString(4,req.getParameter("add"));
            stmt.setString(5,req.getParameter("ph1"));
            stmt.setString(6,req.getParameter("ph2"));
            stmt.setString(7,"");
            stmt.setString(8,req.getParameter("desc"));
            //String sql = "insert into accounts values(" + req.getParameter('acid') + ",'" + req.getParameter('name') + "',0,'" + req.getParameter('add') + "','" + req.getParameter('ph1') + "','" + req.getParameter('ph2') + "','','" + req.getParameter('desc') + "';";
            stmt.executeUpdate();
            res.setContentType("text/html");
            PrintWriter pw = res.getWriter();
            pw.println("Data Inserted Successfully " );
            
            stmt.close();
            con.close();
        }
        catch(ClassNotFoundException | NumberFormatException | SQLException e)
        {
            PrintWriter pw = res.getWriter();
            pw.println("Error Occurred: " + e);
        }
            
    }
}
