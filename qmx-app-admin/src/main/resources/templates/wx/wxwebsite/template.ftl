<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加模块</title>
    <link rel="stylesheet" href="${base}/bak/css/wx/wxSystem.css">
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
        .mwb_add li img {
            width: 150px;
            height: 255px;
            display: block;
        }
    </style>
</head>
<body>
<form class="layui-form" action="" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">选择模板</label>
            <div class="layui-input-inline" style="width: 900px;">
                <ul class="row mwb_add">
                <@shiro.hasPermission name = "wxwebsite:template_one">
                    <li class="pad_5 picth">
                        <img src="${base}/resources/module/wx/images/mwb_add_bg_1.jpg" />
                        <p class="center">
                            <input onclick="location.href='add?template=wxwebsite_one';" type="button" class="layui-btn layui-btn-primary" value="新增"/>
                            <#--<input onclick="location.href='#';" type="button" class="layui-btn layui-btn-primary" value="预览"/>-->
                        </p>
                    </li>
                </@shiro.hasPermission>
                <@shiro.hasPermission name = "wxwebsite:template_two">
                    <li class="pad_5 picth">
                        <img src="${base}/resources/module/wx/images/mwb_add_bg_2.jpg" />
                        <p class="center">
                            <input onclick="location.href='add?template=wxwebsite_two';" type="button" class="layui-btn layui-btn-primary" value="新增"/>
                            <#--<input onclick="location.href='#';" type="button" class="layui-btn layui-btn-primary" value="预览"/>-->
                        </p>
                    </li>
                </@shiro.hasPermission>
                <@shiro.hasPermission name = "wxwebsite:template_three">
                    <li class="pad_5 picth">
                        <img src="${base}/resources/module/wx/images/mwb_add_bg_3.jpg" />
                        <p class="center">
                            <input onclick="location.href='add?template=wxwebsite_three';" type="button" class="layui-btn layui-btn-primary" value="新增"/>
                            <#--<input onclick="location.href='#';" type="button" class="layui-btn layui-btn-primary" value="预览"/>-->
                        </p>
                    </li>
                </@shiro.hasPermission>
                <@shiro.hasPermission name = "wxwebsite:template_four">
                    <li class="pad_5 picth">
                        <img src="${base}/resources/module/wx/images/mwb_add_bg_4.jpg" />
                        <p class="center">
                            <input onclick="location.href='add?template=wxwebsite_four';" type="button" class="layui-btn layui-btn-primary" value="新增"/>
                            <#--<input onclick="location.href='#';" type="button" class="layui-btn layui-btn-primary" value="预览"/>-->
                        </p>
                    </li>
                </@shiro.hasPermission>
                </ul>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline" style="width: 900px;">
                <input onclick="history.back();"style="margin-left: 900px;" type="button" class="layui-btn layui-btn-primary" value="返回"/>
            </div>
        </div>
    </div>
</form>
</body>
</html>
