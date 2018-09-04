<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">
</head>
<body>

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>门票短信日志列表</legend>
</fieldset>
<form id="listForm" class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">手机号码</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="phone" value="${queryDto.phone!}" placeholder="手机号码"/>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>

<div class="layui-form-item" style="margin-left: 10px;">

</div>

<table id="listTable" class="layui-table">
    <thead>
    <tr>
        <th class="check">
            序号
        </th>
        <th>
            手机号
        </th>
        <th>
            签名
        </th>
        <th>
            内容
        </th>
        <th>
            订单号
        </th>
        <th>
            发送次数
        </th>
        <th>
            供应商
        </th>
        <th>
            短信平台
        </th>
        <th>
            发送状态
        </th>
        <th>
            发送时间
        </th>
        <th>
            发送人
        </th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            ${(dto_index+1)!}
        </td>
        <td>
        ${dto.phone!}
        </td>
        <td>
        ${dto.signName!}
        </td>
        <td>
        ${dto.content!}
        </td>
        <td>
        ${dto.orderId!}
        </td>
        <td>
        ${dto.sendTimes}
        </td>
        <td>
            <#if dto.supplier??>
						    ${dto.supplier.username!}
						</#if>
        </td>
        <td>
        ${dto.smsPlat.getName()!}
        </td>
        <td>
        ${dto.sendState!}
        </td>
        <td>
        ${dto.createTime?datetime}
        </td>
        <td>
            <#if dto.createUser??>
					    ${dto.createUser.username!}
					</#if>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>