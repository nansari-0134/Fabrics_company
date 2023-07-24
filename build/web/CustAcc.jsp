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
                $.post("getrecord",
                        {
                            level: lvl
                        },
                        function (data) {
                            $('#record').append(data);
                        });


                $('#edit').click(function () {
                    $('#cname').prop('disabled', false);
                    $('#ph1').prop('disabled', false);
                    $('#ph2').prop('disabled', false);
                    $('#add').prop('disabled', false);
                    $('#desc').prop('disabled', false);
                    $('#save').prop('disabled', false);
                });

                $("#next").click(function () {
                    lvl = lvl + 5;
                    $.post("getrecord",
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
                        $.post("getrecord",
                                {
                                    level: lvl
                                },
                                function (data) {
                                    $('#record').append(data);
                                });
                    } else {
                        alert("You are already at first page.");
                        $.post("getrecord",
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
                    $.post("getrecord",
                            {
                                level: 5
                            },
                            function (data) {
                                $('#record').append(data);

                            });
                });

                $("#last").click(function () {
                    $.post("getrecord",
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
                    $("#accid").val($(this).find('td:eq(0)').text());
                    $("#cname").val($(this).find('td:eq(1)').text());
                    $("#ph1").val($(this).find('td:eq(3)').text());
                    $("#ph2").val($(this).find('td:eq(4)').text());
                    $("#add").val($(this).find('td:eq(5)').text());
                    $("#desc").val($(this).find('td:eq(6)').text());


                });
                $('#save').click(function () {
                    $.post("updatedata",
                            {
                                accid: $("#accid").val(),
                                cname: $("#cname").val(),
                                ph1: $("#ph1").val(),
                                ph2: $("#ph2").val(),
                                add: $("#add").val(),
                                desc: $("#desc").val()
                            },
                            function (data, status) {
                                alert(data + "\nRecord saving Status: " + status);
                            });
                    $('#cname').prop('disabled', true);
                    $('#ph1').prop('disabled', true);
                    $('#ph2').prop('disabled', true);
                    $('#add').prop('disabled', true);
                    $('#desc').prop('disabled', true);
                    $('#save').prop('disabled', true);
                });

                $('#search').click(function () {
                    let a = prompt("Select search by:\n1.Phone Number\n2.Name\n3.Account Id");
                    let t = null;
                    if (a !== null)
                    {
                        if (a === '3')
                        {
                            t = prompt('Enter Account Id:');
                        } else if (a === '2')
                            t = prompt('Enter Name:');
                        else if (a === '1')
                            t = prompt('Enter Phone Number:');
                        else
                            alert("Invalid Option");
                        if (t !== null)
                        {
                            $.post("searchData", {
                                act: a,
                                val: t
                            }, function (data) {
                                if (data === '')
                                    alert("No Record Found");
                                else {
                                    console.log(data);
                                    const arr = data.split("#");
                                    $("#accid").val(arr[0]);
                                    $("#cname").val(arr[1]);
                                    $("#ph1").val(arr[2]);
                                    $("#ph2").val(arr[3]);
                                    $("#add").val(arr[4]);
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
                String sql = "select * from accounts limit 1;";
                rs = stmt.executeQuery(sql);
                rs.next();

            } catch (ClassNotFoundException | NumberFormatException | SQLException e) {
                PrintWriter o = response.getWriter();
                o.print(e);
            }
        %>
        <label style="background-color:#B5CCC0;width: 100%;height: 20px;text-align: center;display: block;">
            Customer Accounts
        </label>

        <div style="font-size: 1.2rem;line-height: 2;width: 80%;left: 10%;right:10%;top: 2%;position: relative;display: block;">
            <form method="POST" action="updatedata">
                <table style = "position: relative;width: 100%;border: 1px;border-style: solid;">
                    <tr>
                        <td> <label>Account Id : </label> </td>
                        <td style="padding: 0;"> <input type="text" id="accid" name="accid" placeholder="Account Id" value="<%= rs.getString("Id")%>" disabled="true" required="true"/></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td> <label>Name : </label> </td>
                        <td colspan="3" style="padding: 0;"> <input type="text" required="true" id="cname" name="cname" placeholder="Account Holder Name" disabled="true" style="position: relative;width: 95%;display: inline-block;" value="<%= rs.getString("Name")%>"/></td>
                    </tr>
                    <tr>
                        <td> <label>Phone 1 : </label> </td>
                        <td style="padding: 0;"> <input type="number" id="ph1" name="ph2" value="<%= rs.getString("Phone1")%>" placeholder="Phone 1" disabled="true"/></td>
                        <td>Phone 2 :</td>
                        <td style="padding: 0;"><input type="number" id="ph2" name="ph1" placeholder="Phone 2" value="<%= rs.getString("Phone2")%>" disabled="true"/></td>
                    </tr>
                    <tr>
                        <td> <label>Address : </label> </td>
                        <td colspan="3" rowspan="2" style="padding: 0;"> <textarea name="add" id="add" placeholder="Address" disabled="true" style="display: inline-block;width: 95%;height: 95%"><%= rs.getString("Address")%></textarea></td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td> <label>Description : </label> </td>
                        <td colspan="3" rowspan="2"style="padding: 0;"> <textarea name="add" id="desc" placeholder="Description" disabled="true" style="display: inline-block;width: 95%;height: 95%"><%= rs.getString("Details")%></textarea></td>
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
                    <th style="width:10vw;">Balance</th>
                    <th style="width:40vw;">Phone1</th>
                    <th style="width:40vw;">Phone2</th>
                    <th style="width:50vw;">Address</th>
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
