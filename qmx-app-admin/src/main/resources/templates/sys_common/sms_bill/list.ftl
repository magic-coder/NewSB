<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>短信账单列表</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">

    </script>
</head>
<body>

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>短信账单列表</legend>
</fieldset>
<form id="listForm" class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">账号名称</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="memberName" value="${queryDto.memberName!}" placeholder="账号名称"/>
            </div>
            <div class="layui-input-inline" style="width: 128px;">
                <select name="billType">
                    <option value="">账单类型</option>
                <#list billTypes as act>
                    <option <#if queryDto.billType?? && queryDto.billType == act>selected</#if> value="${act!}">${act.getName()!}</option>
                </#list>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
            </div>
        </div>
    </div>
</form>
<table id="listTable" class="layui-table">
    <thead>
    <tr>
        <th class="check">
            序列
        </th>
        <th>账号名称</th>
        <th>
            账单类型
        </th>
        <th>
            账单日期
        </th>
        <th>
            账单结算日期
        </th>
        <th>
            账单金额
        </th>
        <th>
            是否结算
        </th>
        <th style="width: 50px;">
            <span>操作</span>
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
        ${(dto.memberName)!}
        </td>
        <td>
         <#if dto.billType??>
             ${(dto.billType.getName())!}
         <#else>
             -
         </#if>
        </td>
        <td>
        ${dto.startDate?datetime}~${dto.endDate?datetime}
        </td>
        <td>
        ${dto.settlementDate?datetime}
        </td>
        <td>
            ${dto.billAmount?string("0.00")}
        </td>
        <td>${dto.settleStatus?string("是", "否")}</td>
        <td>
            <#if dto.settleStatus??>
                <#if dto.settleStatus>
                    已结算:${dto.updateTime?datetime}
                <#else>
                    <#if dto.endDate?datetime lt .now?datetime>
                        <a href="settleSmsBill?id=${dto.id}">[结算]</a>
                    </#if>

                </#if>
            </#if>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>