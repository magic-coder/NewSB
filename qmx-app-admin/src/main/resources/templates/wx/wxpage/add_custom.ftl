<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加模块</title>
    <link rel="stylesheet" href="${base}/bak/css/wx/wxSystem.css">
    <script type="text/javascript" src="${base}/resources/module/wx/js/operate.js"></script>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        var layedit;
        var index;
        var form;
        layui.use(['layedit','form'], function(){
            layedit = layui.layedit;
            layedit.set({
                uploadImage: {
                    url: '${base}/file/upload?fileType=image&token='+getCookie("token") //接口url
                    ,type: 'post' //默认post
                }
            });
            index = layedit.build('demo'); //建立编辑器
            form = layui.form;
            form.on('submit(submit)', function(data){
                $("#content").val(layedit.getContent(index));
                console.log(data.elem); //被执行事件的元素DOM对象，一般为button对象
                console.log(data.form); //被执行提交的form对象，一般在存在form标签时才会返回
                console.log(data.field); //当前容器的全部表单字段，名值对形式：{name: value}
                //return false;
            });
        });
        $().ready(function() {
            jQuery("button.test1").each(function() {
                var $this = $(this);
                uploadCompletes1($this);
            });
        });
        function uploadCompletes1($this) {
            layui.use('upload', function(){
                var upload = layui.upload;
                //执行实例
                upload.render({
                    elem: $this //绑定元素
                    ,url: '${base}/file/upload?fileType=image&token='+getCookie("token") //上传接口
                    ,done: function(res){
                        //如果上传失败
                        if(res.code > 0){
                            return layer.msg('上传失败');
                        }
                        //上传成功
                        ($this). prev().val(res.data);
                    }
                    ,error: function(){
                        //请求异常回调
                        alert("异常!!!");
                    }
                });
            });
        }

    </script>
</head>
<body class="magenta microWebsiteSetup">
<form class="layui-form" id="inputForm" action="save" method="post">
    <input name="id" type="hidden" value="${(dto.id)!}"/>
    <input name="template" type="hidden" value="${(template)!}"/>
    <input name="token" type="hidden" value="${(token)!}" />
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">页面标题:</label>
            <div class="layui-input-inline">
                <input id="title" name="title" value="${(dto.title)!}" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 120px;">图片列表:</label>
            <div class="layui-input-inline" style="width: 50%;">
                <input id="buy_bg" name="buy_bg_" value="${(params.buy_bg)!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input">
                <button type="button" class="layui-btn test1">
                    <i class="layui-icon">&#xe67c;</i>上传图片
                </button>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">说明内容:</label>
            <div class="layui-input-inline" style="width: 80%;">
                <textarea id="demo"  style="display: none;">${(params.content)!}</textarea>
                <input id="content" name="content_" type="hidden" value="${(params.content)!}"/>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
</body>
</html>