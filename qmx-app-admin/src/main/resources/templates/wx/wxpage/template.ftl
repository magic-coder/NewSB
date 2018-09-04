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
                    <li class="pad_5 picth">
                        <center>自定义</center>
                        <img src="${base}/resources/module/wx/images/agent.jpg" />
                        <p class="center">
                            <input onclick="location.href='add?template=custom';" type="button" class="layui-btn layui-btn-primary" value="新增"/>
                            <#--<input onclick="location.href='#';" type="button" class="layui-btn layui-btn-primary" value="预览"/>-->
                        </p>
                    </li>
                    <li class="pad_5 picth">
                        <center>精彩瞬间</center>
                        <img src="${base}/resources/module/wx/images/picture.jpg" />
                        <p class="center">
                            <input onclick="location.href='add?template=picture';" type="button" class="layui-btn layui-btn-primary" value="新增"/>
                            <#--<input onclick="location.href='#';" type="button" class="layui-btn layui-btn-primary" value="预览"/>-->
                        </p>
                    </li>
                    <li class="pad_5 picth">
                        <center>图文列表</center>
                        <img src="${base}/resources/module/wx/images/listagent.png" />
                        <p class="center">
                            <input onclick="location.href='add?template=listagent';" type="button" class="layui-btn layui-btn-primary" value="新增"/>
                            <#--<input onclick="location.href='#';" type="button" class="layui-btn layui-btn-primary" value="预览"/>-->
                        </p>
                    </li>
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