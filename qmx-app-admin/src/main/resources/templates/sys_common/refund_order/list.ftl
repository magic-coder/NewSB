<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>支付退款列表</title>
<#include "/include/header_include_old.ftl">
    <script src="${base}/resources/assets/layer/layer.js"></script>
	<script type="text/javascript">
		$(function () {
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
								//alert(msg);
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
            支付退款
	    </div>
	</div>
	<form id="listForm" action="list" method="get">
        <div class="bar">
        <@shiro.hasPermission name = "admin:viewOrderRefundResult">
            <a class="button" id="viewRefundResultBtn" href="javascript:;">查看退款结果</a>
        </@shiro.hasPermission>
        </div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
                    支付订单号
				</th>
				<th>
                    商户订单号
				</th>
                <th>
                    支付渠道订单号
                </th>
				<th>
                    商户退款流水号
				</th>
                <th>
                    渠道退款流水号
                </th>
                <th>
                    退款金额（单位：分）
                </th>
                <th>
                    订单金额（单位：分）
                </th>
                <th>
                    错误信息
                </th>
                <th>
                    退款是否成功
                </th>
                <th>
                    退款成功时间
                </th>
                <th>
                    退款说明
                </th>
			</tr>
			<#list page.records as dto>
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${dto.id}" />
					</td>
					<td>
						${dto.payOrderId!}
					</td>
					<td>
						${dto.mchOrderId!}
					</td>
                    <td>
					${dto.payChannelOrderId!}
                    </td>
					<td>
						${dto.mchRefundSn!}
					</td>
                    <td>
					${dto.refundId!}
                    </td>
                    <td>
					${dto.refundFee!}
                    </td>
                    <td>
					${dto.totalFee!}
                    </td>
                    <td>
						<#if dto.errCode??>
						${dto.errCode!}(${dto.errMsg!})
						</#if>
                    </td>
                    <td>
					${dto.refundSucc?string("是","否")}
                    </td>
                    <td>
						<#if dto.refundSuccTime??>
						    ${dto.refundSuccTime?datetime}
						<#else>
							-
						</#if>

                    </td>
                    <td>
					${dto.refundDesc!}
                    </td>
				</tr>
			</#list>
		</table>
	<#include "/include/pagination.ftl">
	</form>
</body>
</html>