<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">
<#--<link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
<link href="${base}/bak/css/bootstrap.min.css"/>
<script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="${base}/bak/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${base}/bak/js/bootstrap-paginator.js"></script>-->
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
    <legend>授权列表</legend>
</fieldset>
<form action="list" method="get" class="layui-form">
    <div class="layui-form-item" style="margin-left: 10px;">
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="distributor" value="${dto.distributor!}" autocomplete="off"
                       class="layui-input" placeholder="分销商id">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="productId" value="${dto.productId!}" autocomplete="off"
                       class="layui-input" placeholder="产品id">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <select name="status" class="layui-input">
                    <option value="">--授权状态--</option>
                    <option value="normal"<#if '${dto.status!}'=='normal'>selected</#if>>正常</option>
                    <option value="disable"<#if '${dto.status!}'=='disable'>selected</#if>>禁用</option>
                    <option value="apply"<#if '${dto.status!}'=='apply'>selected</#if>>待审核</option>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list.jhtml?hid=${dto.hid!}';"
                        class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>
<#--<div class="bar">
    <br/>
&lt;#&ndash;<input type="text" placeholder="酒店名称" name="name" value="${dto.name!}"/>&ndash;&gt;
    <input type="hidden" name="hid" value="${dto.hid!}"/>
    <input type="text" placeholder="分销商id" value="${dto.distributor!}" name="distributor"/>
    <input type="text" placeholder="产品id" value="${dto.productId!}" name="productId"/>
    <select name="status">
        <option value="">--授权状态--</option>
        <option value="normal"<#if '${dto.status!}'=='normal'>selected</#if>>正常</option>
        <option value="disable"<#if '${dto.status!}'=='disable'>selected</#if>>禁用</option>
        <option value="apply"<#if '${dto.status!}'=='apply'>selected</#if>>待审核</option>
    </select>
    <button type="submit" class="button">查询</button>
    <button type="button" class="button" onclick="location.href='list.jhtml?hid=${dto.hid!}';">重置</button>
    <span style="color:green;">${flash_message_attribute_name!}</span>
</div>-->
<div class="layui-form-item" style="margin-left: 10px;">
<@shiro.hasPermission name="deleteImpower">
    <button onclick="delAll()" class="layui-btn layui-btn-normal">删除</button>
</@shiro.hasPermission>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            分销商
        </th>
        <th>
            授权产品(ID)
        </th>
        <th>
            产品状态
        </th>
        <th>
            授权状态
        </th>
        <th>
            创建时间
        </th>
        <th>
            授权人
        </th>
        <th>
            <span>操作</span>
        </th>
    </tr>
    </thead>
<tbody>
<#list page.records as dto>
<tr>
    <td>
        <input type="checkbox" name="ids" value="${dto.id!}" id="checkboxes" class="checkboxes"/>
    </td>
    <td>
        <span>${dto.distributorName!}</span>(${dto.distributor!})
    </td>
    <td>
    <#--<#list name?keys as key>-->
        <span>${dto.productName!}</span>(${dto.productId!})
    <#--</#list>-->
    </td>
    <td>
    <#--<#list status?keys as key>-->
        <font
            <#if '${dto.productStatus!}'=='上架'>color="green"
            <#else >color="red"</#if>>${dto.productStatus!}</font>
    <#--</#list>-->
    </td>
    <td>
        <#if '${dto.status!}'=='normal'><font color="green">正常</font>
        <#elseif '${dto.status!}'=='disable'><font color="red">禁用</font>
        <#elseif '${dto.status!}'=='apply'><font color="blue">待审核</font>
        </#if>
    </td>
    <td>
    ${(dto.createTime!)?string("yyyy-MM-dd HH:mm:ss")}
    </td>
    <td>
    ${dto.createName!}
    </td>
    <td>
        <@shiro.hasPermission name="updateImpower">
        <#--<a href="/HotelProductImpower/editRate?id=${dto.id!}"><#if '${dto.status!}'=='apply'>[审核]<#else >
            [修改授权]</#if></a>-->
            <input type="button" onclick="location.href='/HotelProductImpower/editRate?id=${dto.id!}';"
                   class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}"
                   <#if dto.status=='apply'>value="审核"<#else>value="修改授权"</#if>/>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="checkImpower">
        <#--<a href="/HotelProductImpower/getRate?productId=${dto.id!}">[授权详情]</a>-->
            <input type="button" onclick="location.href='/HotelProductImpower/getRate?productId=${dto.id!}';"
                   class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" value="授权详情"/>
        </@shiro.hasPermission>
    <#--<a href="imgList?hid=${dto.id}">[图片预览]</a>-->
    <#--<a href="edit?id=${dto.id!}">[编辑]</a>-->
    <#--<a onclick="del('${dto.id!?c}');">[删除]</a>-->

    </td>
</tr>
</tbody>
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
                url: '/HotelProductImpower/deleteAll',
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