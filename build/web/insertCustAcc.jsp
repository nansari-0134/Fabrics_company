<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <style>
            
        </style>
<!--        Script to handle form data-->
        <script>
            $(document).ready(function(){
                $("#submit_btn").click(function(){
//                   Form Validation  
                   if($("#cname").val() === "")
                   {
                       alert("Customer must have a name.");
                       return false;
                   }
                   
                   if($("#add").val() === "")
                   {
                       alert("Customer must have a Address.");
                       return false;
                   }
                   
                   if($("#ph1").val() === "" && $("#ph2").val() === "")
                   {
                       alert("Customer must have atleast one phone number.");
                       return false;
                   }
                  
                  
//                  Saving Data
                  $.post("SaveData",
                  {
                    accid : $("#accid").val(),
                    cname : $("#cname").val(),
                    ph1 : $("#ph1").val(),
                    ph2 : $("#ph2").val(),
                    add : $("#add").val(),
                    desc : $("#desc").val()
                  },
                  function(data,status){
                    alert(data + "\nRecord saving Status: " + status);
                  });
                  
//                  Clearing Form
                  var acid = Number($("#accid").val()) +1;
                  $("#accid").val(acid);
                  $("#cname").val("");
                  $("#ph1").val("");
                  $("#ph2").val("");
                  $("#add").val("");
                  $("#desc").val("");
                });
              });
        </script>
            
            
    </head>
    <body>
<!--        Generating Account Id-->
        <%! int acid; %>
        <%
            try{
            Class.forName("com.mysql.jdbc.Driver");
            
            String user = "root";
            String pass = "80855";
            String url = "jdbc:mysql://localhost:3307/mydb1";
            Connection con = DriverManager.getConnection(url,user,pass);
            Statement st = con.createStatement();
            
            ResultSet rs = st.executeQuery("Select max(Id) from accounts;");
            if(rs.next())
                {
                    acid = Integer.parseInt(rs.getString("max(Id)"));
                }
            else
                {
                    acid = 0;
                }
            }
            catch(Exception e)
            {
                out.println("Something Is Wrong. Try Reloading this page.." + "\nError Code :" + e);
            }
        %>
        
        <label style="background-color:#B5CCC0;width: 100%;height: 20px;text-align: center;display: block;">
            Customer Account Insert
        </label>
        
        <div style="font-size: 1rem;line-height: 2;width: 80%;height: 80%;left: 10%;right:10%;top: 10%;position: relative;">
            <table style = "position: relative;width: 100%;">
                <tr>
                    <td> <label>Account Id : </label> </td>
                    <td style="padding: 0;"> <input type="text" id="accid" placeholder="Account Id" disabled="true" value=<%= acid+1 %> /></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td> <label>Name : </label> </td>
                    <td colspan="3" style="padding: 0;"> <input type="text" id="cname" placeholder="Account Holder Name" style="position: relative;width: 95%;display: inline-block;"/></td>
                </tr>
                <tr>
                    <td> <label>Phone 1 : </label> </td>
                    <td style="padding: 0;"> <input type="number" id="ph1" placeholder="Phone 1"/></td>
                    <td>Phone 2 :</td>
                    <td style="padding: 0;"><input type="number" id="ph2" placeholder="Phone 2"/></td>
                </tr>
                <tr>
                    <td> <label>Address : </label> </td>
                    <td colspan="3" rowspan="2" style="padding: 0;"> <textarea id="add" placeholder="Address" style="display: inline-block;width: 95%;height: 95%"/></td>
                </tr>
                <tr><td></td></tr>
                <tr>
                    <td> <label>Description : </label> </td>
                    <td colspan="3" rowspan="2" style="padding: 0;"> <textarea id="desc" placeholder="Description" style="display: inline-block;width: 95%;height: 95%"/></td>
                </tr>
                <tr><td></td></tr>
                <tr style="text-align: center;">
                    <td colspan="4">  <button value="Save record" id ="submit_btn">Save Record </button></td>
                </tr>
            </table>
        </div>
    </body>
</html>
