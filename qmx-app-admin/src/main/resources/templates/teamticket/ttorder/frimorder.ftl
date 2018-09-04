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
    <#list order.infos as info>
        <p class="row">${info.productName}：${info.quantity}张</p>
    </#list>
    </div>
</div>
</body>

</html>