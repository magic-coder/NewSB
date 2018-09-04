<!doctype html>
<html>

<head>
    <meta charset="UTF-8">
    <title></title>
    <meta name="viewport"
          content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no"/>
    <link href="${base}/resources/module/teamticket/css/mui.min.css" rel="stylesheet"/>
    <link href="${base}/resources/module/teamticket/css/firm.css" rel="stylesheet"/>
</head>

<body class="firm">

<div class="mui-content">
    <div class="row">
        <p class="firm-title">订单详细</p>
    </div>
    <div class="firm-table">
        <p class="row">团单号：${order.sn!}</p>
        <p class="row">游玩日期：${order.date!}</p>
    <#list order.infoDtos as info>
        <p class="row">${info.productName!}：${info.quantity!}张</p>
    </#list>
    <#list order.increaseInfoDtos as info>
        <p class="row">${info.productName!}：${info.quantity!}份</p>
    </#list>
        <p class="row">定金已付：${(order.deposit?string.currency)!}元</p>
        <p class="row">定金支付方式：
        <#if order.depositPayType??>
            <#if order.depositPayType=='WX_NATIVE'>微信支付
            <#elseif order.depositPayType=='ALIPAY_QR'>支付宝支付
            <#elseif order.depositPayType=='DEPOSIT'>预存款支付
            <#else>/
            </#if>
        <#else>/
        </#if>
        </p>
        <p class="row">下单时间：${order.createTime!?string("yyyy-MM-dd HH:mm:ss")}</p>
        <p class="row">订单状态：${order.orderStatus.title!}</p>
    </div>

<#if user?? && (order.orderStatus == "unhaveOrder" || order.orderStatus == "updateApplied")>
    <div class="row">
        <a id="orderReceiving" data-id="${order.id!?c}" class="firm-btn">确认订单</a>
    </div>
</#if>
</div>

<#include "/include/common_header_include.ftl">
<script>
    //接单
    $(document).on("click", "#orderReceiving", function () {
        var data = $(this).attr("data-id");
        layer.confirm('确定接单吗？', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: "/taOrder/orderReceiving",
                type: "POST",
                data: {id: data},
                beforeSend: function () {
                    $("#affirm").attr("disabled", "disabled");
                },
                success: function (json) {
                    if (json.state == "success") {
                        layer.msg(json.msg);
                        setTimeout(function () {
                            location.reload(true);
                        }, 500);
                    } else {
                        layer.msg(json.msg);
                    }
                },
                complete: function () {
                    $("#affirm").removeAttr("disabled");
                },
            });
        }, function () {

        });
    });
</script>

</body>

</html>