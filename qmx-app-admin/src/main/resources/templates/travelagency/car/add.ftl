<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate', 'upload'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var upload = layui.upload;
            laydate.render({
                elem: '#validity'
            });

            form.verify({
                distributorId: [/[\S]+/, "请选择旅行社"]
            });

            form.verify({
                count: [/^\+?[1-9][0-9]*$/, '请输入正确的载客数!']
            });

            upload.render({
                elem: '#travelCardBtn',
                url: '${base}/file/upload?fileType=image&token=' + getCookie("token"),
                done: function (res) {
                    //如果上传失败
                    if (res.code > 0) {
                        return layer.msg('上传失败');
                    }
                    //上传成功
                    $("#travelCard").val(res.data);
                },
                error: function () {
                    //请求异常回调
                    alert("异常!!!");
                }
            });
        });
        //关联分销商
        $(document).on("click", "#userIdBtn", function () {
            var index = layer.open({
                type: 2,
                title: '关联旅行社',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getUser'
            });
        });
    </script>
</head>
<body>
<form class="layui-form" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
<#if user??>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">关联旅行社</label>
            <div class="layui-input-inline" style="width: auto;">
                <input id="distributorId" name="distributorId" type="hidden" lay-verify="distributorId"
                       autocomplete="off"
                       class="layui-input" value="">
                <div id="distributorName" class="layui-form-mid"></div>
            </div>
            <div class="layui-input-inline">
                <button id="userIdBtn" type="button" class="layui-btn">
                    选择
                </button>
            </div>
        </div>
    </div>
</#if>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">车牌号</label>
            <div class="layui-input-inline">
                <input name="carNumber" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">车品牌</label>
            <div class="layui-input-inline">
                <input name="carBrand" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">车身颜色</label>
            <div class="layui-input-inline">
                <input name="color" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">排单等级</label>
            <div class="layui-input-inline">
                <select name="grade" lay-verify="required">
                    <option value=""></option>
                <#list levels as level>
                    <option value="${level}">${level.title}</option>
                </#list>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">最大载客数</label>
            <div class="layui-input-inline">
                <input name="maxPassenger" lay-verify="required|count" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">所属公司</label>
            <div class="layui-input-inline">
                <input name="company" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">有效期至</label>
            <div class="layui-input-inline">
                <input id="validity" name="validity" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">行驶证</label>
            <div class="layui-input-inline">
                <input id="travelCard" name="travelCard" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-input-inline">
                <button id="travelCardBtn" type="button" class="layui-btn">
                    <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
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
</body>
</html>