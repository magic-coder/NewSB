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
    <script type="text/javascript">
        function delAll() {
            if ($(".checkboxes:checked").length < 1) {
                alert('请选择一条数据');
                return;
            }
            var ids = "";
            var n = "";
            var msg = "您真的确定要删除吗?\n\n请确认！";
            if (confirm(msg) == true) {
                $("input[name='ids']:checked").each(function () {//遍历选中的单选框
                    var id = $(this).val();
                    ids = ids + "," + id;
                });
                ids = ids.substring(1, ids.length);
                $.ajax({
                    url: '/hotelInfo/deleteAll',
                    type: 'GET',
                    async: true,
                    data: {"ids": ids},
                    success: function (result) {
                        if (result.data == "1") {
                            showTip("操作成功", "success");
                            $("input[name='ids']:checked").each(function () {//遍历选中的单选框
                                n = $(this).parents("tr").index();//获取单选框选中的所在行数
                                $("table#listTable").find("tr:eq(" + n + ")").remove();
                            });
                        } else {
                            showTip("操作失败", "danger");
                        }
                    }
                });
                return true;
            } else {
                return false;
            }
        }
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>通知列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="employee" value="${dto.employee!}" autocomplete="off"
                       class="layui-input" placeholder="员工id">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <select name="informType" class="layui-input">
                    <option value="">请选择通知类型</option>
                <#list type as info>
                    <option value="${info!}" <#if '${info!}'=='${dto.informType!}'>selected</#if>>${info.type!}</option>
                </#list>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                &nbsp;
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item" style="margin-left: 10px;">
<@shiro.hasPermission name="addRefundInform">
    <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
</@shiro.hasPermission>
<@shiro.hasPermission name="deleteRefundInform">
    <button onclick="delAll()" class="layui-btn layui-btn-normal">删除</button>
</@shiro.hasPermission>
</div>

<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th class="check"><input type="checkbox" id="selectAll"/></th>
        <th>员工(id)</th>
        <th>通知类型</th>
        <th>通知方式</th>
        <th>创建时间</th>
        <th>创建人</th>
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
        ${dto.employeeName!}(${dto.employee!})
        </td>
        <td>
        <#--  <#list type as info>
              <#if info=='${dto.informType!}'>
          ${info.type!}
          </#if>
  </#list>-->
            ${dto.informType.type!}
        </td>
        <td>
        ${dto.informWay!}
        </td>
        <td>${dto.createTime!?string("yyyy-MM-dd HH:mm:ss")}</td>
        <td>${dto.createName!}</td>
        <td>
            <@shiro.hasPermission name="editRefundInform">
                <input type="button" onclick="location.href='edit?id=${dto.id!}';"
                       class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                       value="编辑"/>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="disPlayRefundInform">
                <input type="button" onclick="location.href='disPlay?id=${dto.id!}';"
                       class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                       value="查看"/>
            </@shiro.hasPermission>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>