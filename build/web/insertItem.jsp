<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <style>
            
        </style>
        <script>
            var imageInput = document.getElementById("item_img");
            var selectedImage = document.getElementById("item_display_img");

            imageInput.addEventListener("change", function() {
              var file = imageInput.files[0];
              var reader = new FileReader();

              reader.onload = function() {
                selectedImage.src = reader.result;
              };

              reader.readAsDataURL(file);
            });
      </script>
<!--        Script to handle form data-->
        <script>
            $(document).ready(function(){
                $("#myForm").submit(function(e){
                    e.preventDefault();
//                   Form Validation  

                   if($("#iname").val() === "")
                   {
                       alert("Item must have a name.");
                       return false;
                   }
                   
                   if($("#costprice").val() === "")
                   {
                       alert("Cost price must be entered");
                       return false;
                   }
                   
                   if($("#sellprice").val() === "")
                   {
                       alert("sell price must be entered");
                       return false;
                   }
                 //                  Saving Data
                 let f = new FormData(this);
                 f.append("iid", $('#itemid').val());
                  $.ajax({
                    url: "insertItem",
                    data: f,
                    type: 'POST',
                    processData: false,
                    contentType: false,
                    success: function(data){
                        console.log(data);
                        alert("Record inserted Successfully.");
                    },
                    error: function(jqXHR,textStatus,errorThrown){
                        
                        alert("Data not saved.");
                    }
                    
                  });
//                    $('#myForm').submit(function(){
//                        $.post("insertItem",new FormData(this),function(data){
//                            alert("done");
//                        });
//                    });
                  
//                 Clearing Form
                  var id = Number($("#itemid").val()) +1;
                  $("#itemid").val(id);
                  $("#iname").val("");
                  $("#costprice").val("");
                  $("#sellprice").val("");
                  $("#desc").val("");
                  $('#item_display_img').attr("src","icons/logo.jpg");
                  $('item_img').val('');
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
            
            ResultSet rs = st.executeQuery("Select max(Id) from items;");
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
            Insert New Item
        </label>
        
        <div style="font-size: 1rem;line-height: 2;width: 80%;height: 80%;left: 10%;right:10%;position: relative;">
            <form id="myForm" enctype="multipart/form-data" action="insertItem" method="POST">
                <label style="display:block;text-align: center;"><img height="200px" width="200px" src="icons/logo.jpg" id='item_display_img' /></label>
            <table style = "position: relative;width: 100%;">
                
                <tr>
                    <td> <label>Item Id : </label> </td>
                    <td style="padding: 0;"> <input type="text" name="itemid" id="itemid" placeholder="Item Id" disabled="true" value=<%= acid+1 %> /></td>
                    <td>Choose Image :</td>
                    <td style="padding: 0;"><input type="file" name="item_img" id="item_img" accept="image/*" /></td>    
                </tr>
                <tr>
                    <td> <label>Name : </label> </td>
                    <td colspan="3" style="padding: 0;"> <input type="text" name="iname" name="iname" id="iname" placeholder="Item Name" style="position: relative;width: 95%;display: inline-block;"/></td>
                </tr>
                <tr>
                    <td> <label>Cost Price : </label> </td>
                    <td style="padding: 0;"> <input type="number" name="costprice" id="costprice" placeholder="Cost Price"/></td>
                    <td>Sell Price:</td>
                    <td style="padding: 0;"><input type="number" name="sellprice" id="sellprice" placeholder="Sell Price"/></td>
                </tr>
                <tr>
                    <td> <label>Description : </label> </td>
                    <td colspan="3" rowspan="2" style="padding: 0;"> <textarea name="desc" id="desc" placeholder="Description" style="display: inline-block;width: 95%;height: 95%"/></td>
                </tr>
                <tr><td></td></tr>
                <tr><td></td></tr>
                <tr style="text-align: center;">
                    <td colspan="4">  <input type="submit" value="Save record" id ="submit_btn" /></td>
                </tr>
            </table>
            </form>
        </div>
    </body>
</html>
