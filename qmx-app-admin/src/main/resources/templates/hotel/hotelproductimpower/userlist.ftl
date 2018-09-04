<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
    <script>
        //注意：parent 是 JS 自带的全局对象，可用于操作父页面
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        //关闭iframe
        $(document).on("click", "#closeIframe", function () {
            parent.layer.close(index);
        });
        //提交iframe
        $(document).on("click", "#submitIframe", function () {
            var $checkedIds = $("input[name='ids']:enabled:checked");
            $checkedIds.each(function () {
                var id = $(this).val();
                var tr = $(this).parents("tr:eq(0)");
                // var username = tr.find("td:eq(3)").text();
                addProductItem({
                    id: id,
                    username: tr.find("td:eq(3)").text()
                });
            });
            /*parent.$("#distributorId").val($checkedId.val());
            parent.$("#distributorName").html($checkedId.parents("tr:eq(0)").find("td:eq(1)").text());*/
            parent.layer.close(index);
        });

        function addProductItem(data) {
            var repeat = false;
            parent.$("#userTable input.userId").each(function () {
                var tmp = $(this).val();
                if (tmp == data.id) {
                    repeat = true;
                    return false;
                }
            });
            if (repeat) {
                return false;
            }
            var $tr = '<tr>' +
                    '<td>' + data.id + '</td>' +
                    '<td>' + data.username + '</td>' +
                    '<td>' +
                    '<input type="button" class="layui-btn layui-btn-sm layui-btn-normal deleteItem" data-id="' + data.id + '" value="删除"/>' +
                    '<input id="userId" name="userId" class="userId" value="' + data.id + '" type="hidden" >' +
                    '</td>' +
                    '</tr>';
            parent.$('#userTable').append($tr);
        }
    </script>

</head>
<body>
<hr/>
<form class="layui-form" action="getUser" method="post">
    <input type="hidden" name="productId" value="${productId!}"/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">账号名称</label>
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='getUser';" class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable">
    <thead>
    <tr>
        <th class="check">
            <input id="selectAll" type="checkbox">
        </th>
        <th>
            账号
        </th>
        <th>
            角色
        </th>
        <th>
            姓名
        </th>
        <th>
            最后登录日期
        </th>
        <th>
            创建日期
        </th>
    </tr>
    <tbody>
    <#list page.records as info>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${info.id!?c}"/>
        </td>
        <td>
        ${info.account!}
        </td>
        <td>
            <#if '${info.userType!}'='distributor'>
                一级分销商
            <#elseif '${info.userType!}'='distributor2'>
                二级分销商
            </#if>
        </td>
        <td>
        ${info.username!}
        </td>
        <td>
            <#if info.lastLoginTime??>${info.lastLoginTime!?datetime}</#if>
        </td>
        <td>
        ${info.createTime!?datetime}
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
<div class="layui-form-item">
    <div align="center">
        <div>
            <input id="submitIframe" type="button" class="layui-btn layui-btn-normal" value="确定"/>
            <input id="closeIframe" type="button" class="layui-btn layui-btn-primary" value="取消"/>
        </div>
    </div>
</div>
</body>
</html>