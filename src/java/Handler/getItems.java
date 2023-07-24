
package Handler;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import java.sql.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class getItems extends HttpServlet {

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try{
            Class.forName("com.mysql.jdbc.Driver");
            int level = Integer.parseInt(request.getParameter("level"));
            String user = "root";
            String pass = "80855";
            String url = "jdbc:mysql://localhost:3307/mydb1";

            Connection con = DriverManager.getConnection(url,user,pass);
            Statement stmt = con.createStatement();
            String sql = null;
            ResultSet rs;
            if(level != -1)
                sql = "select * from items where Id <= " + level + " and Id > " + (level-5) +";";
            else
            {
                sql = "select max(Id) from items;";
                rs = stmt.executeQuery(sql);
                rs.next();
                level = rs.getInt(1);
                level = level/5;
                level = (level+1)*5;
                sql = "select * from items where Id <= " + level + " and Id > " + (level-5) +";";
            }
            rs = stmt.executeQuery(sql);
            while(rs.next()){

            out.println("<tr id='record_tr'>");
            out.println("<td>" + rs.getString(1) + "</td>");
            out.println("<td>" + rs.getString(2) + "</td>");
            out.println("<td>" + rs.getString(4) + "</td>");
            out.println("<td>" + rs.getString(5) +  "</td>");
            out.println("<td>" + rs.getString(3) + "</td>");
            out.println("</tr>");
            } 
            }  
            catch(ClassNotFoundException | NumberFormatException | SQLException e)
            {
                PrintWriter o = response.getWriter();
                o.print(e);
            }
    }
}
