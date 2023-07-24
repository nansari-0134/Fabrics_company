package Handler;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
public class insertItem extends HttpServlet {

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        System.out.println("Done1");
        Part part = request.getPart("item_img");
        // Save the file to the database

        try {
            Class.forName("com.mysql.jdbc.Driver");

            String user = "root";
            String pass = "80855";
            String url = "jdbc:mysql://localhost:3307/mydb1";

            Connection con = DriverManager.getConnection(url, user, pass);
            PreparedStatement statement = con.prepareStatement("INSERT INTO items values(?,?,?,?,?,?);");
            String filename = part.getSubmittedFileName();
            statement.setInt(1, Integer.parseInt(request.getParameter("iid")));
            statement.setString(2, request.getParameter("iname"));
            statement.setString(3, request.getParameter("desc"));
            statement.setFloat(4, Float.parseFloat(request.getParameter("costprice")));
            statement.setFloat(5, Float.parseFloat(request.getParameter("sellprice")));
            statement.setString(6, filename);
            out.println(filename);
            statement.executeUpdate();

            System.out.println(filename);

            InputStream p = part.getInputStream();
            byte[] data = new byte[p.available()];
            p.read(data);
            String path = request.getRealPath("/") + "img" + File.separator + filename;
            //path = path.replaceAll(" ", "%20");
            FileOutputStream fos = new FileOutputStream(path);
            out.println(path);
            fos.write(data);
            fos.close();

        } catch (Exception e) {
            out.println(e + request.getParameter("iid")+ request.getParameter("iname")+ request.getParameter("sellprice")+ request.getParameter("costprice"));
            e.printStackTrace();
        }
    }
}
