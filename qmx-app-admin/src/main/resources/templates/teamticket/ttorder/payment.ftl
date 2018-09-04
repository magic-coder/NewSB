<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>订单-支付</title>
</head>
<body>
<form class="layui-form" action="payorder" method="post">
    <hr>
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <div class="layui-form-item">
        <label class="layui-form-label">支付方式</label>
        <div class="layui-input-inline">
            <select id="paytype" lay-filter="paytype" name="paytype">
                <option value="xianshang">在线支付</option>
                <option value="xianxia">线下支付</option>
            </select>
        </div>
    </div>
    <div class="layui-form-item xianshang">
        <label class="layui-form-label">支付类型</label>
        <div class="layui-input-inline">
            <select name="payChannelNo">
            <#list paytypes as paytype>
                <option value="${paytype.channelNo!}">${paytype.payPlat.getName()!}</option>
            </#list>
            </select>
        </div>
    </div>
    <div class="layui-form-item layui-form-text xianxia" style="display: none;">
        <label class="layui-form-label">备注</label>
        <div class="layui-input-block">
            <textarea id="remark" name="remark" placeholder="备注" class="layui-textarea"></textarea>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">下一步</button>
        </div>
    </div>
</form>
</body>

<#include "/include/common_header_include.ftl">
<script>
    layui.use(['jquery', 'form', 'table', 'laydate'], function () {
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引

        var $ = layui.$;
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;

        form.on('select(paytype)', function (data) {
            var type = data.value;
            if (type == "xianxia") {
                $(".xianxia").show();
                $(".xianshang").hide();
                $("#remark").attr("lay-verify", "required");
            } else {
                $(".xianxia").hide();
                $(".xianshang").show();
                $("#remark").attr("lay-verify", "");
            }
        });

        $(function () {
            var type = $("#paytype").val();
            if (type == "xianxia") {
                $(".xianxia").show();
                $(".xianshang").hide();
                $("#remark").attr("lay-verify", "required");
            } else {
                $(".xianxia").hide();
                $(".xianshang").show();
                $("#remark").attr("lay-verify", "");
            }
        });

        form.on('submit(submit)', function (data) {
            if ("xianxia" == data.field.paytype) {
                parent.layer.close(index);
                //parent.location.reload();
                setTimeout(function () {
                    location.reload(true);
                }, 500);
            } else {

            }
        });

    });
</script>
</html>