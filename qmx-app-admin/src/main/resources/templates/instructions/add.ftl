<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>添加说明</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/resources/common/js/area-data.js"></script>
    <script type="text/javascript" src="${base}/resources/common/js/picker.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/editor/kindeditor.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/openMap.js"></script>
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
</head>
<body>
<form class="layui-form" action="save" style="margin-top: 10px;" method="post">
    <div class="layui-form-item" style="margin-top: 20px;">
        <div class="layui-inline">
            <label class="layui-form-label">说明名称</label>
            <div class="layui-input-inline">
            <#--<input type="hidden" name="areaId"/>-->
                <input type="text" name="title" placeholder="请输入说明标题" lay-verify="required" maxlength="125"
                       autocomplete="off" class="layui-input" style="width: 475px"
                >
            </div>
        </div>
        <br/>
        <div class="layui-inline">
            <label class="layui-form-label">说明编号</label>
            <div class="layui-input-inline">
            <#--<input type="hidden" name="areaId"/>-->
                <input type="text" name="serial" placeholder="请输入说明标号" lay-verify="required" maxlength="125"
                       <#--autocomplete="off"-->  onkeyup="value=value.replace(/[\W]/g,'')"
                       class="layui-input" style="width: 475px">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label">查看角色</label>
        <div class="layui-input-block">
            <input type="hidden" name="type" title="管理员" checked="" value="admin" style="display: none">
            <input type="checkbox" name="type" value="supplier" title="供应商">
            <input type="checkbox" name="type" value="group_supplier" title="集团供应商" <#--checked=""-->>
            <input type="checkbox" name="type" value="distributor" title="分销商">
            <input type="checkbox" name="type" value="distributor2" title="二级分销商">
            <input type="checkbox" name="type" value="employee" title="员工">
        <#--<input type="checkbox" name="type" value="travelagency" title="旅行社">-->
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">描述</label>
            <div class="layui-input-inline">
                <textarea name="details" class="editor" lay-verify="required"
                          style=" height: 600px; width: 950px"></textarea>
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

</body>
</html>
<#--&nbsp;&nbsp;<button class="layui-btn layui-btn-primary layui-btn-sm" onclick="javascript:history.back(-1)">返  回</button><br>-->
<#--${data.details!}-->
