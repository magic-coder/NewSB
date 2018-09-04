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
<#include "../scratchcard/tab.ftl"/>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">活动名称</label>
            <div class="layui-input-inline">
                <select name="scratchCard" class="input_1" lay-verify="" lay-search>
                    <option value=""></option>
                <#list activitys as activity>
                    <option value="${activity.id!}" <#if dto.scratchCard?? && dto.scratchCard==activity.id>selected</#if> > ${activity.name!} </option>
                </#list>
                </select>
            </div>
            <label class="layui-form-label" style="width: 30px;">券号</label>
            <div class="layui-input-inline">
                <input type="text" name="cardcode" value="${dto.cardcode!}" autocomplete="off"
                       class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 60px;">奖品名称</label>
            <div class="layui-input-inline" style="width: 120px;">
                <input type="text" name="prizeName" value="${dto.prizeName!}" autocomplete="off"
                       class="layui-input">
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
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>活动名称</th>
        <th>参与者</th>
        <th>日期</th>
        <th>是否是当日首次分享</th>
        <th>中奖状态</th>
        <th>奖品名称</th>
        <th>劵号</th>
        <th>劵号状态</th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>
        ${dto.scratchCardName!}
        </td>
        <td>
        ${dto.userName!}
        </td>
        <td>
        ${dto.date!}
        </td>
        <td>
            <#if dto.share??&&dto.share>
                <span style="color:green;">√</span>
            <#else>
                <span style="color:red;">×</span>
            </#if>
        </td>
        <td>
            <#if dto.winState??&&dto.winState>
                <span style="color:green;">√</span>
            <#else>
                <span style="color:red;">×</span>
            </#if>
        </td>
        <td>
        ${dto.prizeName!}
        </td>
        <td>
        ${dto.cardcode!}
        </td>
        <td>
        <#if dto.winState??&&dto.winState>
            <#if dto.state=="normal">
                <span style="color:green;">正常</span>
            <#elseif dto.state=="used">
                <span style="color:red;">已使用</span>
            <#else>
                <span style="color:red;">过期</span>
            </#if>
        </#if>
        </td>
    </tr>
    </#list>

    </tbody>
</table>
<#include "/include/my_pagination.ftl">
<script>
    layui.use(['form', 'table', 'laydate'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
    });
</script>
</body>
</html>