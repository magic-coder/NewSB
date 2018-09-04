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
                elem: '#startDate'
            });
            laydate.render({
                elem: '#endDate'
            });
        });
    </script>
</head>
<body>
<form style="margin-top: 20px;" class="layui-form" action="findChargeTypePage" method="get">
    <input name="memberId" value="${(queryDto.memberId)!}" type="hidden"/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">操作日期</label>
            <div class="layui-input-inline">
                <input type="text" name="startDate" value="${(queryDto.startDate?date)!}" id="startDate" placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-input-inline">
                <input type="text" name="endDate" value="${(queryDto.endDate?date)!}" id="endDate" placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">操作日期</label>
            <div class="layui-input-inline">
                <input type="text" name="createIp" value="${(queryDto.createIp)!}" id="createIp" placeholder="请输入IP" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
            </div>
        </div>
    </div>
</form>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" lay-size="sm">
    <colgroup>
        <col width="20">
        <col width="110">
        <col>
        <col width="100">
        <col width="50">
        <col width="100">
    </colgroup>
    <thead>
    <tr>
		<th>NO</th>
        <th>账号</th>
        <th>修改内容</th>
        <th>修改人</th>
        <th>IP</th>
        <th>修改日期</th>
    </tr>
    </thead>
    <tbody>
	<#list page.records as dto>
		<tr>
			<td align="center">${dto_index+1!}</td>
			<td>${dto.memberName!}</td>
			<td>${dto.content!}</td>
			<td>${dto.createByName!}</td>
			<td align="center">${dto.createIp!}</td>
            <td align="center">${dto.createTime?datetime}</td>
		</tr>
	</#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>