
package Handler;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class searchData extends HttpServlet {
    protected void service(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.setContentType("text/html;charset=UTF-8");
        PrintWriter out = res.getWriter();
        try{
            Class.forName("com.mysql.jdbc.Driver");
            String user = "root";
            String pass = "80855";
            String url = "jdbc:mysql://localhost:3307/mydb1";
            String act = req.getParameter("act");
            String val = req.getParameter("val");
            Connection con = DriverManager.getConnection(url,user,pass);
            Statement stmt = con.createStatement();
            String sql = null;
            ResultSet rs;
            if(act.equals("3"))
                sql = "select * from accounts where Id = " + val +";";
            else if(act.equals("2"))
                sql = "select * from accounts where Name = '" + val +"';";
            else
                sql = "select * from accounts where Phone1 = '" + val +"' or Phone2='" + val +"';";
            ServletContext context = getServletContext( );
            context.log(val);
            context.log(sql);
            rs = stmt.executeQuery(sql);
            if(rs.next()){
            out.print(rs.getString(1) + "#");
            out.print(rs.getString(2)+ "#");
            out.print(rs.getString(5)+ "#");
            out.print(rs.getString(6)+ "#");
            out.print(rs.getString(4)+ "#");
            out.print(rs.getString(8));
            }
            else
            {
                //nothing
            }
            }  
            catch(ClassNotFoundException | NumberFormatException | SQLException e)
            {
                PrintWriter o = res.getWriter();
                o.print(e);
            }
    }
}
