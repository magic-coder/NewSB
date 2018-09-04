<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>列表</title>
    <#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form','table','laydate'], function(){
            var table = layui.table
                    ,laydate = layui.laydate,
					form = layui.form;
            //日期
            laydate.render({
                elem: '#accountCanUseEnd'
            });
            $(document).on("click","#reCharge",function(){
                var data = $(this).attr("data-id");
                var index = layer.open({
                    type: 2,
                    title: '系统充值',
                    area: ['500px', '450px'], //宽高
                    fix: true, //固定
                    content: '/userDeposit/preRecharge?userId='+data
                });
            });
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>预存款用户列表</legend>
</fieldset>
<form class="layui-form" action="list" method="get">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">登录账号</label>
            <div class="layui-input-inline">
                <input type="text" name="account" value="${userQueryVo.account!}" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-inline">
                <input type="text" name="username" value="${userQueryVo.username!}" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">是否启用</label>
            <div class="layui-input-inline">
                <select name="enable">
                    <option value=""></option>
                    <option <#if (!userQueryVo.enable?? || userQueryVo.enable)>selected</#if> value="true">启用</option>
                    <option <#if userQueryVo.enable?? && !userQueryVo.enable>selected</#if> value="false">禁用</option>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <input type="button" class="layui-btn layui-btn-primary" onclick="location.href='list'" value="重置"/>
            </div>
        </div>
    </div>
</form>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable" lay-size="sm" lay-filter="sysBalanceTableEvent">
    <colgroup>
        <col width="20">
        <col width="110">
        <col width="50">
        <col width="50">
        <col width="50">
        <col width="50">
        <col width="50">
        <col>
    </colgroup>
    <thead>
    <tr>
		<th>NO</th>
        <th>用户名</th>
        <th>账号</th>
        <th>联系电话</th>
        <th>余额</th>
        <th>历史充值</th>
        <th>状态</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
	<#list page.records as dto>
		<tr>
			<td align="center">${dto_index+1!}</td>
			<td>${dto.username!}</td>
			<td>${dto.account!}</td>
			<td>${dto.phone!}</td>
            <#if dto.userDeposit??>
                <td align="center">${dto.userDeposit.depositBalance!}</td>
                <td align="center">${dto.userDeposit.rechargedDepositBalance!}</td>
            <#else>
                <td align="center">-</td>
                <td align="center">-</td>
            </#if>
            <td>
				<#if dto.enable>
                    <i class="layui-icon">&#xe605;</i>
				<#else>
                    <i class="layui-icon">&#x1006;</i>
				</#if>
			</td>
            <td>
                <@shiro.hasPermission name = "admin:updateUserDepositBalance">
                    <button class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}" id="reCharge">充值</button>
                </@shiro.hasPermission>
                <button class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}">预存款充值统计</button>
                <button class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}">预存款消费统计</button>
			</td>
		</tr>
	</#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>