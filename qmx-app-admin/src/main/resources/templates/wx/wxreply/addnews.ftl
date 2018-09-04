<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>自动回复</title>
    <link rel="stylesheet" href="${base}/bak/css/wx/layui.css">
    <script type="text/javascript" src="${base}/resources/module/wx/js/showDialog.js"></script>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
    <script>
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
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" action="save" method="post">
    <input type="hidden" name="msgTypes" value="NEWS"/>
    <input type="hidden" name="id" value="${(dto.id)!}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>图文回复</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">关键字:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="keyvalue" value="${(dto.keyvalue)!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 120px;">图文封面:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="mediaUrl" value="${(dto.mediaUrl)!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input">
                <button type="button" class="layui-btn test1">
                    <i class="layui-icon">&#xe67c;</i>上传图片
                </button>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">图文标题:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="title" value="${(dto.title)!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 120px;">图文描述:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="description" value="${(dto.description)!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">图文跳转链接:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="url" value="${(dto.url)!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 120px;">多图文选择:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input id="mediaId" name="mediaId" value="${(dto.mediaId)!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input">
                <button id="showmaterial" type="button" class="layui-btn">
                    <i class="layui-icon">&#xe67c;</i>选择素材
                </button>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
<script>
    function choiceValue(value) {
        $("input[name=mediaId]").val(value);
    }
    layui.use(['form'], function() {
        var form = layui.form;

        $("#showmaterial").click(function () {
            layer.open({
                title: '选择'
                ,type: 2
                ,area: ['60%', '80%']
                ,content: '../wxMaterial/wxmateriallist?type=NEWS'
            });
        });
    });
</script>
</body>
</html>