<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>支付订单列表</title>
<#include "/include/header_include_old.ftl">
    <script src="${base}/resources/assets/layer/layer.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#payRefundBtn").click(function () {
                if ($("tr").hasClass("selected") && $(".selected").length == 1) {
                    var val = $(".selected > td > input").val();
                    var data = {};
                    data.orderId = val;
                    $.ajax({
                        url: "prePayRefund",
                        type: "GET",
                        data:data,
                        cache: false,
                        success: function(message) {
                            $.dialog({
                                title: "退款",
                                content: message,
                                width: 300,
                                modal: true,
                                ok: "确定",
                                cancel: "取消",
                                onShow: function() {
                                },
                                onClose: function() {
                                    $("#refundAmnoutForm").remove();
                                },
                                onOk: function(){
                                    var amount = $("#refundAmnout").val();
                                    var map ={};
                                    map.token = '${token}';
                                    map.orderId = val;
                                    map.amount = amount;
                                    $.ajax({
                                        url: "doPayRefund",
                                        type: "POST",
                                        data:map,
                                        cache: false,
                                        success: function(message) {
                                            if(message){
                                                if(message.errorCode == 0){
                                                    alert('退款成功');
                                                }else{
                                                    alert(message.errorMsg);
                                                }
                                            }
                                        }
                                    });
                                }
                            });
                        }
                    });
                } else {
                    alert("你还未选中记录或选择了多条记录");
                    return false;
                }
            });
            $("#updatePayStatusBtn").click(function () {
                if ($("tr").hasClass("selected") && $(".selected").length == 1) {
                    var val = $(".selected > td > input").val();
                    var data = {};
                    data.id = val;
                    $.ajax({
                        url: "updateStatus",
                        type: "POST",
                        data:data,
                        cache: false,
                        success: function(message) {
                            if(message){
                                if(message.errorCode == 0){
                                    alert(message.data);
                                }else{
                                    alert(message.errorMsg);
                                }
                            }
                        }
                    });
                } else {
                    alert("你还未选中记录或选择了多条记录");
                    return false;
                }
            });

            $("#viewPayResultBtn").click(function () {
                if ($("tr").hasClass("selected") && $(".selected").length == 1) {
                    var val = $(".selected > td > input").val();
                    var data = {};
                    data.id = val;
                    $.ajax({
                        url: "getPayOrderStatus",
                        type: "POST",
                        data:data,
                        cache: false,
                        success: function(message) {
                            if(message){
                                var msg =  message;
                                console.info(msg);
                                layer.open({
                                    content: msg,
                                    area: ['660px', '500px'],
                                    scrollbar: false
                                });
                            }
                        }
                    });
                } else {
                    alert("你还未选中记录或选择了多条记录");
                    return false;
                }
            });

            $("#viewRefundResultBtn").click(function () {
                if ($("tr").hasClass("selected") && $(".selected").length == 1) {
                    var val = $(".selected > td > input").val();
                    var data = {};
                    data.id = val;
                    $.ajax({
                        url: "getRefundStatus",
                        type: "POST",
                        data:data,
                        cache: false,
                        success: function(message) {
                            if(message){
                                var msg =  message;
                                console.info(msg);
                                layer.open({
                                    content: msg,
                                    area: ['660px', '500px'],
                                    scrollbar: false
                                });
                            }
                        }
                    });
                } else {
                    alert("你还未选中记录或选择了多条记录");
                    return false;
                }
            });
        })
    </script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
            支付订单列表
	    </div>
	</div>
	<form id="listForm" action="list" method="get">
        <div class="bar">
            商户号：<input name="mchId" value="${queryDto.mchId!}" />
            订单状态：
            <select name="payStatus">
                <option value="">请选择</option>
                <option value="INIT" <#if queryDto.payStatus?? && queryDto.payStatus = 'INIT'>selected</#if>>等待支付</option>
                <option value="SUCCESS" <#if queryDto.payStatus?? && queryDto.payStatus = 'SUCCESS'>selected</#if>>支付成功</option>
            </select>
            <select name="payPlat">
                <option value="">请选择</option>
                <option value="WXPAY" <#if queryDto.payPlat?? && queryDto.payPlat = 'WXPAY'>selected</#if>>微信</option>
                <option value="ALIPAY" <#if queryDto.payPlat?? && queryDto.payPlat = 'ALIPAY'>selected</#if>>支付宝</option>
            </select>
            <input type="submit" class="button" value="查询"/>
        </div>
		<div class="bar">
        <@shiro.hasPermission name = "admin:addPayOrder">
            <a href="add" class="button">添加</a>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "admin:payOrderRefund">
            <a class="button" id="payRefundBtn" href="javascript:;">支付退款</a>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "admin:updatePayOrderPayStatus">
            <a class="button" id="updatePayStatusBtn" href="javascript:;">更新支付状态</a>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "admin:vewPayOrderResult">
            <a class="button" id="viewPayResultBtn" href="javascript:;">查看支付结果</a>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "admin:viewPayOrderRefundResult">
            <a class="button" id="viewRefundResultBtn" href="javascript:;">查看退款结果</a>
        </@shiro.hasPermission>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
                    mchOrderId
				</th>
                <th>
                    支付方式
                </th>
                <th>
                    金额/已退（单位：元）
                </th>
                <th>
                    支付状态
                </th>
                <th>
                    device
                </th>
				<th>
                    subject
            	</th>
                <th>
                    body
                </th>
                <th>
                    支付订单号
                </th>
                <th>
                    通知次数
                </th>
                <th>
                    最后通知时间
                </th>
                <th>
                    支付成功时间
                </th>
                <th>
                    交易场景
                </th>
                <th>
                    交易类型
                </th>
                <th>
                    错误信息
                </th>
			</tr>
			<#list page.records as dto>
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${dto.id}" />
					</td>
					<td title="支付时间:${dto.createTime?datetime}">
						${dto.mchOrderId!}
					</td>
                    <td>
					${dto.channelName!}(${dto.channelNo!})
                    </td>
                    <td>
					${dto.amount?string('0.00')}/${dto.refundAmount?string('0.00')!}
                    </td>
                    <td>
					${dto.payStatus.getName()!}
                    </td>
                    <td>
					${dto.device!}
                    </td>
                    <td>
					${dto.subject!}
                    </td>
                    <td>
					${dto.body!}
                    </td>
					<td>
					${dto.channelOrderId!}
					</td>
                    <td>
					${dto.notifyCount!}
                    </td>
                    <td>
                        <#if dto.lastNotifyTime??>
                            ${dto.lastNotifyTime?datetime}
                        <#else>
                            -
                        </#if>
                    </td>
                    <td>
                        <#if dto.paySuccTime??>
                            ${dto.paySuccTime?datetime}
                        <#else>
                            -
                        </#if>
                    </td>
                    <td>
					${dto.tradingScene.getName()!}
                    </td>
                    <td>
					${dto.tradingType.getName()!}
                    </td>
                    <td>
						<#if dto.errCode??>
                        ${dto.errMsg!}(${dto.errCode!})
						</#if>
                    </td>
				</tr>
			</#list>
		</table>
	<#include "/include/pagination.ftl">
	</form>
</body>
</html>