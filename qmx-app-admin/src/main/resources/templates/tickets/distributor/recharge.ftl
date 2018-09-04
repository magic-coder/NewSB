<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>${message("admin.admin.edit")}</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<style type="text/css">
.roles label {
	width: 150px;
	display: block;
	float: left;
	padding-right: 5px;
}
</style>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $selectAll = $("#inputForm .selectAll");
	
	[@flash_message /]
	
	$selectAll.click(function() {
		var $this = $(this);
		var $thisCheckbox = $this.closest("tr").find(":checkbox");
		if ($thisCheckbox.filter(":checked").size() > 0) {
			$thisCheckbox.prop("checked", false);
		} else {
			$thisCheckbox.prop("checked", true);
		}
		return false;
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			modifyBalance: {
				required: true,
				min: -${admin.balance},
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			},
		},
		messages: {
			password: {
				pattern: "${message("admin.validate.illegal")}"
			}
		}
	});

});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			预存款充值
	    </div>
	</div>
	<form id="inputForm" action="doRecharge.jhtml" method="post">
		<input type="hidden" name="id" value="${admin.id}" />
		<table class="input">
			<tr>
				<th>
					用户名:
				</th>
				<td>
					${admin.username}
				</td>
			</tr>
			<tr>
				<th>
					当前余额:
				</th>
				<td>
					${currency(admin.balance, true)}
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>余额调整（充值/扣除）:
				</th>
				<td>
					<input type="text" name="modifyBalance" class="text" maxlength="16" title="正数代表充值，负数代表扣除" />
				</td>
			</tr>
			<tr>
				<th>
					备注:
				</th>
				<td>
					<input type="text" name="depositMemo" class="text" maxlength="200" />
				</td>
			</tr>
		</table>
		<table class="input">
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="${message("admin.common.submit")}" />
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back();" />
				</td>
			</tr>
		</table>
		<table class="input">
            <tr>
                <th>
                    预存款调整记录:
                </th>
                <td colspan="3">
                    <table width="100%">
                        <tr class="title">
                            <th>操作时间</th>
                            <th>操作人</th>
                            <th>增加</th>
                            <th>扣除</th>
                        </tr>
					[#assign addAmount = 0]
					[#assign subtract = 0]
					[#list depositList as deposit]
                        <tr>
                            <td>${deposit.createDate?string('yyyy-MM-dd HH:mm:ss')}</td>
                            <td>${deposit.operator.username}(${deposit.operator.name})</td>
                            <td>[#if deposit.credit gt 0]
                                [#assign addAmount = addAmount + deposit.credit]
								${deposit.credit}[/#if]</td>
                            <td>[#if deposit.credit lt 0]
								[#assign subtract = subtract + deposit.credit]
								${deposit.credit}[/#if]</td>
                        </tr>
					[/#list]
						<tr>
							<td colspan="2">合计</td>
							<td>${addAmount}</td>
                            <td>${subtract}</td>
						</tr>
                        <tr>
                            <td colspan="3">实际充值合计</td>
                            <td>${(addAmount+subtract)}</td>
                        </tr>
                    </table>
                </td>
            </tr>
		</table>
	</form>
</body>
</html>