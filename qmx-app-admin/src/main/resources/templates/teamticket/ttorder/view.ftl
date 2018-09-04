<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
    <link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.lSelect.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
    <script type="text/javascript">
        $().ready(function () {
        });
    </script>
</head>
<body>

<ul id="tab" class="tab">
    <li>
        <input type="button" value="订单信息"/>
    </li>
</ul>
<table class="input tabContent">
    <tr>
        <th>
            订单编号:
        </th>
        <td width="360">
        ${dto.id!?c}
        </td>
        <th>
            时间
        </th>
        <td>
        ${dto.createTime?datetime}
        </td>
    </tr>
    <tr>
        <th>
            订单状态:
        </th>
        <td>${dto.orderStatus.title}</td>
        <th>
            支付状态:
        </th>
        <td>${dto.paymentStatus.title}</td>
    </tr>
    <tr>
        <th>
            总金额:
        </th>
        <td>${dto.totalAmount}</td>
        <th>
            已付金额:
        </th>
        <td>${dto.amountPaid}</td>
    </tr>
    <tr>
        <th>
            未付金额:
        </th>
        <td>${dto.totalAmount-dto.amountPaid}</td>
        <th>
            下单人:
        </th>
        <td>${dto.operatorName}</td>
    </tr>
    <tr>
        <th>
            出票状态:
        </th>
        <td>
        ${dto.ticketStatus?string("<span style='color: #0aad00;'>已出票</span>","<span style='color: red;'>未出票</span>")}
        </td>
        <th>
            检票状态:
        </th>
        <td>
        ${dto.checkTicketStatus?string("<span style='color: #0aad00;'>已检票</span>","<span style='color: red;'>未检票</span>")}
        </td>
    </tr>
    <tr>
        <th>订单详细</th>
        <td colspan="3">
            <table>
                <tr>
                    <th>产品名称</th>
                    <th>数量</th>
                    <th>总价格</th>
                    <th>绩效方式</th>
                    <th>绩效金额</th>
                </tr>
            <#list dto.infos as info>
                <tr align="right">
                    <td>${info.productName!}</td>
                    <td>${info.quantity!}</td>
                    <td>${(info.price*info.quantity)!?string("currency")}</td>
                    <td><#if info.type??>${info.type.title!}</#if></td>
                    <td>${info.number!?string("currency")}</td>
                </tr>
            </#list>
            </table>
        </td>
    </tr>
    <tr>
        <th>开票信息</th>
        <td colspan="3">
            <table>
                <tr>
                    <th>开票单位名称</th>
                    <td>${dto.unitName!}</td>
                </tr>
                <tr>
                    <th>纳税人识别号(税号)</th>
                    <td>${dto.unitTaxNumber!}</td>
                </tr>
                <tr>
                    <th>单位地址</th>
                    <td>${dto.unitAddr!}</td>
                </tr>
                <tr>
                    <th>单位电话</th>
                    <td>${dto.unitPhone!}</td>
                </tr>
                <tr>
                    <th>银行开户行</th>
                    <td>${dto.unitBank!}</td>
                </tr>
                <tr>
                    <th>银行账号</th>
                    <td>${dto.unitAccount!}</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>