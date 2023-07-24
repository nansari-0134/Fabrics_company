<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        </style>
        <style>
            #record > tr:hover ,#cust_record > tr:hover
            {
                background-color: #239D2A;
                color: white;
                cursor: pointer;
            }
        </style>
        <script>
            function clear_table() {
                for (var i = 0; i < 5; i++)
                    document.getElementById("record_table").deleteRow(1);

            }
        </script>
        <script>
            function clear_cust_table() {
                for (var i = 0; i < 5; i++)
                    document.getElementById("cust_record_table").deleteRow(1);

            }
        </script>
        <script>
            $(document).ready(function () {
                var lvl_cust = 5;
                $.post("getrecord",
                        {
                            level: lvl_cust
                        },
                        function (data) {
                            $('#cust_record').append(data);
                        });

                $("#cust_next").click(function (e) {
                    lvl_cust = lvl_cust + 5;
                    e.stopImmediatePropagation();
                    $.post("getrecord",
                            {
                                level: lvl_cust
                            },
                            function (data) {
                                if (data === '')
                                {
                                    alert("You are at the last");
                                    $('#cust_previous').click();
                                } else {
                                    $('#cust_record').append(data);
                                }
                            });
                });

                $("#cust_previous").click(function (e) {
                    e.stopImmediatePropagation();
                    if (lvl_cust > 5) {
                        lvl_cust = lvl_cust - 5;
                        $.post("getrecord",
                                {
                                    level: lvl_cust
                                },
                                function (data) {
                                    $('#cust_record').append(data);
                                });
                    } else {
                        alert("You are already at first page.");
                        $.post("getrecord",
                                {
                                    level: lvl_cust
                                },
                                function (data) {
                                    $('#cust_record').append(data);
                                });
                    }
                });

                $("#cust_first").click(function (e) {
                    e.stopImmediatePropagation();
                    lvl_cust = 5;
                    $.post("getrecord",
                            {
                                level: 5
                            },
                            function (data) {
                                $('#cust_record').append(data);

                            });
                });

                $("#cust_last").click(function (e) {
                    e.stopImmediatePropagation();
                    $.post("getrecord",
                            {
                                level: -1
                            },
                            function (data) {
                                $('#cust_record').append(data);
                                let curr = $('#cust_record_table tr:last').find('td:eq(0)').html();
                                lvl_cust = Number(curr);
                                if (Math.floor(lvl_cust / 5) !== lvl_cust / 5)
                                    lvl_cust = lvl_cust + (5 - lvl_cust % 5);
                            });
                });




//-----------------------------------------------------------------------------          

                var lvl = 5;
                $.post("getOrderItem",
                        {
                            level: lvl
                        },
                        function (data) {
                            $('#record').append(data);
                        });


                $("#next").click(function (e) {
                    e.stopImmediatePropagation();
                    lvl = lvl + 5;
                    $.post("getOrderItem",
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

                $("#previous").click(function (e) {
                    e.stopImmediatePropagation();
                    if (lvl > 5) {
                        lvl = lvl - 5;
                        $.post("getOrderItem",
                                {
                                    level: lvl
                                },
                                function (data) {
                                    $('#record').append(data);
                                });
                    } else {
                        alert("You are already at first page.");
                        $.post("getOrderItem",
                                {
                                    level: lvl
                                },
                                function (data) {
                                    $('#record').append(data);
                                });
                    }
                });

                $("#first").click(function (e) {
                    e.stopImmediatePropagation();
                    lvl = 5;

                    $.post("getOrderItem",
                            {
                                level: 5
                            },
                            function (data) {
                                $('#record').append(data);

                            });
                });

                $("#last").click(function (e) {
                    e.stopImmediatePropagation();
                    $.post("getOrderItem",
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
                $(document).off().on("click", ".cust_record_tr", function (e) {
                    e.stopImmediatePropagation();
//             let curr = $(this).closest("tr").find('td:eq(0)').text();
                    
                    $("#cid").val($(this).find('td:eq(0)').text());
                    $("#cname").val($(this).find('td:eq(1)').text());
                    $("#add").val($(this).find('td:eq(5)').text());
                });
                $(document).on("click", ".item_record_tr", function () {
                    let total = $('#total');
                    let disc = $('#discount').val();

                    let a = "<tr><td>" + $(this).find('td:eq(0)').text() + "</td>";
                    a += "<td>" + $(this).find('td:eq(1)').text() + "</td>";
                    a += "<td>" + $(this).find('td:eq(2)').text() + "</td>";
                    a += "<td><input type='number' class='qty' value=1 /></td>";
                    a += "<td>" + $(this).find('td:eq(2)').text() + "</td>";
                    a += "<td><button id='remove_btn'>Remove</button></td></tr>";
                    $('#order_list').append(a);
                    total.text(Number(total.text()) + Number($(this).find('td:eq(2)').text()));
                    $('#grandtotal').text(Number(total.text()) - Number(disc));
                });
                

                $(document).on("change", ".qty", function (e) {
                    e.preventDefault();
                    e.stopImmediatePropagation();
                    let amt = $(this).closest("tr").find('td:eq(4)');
                    let amt_before = amt.text();
                    let total = $('#total');
                    let disc = $('#discount').val();
                    let price = $(this).closest("tr").find('td:eq(2)').text();
                    let qty = $(this).val();
                    console.log(price);
                    console.log(qty);
                    if (qty === null)
                        qty = 0;
                    amt.text(Number(price) * Number(qty));
                    total.text(Number(total.text()) - Number(amt_before) + Number(amt.text()));
                    $('#grandtotal').text(Number(total.text()) - Number(disc));
                });



                $(document).on("click", "#remove_btn", function (e) {
                    
                    e.stopImmediatePropagation();
                    let total = $('#total');
                    let disc = $('#discount').val();
                    let a = $(this).closest("tr");
                    let price = a.find('td:eq(2)').text();
                    let qty = a.find('td:eq(3)').find('input:first-child').val();
                    console.log(price);
                    console.log(qty);
                    total.text(Number(total.text()) - (Number(price) * Number(qty)));
                    $('#grandtotal').text(Number(total.text()) - Number(disc));
                    a.remove();
                });

                $(document).on("change", "#discount", function (e) {
                    e.preventDefault();
                    e.stopImmediatePropagation();
                    let total = $('#total');
                    let disc = $('#discount').val();
                    $('#grandtotal').text(Number(total.text()) - Number(disc));
                });

                $('#submit_btn').click(function () {
                    if ($('#cid').val() === '')
                    {
                        alert("First Select Customer Account");
                        return false;
                    }
                    if ($('#order_list tr').length === 0)
                    {
                        alert("Choose atleast one item");
                        return false;
                    }
                    let a = "";
                    var i = 0;
                    var t = document.getElementById('order_list');
                    $("#order_list tr").each(function() {
                        a += "@";
                        a += $(t.rows[i].cells[0]).text() + ",";
                        a += $(t.rows[i].cells[2]).text() + ",";
                        a += $(t.rows[i].cells[3]).find('input:first-child').val();
                        i++;
                    });
                    console.log($('#cid').text());
                    console.log(a);
                    $.post("insertOrder",{
                        cid : $('#cid').val(),
                        order: a,
                        disc: $('#discount').val(),
                        sts : $('#status').is(':checked') 
                    },
                    function(data)
                    {
                        if(data==='')                            
                            alert("Data Not Inserted");
                        else{
                            alert("Data inserted Successfully");
                            $('#current_window').off();
                            $('#current_window').load('order_generation.jsp');
                            window.open("invoice.jsp?oid=" + encodeURI(data));
                        }
                    });
                });
            });
        </script>
    </head>
    <body>
        <label style="background-color:#B5CCC0;width: 100%;height: 20px;display: block;text-align: center;">
            Order Generation
        </label>

        <div>
            <label style="text-align: center;display: block;">Customer details</label><hr>
            <div id="c_details" style="font-family:'Lucida Sans';text-align: center;top: 50px;position: relative;">
                <table style="width:90%;left:5%;position: relative;">
                    <tr>
                        <td><label for="name" class="form__label">Customer id : </label></td>
                        <td><input type="input" class="form__field" placeholder="Id" name="cid" id='cid' required disabled="true" /></td>
                        <td></td>
                        <td><label for="name" class="form__label">Customer name : </label></td>
                        <td><input type="input" class="form__field" placeholder="Name" name="cname" id='cname' required disabled="true"/></td>
                    </tr>
                    <tr>
                        <td><label for="name" class="form__label">Address : </label></td>
                        <td colspan="4"><input type="input" class="form__field" placeholder="Address" name="add" id='add' required disabled="true"/></td>
                    </tr>
                </table>
                <!--                <input type="checkbox" id="show_cust_list">Pick from the List</input>-->
                <div id="cust_list" style="display:flex;position: relative;">
                    <div id="cust_list_div" style="width: 79%;margin:5px;overflow-x: scroll;">
                        <table id="cust_record_table" style="width: 100%;position: relative;overflow-x: scroll;">
                            <thead style="background-color:#97AEA2;">
                            <th style="width:10vw;">Id</th>
                            <th style="width:50vw;">Name</th>
                            <th style="width:10vw;">Balance</th>
                            <th style="width:40vw;">Phone1</th>
                            <th style="width:40vw;">Phone2</th>
                            <th style="width:50vw;">Address</th>
                            <th style="width:50vw;">Description</th>
                            </thead>
                            <tbody id="cust_record">
                            </tbody>
                        </table>
                    </div>
                    <div id="list_btn" style="width:19%;text-align: center;">
                        <button id="cust_next" onclick="javascript:clear_cust_table();" style="width:70%;padding:10px;margin:5px;">Next</button>
                        <button id="cust_previous" onclick="javascript:clear_cust_table();" style="width:70%;padding:10px;margin:5px">Previous</button>
                        <button id="cust_first" onclick="javascript:clear_cust_table();" style="width:70%;padding:10px;margin:5px">First</button>
                        <button id="cust_last" onclick="javascript:clear_cust_table();" style="width:70%;padding:10px;margin:5px">Last</button>
                    </div>
                </div>
                <hr> <hr>             
            </div>
        </div>
        <div style="font-family:'Lucida Sans';text-align: center;top: 50px;position: relative;">
            <label style="text-align: center;display: block;">Choose Items</label>
            <!--            <table style="width:90%;left:5%;position: relative;">
                            <tr>
                                <td><label for="name" class="form__label">Item id : </label></td>
                                <td><input type="input" class="form__field" placeholder="Id" name="iid" id='iid' required /></td>
                                <td></td>
                                <td><label for="name" class="form__label">Item name : </label></td>
                                <td><input type="input" class="form__field" placeholder="Name" name="iname" id='iname' required /></td>
                            </tr>
                        </table>-->
            <div id="item_list" style="display:flex;position: relative;">
                <div style="width: 79%;margin:5px;overflow-x: scroll;">
                    <table id="record_table" style="width: 100%;position: relative;overflow-x: scroll;">
                        <thead style="background-color:#97AEA2;">
                        <th style="width:10vw;">Id</th>
                        <th style="width:50vw;">Name</th>
                        <th style="width:40vw;">Price</th>
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
                </div>
            </div>
        </div>
        <hr><hr>
        <div style="font-family:'Lucida Sans';text-align: center;top: 50px;position: relative;">
            <label style="text-align: center;display: block;">Order details</label><hr>
            <table id="orders" style="width: 100%;position: relative;">
                <thead style="background-color:#97AEA2;">
                <th style="width:15vw;">ID</th>
                <th style="width:50vw;">Name</th>
                <th style="width:30vw;">Price</th>
                <th style="width:15vw;">Qty.</th>
                <th style="width:50vw;">Amount</th>
                <th style="width:50vw;"></th>
                </thead>
                <tbody id="order_list">
                </tbody>
            </table>
        </div>
        <br><br><br><br>
        <div style="display:flex;position: relative;">
            <div style="position: relative;width: 79%;line-height: 40px;">
                <table>
                    <tr><td><label>Total </label></td>
                        <td><label id='total'>0</label><br></td></tr>


                    <tr><td><label>Discount </label></td>
                        <td><input type="number" id="discount" value="0"><br></td></tr>

                    <tr><td><label>Grand Total </label></td>
                        <td><label id='grandtotal'>0</label><br></td></tr>

                    <tr><td colspan='2'><input id="status" type="checkbox"> Paid Already </input></td></tr>
                </table>

            </div>
            <div style="text-align:center;width: 19%;position: relative;">
                <button id='submit_btn' style="top:50px;">Submit and print bill</button>
            </div>
        </div>
    </body>
</html>
