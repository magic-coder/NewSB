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

        });
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        //关联分销商
        $(document).on("click", "#btn", function () {
            $.ajax({
                url: 'executeReturn',
                type: 'GET',
                data: {'date': '${date}', 'memberId': '${memberId!}'},
                dataType: 'json',
                success: function (data) {
                    if (data == 'success') {
                        layer.msg(data.msg);
                        parent.layer.close(index);
                    } else {
                        layer.msg(data.msg);
                    }
                }
            })
        });

    </script>
</head>
<body>

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>量返信息</legend>
</fieldset>
<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label">金额总数</label>
        <div class="layui-form-mid">${moneySum!}</div>
    </div>
</div>
<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label">数量总数</label>
        <div class="layui-form-mid">${amountSum!}</div>
    </div>
</div>
<div class="layui-form-item">
    <div class="layui-input-block">
        <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" id="btn"
               value="确认"/>
        <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
    </div>
</div>
</body>
</html>