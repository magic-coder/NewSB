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
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>授权方列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">授权方appid</label>
            <div class="layui-input-inline">
                <input type="text" name="authorizerAppid" value="${dto.authorizerAppid!}" autocomplete="off"
                       class="layui-input" placeholder="授权方appid">
            </div>
            <label class="layui-form-label">授权方昵称</label>
            <div class="layui-input-inline">
                <input type="text" name="nickName" value="${dto.nickName!}" autocomplete="off"
                       class="layui-input" placeholder="授权方昵称">
            </div>
        <#--<div class="layui-input-inline">
            <select name="enable" lay-filter="aihao" lay-verify="required">
                <option value="">--是否启用--</option>
                <option value="1" <#if dto.enable?? && dto.enable==true>selected</#if>>启用</option>
                <option value="0" <#if dto.enable?? && dto.enable==false>selected</#if> >禁用</option>
            </select>
        </div>-->
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
        <div class="layui-input-inline">
            <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
        </div>
    </div>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            授权方appid
        </th>
        <th>
            授权方昵称
        </th>
        <th>
            原始ID
        </th>
        <th>
            GDS secretKey
        </th>
    <#--<th>
        是否启用
    </th>-->
        <th>
            <span>操作</span>
        </th>
    </tr>
<#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>
        ${dto.authorizerAppid!}
        </td>
        <td>
        ${dto.nickName!}
        </td>
        <td>
        ${dto.userName!}
        </td>
        <td>
        ${dto.secretKey!}
        </td>
    <#--<td>

    </td>-->
        <td>
            <input type="button" onclick="location.href='shouquan';" class="layui-btn layui-btn-sm" value="授权"/>
            <input type="button" onclick="location.href='edit?id=${dto.id!?c}';"
                   class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!?c}" id="viewBtn"
                   value="编辑"/>
            <input type="button" onclick="del('${dto.id?c}')" class="layui-btn layui-btn-normal layui-btn-sm"
                   data-id="${dto.id!?c}" id="viewBtn"
                   value="删除"/>
        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">

<script type="text/javascript">
    function del(id) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg) == true) {
            window.location.href = "delete.jhtml?id=" + id;
        } else {
            return false;
        }
    }

</script>
</body>
</html>