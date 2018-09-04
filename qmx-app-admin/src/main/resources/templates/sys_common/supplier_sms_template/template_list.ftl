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
            $(document).on("click","#selectSmsTemplate",function(){
                var ids = $("#listTable").find("input[name='ids']:checked");
                //ids.attr("checked","checked");
                //alert(ids.val());
                var idArray = new Array();
                var nameArray = new Array();
                ids.each(function () {
                    idArray.push($(this).val());
                    nameArray.push($(this).attr('tName'));
                })
                parent.$('input[name=templateIds]').val(idArray);
                parent.$('#templateNameId').val(nameArray);
                //pindex.layer.xx(ids.val());
                parent.layer.close(pindex);
            });
        });
    </script>
</head>
<body>
<form id="listForm" class="layui-form" action="templateList" method="post" style="margin-top: 10px;">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">模板名称</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="name" value="${queryDto.name!}" placeholder="模板名称"/>
            </div>
            <div class="layui-input-inline" style="width: 128px;">
                <select name="accountChargeType" lay-verify="required">
                <#list smsPlatTypes as act>
                    <option <#if queryDto.smsPlatType?? && queryDto.smsPlatType == act>selected</#if> value="${act!}">${act.getName()!}</option>
                </#list>
                </select>
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
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="title">模板名称</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="type">模板类型</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="smsPlatType">短信平台</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="signName">模板签名</a>
        </th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as warehouse>
    <tr>
        <td>
            <input type="checkbox" name="ids" tName="${warehouse.name!}" value="${warehouse.id}"/>
        </td>
        <td>
            <span title="${warehouse.content!}">${warehouse.name!}</span>
        </td>
        <td>
        ${warehouse.templateType.getName()!}
        </td>
        <td>
            <#if warehouse.smsPlatType??>
                ${warehouse.smsPlatType.getName()!}
            <#else>
                -
            </#if>

        </td>
        <td>
        ${warehouse.signName}
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
<div class="layui-footer">
<!-- 底部固定区域 -->
    <div class="layui-form-item" align="center">
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button id="selectSmsTemplate" class="layui-btn layui-btn-normal layui-btn-lg">确定</button>
            </div>
        </div>
    </div>
</div>

</html>