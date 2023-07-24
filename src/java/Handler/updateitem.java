package Handler;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import java.sql.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class updateitem extends HttpServlet {
    protected void service(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try{
            Class.forName("com.mysql.jdbc.Driver");
            
            String user = "root";
            String pass = "80855";
            String url = "jdbc:mysql://localhost:3307/mydb1";
            
            Connection con = DriverManager.getConnection(url,user,pass);
            PreparedStatement stmt=con.prepareStatement("update items set Name = ?,Details=?,CostPrice=?,SellPrice=? where Id =?;"); 
            
            stmt.setString(1,req.getParameter("iname"));
            stmt.setString(2,req.getParameter("desc"));
            stmt.setString(3,req.getParameter("costprice"));
            stmt.setString(4,req.getParameter("sellprice"));
            stmt.setInt(5,Integer.parseInt(req.getParameter("iid")));
            
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
