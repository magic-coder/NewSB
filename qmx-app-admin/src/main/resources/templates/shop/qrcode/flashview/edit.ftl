<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            form.verify({
                serial:[/^\d+$/,"请填写正确序号！"]
            });

            //验证图片上传
            form.verify({
                imgurl: function (value, item) {
                    if (value == null || value == undefined || value == '') {
                        return '请上传轮播图';
                    }
                }
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
        });
    </script>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>编辑轮播图</legend>
    </fieldset>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">名称</label>
            <div class="layui-input-inline">
                <input name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.name!}">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">图片</label>
            <div class="layui-input-block">
                <input type="hidden" name="imgurl" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.imgurl!}">
                <img src="${dto.imgurl!}" class="imageStyleImg" alt="" height="150" width="300" style="border: solid"/>
                <button type="button" class="layui-btn test1">
                    <i class="layui-icon">&#xe67c;</i>上传图片
                </button>
                <li style="color: red">(请上传300px*150px大小的图片)</li>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline" style="width: auto">
            <label class="layui-form-label">调转链接</label>
            <div class="layui-input-inline">
                <input name="link" autocomplete="off" class="layui-input" value="<#if dto.link??>${dto.link!}</#if>">
            </div>
            <span style="color: red">链接格式:http://www.baidu.com</span>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">排序</label>
            <div class="layui-input-inline">
                <input name="serial" lay-verify="serial" autocomplete="off" class="layui-input"
                       value="${dto.serial!}">
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
</body>
</html>