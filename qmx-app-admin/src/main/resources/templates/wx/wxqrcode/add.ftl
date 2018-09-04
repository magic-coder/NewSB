<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>添加二维码</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" id="inputForm" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">二维码类型</label>
            <div class="layui-input-inline">
                <select id="type" name="actionName" lay-filter="aihao" lay-verify="required">
                <#list QrcodeType as type>
                    <option value="${type}">${type.title}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">设置场景值</label>
            <div class="layui-input-inline">
                <input id="scene" name="sceneStr" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" onclick="return submitform();">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
	</form>
    <script type="text/javascript">
        function submitform(){
            var type = $("#type").val();
            if($("#scene").val()==""){
                return;
            }
            if(type=="QR_LIMIT_STR_SCENE"||type=="QR_LIMIT_SCENE"){
                $("#scene").attr("name","sceneStr");
            }else if(type=="QR_SCENE"||type=="QR_STR_SCENE"){
                $("#scene").attr("name","sceneId");
                if(isNaN($("#scene").val())){
                    alert("临时二维码场景值必须为数字");
                    return;
                }
            }
            $("#inputForm").submit();
        }
    </script>
    <script>
        var Script = function () {
            $("#inputForm").validate({
                rules: {
                    actionName: "required",
                    sceneId: "required",
                    sceneStr: "required",
                },
                messages: {
                    actionName: "必须选择一个",
                    sceneId: "必填项",
                    sceneStr: "必填项",
                }
            });
        }();
    </script>
</body>
</html>