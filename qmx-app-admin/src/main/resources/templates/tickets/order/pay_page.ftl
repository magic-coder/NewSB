<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>订单支付</title>
    <link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
    <script src="${base}/resources/assets/layer/layer.js"></script>
    <style type="text/css">
        .roles label {
            width: 150px;
            display: block;
            float: left;
            padding-right: 5px;
        }
    </style>
    <script type="text/javascript">

        //查询支付状态
        var orderId = '${(orderInfo.id)!}';
        var queryInterVal = setInterval(function () {
            queryPayStatus();
        },5000);

        function queryPayStatus() {
            $.ajax({
                url:'queryPayStatus?orderId=${(orderInfo.id)!}',
                type:'POST', //GET
                //async:true,    //或false,是否异步
                //data:reqData,
                //timeout:5000,    //超时时间
                dataType:'json',    //返回的数据格式：json/xml/html/script/jsonp/text
                success:function(resp){
                    if(resp){
                        if(resp == true){
                            window.clearInterval(queryInterVal);
                            layer.open({
                                type: 1
                                ,content: '<div style="padding: 20px 80px;">支付成功</div>'
                                ,btn: '关闭'
                                ,btnAlign: 'c' //按钮居中
                                ,yes: function(){
                                    location.href="orderList"
                                    //parent.layer.close(pindex);
                                }
                            });
                        }
                    }
                },
                error:function(xhr,textStatus){
                    window.clearInterval(queryInterVal);
                    layer.alert(xhr.responseText, {
                        title: '提示'
                    });
                }
            });
        }
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        在线支付
    </div>
</div>
<form id="inputForm" action="payOrder" method="post">
    <input type="hidden" name="orderId" value="${orderInfo.id!}" />
    <table class="input">
        <tr>
            <th>
                订单编号:
            </th>
            <td>
			${orderInfo.id!}
            </td>
        </tr>
        <tr>
            <th>
                产品名称:
            </th>
            <td>
			${orderInfo.productName!}
            </td>
        </tr>
        <tr>
            <th>
                应付金额:
            </th>
            <td>
			${orderInfo.amountPaid?string("0.00")}
            </td>
        </tr>
        <tr>
            <th>
                支付方式:
            </th>
            <td>
                ${payMethod.getName()!}
            </td>
        </tr>
        <tr>
            <th>
                支付二维码:
            </th>
            <td>
			<img src="${codeUrl!}" alt="${payMethod.getName()!}"/>
            </td>
        </tr>
    </table>
    <table class="input">
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="button" class="button" value="返回" onclick="history.back()" />
            </td>
        </tr>
    </table>
</form>
</body>
</html>