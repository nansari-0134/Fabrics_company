
package Handler;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import java.sql.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class getOrderItemsList extends HttpServlet {
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
            String sql = null;
            ResultSet rs;
            sql = "Select * from order_items where Id = " + request.getParameter("oid") + ";";
            System.out.println(request.getParameter("oid"));
            rs = stmt.executeQuery(sql);
            while(rs.next()){
                out.print("<tr>");
                out.print("<td>" + rs.getString("item_id") + "</td>");
                out.print("<td>" + rs.getString("qty") + "</td>");
                out.print("<td>" + rs.getString("price") + "</td>");
                out.print("<td>" + (Float.parseFloat(rs.getString("price")) * Integer.parseInt(rs.getString("qty"))) + "</td>");
                out.print("</tr>");

            } 
            sql = "select * from Orders where Id = " + request.getParameter("oid") + ";";
            out.print("#");
            rs = stmt.executeQuery(sql);
            rs.next();
            out.print(rs.getString("Total"));
            out.print("#");
            out.print(rs.getString("Discount"));
            
            }  
            catch(ClassNotFoundException | NumberFormatException | SQLException e)
            {
                PrintWriter o = response.getWriter();
                o.print(e);
                System.out.println(e);
            }
    }
}
