<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        //注意：parent 是 JS 自带的全局对象，可用于操作父页面
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        layui.use(['form', 'table', 'laydate', 'jquery'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.$;//重点处

            //提交iframe
            form.on('submit(submit1)', function () {

                var productIds = $("input[name=productId]");
                var ipPrice = $("input[name=ipPrice]");
                var jsonqb = [];
                var $qbtr = "";
                jsonqb.push({
                    // "ppid": $(ppids[i]).val(),
                    "productId": $(productIds).val(),
                    "ipPrice": $(ipPrice).val()
                });
                $qbtr += //'<input name="ppid" value="' + $(ppids).val() + '"/>' +
                        '<input name="ipProductId" value="' + $(productIds).val() + '"/>' +
                        '<input name="ipPrice" value="' + $(ipPrice).val() + '"/>';
                parent.$('#jsonip${productId}').val(JSON.stringify(jsonqb));
                parent.$("#ip${productId}").html($qbtr);
                parent.layer.close(index);
            });

            $(function () {
                var jsonStr = parent.$('#jsonip${productId}').val();
                var json = jQuery.parseJSON(jsonStr);
                for (var i = 0; i < json.length; i++) {
                    $("#ipPrice").val(json[i].ipPrice);
                }
                form.render();
            });
        });

        //关闭iframe
        $(document).on("click", "#closeIframe", function () {
            parent.layer.close(index);
        });
    </script>
</head>
<body>
<hr/>
<form class="layui-form" action="#" method="post">
    <table id="table" class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;">
        <input type="hidden" name="productId" value="${productId!}">
        <div class="layui-form-item">
            &nbsp;
            <div class="layui-inline">
                <div class="layui-form-mid">该增值产品的结算价为:</div>
                <div class="layui-input-inline" style="width:auto;">
                    <input autocomplete="off" lay-verify="number" name="ipPrice" id="ipPrice" class="layui-input"
                           style="width: 50px;">
                </div>
                <div class="layui-form-mid">元</div>
            </div>
        </div>
    </table>
    <div align="center">
        <button class="layui-btn" lay-submit="" lay-filter="submit1">确定</button>
        <input id="closeIframe" type="button" class="layui-btn layui-btn-primary" value="取消"/>
    </div>
</form>
</body>
</html>