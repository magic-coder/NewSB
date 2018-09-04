<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>订单-支付</title>
<#include "/include/common_header_include.ftl">
    <script>
        var queryInterVal;
        layui.use(['form', 'laydate'], function () {
            var form = layui.form, laydate = layui.laydate;
            var pindex = parent.layer.getFrameIndex(window.name); //获取窗口索引
            var orderId = '${(payOrder.id)!}';
            //查询支付状态
            queryInterVal = setInterval(function () {
                queryPayStatus(orderId, pindex);
            }, 5000);
        });

        function queryPayStatus(payOrderId, pindex) {
            $.ajax({
                url: 'queryRechargeStatus?orderId=${(payOrder.id)!}&type=${type!}&id=${id!}',
                type: 'POST', //GET
                //async:true,    //或false,是否异步
                //data:reqData,
                //timeout:5000,    //超时时间
                dataType: 'json',    //返回的数据格式：json/xml/html/script/jsonp/text
                success: function (resp) {
                    if (resp) {
                        if (resp == true) {
                            window.clearInterval(queryInterVal);
                            layer.open({
                                type: 1
                                , content: '<div style="padding: 20px 80px;">支付成功</div>'
                                , btn: '关闭'
                                , btnAlign: 'c' //按钮居中
                                , yes: function () {
                                    parent.layer.close(pindex);
                                    setTimeout(function () {
                                        location.reload(true);
                                    }, 500);
                                }
                            });
                        }
                    }
                },
                error: function (xhr, textStatus) {
                    layer.alert(xhr.responseText, {
                        title: '提示'
                    });
                },
                complete: function () {
                    layer.close(index);
                }
            });
        }
    </script>
</head>
<body>
<#--<fieldset class="layui-elem-field" style="margin-left: 20px;margin-right: 20px;margin-top: 30px;">
    <legend>${payOrder.payPlat.getName()!}</legend>
    <div class="layui-field-box">
        <form class="layui-form" action="" style="margin-top: 20px;">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">支付金额:</label>
                    <label class="layui-form-label">￥${payOrder.amount!}</label>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">&nbsp;</label>
                    <div class="layui-input-inline">
                        <img src="${codeUrl!}" alt="" title="${payOrder.payPlat.getName()!}"/>
                    </div>
                </div>
            </div>
        </form>
    </div>
</fieldset>-->
<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label">支付成功</label>
    </div>
</div>
</body>
</html>