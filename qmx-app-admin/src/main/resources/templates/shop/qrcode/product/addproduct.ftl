<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/resources/admin/editor/kindeditor.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/openMap.js"></script>
    <script>
        layui.use(['form', 'table', 'laydate', 'jquery'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.jquery;

            form.verify({
                outId: [/[\S]+/, "请选择产品"],
                imgurl: [/[\S]+/, "请上传图片"],
                dayMaxStock: [/^\d+$/, "请填写正确的日库存！"],
                maxStock: [/^\d+$/, "请填写正确的最大库存！"],
                serial: [/^\d+$/, "请填写正确的序号！"],
                salePrice: [/(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^[0-9]\.[0-9]([0-9])?$)/, "请填写正确的售卖价！"]
            });
        });

    </script>
</head>
<body>
<form class="layui-form" action="save" method="post">
    <!--分组id-->
    <input name="groupId" value="${groupId!}" id="groupId" type="hidden"/>
    <!--产品id-->
    <input type="hidden" id="outId" name="outId" lay-verify="outId" value=""/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">选择产品</label>
        <div class="layui-input-inline">
            <input type="text" id="outName" name="outName" class="layui-input" value="" readonly="readonly"/>
        </div>
        <div class="layui-input-inline">
            <input id="addProduct" type="button" class="layui-btn" value="选择产品">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">二维码名称</label>
        <div class="layui-input-inline">
            <input name="name" class="layui-input" lay-verify="required"/>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 700px;">
            <label class="layui-form-label" style="width: 150px;">产品图片</label>
            <div class="layui-input-block">
                <input type="hidden" name="imgurl" lay-verify="imgurl" autocomplete="off" class="layui-input">
                <img class="imageStyleImg" alt="" height="120" width="120" style="border: solid"/>
                <button type="button" class="layui-btn test1">
                    <i class="layui-icon">&#xe67c;</i>上传图片
                    <li style="color: red;">(请上传1:1比例且小于1M的图片)</li>
                </button>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">二维码售价</label>
        <div class="layui-input-inline">
            <input name="salePrice" id="salePrice" class="layui-input" lay-verify="salePrice"/>
        </div>
        <label class="layui-form-label" style="width: 150px;">序号</label>
        <div class="layui-input-inline">
            <input name="serial" class="layui-input" lay-verify="serial"/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">日库存</label>
        <div class="layui-input-inline">
            <input name="dayMaxStock" class="layui-input" value="" lay-verify="dayMaxStock"/>
        </div>
        <label class="layui-form-label" style="width: 150px;">总库存</label>
        <div class="layui-input-inline">
            <input name="maxStock" class="layui-input" value="" lay-verify="maxStock"/>
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">描述</label>
        <div class="layui-input-block">
            <textarea name="description" class="editor"></textarea>
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
    //选择产品
    $(document).on("click", "#addProduct", function () {
        var groupId = $("#groupId").val();
        var index = layer.open({
            type: 2,
            title: '选择产品',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: '/qrcode/product/getProducts?groupId=' + groupId
        });
    });
    $().ready(function () {
        jQuery("button.test1").each(function () {
            var $this = $(this);
            uploadCompletes1($this);
        });
        jQuery("button.test2").each(function () {
            var $this = $(this);
            uploadCompletes2($this);
        });
    });
    function uploadCompletes1($this) {
        layui.use('upload', function () {
            var upload = layui.upload;
            //执行实例
            upload.render({
                elem: $this //绑定元素
                , url: '${base}/file/upload?fileType=image&token=' + getCookie("token") //上传接口
                , done: function (res) {
                    //如果上传失败
                    if (res.code > 0) {
                        return layer.msg('上传失败');
                    }
                    //上传成功
                    ($this).prev().attr("src", res.data);
                    ($this).parent().find("input[name='imgurl']").val(res.data);
                }
                , error: function () {
                    //请求异常回调
                    alert("异常!!!");
                }
            });
        });
    }
</script>
</body>
</html>