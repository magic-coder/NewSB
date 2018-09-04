<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>添加测试支付订单</title>
<#include "/include/header_include_old.ftl">
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			添加
	    </div>
	</div>
	<form id="inputForm" action="savePayOrderInfo" method="post">
		<table class="input">
            <tr>
                <th>
                    <span class="requiredField">*</span>选择配置:
                </th>
                <td>
                    <select name="configId">
                        <option value="">请选择</option>
                        <#list configDtos as config>
                            <option value="${config.id}"><#if config.member??>${config.member.username!}-</#if><#if config.payPlat??>${config.payPlat.getName()}-</#if>${config.payChannelNo!}</option>
                        </#list>
                    </select>
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>交易类型:
                </th>
                <td>
                    <select name="tradingType">
                        <option value="">请选择</option>
                        <#list tradeTypes as t>
                            <option value="${t}">${t.getName()!}</option>
                        </#list>
                    </select>
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>条码:
                </th>
                <td>
                    <input type="text" name="authCode" class="text" maxlength="300" />
                    <span class="tips">条码</span>
                </td>
            </tr>
			<tr>
				<th>
					<span class="requiredField">*</span>amount:
				</th>
				<td>
					<input type="text" name="amount" class="text" maxlength="300" />
                    <span class="tips">单位：分</span>
				</td>
			</tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>body:
                </th>
                <td>
                    <input type="text" name="body" value="${body!}" class="text" maxlength="300" />
                </td>
            </tr>
			<tr>
				<th>
					<span class="requiredField">*</span>clientIp:
				</th>
				<td>
					<input type="text" name="clientIp" value="127.0.0.1" class="text" maxlength="300" />
				</td>
			</tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>device:
                </th>
                <td>
                    <input type="text" name="device" value="${device!}" class="text" maxlength="300" />
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>openId:
                </th>
                <td>
                    <input type="text" name="openId" value="openId" class="text" maxlength="300" />
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>productId:
                </th>
                <td>
                    <input type="text" name="productId" value="2" class="text" maxlength="300" />
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>attach:
                </th>
                <td>
                    <input type="text" name="attach" value="${attach!}" class="text" maxlength="300" />
                </td>
            </tr>
			<tr>
				<th>
                    mchOrderId:
				</th>
				<td>
					<input type="text" name="mchOrderId" class="text" value="${mchOrderId!}" maxlength="30" />
				</td>
			</tr>
            <tr>
                <th>
                    subject:
                </th>
                <td>
                    <input type="text" name="subject" class="text" value="${subject!}" maxlength="30" />
                </td>
            </tr>
            <tr>
                <th>
                    notifyUrl:
                </th>
                <td>
                    <input type="text" name="notifyUrl" class="text" value="${notifyUrl!}" maxlength="30" />
                </td>
            </tr>
		</table>
		<table class="input">
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="保存" />
					<input type="button" class="button" value="返回" onclick="history.back();" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>