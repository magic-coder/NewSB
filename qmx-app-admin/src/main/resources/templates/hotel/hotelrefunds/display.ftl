<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
    <link href="${base}/css/common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript"  src="/js/jquery-latest.js"></script>
<#--    <script type="text/javascript" src="${base}/js/datePicker/WdatePicker.js"></script>-->
<#--    <script type="text/javascript" src="${base}/js/common.js"></script>-->
<#--    <script type="text/javascript" src="${base}/js/input.js"></script>-->
    <style type="text/css">
        .roles label {
            width: 150px;
            display: block;
            float: left;
            padding-right: 6px;
        }
    </style>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">

    </div>
</div>
<table class="input">
    <tr>
        <th>
            编号：
        </th>
        <td>
            ${dto.orderSn!}
        </td>
        <th>
            创建日期:
        </th>
        <td>
        ${dto.createTime?datetime!}
        </td>
    </tr>
    <tr>
        <th>
            退款方式:
        </th>
        <td>
            -
        </td>
        <th>
            支付方式:
        </th>
        <td>
            -
        </td>
    </tr>
    <tr>
        <th>
            退款银行:
        </th>
        <td>
            -
        </td>
        <th>
            退款账号:
        </th>
        <td>
            -
        </td>
    </tr>
    <tr>
        <th>
            收款人:
        </th>
        <td>
        -
        </td>
        <th>
            退款金额:
        </th>
        <td>
            ${dto.amount!}
        </td>
    </tr>
    <tr>
        <th>
            订单:
        </th>
        <td>
        ${dto.orderId!}
        </td>
        <th>

        </th>
        <td>

        </td>
    </tr>
    <tr>
        <th>
            退款数量:
        </th>
        <td>
        ${dto.quantity!}
        </td>
        <th>
            备注:
        </th>
        <td>
        ${dto.memo!}
        </td>
    </tr>
</table>
    <table class="input" >
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="button" class="button" value="返回" onclick="history.back();"/>
            </td>
        </tr>
    </table>

</body>
</html>