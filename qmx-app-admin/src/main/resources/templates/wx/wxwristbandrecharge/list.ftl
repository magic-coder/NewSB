<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
</head>
<body>
<#include "../wxwristband/tab.ftl"/>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">条码号</label>
            <div class="layui-input-inline">
                <input type="text" name="barCode" value="${dto.barCode!}" autocomplete="off"
                       class="layui-input" placeholder="请输入条码号">
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
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <tr>
        <th>id</th>
        <th>sn</th>
        <th width="20%">腕带条码</th>
        <th width="20%">金额</th>
        <th width="20%">时间</th>
        <th width="10%">充值状态</th>
        <th width="10%">同步状态</th>
        <th width="20%">备注</th>
    </tr>
<#list page.records as dto>
    <tr>
        <td class="center">${dto.id!}</td>
        <td class="center">${dto.sn!}</td>
        <td class="center">${dto.barCode!}</td>
        <td class="center"><#if dto.type?? && dto.type=="consumption">-<#else>+</#if>￥${dto.rMoney!}</td>
        <td class="center"><#if dto.rDate??>${dto.rDate?string("yyyy-MM-dd HH:mm:ss")}</#if></td>
        <td class="center">
            <#if dto.rStatus==1>
                <span style="color:green;">已支付</span>
            <#else>
                <span style="color:red;">未支付</span>
            </#if>
        </td>
        <td class="center">
            <#if dto.tStatus==1>
                <span style="color:green;">已同步</span>
            <#else>
                <span style="color:red;">未同步</span>
            </#if>
        </td>
        </td>
        <td class="center">${dto.remarks!}</td>
    </tr>
</#list>
</table>
</body>
</html>