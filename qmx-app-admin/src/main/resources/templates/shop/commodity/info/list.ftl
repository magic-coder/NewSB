<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>商品列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            laydate.render({elem: "#date"});
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>商品列表</legend>
</fieldset>
<form class="layui-form" action="list" method="get">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">商品名称</label>
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
                       class="layui-input">
                <input type="hidden" name="sid" value="${dto.sid!}">
            </div>
            <label class="layui-form-label">商品品类</label>
            <div class="layui-input-inline">
                <select name="commodityCategory">
                    <option value="">请选择商品品类</option>
                <#list category as info>
                    <option value="${info.id!}" class="layui-input"
                            <#if '${info.id!}'=='${dto.commodityCategory!}'>selected</#if>>${info.categoryName!}</option>
                </#list>
                </select>
            </div>
            <label class="layui-form-label">商品品牌</label>
            <div class="layui-input-inline">
                <input type="text" name="brand" value="${dto.brand!}" autocomplete="off"
                       class="layui-input">
            </div>
            <label class="layui-form-label">商品类型</label>
            <div class="layui-input-inline">
                <select name="commodityType">
                    <option value="">请选择商品类型</option>
                <#list type as info>
                    <option value="${info!}" class="layui-input"
                            <#if info=='${dto.commodityType!}'>selected</#if>>${info.type!}</option>
                </#list>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list?sid=${dto.sid!}';"
                        class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
        <div class="layui-input-inline">
        <@shiro.hasPermission name="createCommodity">
            <button onclick="location.href='add?sid=${dto.sid!}';" class="layui-btn layui-btn-normal">新增</button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="deleteCommodity">
            <button onclick="delAll()" class="layui-btn layui-btn-normal">删除</button>
        </@shiro.hasPermission>
        </div>

    </div>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            商品名称
        </th>
        <th>
            供应商(id)
        </th>
        <th>
            商品品类
        </th>
        <th>
            商品品牌
        </th>
        <th>
            商品类型
        </th>
        <th>
            创建时间
        </th>
        <th>
            创建人
        </th>
        <th>
            <span>操作</span>
        </th>
    </tr>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}" id="checkboxes" class="checkboxes"/>
        </td>
        <td>
        ${dto.name!}
        </td>
        <td>
        ${dto.supplyRelationName!}(${dto.sid!})
        </td>
        <td>
        <#--<#list category as info>
            <#if '${info.id!}'=='${dto.commodityCategory!}'>
        ${info.categoryName!}
        </#if>
        </#list>-->
            ${dto.categoryName!}
        </td>
        <td>
        ${dto.brand!}
        </td>
        <td>
            <#list type as info>
                <#if info=='${dto.commodityType!}'>
            ${info.type!}
            </#if>
            </#list>
        </td>
        <td>
        ${(dto.createTime!)?string("yyyy-MM-dd HH:mm:ss")}
        </td>
        <td>
        ${dto.createName!}
        </td>
        <td>
            <@shiro.hasPermission name="editCommodity">
                <input type="button" onclick="location.href='edit?id=${dto.id!}';"
                       class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!?c}" id="viewBtn"
                       value="编辑"/>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="viewCommodity">
                <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="viewBtn"
                       value="查看" onclick="location.href='disPlay?id=${dto.id!}'"/>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="coomodityStorage">
                <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="viewBtn"
                       value="商品入库" onclick="rukun('${dto.id!}')"/>
            </@shiro.hasPermission>
            <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="viewBtn"
                   value="入库信息" onclick="rukunList('${dto.id!}')"/>
        </td>
    </tr>
    </#list>
    </tbody>
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
<script type="text/javascript">
    function delAll() {
        if ($(".checkboxes:checked").length < 1) {
            alert('请选择一条数据');
            return;
        }
        var ids = new Array();
        var n = "";
        var msg = "您真的确定要删除吗?\n\n请确认！";
        if (confirm(msg) == true) {
            $("input[name='ids']:checked").each(function () {//遍历选中的单选框
                var id = $(this).val();
                ids.push(id);
            });
            $.ajax({
                url: '/commodity/info/deleteAll',
                type: 'GET',
                async: true,
                data: {"ids": ids},
                traditional: true,
                success: function (result) {
                    if (result.data == "1") {
                        showTip("操作成功", "success");
                        $("input[name='ids']:checked").each(function () {//遍历选中的单选框
                            n = $(this).parents("tr").index() + 1;//获取单选框选中的所在行数
                            $("table#sysBalanceTable").find("tr:eq(" + n + ")").remove();
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
    });
    //入库弹窗
    function rukun(id) {
        layer.open({
            type: 2,
            area: ['550px', '460px'],
            title: '商品入库信息',
            shade: 0.6, //遮罩透明度
            maxmin: true, //允许全屏最小化
            anim: 1,//0-6的动画形式，-1不开启
            shadeClose: true,
            content: 'storage?cid=' + id
        });
    }
    //入库信息
    function rukunList(id) {
        layer.open({
            type: 2,
            title: '',
            shadeClose: true,
            shade: false,
            maxmin: true, //开启最大化最小化按钮
            area: ['893px', '600px'],
            content: 'storageList?cid=' + id
        });
    }

</script>
<#--消息提示框-->
<style>
    #tip {
        position: absolute;
        top: 85px;
        left: 50%;
        display: none;
        z-index: 9999;
        color: red;
        font-size: 20px;
    }
</style>
<strong id="tip"></strong>
<script>
    //tip是提示信息，type:'success'是成功信息，'danger'是失败信息,'info'是普通信息,'warning'是警告信息
    function showTip(tip, type) {
        var $tip = $('#tip');
        $tip.stop(true).prop('class', 'alert alert-' + type).text(tip).css('margin-left', -$tip.outerWidth() / 2).fadeIn(500).delay(2000).fadeOut(500);
    }

    var Script = function () {
    <#if msg??>
        showTip("${msg}", "success");
    </#if>
    }();
</script>
</body>
</html>