
package Handler;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import java.sql.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class pendingToPaid extends HttpServlet {

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
            
            String id = request.getParameter("oid");
            stmt.executeUpdate("update Orders set status = 'Paid' where Id =" + id + ";");
            stmt.close();
            con.close();
            
            
            }  
            catch(ClassNotFoundException | NumberFormatException | SQLException e)
            {
                PrintWriter o = response.getWriter();
                o.print(e);
            }
    }
}
