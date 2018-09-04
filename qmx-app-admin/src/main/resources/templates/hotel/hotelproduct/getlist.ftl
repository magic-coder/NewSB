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
    <legend>产品列表</legend>
</fieldset>
<form class="layui-form" action="getList" method="post">
    <div class="layui-form-item" style="margin-left: 10px;">
        <div class="layui-inline">
            <div class="layui-input-inline">
                <select name="hid" class="layui-input">
                    <option value="">请选择酒店</option>
                <#list hidMap ?keys as key>
                    <option value="${key!}" <#if '${key!}'=='${dto.hid!}'>selected</#if>>${hidMap['${key!}']!}</option>
                </#list>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
                       class="layui-input" placeholder="产品名称">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="rid" value="${dto.rid!}" autocomplete="off"
                       class="layui-input" placeholder="房型ID">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
            <#--<input type="text" name="supplierName" value="${dto.supplierName!}" autocomplete="off"
                   class="layui-input" placeholder="供应商">-->
                <select name="status" class="layui-input">
                    <option value="">请选择状态</option>
                    <option value="上架"  <#if '${dto.status!}'=='上架'>selected</#if>>上架</option>
                    <option value="下架" <#if '${dto.status!}'=='下架'>selected</#if>>下架</option>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
            <#--<input type="text" name="supplierName" value="${dto.supplierName!}" autocomplete="off"
                   class="layui-input" placeholder="供应商">-->
                <select name="rollawayBed" class="layui-input">
                    <option value="">请选择加床</option>
                    <option value="1" <#if '${dto.rollawayBed!}'=='1'>selected</#if>>能加床</option>
                    <option value="2" <#if '${dto.rollawayBed!}'=='2'>selected</#if>>不能加床</option>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
            <#--<input type="text" name="supplierName" value="${dto.supplierName!}" autocomplete="off"
                   class="layui-input" placeholder="供应商">-->
                <select name="windowType" class="layui-input">
                    <option value="">请选择窗型</option>
                    <option value="1" <#if '${dto.windowType!}'=='1'>selected</#if>>有窗</option>
                    <option value="2" <#if '${dto.windowType!}'=='2'>selected</#if>>无窗</option>
                    <option value="3" <#if '${dto.windowType!}'=='3'>selected</#if>>部分有窗</option>
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
<@shiro.hasPermission name="addHotelProduct">
    <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
</@shiro.hasPermission>
<@shiro.hasPermission name="deleteHotelProduct">
    <button onclick="delAll()" class="layui-btn layui-btn-normal">删除</button>
</@shiro.hasPermission>
</div>

<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th class="check"><input type="checkbox" id="selectAll"/></th>
        <th>产品名称</th>
        <th>所属酒店</th>
        <th>房型</th>
        <th>窗型</th>
        <th>加床</th>
        <th>状态</th>
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
        ${dto.hidName!}
        </td>
        <td>
        ${dto.ridName!}(${dto.rid!})
        </td>
        <td>
            <#if '${dto.windowType!}'=='1'>有窗<#elseif '${dto.windowType!}'=='2'>无窗<#else>部分有窗</#if>
        </td>
        <td>
            <#if '${dto.rollawayBed!}'=='1'>能加床
            <#elseif '${dto.rollawayBed!}'=='2'>不能加床
            </#if>
        </td>
        <td>
            <font <#if '${dto.status!}'=='上架'>color="green"<#else>color="red"</#if>>${dto.status!}</font>
        </td>
        <td>${(dto.createTime!)?string("yyyy-MM-dd HH:mm:ss")}</td>
        <td>${dto.createName!}</td>
        <td>
            <@shiro.hasPermission name="editHotelProduct">
                <input type="button" onclick="location.href='edit?id=${dto.id!}';"
                       class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                       value="编辑"/>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="disPlayProduct">
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