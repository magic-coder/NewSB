<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>修改说明</title>
<#include "/include/common_header_include.ftl">
    <script type="application/javascript">
        layui.use(['form', 'table', 'laydate'], function () {{
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>


<#--<script>-->
<#--layui.config({-->
<#--base: '${base}/resources/common/js/' //你存放新模块的目录，注意，不是layui的模块目录-->
<#--}).use('picker'); //加载入口-->
<#--layui.use(['picker', 'form'], function () {-->
<#--var picker = layui.picker, form = layui.form;-->

<#--//demo2-->
<#--var areaDiv = new picker();-->
<#--areaDiv.set({-->
<#--elem: '#areaDiv',-->
<#--data: Areas,-->
<#--canSearch: true-->
<#--}).render();-->
<#--});-->
<#--</script>-->
<#-- <script>
     $(function () {
         alert("ada");
         var $details = $("#details");
         $details.html("adasdasd")
     })
 </script>-->
</head>
<body>
<form class="layui-form" action="editorupdate" style="margin-top: 10px;" method="post">
    <div class="layui-form-item" style="margin-top: 20px;">
        <div class="layui-inline">
            <label class="layui-form-label">说明名称</label>
            <div class="layui-input-inline">
            <#--<input type="hidden" name="areaId"/>-->
                <input type="text" name="title" lay-verify="required" maxlength="125" autocomplete="off"
                       class="layui-input" style="width: 475px" value="${data.title!}">
            </div>
        </div>
        <br/>
        <div class="layui-inline">
            <label class="layui-form-label">说明编号</label>
            <div class="layui-input-inline">
            <#--<input type="hidden" name="areaId"/>-->
                <input type="text" name="serial" lay-verify="required" maxlength="125"
                       <#--autocomplete="off"--> onkeyup="value=value.replace(/[\W]/g,'')"
                       class="layui-input" style="width: 475px" value="${data.serial!}">
            </div>
        </div>
    </div>
    <input type="hidden" name="id" value="${dto.id}"/>
    <input type="hidden" name="detailsId" value="${dto.detailsId}"/>
    <div class="layui-form-item">
        <label class="layui-form-label">查看角色</label>
        <div class="layui-input-block">
            <input type="hidden" name="type" title="管理员" checked="" value="admin" style="display: none">
        <#if data.supplier??>
            <input type="checkbox" name="type" title="供应商" checked="" value="supplier">
        <#else>
            <input type="checkbox" name="type" title="供应商" value="supplier">
        </#if>

        <#if data.group_supplier??>
            <input type="checkbox" name="type" title="集团供应商" checked="" value="group_supplier">
        <#else>
            <input type="checkbox" name="type" title="集团供应商" value="group_supplier">
        </#if>

        <#if data.distributor??>
            <input type="checkbox" name="type" title="分销商" checked="" value="distributor">
        <#else>
            <input type="checkbox" name="type" title="分销商" value="distributor">
        </#if>
        <#if data.distributor2??>
            <input type="checkbox" name="type" title="二级分销商" checked="" value="distributor2">
        <#else>
            <input type="checkbox" name="type" title="二级分销商" value="distributor2">
        </#if>
        <#if data.employee??>
            <input type="checkbox" name="type" title="员工" checked="" value="employee">
        <#else>
            <input type="checkbox" name="type" title="员工" value="employee">
        </#if>
        <#--<#if data.travelagency??>-->
        <#--<input type="checkbox" name="type" title="旅行社" checked="" value="travelagency">-->
        <#--<#else>-->
        <#--<input type="checkbox" name="type" title="旅行社" value="travelagency">-->
        <#--</#if>-->

        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">描述</label>  <#--data.details!-->
            <div class="layui-input-inline">
                <textarea id="details" name="details" class="editor" lay-verify="required"
                          style=" height: 600px; width: 950px">${data.helpDetails.details!}</textarea>
            </div>
        </div>
    </div>


<#--<script>-->
<#--KindEditor.ready(function(K) {-->
<#--window.editor = K.create('#editor_id');-->
<#--});-->
<#--</script>-->

    <div class="layui-form-item">
        <div class="layui-input-block" style="margin-top: 10px;">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitUpdate">提交</button>
                <button type="reset" class="layui-btn layui-btn-primary " onclick="javascript:history.back(-1)">返回
                </button>
            </div>
        </div>
    </div>
</form>
<script type="text/javascript" src="${base}/resources/common/js/area-data.js"></script>
<script type="text/javascript" src="${base}/resources/common/js/picker.js"></script>
<script type="text/javascript" src="${base}/resources/admin/editor/kindeditor.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/openMap.js"></script>
</body>
</html>
<#--&nbsp;&nbsp;<button class="layui-btn layui-btn-primary layui-btn-sm" onclick="javascript:history.back(-1)">返  回</button><br>-->
<#--${data.details!}-->
