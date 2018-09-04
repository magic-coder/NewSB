<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>退款审核</title>
    <#include "/include/common_header_include.ftl">
    <style type="text/css">
        .layui-form-label2 {
            float: left;
            display: block;
            padding: 9px 0px;
            font-weight: 400;
            line-height: 20px;
            text-align: left;
        }
        .layui-form-item2 {
            clear: both;
        }
    </style>
    <script>
        layui.use(['form'], function () {
            var form = layui.form;
            var pindex = parent.layer.getFrameIndex(window.name); //获取窗口索引
            form.verify({
                quantity: function (value, item) { //value：表单的值、item：表单的DOM对象
                    if (!new RegExp("^[0-9]*$").test(value)) {
                        return '退款数量有误';
                    }
                }
            });
            //监听提交
            form.on('submit(submitRefund)', function (data) {
                var index = layer.load(2, {time: 6 * 1000}); //设定最长等待10秒
                var reqData = data.field;
                $.ajax({
                    url: 'doAuditRefund',
                    type: 'POST', //GET
                    //async:true,    //或false,是否异步
                    data: reqData,
                    //timeout:5000,    //超时时间
                    dataType: 'json',    //返回的数据格式：json/xml/html/script/jsonp/text
                    success: function (resp) {
                        if (resp) {
                            if (resp.errorCode == 0) {
                                layer.open({
                                    type: 1
                                    , content: '<div style="padding: 20px 80px;">审核成功</div>'
                                    , btn: '关闭'
                                    , btnAlign: 'c' //按钮居中
                                    , yes: function () {
                                        parent.layer.close(pindex);
                                        location.href = "orderList";
                                    }
                                });

                            } else {
                                layer.alert(resp.errorMsg, {
                                    title: '提示'
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
                return false;
            });
        });
    </script>
</head>
<body>

<form class="layui-form" action="" style="margin-top: 20px;">
    <input name="id" type="hidden" value="${refundDTO.id!}"/>
    <div class="layui-form-item" style="margin-bottom: 1px;" >
        <div class="layui-inline">
            <label class="layui-form-label">订单号:</label>
            <div class="layui-input-inline">
                <label class="layui-form-label2">${order.id!}</label>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">创建日期</label>
            <div class="layui-input-inline">
                <label class="layui-form-label2">${order.createTime?datetime}</label>
            </div>
        </div>
    </div>

    <div class="layui-form-item"style="margin-bottom: 1px;" >
        <div class="layui-inline">
            <label class="layui-form-label">订单金额</label>
            <div class="layui-input-inline">
                <label class="layui-form-label2">${order.totalAmount?string("0.00")}</label>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">支付金额</label>
            <div class="layui-input-inline">
                <label class="layui-form-label2">${order.amountPaid?string("0.00")}</label>
            </div>
        </div>
    </div>
    <#if refundDTO??>
    <div class="layui-form-item" style="margin-bottom: 1px;" >
        <div class="layui-inline">
            <label class="layui-form-label">退款数量</label>
            <div class="layui-input-inline">
                <label class="layui-form-label2">${refundDTO.quantity!}</label>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">退款金额</label>
            <div class="layui-input-inline">
                <label class="layui-form-label2">${refundDTO.amount?string("0.00")}</label>
            </div>
        </div>
    </div>
        <div class="layui-form-item" style="margin-bottom: 1px;" >
            <div class="layui-inline">
                <label class="layui-form-label">退款审核</label>
                <div class="layui-input-inline">
                    <select class="selectpicker" name="agreeRefund">
                        <option value="true">同意退款</option>
                        <option value="false">拒绝退款</option>
                    </select>
                </div>
            </div>
        </div>
    </#if>
    <div class="layui-form-item layui-form-text" style="margin-top: 20px;">
        <label class="layui-form-label">备注</label>
        <div class="layui-input-block" style="padding-right: 60px;">
            <textarea placeholder="请输入备注" cols="20" rows="2" name="remark" class="layui-textarea"></textarea>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitRefund">立即提交</button>
        </div>
    </div>
</form>
</body>
</html>