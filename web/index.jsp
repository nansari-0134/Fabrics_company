<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <style><%@include file="index.css"%></style>

        <title>Login</title>
        <!-- Latest compiled and minified CSS -->
        <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <!-- Latest compiled JavaScript -->
        <script src="bootstrap/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <%
            if (session.getAttribute("User") != null) {
                response.sendRedirect("main.jsp");
            }
        %>
        <div id="header">
            <!--         <h2> Kabira Fabrics</h2>
                    <h4> Admin Login</h4> -->
        </div>
        <!--    <div id ="Login">
                <div id="login_form">
                    <img src="icons/login.jpg" alt="Login" height="100px" width="100px"/>
                    <form action="login" method = "post">
                        <div class="input-container">
                            <input type="text" name="user" required=""/>
                            <label>Username</label>		
                        </div>
                        <div class="input-container">		
                            <input type="password" name="pass" required=""/>
                            <label>Password</label>
                        </div>
                        <button type="submit" class="btn">submit</button>
                    </form>	
                </div>
            </div>-->
        <div class="row">
            <div class="wrapper col-lg-4 col-md-6 col-sm-18 col-xs-12">
                <div class="logo">
                    <img src="./icons/logo.jpg" alt="">
                </div>
                <div class="text-center mt-4 name">
                    Kabir Fabrics
                </div>
                <form class="p-3 mt-3 form-group" action="login" method = "post">
                    <div class="form-field d-flex align-items-center">
                        <span class="far fa-user"></span>
                        <input type="text" name="user" id="userName" placeholder="Username">
                    </div>
                    <div class="form-field d-flex align-items-center">
                        <span class="fas fa-key"></span>
                        <input type="password" name="pass" id="pwd" placeholder="Password">
                    </div>
                    <button class="btn mt-3">Login</button>
                </form>
                <div class="text-center fs-6">
                    <a href="https://www.linkedin.com/in/nizam-ansari-a84668236/">Devloped by Nizam with <span>&#128151;</span></a>
                </div>
            </div>
        </div>
    </body>
</html>


