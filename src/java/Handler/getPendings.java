package Handler;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import java.sql.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class getPendings extends HttpServlet {

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try{
            Class.forName("com.mysql.jdbc.Driver");
            String user = "root";
            String pass = "80855";
            String url = "jdbc:mysql://localhost:3307/mydb1";

            Connection con = DriverManager.getConnection(url,user,pass);
            Statement stmt = con.createStatement();
            Statement stmt1 = con.createStatement();
            String sql = null;
            int oid;
            ResultSet rs,rs1;
            
            //extract all pending Orders
            sql = "select * from Orders where status = 'Pending';";
            rs = stmt.executeQuery(sql);
            
            while(rs.next()){
            rs1 = stmt1.executeQuery("select Name from accounts where Id = " + rs.getString("cust_id") + ";");
            rs1.next();
            oid = Integer.parseInt(rs.getString("Id"));
            out.print("<tr id='record_tr'>");
            out.print("<td>" + rs.getString("Id") + "</td>");
            out.print("<td>" + rs1.getString("Name") + "</td>");
            out.print("<td>" + rs.getString("Date") +  "</td>");
            out.print("<td>" + (Integer.parseInt(rs.getString("total")) - Integer.parseInt(rs.getString("Discount"))) + "</td>");
            out.print("<td><button id='remove_btn'>Mark It as Paid</button></td>");
            out.print("</tr>");
            } 
            
            }  
            catch(ClassNotFoundException | NumberFormatException | SQLException e)
            {
                PrintWriter o = response.getWriter();
                o.print(e);
            }
    }
}
