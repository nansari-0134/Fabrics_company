<!DOCTYPE html>
<html lang="en">
<head>
    <style><%@include file="main.css"%></style>
    <title>Kabir Fabrics!</title>
    <style>
        *{
            font-family: 'Lucida Sans';
        }
        .hide{
            display: none;
        }
        button:hover
        {
            background-color: #239D2A;
            color: white;
            cursor: pointer;
        }
        button
        {
            border-radius: 12px;
            border: 2px solid #4CAF50;
        }
        input {
                border: 0;
                border-bottom: 2px solid gray;
                outline: 0;
                padding: 7px 0;
                background: transparent;
                transition: border-color 0.2s;
            }
    </style>
    <script type="text/javascript" src="ajax_lib.min.js"></script>
<!--    JavaScript Functions-->
    <script>
        function Expand(){
            var x = document.getElementById("hamburger");
            if(x.textContent === "X")
            {
                var a = document.getElementById("menu_bar");
                var b = document.getElementById("current_window");
                b.style.left = '7vw';
                b.style.width = '93vw';
                a.style.display = 'none';
                x.textContent="=";
            }
            else
            {
                var a = document.getElementById("menu_bar");
                var b = document.getElementById("current_window");
                b.style.left = '20vw';
                b.style.width = '80vw';
                a.style.display = 'initial';
                x.textContent ="X";
            }
        }
    </script>
    
<!--    JQuery-->
    <script>
        $(document).ready(function(){
            $('#menu_item').click(function(){
                $('#current_window').off();
            });
            $('.open_acc').click(function(){
                $('#current_window').load('insertCustAcc.jsp');
            });
            $('.show_acc').click(function(){
                $('#current_window').load('CustAcc.jsp');
            });
            $('.open_item').click(function(){
                $('#current_window').load('insertItem.jsp');
            });
            $('.show_item').click(function(){
                $('#current_window').load('itemList.jsp');
            });
            $('.order_generation').click(function(){
                $('#current_window').load('order_generation.jsp');
            });
            $('.pending_payments').click(function(){
                $('#current_window').load('pendingPayments.jsp');
            });
            $('.past_orders').click(function(){
                $('#current_window').load('pastOrders.jsp');
            });
            $('.accmaster').click(function(){
               $('.accmaster_items').toggleClass('hide');
            });
            $('.item_master').click(function(){
               $('.itemmaster_items').toggleClass('hide');
            });
            });
    </script>
</head>
<body>
    <%! String user; %>
    <%
        if(session.getAttribute("User") == null)
        {
            response.sendRedirect("index.jsp");
        }
        else
        {
            user = (String) session.getAttribute("User");
        }
    %>
    <div class="title" style="height: 5vh;">
        <label style="display: inline;width: 5vw;margin: 5px;"> <%= " Current User : " + user %></label>
        <form action="Logout" method="POST" id="logout_btn_div">
            <input type ="submit" value="Logout" id="logout_btn"/>
        </form>
    </div>
        
    <button onclick="Expand()" id ="hamburger">X</button>
    
    <div id="menu_bar">
        
        <ul id = "menu">
            <li id = "menu_item" class="accmaster">Account Master</li>
            <ul id = "menu" class = "accmaster_items hide">
                <li id = "menu_item" class="open_acc">Add New Customer Account</li>
                <li id = "menu_item" class="show_acc">Customer Accounts</li>
            </ul>
            <li id = "menu_item" class="item_master">Product Master</li>
            <ul id = "menu" class = "itemmaster_items hide">
                <li id = "menu_item" class="open_item">Add New Item</li>
                <li id = "menu_item" class="show_item">Items</li>
            </ul>
            <li id = "menu_item" class="order_generation">Order Generation</li>
            <li id = "menu_item" class="pending_payments">Pending Payments</li>
            <li id = "menu_item" class="past_orders">Past Orders</li>
        </ul>
        
<!--        <label style="margin: 5px;display: block; position: inherit; bottom: 5px;font-size: 10px;text-align: center;width: 20vw;"> Devloped By, nansari.0134@gmail.com </label>-->
    </div>
        
    <div id = "current_window" style="display: inline-grid;overflow: scroll;">
        
    </div>
</body>
</html>