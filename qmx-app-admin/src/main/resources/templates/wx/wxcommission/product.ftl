<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate', 'element'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.jquery;
            var element = layui.element;
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
                    url: "deleteproduct",
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
</head>
<body>
<#include "tab.ftl"/>

<form class="layui-form" action="product" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">规则名称</label>
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
                       class="layui-input" placeholder="规则名称">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='product';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
        <div class="layui-input-inline">
            <button onclick="location.href='addproduct';" class="layui-btn layui-btn-normal">新增</button>
        </div>
    </div>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;">
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            规则名称
        </th>
        <th>
            返佣模式
        </th>
        <th>
            返佣金额
        </th>
        <th>
            操作
        </th>
    </tr>
<#list page.records as dto>
    <tr>
        <td>
            <input name="id" type="checkbox" value="${(dto.id)!}"/>
        </td>
        <td>
        ${(dto.name)!}
        </td>
        <td>
        ${(dto.type.title)!}
        </td>
        <td>
        ${(dto.amount)!}
        </td>
        <td>
            <input type="button" onclick="location.href='addproduct?id=${dto.id!?c}';"
                   class="layui-btn" value="编辑"/>
            <input type="button" class="layui-btn" data-id="${dto.id!?c}" id="deleteBtn" value="删除"/>
        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>