<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/resources/common/js/area-data.js"></script>
    <script type="text/javascript" src="${base}/resources/common/js/picker.js"></script>
    <script>
        layui.config({
            base: '${base}/resources/common/js/' //你存放新模块的目录，注意，不是layui的模块目录
        }).use('picker'); //加载入口
        layui.use(['picker','form'], function() {
            var picker = layui.picker,form=layui.form;

            //demo2
            var areaDiv = new picker();
            areaDiv.set({
                elem: '#areaDiv',
                data: Areas,
                canSearch: true
            }).render();

            //监听提交
            /*form.on('submit(submitUpdate)', function(data){
                var reqData = data.field;
                layer.alert(JSON.stringify(reqData), {
                    title: '最终的提交信息'
                });
                return false;
            });*/
        });
    </script>
</head>
<body>
<form class="layui-form" action="save" style="margin-top: 10px;" method="post">
    <div class="layui-form-item" style="margin-top: 20px;">
        <div class="layui-inline">
            <label class="layui-form-label">登录账号</label>
            <div class="layui-input-inline">
                <input type="hidden" name="enable" value="true"/>
                <input type="hidden" name="areaId"/>
                <input type="text" name="account" lay-verify="required" maxlength="20" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">登录密码</label>
            <div class="layui-input-inline">
                <input type="password" name="password" lay-verify="required" maxlength="20" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-inline">
                <input type="text"name="username" maxlength="20" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">手机</label>
            <div class="layui-input-inline">
                <input type="text" name="phone" lay-verify="phone" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <div id="areaDiv"></div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block" style="margin-top: 10px;">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitUpdate">提交</button>
            </div>
        </div>
    </div>
</form>

</body>
</html>