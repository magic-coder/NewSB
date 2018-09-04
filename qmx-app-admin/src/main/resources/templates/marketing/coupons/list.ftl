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
    <legend>优惠券列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">优惠券名称</label>
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
                       class="layui-input" placeholder="优惠券名称">
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
            优惠券名称
        </th>
        <th>
            面值
        </th>
        <th>
            库存/领取
        </th>
        <th>
            门票名称(ID)
        </th>
        <th>
            有效日期
        </th>
        <th>
            操作
        </th>
    </tr>
<#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>
            ${dto.name!}
        </td>
        <td>
            ${dto.price!}
        </td>
        <td>
            ${dto.totleNumber!}/<#if dto.number??>${dto.number!}<#else>0</#if>
        </td>
        <td>
            <label style="font-size: 12px;display: block;width: 400px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;">${dto.productName!}(${dto.product!})</label>
        </td>
        <td>
        ${dto.beginDate!?string("yyyy-MM-dd")}至${dto.endDate!?string("yyyy-MM-dd")}
        </td>
        <td>
            <input type="button" onclick="location.href='edit?id=${dto.id!?c}';"
                   class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!?c}" id="viewBtn"
                   value="编辑"/>
            <@shiro.hasPermission name = "wxcoupons:delete">
                <input type="button" class="layui-btn layui-btn-normal layui-btn-sm"
                       data-id="${dto.id?c}" id="deleteBtn"
                       value="删除"/>
            </@shiro.hasPermission>
        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">
<script type="text/javascript">
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
</body>
</html>