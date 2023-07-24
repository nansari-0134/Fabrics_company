<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<html lang="en">
    <head>
        <title>Invoice</title>
        <style>
            .form__field {
                border: 0;
                width: 100%;
                border-bottom: 2px solid gray;
                outline: 0;
                padding: 7px 0;
                background: transparent;
                transition: border-color 0.2s;
            }
            #orders {
                font-family: Arial, Helvetica, sans-serif;
                border-collapse: collapse;
                width: 100%;
            }

            #orders td, #orders th {
                border: 1px solid #ddd;
                padding: 8px;
            }

            #orders tr:nth-child(even){
                background-color: #f2f2f2;
            }

            #orders tr:hover {
                background-color: #ddd;
            }

            #orders th {
                padding-top: 12px;
                padding-bottom: 12px;
                text-align: left;
                background-color: #239D2A;
                color: white;
            }
            @media print {
                    
            }
        </style>
        <script>
            function printBill(){
                var style = `<style>
            .form__field {
                border: 0;
                width: 100%;
                border-bottom: 2px solid gray;
                outline: 0;
                padding: 7px 0;
                background: transparent;
                transition: border-color 0.2s;
            }
            #orders {
                font-family: Arial, Helvetica, sans-serif;
                border-collapse: collapse;
                width: 100%;
            }

            #orders td, #orders th {
                border: 1px solid #ddd;
                padding: 8px;
            }

            #orders tr:nth-child(even){
                background-color: #f2f2f2;
            }

            #orders tr:hover {
                background-color: #ddd;
            }

            #orders th {
                padding-top: 12px;
                padding-bottom: 12px;
                text-align: left;
                background-color: #239D2A;
                color: white;
            }
            
        </style>`
                var divContents = document.getElementById("bill").innerHTML;
                var a = window.open('', '');
                a.document.write(style);
                a.document.write(divContents);
                a.document.close();
                a.print();
            }
        </script>
    </head>
    <%! ResultSet rs, rs1,rs2;
            Connection con;
            Statement stmt, stmt1,stmt2;
            int oid,disc;
            String cname,cid,cadd,date;
            float total=0;
        %>
        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                String user = "root";
                String pass = "80855";
                String url = "jdbc:mysql://localhost:3307/mydb1";

                con = DriverManager.getConnection(url, user, pass);
                stmt = con.createStatement();
                stmt1 = con.createStatement();
                stmt2 = con.createStatement();
                String sql;
                oid = Integer.parseInt(request.getParameter("oid"));
                //extract all pending Orders
                sql = "select * from Orders where Id = " + oid + ";";
                rs = stmt.executeQuery(sql);
                
                if (rs.next()) {
                    rs1 = stmt1.executeQuery("select * from accounts where Id = " + rs.getString("cust_id") + ";");
                    rs1.next();
                    cid = rs1.getString("Id");
                    cname = rs1.getString("Name");
                    cadd = rs1.getString("Id");
                    disc = Integer.parseInt(rs.getString("Discount"));
                    total = Float.parseFloat(rs.getString("Total"));
                    date = rs.getString("Date");
                    rs1 = stmt1.executeQuery("Select * from order_items where Id = " + oid + ";");
                    

                }

            } catch (ClassNotFoundException | NumberFormatException | SQLException e) {
                PrintWriter o = response.getWriter();
                o.print(e);
            }
        %>
    <body onload="printBill()">
        <div style="width:21cm;height: 29.7cm;position: relative;margin: auto;" id="bill">
            
            <div id="header" style="line-height: 1px;">
                <div style="top:50px;left: 5%;position: ">
                    <label>
                        <img src="icons/logo.jpg" alt="Kabir Fabrics" height="100px" width="100px" />
                        <h2>&nbsp;&nbsp;Invoice</h2>            
                    </label>
                </div>
                <div style="right:5%;top: 10px;position: absolute;">
                    <p style="font-family: 'Copperplate Gothic Bold';font-size: 32px;">Kabir Fabrics</h1>
                    <h4 style="">Address Here (C.G.)</h4>
                    <h4 style="">Phone : 123XXXXXXX </h4>
                </div>
            </div>

            <div id="customer_details" style="line-height: 1px;position: relative;">
                <hr>
                <br><br><br><br>
                <table style="width:90%;left:5%;position: relative;">
                    <tr>
                        <td><label for="name" class="form__label">Order id : </label></td>
                        <td><input type="input" class="form__field" placeholder="Id" name="cid" id='oid' value="<%= oid %>" required disabled="true" /></td>
                        <td></td>
                        <td><label for="name" class="form__label">Date : </label></td>
                        <td><input type="input" class="form__field" placeholder="Date" name="odate" id='odate' value="<%= date %>" required disabled="true"/></td>
                    </tr>
                    <tr>
                        <td><label for="name" class="form__label">Customer id : </label></td>
                        <td><input type="input" class="form__field" placeholder="Id" name="cid" id='cid' value="<%= cid %>" required disabled="true" /></td>
                        <td></td>
                        <td><label for="name" class="form__label">Customer name : </label></td>
                        <td><input type="input" class="form__field" placeholder="Customer Name" name="cname"value="<%= cname %>" id='cname' required disabled="true"/></td>
                    </tr>
                    <tr>
                        <td><label for="name" class="form__label">Address : </label></td>
                        <td colspan="3"><textarea class="form__field" style="width:100%;" placeholder="Address" value="<%= cadd %>" name="add" id='add' required disabled="true"></textarea></td>
                    </tr>
                </table>
            </div>
            <div id="Item_list">
                <hr>
                <table id="orders">
                      <tr>
                        <th style="width: 10vw;">Sr. No.</th>
                        <th style="width: 10vw;">Item Id</th>
                        <th style="width: 40vw;">Item Name</th>
                        <th style="width: 10vw;">Qty</th>
                        <th style="width: 15vw;">Rate</th>
                        <th style="width: 15vw;">Amount</th>
                      </tr>
                      <%
                        int i=0;
                        while(rs1.next()){
                            i++;
                            rs2 = stmt2.executeQuery("select Name from items where Id = " + rs1.getString("item_id") + ";");
                            rs2.next();
                            out.print("<tr id='record_tr'>");
                            out.print("<td>" + i  + "</td>");
                            out.print("<td>" + rs1.getString("item_id") + "</td>");
                            out.print("<td>" + rs2.getString("Name") + "</td>");
                            out.print("<td>" + rs1.getString("qty") + "</td>");
                            out.print("<td>" + rs1.getString("price") + "</td>");
                            out.print("<td>" + (Float.parseFloat(rs1.getString("price")) * Integer.parseInt(rs1.getString("qty"))) + "</td>");
                            out.print("</tr>");
                            
                        }
                    %>
                </table>
            </div>
            <hr>
            <br><br>
            <div id="overall_prices" style="right: 5%;font-size: 24px;position: absolute;">
                <label> Total Amount : <%= total %></label><br>
                <label> Discount : <%= disc %></label><br>
                <label> Total Amount Payable : <%= total - disc %></label>                   
            </div>
        </div>
    </body>
</html>