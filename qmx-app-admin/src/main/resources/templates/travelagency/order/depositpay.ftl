<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>订单-支付</title>
<#include "/include/common_header_include.ftl">
</head>
<body>
<form class="layui-form" action="payorder" method="post">

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">账户名称</label>
            <div class="layui-form-mid">${dto.username!}</div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">账户余额</label>
            <div class="layui-form-mid">${dto.userDeposit.depositBalance!}</div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">支付金额</label>
            <div class="layui-form-mid">${amount!}</div>
        </div>
    </div>
</form>
<div class="layui-form-item">
    <div class="layui-input-block">
        <button class="layui-btn layui-btn-normal" id="btn">确认</button>
    </div>
</div>
<script>
    layui.use(['form', 'table', 'laydate', 'jquery'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
        var $ = layui.jquery;
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引

        $(document).on("click", "#btn", function () {
            $.ajax({
                url: "depositPay",
                type: "GET",
                data: {id: '${order.id!}', amount: '${amount!}', type: '${type!}'},
                success: function (result) {
                    if (result.state == 'success') {
                        layer.msg(result.msg, {
                            time: 1000 //1秒关闭（如果不配置，默认是3秒）
                        }, function () {
                            parent.layer.close(index);
                            window.parent.location.reload(true);
                        });
                        /* parent.layer.close(index);
                         setTimeout(function () {
                             location.reload(true);
                         }, 500);*/
                    } else {
                        layer.msg(result.msg);
                        //parent.layer.close(index);
                    }
                }
            });
        });

        form.render();
    });
</script>
</body>

</html>