<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>产品列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
    <script>
        //删除
        $(document).on("click", "#deleteBtn", function () {
            var data = $(this).attr("data-id");
            layer.confirm('确定删除吗？', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                $.ajax({
                    url: "delete",
                    type: "POST",
                    data: {id: data},
                    beforeSend: function () {
                    },
                    success: function (json) {
                        if (json.state == "success") {
                            layer.msg(json.msg);
                            setTimeout(function () {
                                location.reload(true);
                            }, 500);
                        } else {
                            layer.msg(json.msg);
                        }
                    }
                });
            }, function () {

            });
        });
    </script>
    <script>
        $(document).ready(function (e) {
            $("#selectAll").click(function () {
                if (this.checked) {
                    $("[name=ids]").attr("checked", true);
                } else {
                    $("[name=ids]").attr("checked", false);
                }
            });
            $("tr").slice(1).click(function (e) {
                // 找到checkbox对象
                var ids = $("input[name=ids]", this);
                if (ids.length < 1) {
                    return;
                }
                if (ids[0].checked) {
                    $("[name=ids]", this).attr("checked", false);
                } else {
                    $("[name=ids]", this).attr("checked", true);
                }
            });
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>产品列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">产品名称</label>
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
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
<div class="layui-form-item" style="margin-left: 10px;">
<@shiro.hasPermission name = "ttproduct:add">
    <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
</@shiro.hasPermission>
</div>

<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th><input type="checkbox" id="selectAll"/></th>
        <th>产品名称(产品ID)</th>
        <th>门市价</th>
        <th>是否上架</th>
        <th>创建日期</th>
        <th>添加人</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>
            <span title="${dto.name}">${dto.name}</span>(${dto.id})
        </td>
        <td>
        ${dto.marketPrice}
        </td>
        <td>
            <#if dto.marketable>
                <i class="layui-icon">&#xe605;</i>
            <#else>
                <i class="layui-icon">&#x1006;</i>
            </#if>
        </td>
        <td>
        ${dto.createTime?datetime}
        </td>
        <td>
        ${dto.memberName!}
        </td>
        <td>
            <@shiro.hasPermission name = "ttproduct:edit">
                <input type="button" onclick="location.href='edit?id=${dto.id!}';"
                       class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="editBtn"
                       value="编辑"/>
            </@shiro.hasPermission>
            <@shiro.hasPermission name = "ttproduct:delete">
                <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}" id="deleteBtn"
                       value="删除"/>
            </@shiro.hasPermission>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>