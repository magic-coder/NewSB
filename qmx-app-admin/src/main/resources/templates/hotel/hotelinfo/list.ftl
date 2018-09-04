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

        //全选
        $('#selectAll').click(function () {
            // do something
            if ($("#selectAll").attr("checked")) {
                $("input[name='ids']").attr("checked", true);
            } else {
                $("input[name='ids']").attr("checked", false);
            }
        })
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>酒店列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item" style="margin-left: 10px;">
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
                       class="layui-input" placeholder="酒店名称">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="phone" value="${dto.phone!}" autocomplete="off"
                       class="layui-input" placeholder="联系电话">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
            <#--<input type="text" name="supplierName" value="${dto.supplierName!}" autocomplete="off"
                   class="layui-input" placeholder="供应商">-->
                <select name="star" id="star" class="layui-input">
                    <option value="">--酒店星级--</option>
                    <option value="2" <#if '${dto.star!}'='2'> selected='selected'</#if>>二星级以下/经济</option>
                    <option value="3" <#if '${dto.star!}'='3'> selected='selected'</#if>>三星级/舒适</option>
                    <option value="4" <#if '${dto.star!}'='4'> selected='selected'</#if>>四星级/高档</option>
                    <option value="5" <#if '${dto.star!}'='5'> selected='selected'</#if>>五星级/豪华</option>
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
<@shiro.hasPermission name="addHotel">
    <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
</@shiro.hasPermission>
<@shiro.hasPermission name="deleteHotel">
    <button onclick="delAll()" class="layui-btn layui-btn-normal">删除</button>
</@shiro.hasPermission>
</div>

<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th class="check"><input type="checkbox" id="selectAll"/></th>
        <th>酒店名称</th>
        <th>酒店地址</th>
        <th>联系电话</th>
        <th>酒店星级</th>
        <th>房间数</th>
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
        ${dto.name!}
        </td>
        <td>
        ${dto.address!}
        </td>
        <td>
        ${dto.phone!}
        </td>
        <td>
            <#if '${dto.star!}'='2'>
                二星级以下/经济
            <#elseif '${dto.star!}'='3'>
                三星级/舒适
            <#elseif '${dto.star!}'='4'>
                四星级/高档
            <#elseif '${dto.star!}'='5'>
                五星级/豪华
            </#if>
        </td>
        <td>
        ${dto.rooms!}
        </td>
        <td>
        ${dto.createTime!?string("yyyy-MM-dd HH:mm:ss")}
        </td>
        <td>${dto.createName!}</td>
        <td>
            <input type="button" onclick="location.href='/hotelRoomType/getList?hid=${dto.id}';"
                   class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}"
                   value="房型预览"/>
            <@shiro.hasPermission name="editHotel">
                <input type="button" onclick="location.href='edit?id=${dto.id!}';"
                       class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                       value="编辑"/>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="disPlayHotel">
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