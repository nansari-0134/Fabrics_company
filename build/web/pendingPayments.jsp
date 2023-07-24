<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<!DOCTYPE html>
<html>
    <head>
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
            #order_list > tr:hover ,#item_list > tr:hover  
            {
                background-color: #239D2A;
                color: white;
                cursor: pointer;
            }
        </style>

        <script>
            $(document).ready(function () {
                
                $.post("getPendings",
                        {
                        },
                        function (data) {
                            $('#order_list').append(data);
                        });


                $(document).on("click", "#record_tr", function () {
                    
                      let curr = $(this).closest("tr").find('td:eq(0)').text();
                      $('#oid').val($(this).closest("tr").find('td:eq(0)').text());
                      $('#cname').val($(this).closest("tr").find('td:eq(1)').text());
//                    $("#accid").val($(this).find('td:eq(0)').text());
                    $.post("getOrderItemsList", {
                        oid: $(this).closest("tr").find('td:eq(0)').text()
                    }, function (data) {
                        if (data === '')
                            alert("No Record Found");
                        else {
                            console.log(data);
                            const arr = data.split("#");
                            $('#item_list').empty();
                            $('#item_list').append(arr[0]);
                            $('#total').text(arr[1]);
                            $('#discount').val(arr[2]);
                            $('#grandtotal').text(Number(arr[1] - Number(arr[2])));
                        }
                    });
                });
                
                $(document).on("click", "#remove_btn", function (e) {
                    
                    e.stopImmediatePropagation();
                    let a = $(this).closest("tr");
                    let id = a.find('td:eq(0)').text();
                    let cname = a.find('td:eq(1)').text();
                    let date = a.find('td:eq(2)').text();
                    let amt = a.find('td:eq(3)').text();
                    if(confirm("Are you sure you want to mark following order as paid?\nId :" + id +"\nCustomer Name: " + cname + "\nDate :" + date +"\nAmount : " +amt))
                    {
                        $.post("pendingToPaid",
                        {
                            oid: id
                        },
                        function (data) {
                            a.remove();
                            alert("Marked as Paid Successfully");
                        });
                    }
                });

            });
        </script>
    </head>
    <body>
        <%! ResultSet rs, rs1;
            Connection con;
            Statement stmt, stmt1;
            int oid;
            String cname;
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
                String sql;

                //extract all pending Orders
                sql = "select * from Orders where status = 'Pending' limit 1;";
                rs = stmt.executeQuery(sql);

                if (rs.next()) {
                    rs1 = stmt1.executeQuery("select Name from accounts where Id = " + rs.getString("cust_id") + ";");
                    rs1.next();
                    oid = Integer.parseInt(rs.getString("Id"));
                    cname = rs1.getString("Name");

                    rs1 = stmt1.executeQuery("Select * from order_items where Id = " + oid + ";");
                    

                }

            } catch (ClassNotFoundException | NumberFormatException | SQLException e) {
                PrintWriter o = response.getWriter();
                o.print(e);
            }
        %>
        <label style="background-color:#B5CCC0;width: 100%;height: 20px;display: block;text-align: center;">
            Pending Payments
        </label>
        <div id="cust_list_div" style="left: 2.5%;width: 95%;height: 50%;margin:5px;overflow-x: visible;position: relative;">
            <label style="text-align: center;display: block;">Pending Orders</label><hr>
            <table id="orders" style="width: 100%;position: relative;">
                <thead style="background-color:#97AEA2;">
                <th style="width:15vw;">Order Id</th>
                <th style="width:50vw;">Name</th>
                <th style="width:30vw;">Date</th>
                <th style="width:50vw;">Amount</th>
                <th style="width:20vw;"></th>
                </thead>
                <tbody id="order_list">
                    
                </tbody>
            </table>
        </div>
        <br><br><br><br>
        <div>
            <label style="text-align: center;display: block;">Order details</label><hr>
            <div id="c_details" style="font-family:'Lucida Sans';text-align: center;top: 50px;position: relative;">
                <table style="width:90%;left:5%;position: relative;">
                    <tr>
                        <td><label for="name" class="form__label">Order id : </label></td>
                        <td><input type="input" class="form__field" placeholder="Id" name="oid" id='oid' disabled="true" value="<%= oid %>" /></td>
                        <td></td>
                        <td><label for="name" class="form__label">Customer name : </label></td>
                        <td><input type="input" class="form__field" placeholder="Name" name="cname" id='cname' disabled="true"  value="<%= cname %>" /></td>
                    </tr>

                </table>           
            </div>
        </div>
        <div style="font-family:'Lucida Sans';text-align: center;top: 50px;position: relative;">            
            <table id="orders" style="width: 100%;position: relative;">
                <thead style="background-color:#97AEA2;">
                <th style="width:50vw;">Item Id</th>
                <th style="width:30vw;">Qty</th>
                <th style="width:15vw;">Price </th>
                <th style="width:50vw;">Amount</th>
                <th style="width:50vw;"></th>
                </thead>
                <tbody id="item_list">
                    <%
                        
                        while(rs1.next()){
                            out.print("<tr id='record_tr'>");
                            out.print("<td>" + rs1.getString("item_id") + "</td>");
                            out.print("<td>" + rs1.getString("qty") + "</td>");
                            out.print("<td>" + rs1.getString("price") + "</td>");
                            out.print("<td>" + (Float.parseFloat(rs1.getString("price")) * Integer.parseInt(rs1.getString("qty"))) + "</td>");
                            out.print("</tr>");
                            total += (Float.parseFloat(rs1.getString("price")) * Integer.parseInt(rs1.getString("qty")));
                        }
                    %>
                </tbody>
            </table>
        </div>
        <br><br><br><br>
        <div style="display:flex;position: relative;">
            <div style="position: relative;width: 79%;line-height: 40px;">
                <table>
                    <tr><td><label>Total </label></td>
                        <td><label id='total'><%= total %></label><br></td></tr>


                    <tr><td><label>Discount </label></td>
                        <td><input type="number" id="discount" value="0" disabled="true" value="<%= rs.getString("Discount") %>" /><br></td></tr>

                    <tr><td><label>Grand Total </label></td>
                        <td><label id='grandtotal'><%= total - Integer.parseInt(rs.getString("Discount")) %></label><br></td></tr>

                </table>

            </div>

        </div>

        <hr><hr>
        <div style="font-family:'Lucida Sans';text-align: center;top: 50px;position: relative;">

        </div>



    </body>
</html>
