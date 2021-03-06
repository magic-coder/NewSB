<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>会员-新增</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/resources/common/js/area.js"></script>
    <script>
        layui.use('upload', function () {
            var $ = layui.jquery
                    , upload = layui.upload;

            //普通图片上传
            var uploadInst = upload.render({
                elem: '#test1'
                , url: '/file/upload2?fileType=image'
                , before: function (obj) {
                    //预读本地文件示例，不支持ie8
                    obj.preview(function (index, file, result) {
                        $('#demo1').attr('src', result); //图片链接（base64）
                        $('#demo1').show();
                    });
                }
                , accept: "images"
                , exts: 'jpg|png'
                , size: 1000
                , acceptMime: 'image/jpg, image/png'
                , done: function (res) {
                    //如果上传失败
                    if (res.code > 0) {
                        return layer.msg('上传失败');
                    }
                    //上传成功
                    $("#fileImage").val(res.url);
                    return layer.msg('上传成功');
                }
                , error: function () {
                    //演示失败状态，并实现重传
                    var demoText = $('#demoText');
                    demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-mini demo-reload">重试</a>');
                    demoText.find('.demo-reload').on('click', function () {
                        uploadInst.upload();
                    });
                }
            });
        });

        //        //会员客户经理
        //        $(document).on("click", "#userIdBtn", function () {
        //            var index = layer.open({
        //                type: 2,
        //                title: '会员客户经理',
        //                area: ['60%', '80%'], //宽高
        //                fix: true, //固定
        //                content: 'adduser'
        //            });
        //        });
        //        layui.use(['form', 'table', 'laydate',], function () {
        //            var table = layui.table;
        //            var laydate = layui.laydate;
        //            var form = layui.form;
        //            loadArea();
        //            form.verify({
        //                sumStock: [/^\d+$/, "！"],
        //                warningStock: [/^\d+$/, "请填写正确的预警库存量！"],
        //                shengfuzheng: [/^d{15}|d{}18$/, "请输入正确的身份证号"]
        //            });
        //            form.render();
        //
        //        });
    </script>
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" id="inputForm" action="update" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>商品信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">商品类别</label>
            <div class="layui-input-inline">
                <select name="exchangeProductType" lay-filter="aihao" lay-verify="required">
                    <option value="">--商品类别--</option>
                <#list productTypes as info>
                    <option value="${info}" <#if dto.exchangeProductType??&&dto.exchangeProductType==info>selected</#if>>${info.title}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">商品名称</label>
            <div class="layui-input-inline">
                <input type="hidden" name="id" value="${dto.id}"/>
                <input name="productName" value="${dto.productName!}" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">商品说明</label>
            <div class="layui-input-inline">
                <input name="text" value="${dto.text!}"  lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">兑换所需积分</label>
            <div class="layui-input-inline">
                <input name="integeral" value="${dto.integeral!}" lay-verify="required|number" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">发货方式</label>
            <div class="layui-input-inline">
                <select name="deliverType" lay-filter="aihao" lay-verify="required">
                    <option value="">--发货方式--</option>
                <#list deliverTypes as info>
                    <option value="${info}" <#if dto.deliverType??&&dto.deliverType==info>selected</#if>>${info.title}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">过期时间</label>
            <div class="layui-input-inline">
                <input id="pastTime" name="expiryTime" value="${dto.expiryTime?datetime!}" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item" style="width: 300px">
            <div class="layui-upload" style="margin-left: 130px">
                <div class="layui-upload-list">
                    <img class="layui-upload-img" id="demo1" src="${dto.image!}" style="width: 120px;">
                    <input type="hidden" name="image" value="${dto.image!}" id="fileImage"/>
                    <p id="demoText"></p>
                </div>
                <button type="button" class="layui-btn" id="test1">上传商品图片</button>
            <#--<button type="button" class="layui-btn" id="test2">上传头像</button>-->
                <div style="color: #46a110">(只支持jpg或png格式)</div>
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
    layui.use('laydate', function () {
        var laydate = layui.laydate;

        //执行一个laydate实例
        laydate.render({
            elem: '#birthday' //指定元素
            , type: 'datetime'
//            ,value: '1980-01-01'
        });
        laydate.render({
            elem: '#pastTime' //指定元素
            , type: 'datetime'
        });
    });
</script>
</body>
</html>