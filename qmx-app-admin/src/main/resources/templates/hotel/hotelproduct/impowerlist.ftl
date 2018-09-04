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
    <legend>授权产品列表</legend>
</fieldset>
<form action="getImpower" method="get" class="layui-form">
<#--<div class="bar">
    <br/>
    <input type="text" placeholder="产品id" value="${dto.productId!}" name="productId"/>
    <select name="hid">
        <option value="">请选择酒店</option>
    <#list hidMap?keys as key>
        <option value="${key!}"<#if '${key!}'=='${dto.hid!}'>selected</#if>>${hidMap['${key!}']!}</option>
    </#list>
    </select>
    <button type="submit" class="button">查询</button>
    <button type="button" class="button" onclick="location.href='getImpower.jhtml';">重置</button>
    <span style="color:green;">${flash_message_attribute_name!}</span>
</div>-->
    <div class="layui-form-item" style="margin-left: 10px;">
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="productId" value="${dto.productId!}" autocomplete="off"
                       class="layui-input" placeholder="产品id">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <select name="status" class="layui-input">
                    <option value="">请选择酒店</option>
                <#list hidMap?keys as key>
                    <option value="${key!}"<#if '${key!}'=='${dto.hid!}'>selected</#if>>${hidMap['${key!}']!}</option>
                </#list>
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
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            产品名称(id)
        </th>
        <th>
            所属酒店
        </th>
        <th>
            房型(id)
        </th>
        <th>
            状态
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
    </thead>
<tbody>
<#list page.records as dto>
<tr>
    <td>
        <input type="checkbox" name="ids" value="${dto.id}" class="checkboxes"/>
    </td>
    <td>
    ${dto.productName!}(${dto.productId!})
    </td>
    <td>
    ${dto.hidName!}
    </td>
    <td>
    ${dto.ridName!}(${dto.rid!})
    </td>
    <td>
        <#if '${dto.status!}'=='normal'><font color="green">正常</font><#elseif '${dto.status!}'=='disable'><font
                color="red">禁用</font><#else ><font color="blue">待审核</font></#if>
    </td>
    <td>
    ${(dto.createTime!)?string("yyyy-MM-dd HH:mm:ss")}
    </td>
    <td>
    ${dto.createName!}
    </td>
    <td>
    <#--<a href="check?id=${dto.id!}">[查看]</a>-->
        <input type="button" onclick="location.href='check?id=${dto.id!}';"
               class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" value="查看"/>
    </td>
</tr>
</tbody>
</#list>
</table>
<#--引人分页-->
<#include "/include/my_pagination.ftl">
<#--分页结束-->


<script type="text/javascript">
    function del(id, hid) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg) == true) {
            window.location.href = "delete.jhtml?id=" + id + "&hid=" + hid;
        } else {
            return false;
        }
    }

</script>
<script type="text/javascript">
    /*   function delAll() {
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
                   url: '/hotelProduct/deleteAll',
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
       }*/
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