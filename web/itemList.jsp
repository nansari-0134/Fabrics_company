<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>

<!DOCTYPE html>
<html>
    <head>
        <style>
            #record > tr:hover
            {
                background-color: #239D2A;
                color: white;
                cursor: pointer;
            }
        </style>
        <script type="text/javascript" src="ajax_lib.min.js"></script>
        <script>
            function clear_table() {
                for (var i = 0; i < 5; i++)
                    document.getElementById("record_table").deleteRow(1);

            }
        </script>
        <script>
            $(document).ready(function () {
                var lvl = 5;
                $.post("getItems",
                        {
                            level: lvl
                        },
                        function (data) {
                            $('#record').append(data);
                        });


                $('#edit').click(function () {
                    $('#iname').prop('disabled', false);
                    $('#sellprice').prop('disabled', false);
                    $('#costprice').prop('disabled', false);
                    $('#desc').prop('disabled', false);
                    $('#save').prop('disabled', false);
                });

                $("#next").click(function () {
                    lvl = lvl + 5;
                    $.post("getItems",
                            {
                                level: lvl
                            },
                            function (data) {
                                if (data === '')
                                {
                                    alert("You are at the last");
                                    $('#previous').click();
                                } else {
                                    $('#record').append(data);
                                }
                            });
                });

                $("#previous").click(function () {
                    if (lvl > 5) {
                        lvl = lvl - 5;
                        $.post("getItems",
                                {
                                    level: lvl
                                },
                                function (data) {
                                    $('#record').append(data);
                                });
                    } else {
                        alert("You are already at first page.");
                        $.post("getItems",
                                {
                                    level: lvl
                                },
                                function (data) {
                                    $('#record').append(data);
                                });
                    }
                });

                $("#first").click(function () {
                    lvl = 5;
                    $.post("getItems",
                            {
                                level: 5
                            },
                            function (data) {
                                $('#record').append(data);

                            });
                });

                $("#last").click(function () {
                    $.post("getItems",
                            {
                                level: -1
                            },
                            function (data) {
                                $('#record').append(data);
                                let curr = $('#record_table tr:last').find('td:eq(0)').html();
                                lvl = Number(curr);
                                if (Math.floor(lvl / 5) !== lvl / 5)
                                    lvl = lvl + (5 - lvl % 5);
                            });
                });

                $(document).on("click", "#record_tr", function () {
//             let curr = $(this).closest("tr").find('td:eq(0)').text();
//                    $("#accid").val($(this).find('td:eq(0)').text());
                    $.post("searchitem", {
                                act: '2',
                                val: $(this).find('td:eq(0)').text()
                            }, function (data) {
                                if (data === '')
                                    alert("No Record Found");
                                else {
                                    console.log(data);
                                    const arr = data.split("#");
                                    $("#itemid").val(arr[0]);
                                    $("#iname").val(arr[1]);
                                    $("#costprice").val(arr[2]);
                                    $("#sellprice").val(arr[3]);
                                    if(arr[4]!=='')
                                        $("#item_display").attr("src","img/"+arr[4]);
                                    else
                                        $("#item_display").attr("src","icons/logo.jpg");
                                    $("#desc").val(arr[5]);
                                }
                            });


                });
                $('#save').click(function () {
                    $.post("updateitem",
                            {
                                iid: $("#itemid").val(),
                                iname: $("#iname").val(),
                                costprice: $("#costprice").val(),
                                sellprice: $("#sellprice").val(),
                                desc: $("#desc").val()
                            },
                            function (data, status) {
                                alert(data + "\nRecord saving Status: " + status);
                            });
                    $('#iname').prop('disabled', true);
                    $('#sellprice').prop('disabled', true);
                    $('#costprice').prop('disabled', true);
                    $('#desc').prop('disabled', true);
                    $('#save').prop('disabled', true);
                });

                $('#search').click(function () {
                    let a = prompt("Select search by:\n1.Name\n2.Item Id");
                    let t = null;
                    if (a !== null)
                    {
                        if (a === '2')
                        {
                            t = prompt('Enter Id:');
                        } 
                        else if (a === '1')
                            t = prompt('Enter Name:');
                        else
                            alert("Invalid Option");
                        if (t !== null)
                        {
                            $.post("searchitem", {
                                act: a,
                                val: t
                            }, function (data) {
                                if (data === '')
                                    alert("No Record Found");
                                else {
                                    console.log(data);
                                    const arr = data.split("#");
                                    $("#itemid").val(arr[0]);
                                    $("#iname").val(arr[1]);
                                    $("#costprice").val(arr[2]);
                                    $("#sellprice").val(arr[3]);
                                    $("#item_display").attr("src","img/"+arr[4]);
                                    $("#desc").val(arr[5]);
                                }
                            });
                        }

                    }

                });

            });
        </script>

    </head>    
    <body>
        <%! ResultSet rs;
            Connection con;
            Statement stmt;
        %>
        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                String user = "root";
                String pass = "80855";
                String url = "jdbc:mysql://localhost:3307/mydb1";

                con = DriverManager.getConnection(url, user, pass);
                stmt = con.createStatement();
                String sql = "select * from items limit 1;";
                rs = stmt.executeQuery(sql);
                rs.next();

            } catch (ClassNotFoundException | NumberFormatException | SQLException e) {
                PrintWriter o = response.getWriter();
                o.print(e);
            }
        %>
        <label style="background-color:#B5CCC0;width: 100%;height: 20px;text-align: center;display: block;">
            Items
        </label>

        <div style="font-size: 1rem;line-height: 2;width: 80%;left: 10%;right:10%;top: 2%;position: relative;display: block;">
            <form method="POST" action="updateitem">
                <table style = "position: relative;width: 100%;border: 1px;border-style: solid;">
                    <tr>
                        <td> <label>Item Id: </label> </td>
                        <td style="padding: 0;"> <input type="text" id="itemid" name="itemid" placeholder="Item Id" value="<%= rs.getString("Id")%>" disabled="true" required="true"/></td>
                        <td></td><td></td>
                        <td rowspan="5" style="text-align:center;"><img height="200px" id="item_display" width="200px" src="<% if(rs.getString("pic").equals("")){out.println("icons/logo.jpg");}else{out.println("img/" +rs.getString("pic"));} %>" alt="Image here" /><br>
<!--                            <input type='file' name="item_img" /></td>-->
                    </tr>
                    <tr>
                        <td> <label>Name : </label> </td>
                        <td colspan="3" style="padding: 0;"> <input type="text" required="true" id="iname" name="iname" placeholder="Account Holder Name" disabled="true" style="position: relative;width: 95%;display: inline-block;" value="<%= rs.getString("Name")%>"/></td>
                    </tr>
                    <tr>
                        <td> <label>Cost Price : </label> </td>
                        <td style="padding: 0;"> <input type="number" id="costprice" name="costprice" value="<%= rs.getString("CostPrice")%>" placeholder="Phone 1" disabled="true"/></td>
                        <td>Sell Price :</td>
                        <td style="padding: 0;"><input type="number" id="sellprice" name="sellprice" placeholder="Phone 2" value="<%= rs.getString("SellPrice")%>" disabled="true"/></td>
                    </tr>
                    <tr>
                        <td> <label>Description : </label> </td>
                        <td colspan="3" rowspan="2" style="padding: 0;"> <textarea name="desc" id="desc" placeholder="Description" disabled="true" style="display: inline-block;width: 95%;height: 95%"><%= rs.getString("Details")%></textarea></td>
                    </tr>
                    <tr><td></td></tr>
                    
                </table>
            </form>
            <!--            buttons-->
        </div>
        <%
            stmt.close();
            con.close();
        %>

        <div style="text-align: center;display: block;position: relative;">
            <button id="edit" style="padding:10px;margin:10px;"> Edit Record </button>
            <button id="save" style="padding:10px;margin:10px;" disabled="true"> Save Record </button>         
        </div>
        <div style="display:flex;position: relative;">
            <div id="cust_list_div" style="width: 79%;margin:5px;overflow-x: scroll;">
                <table id="record_table" style="width: 100%;position: relative;overflow-x: scroll;">
                    <thead style="background-color:#97AEA2;">
                    <th style="width:10vw;">Id</th>
                    <th style="width:50vw;">Name</th>
                    <th style="width:40vw;">Cost Price</th>
                    <th style="width:40vw;">Sell Price</th>
                    <th style="width:50vw;">Description</th>
                    </thead>
                    <tbody id="record">
                    </tbody>
                </table>
            </div>
            <div id="list_btn" style="width:19%;text-align: center;">
                <button id="next" onclick="javascript:clear_table();" style="width:70%;padding:10px;margin:5px;">Next</button>
                <button id="previous" onclick="javascript:clear_table();" style="width:70%;padding:10px;margin:5px">Previous</button>
                <button id="first" onclick="javascript:clear_table();" style="width:70%;padding:10px;margin:5px">First</button>
                <button id="last" onclick="javascript:clear_table();" style="width:70%;padding:10px;margin:5px">Last</button>
                <button id="search" onclick="" style="width:70%;padding:10px;margin:5px">Search</button>
            </div>
        </div>          
    </body>
</html>
