package Handler;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDate;

@MultipartConfig
public class insertOrder extends HttpServlet {

    protected void service(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        PrintWriter out = res.getWriter();

        try {
            Class.forName("com.mysql.jdbc.Driver");

            String user = "root";
            String pass = "80855";
            String url = "jdbc:mysql://localhost:3307/mydb1";

            Connection con = DriverManager.getConnection(url, user, pass);
            Statement stmt = con.createStatement();
            
            //Generate New Order Id 
            ResultSet rs = stmt.executeQuery("select max(Id) from Orders;");
            int id;
            if(rs.next())
                id = rs.getInt(1);
            else
                id=0;
            id++;
            
            //extract Order Items
            String s[] = req.getParameter("order").split("@",-1);
            int[][] data = new int[s.length][3];
            int i;
            
            for(i=1;i<s.length;i++)
            {
                
                String tmp[] = s[i].split(",");
                data[i-1][0] = Integer.parseInt(tmp[0]);
                data[i-1][1] = (int) Float.parseFloat(tmp[1]);
                data[i-1][2] = Integer.parseInt(tmp[2]);
            }
            //extracting other fields
            int cid = Integer.parseInt(req.getParameter("cid"));
            int disc = Integer.parseInt(req.getParameter("disc"));
            String status = req.getParameter("sts");
            if(status.equals("true"))
                status = "Paid";
            else
                status = "Pending";
            
            //insert record in order items
            int total=0;
            String sql;
            for(i=1;i<s.length;i++)
            {
                sql = "insert into Order_items values(" + id + "," + data[i-1][0] + "," + data[i-1][2] + "," + data[i-1][1] + ");";
                total += data[i-1][1] * data[i-1][2];
                
                stmt.executeUpdate(sql);
            }
            
            //insert record into orders 
            sql = "insert into Orders values(" + id + "," + cid + ",'" + LocalDate.now() + "','" + status + "'," + disc + "," + total + ");";
            
            stmt.executeUpdate(sql);
            
            //if customer haven't paid yet put it into his balance
            if(status.equals("Pending"))
            {
                sql = "Update accounts set Balance = Balance + " + (total - disc) + " where Id = " + cid + ";";
                stmt.executeUpdate(sql);
            }
            //closing connection
            stmt.close();
            con.close();
            out.print(id);
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}
