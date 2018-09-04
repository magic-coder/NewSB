<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>添加模板消息</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            form.on('select(typeclick)', function (data) {
                var type = data.value;
                if ("activity" == type) {
                    $("#tips").html("#**#中的内容会被替换掉(#中奖时间#,#微信昵称#,#劵号#,#奖品#)");
                } else if ("fahuo" == type) {
                    $("#tips").html("#**#中的内容会被替换掉（#客户姓名#,#订单号#,#微信昵称#,#下单时间#,#预约时间#,#产品名称#,#票号#,#数量#,#客服电话#,#数量#,#金额#）");
                } else if ("agent1" == type) {
                    $("#tips").html("#**#中的内容会被替换掉（#一级代理昵称#）");
                } else if ("agent2" == type) {
                    $("#tips").html("#**#中的内容会被替换掉（#一级代理昵称#,#二级代理昵称#）");
                } else if ("commissio1" == type) {
                    $("#tips").html("#**#中的内容会被替换掉（#返佣人昵称#,#被返佣人昵称#,#返佣金额#）");
                } else if ("commissio2" == type) {
                    $("#tips").html("#**#中的内容会被替换掉（#返佣人昵称#,#被返佣人昵称#,#被返佣人的上级昵称#,#返佣金额#）");
                } else if ("kf_online" == type) {
                    $("#tips").html("");
                } else if ("coupon_num" == type) {
                    $("#tips").html("#**#中的内容会被替换掉（#名称#,#兑换码#,#金额#,#有效时间#）");
                }
            });
            form.on('input(enableclick)', function (data) {

                var type = data.value;
                if (type == "true") {
                    $("#templateid").show();
                } else {
                    $("#templateid").hide();
                }
            });
        });
    </script>
    <style type="text/css">
        .layui-form-label {
            width: auto;
        }
    </style>
</head>
<body>
<form class="layui-form" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">使用场景:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <select id="type" lay-filter="typeclick" name="type">
                <#list types as type>
                    <option value="${type}">${type.title}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">状态:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <label><input type="radio" name="state" value="1" title="是" checked/></label>
                <label><input type="radio" name="state" value="0" title="否"/></label>
            </div>
            <label class="layui-form-label" style="width: 120px;">是否使用微信模板:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <label><input type="radio" name="enable" lay-filter="enableclick" value="1" title="是"/></label>
                <label><input type="radio" name="enable" lay-filter="enableclick" value="0" title="否" checked/></label>
                <font style="color: red;">如果要使用微信模板，需在微信后台开通模板消息，并获取模板ID</font>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">微信模板ID:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input id="templateid" name="templateId" style="display: inline;width: 190px;" lay-verify="required"
                       autocomplete="off"
                       class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 120px;">模板消息内容:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <textarea id="content" class="layui-textarea" name="content" style="display: inline;"></textarea>
                <p style="border-top:none;">
                    <span id="tips" class="tips"></span>
                </p>
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
    var Script = function () {
        $("#inputForm").validate({
            rules: {
                type: "required",
                state: "required",
                enable: "required",
                templateId: "required",
//                    content: "required",
            },
            messages: {
                type: "必须选择一个",
                state: "必填项",
                enable: "必填项",
                templateId: "必填项",
//                    content:"必填项",
            }
        });
    }();
</script>
</body>
</html>