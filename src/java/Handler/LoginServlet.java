package Handler;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.sql.*;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            res.setContentType("text/html;charset=UTF-8");
            
            Class.forName("com.mysql.jdbc.Driver");
            
            String user = "root";
            String pass = "80855";
            String url = "jdbc:mysql://localhost:3307/mydb1";
            
            Connection con = DriverManager.getConnection(url,user,pass);
            Statement stmt=con.createStatement();  
                       
            String u = req.getParameter("user");
            String p=  req.getParameter("pass");
            ResultSet rs = stmt.executeQuery("select * from login where username='"+ u + "' and password = '" + p + "';" );  
            
            if(rs.next())
            {
                HttpSession session = req.getSession();
                session.setAttribute("User", u);
                res.sendRedirect("main.jsp");
            }
            else
            {
                res.sendRedirect("index.jsp");
            }
            stmt.close();
            con.close();
        } catch (ClassNotFoundException | SQLException ex) {
            PrintWriter pw = res.getWriter();
            pw.println(ex);
            Logger.getLogger(LoginServlet.class.getName()).log(Level.SEVERE, null, ex);
            
        }
        
        
    }
}
