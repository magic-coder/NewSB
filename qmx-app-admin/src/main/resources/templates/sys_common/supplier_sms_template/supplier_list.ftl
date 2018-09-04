<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        layui.use(['form','laydate'], function(){
            var form = layui.form;
            var pindex = parent.layer.getFrameIndex(window.name); //获取窗口索引
            $(document).on("click","tbody tr",function(){
                var ids = $(this).find("input[name='ids']");
                //ids.attr("checked","checked");
                //alert(ids.val());
                parent.$('input[name=memberId]').val(ids.val());
                parent.$('#suppliername').val($(this).attr('account'));
                //pindex.layer.xx(ids.val());
                parent.layer.close(pindex);
            });
        });
    </script>
</head>
<body>
<form id="listForm" class="layui-form" action="supplierList" method="post" style="margin-top: 10px;">
    <div class="layui-form-item" style="padding-left: 20px;">
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input class="layui-input" name="username" value="${(userQueryVo.username)!}" placeholder="用户名"/>
            </div>
            <div class="layui-input-inline">
                <input class="layui-input" name="account" value="${(userQueryVo.account)!}" placeholder="登录账号"/>
            </div>
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
            </div>
        </div>
    </div>
</form>
<table id="listTable" class="layui-table">
    <thead>
    <tr>
        <th class="check">
            序号
        </th>
        <th>账号</th>
        <th>名称</th>
        <th>是否启用</th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr account="${dto.username!'-'}">
        <td>
            <input type="hidden" name="ids" value="${dto.id!}"/>
            ${(dto_index+1)!}
        </td>
        <td>
        ${dto.account!'-'}
        </td>
        <td>
        ${dto.username!'-'}
        </td>
        <td>
            ${dto.enable?string("是", "否")}
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>