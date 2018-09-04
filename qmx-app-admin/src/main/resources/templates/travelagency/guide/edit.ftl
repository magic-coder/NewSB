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


            form.on('select(type)', function (data) {
                var type = data.value;
                if (type == 'guide') {
                    $("#guide").show();
                    //$("#guideNumber").attr("lay-verify", "required");
                }
                if (type == 'lead') {
                    $("#guide").hide();
                    $("#guideNumber").attr("lay-verify", "");
                }
            });
            upload.render({
                elem: '#guideCardBtn',
                url: '${base}/file/upload?fileType=image&token=' + getCookie("token"),
                done: function (res) {
                    //如果上传失败
                    if (res.code > 0) {
                        return layer.msg('上传失败');
                    }
                    //上传成功
                    $("#guideCard").val(res.data);
                },
                error: function () {
                    //请求异常回调
                    alert("异常!!!");
                }
            });
            upload.render({
                elem: '#idCardBtn',
                url: '${base}/file/upload?fileType=image&token=' + getCookie("token"),
                done: function (res) {
                    //如果上传失败
                    if (res.code > 0) {
                        return layer.msg('上传失败');
                    }
                    //上传成功
                    $("#idCard").val(res.data);
                },
                error: function () {
                    //请求异常回调
                    alert("异常!!!");
                }
            });
        });
    </script>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">类型</label>
            <div class="layui-input-inline">
                <select name="type" lay-verify="required" lay-filter="type">
                    <option value=""></option>
                <#list types as type>
                    <option value="${type}" <#if type==dto.type>selected</#if>>${type.title}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">姓名</label>
            <div class="layui-input-inline">
                <input name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.name!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">手机号码</label>
            <div class="layui-input-inline">
                <input name="mobile" lay-verify="required|phone" autocomplete="off" class="layui-input"
                       value="${dto.mobile!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">性别</label>
            <div class="layui-input-inline">
                <select name="gender" lay-verify="required">
                    <option value=""></option>
                <#list genders as gender>
                    <option value="${gender}" <#if gender==dto.gender>selected</#if>>${gender.title!}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">身份证</label>
            <div class="layui-input-inline">
                <input id="idCard" name="idCard" autocomplete="off" class="layui-input"
                       value="${dto.idCard!}">
            </div>
            <div class="layui-input-inline">
                <button id="idCardBtn" type="button" class="layui-btn">
                    <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
                </button>
            </div>
        </div>
    </div>


    <div class="layui-form-item" <#if '${dto.type!}'=='lead'>style="display: none"</#if> id="guide">
        <div class="layui-inline">
            <label class="layui-form-label">导游证号码</label>
            <div class="layui-input-inline">
                <input name="guideNumber" id="guideNumber"
                       autocomplete="off"
                       class="layui-input"
                       value="${dto.guideNumber!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">导游证</label>
            <div class="layui-input-inline">
                <input id="guideCard" name="guideCard" autocomplete="off" class="layui-input"
                       value="${dto.guideCard!}">
            </div>
            <div class="layui-input-inline">
                <button id="guideCardBtn" type="button" class="layui-btn">
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