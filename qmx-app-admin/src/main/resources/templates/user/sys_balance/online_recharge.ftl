<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>系统钱包充值</title>
    <#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form'], function () {
            var form = layui.form;
            form.verify({
                amount: function(value, item){ //value：表单的值、item：表单的DOM对象
                    if(!new RegExp("^[0-9.]+$").test(value)){
                        return '支付金额非法';
                    }
                }
            });

            //监听提交
            form.on('submit(submitPay)', function(data){
                var reqData = data.field;
                var amount = reqData.amount;
                var payChannelNo = reqData.payChannelNo;
                var index = layer.open({
                    type: 2,
                    title: '充值',
                    area: ['500px', '520px'], //宽高
                    fix: true, //固定
                    content: '/sysBalance/onLineRechargePay?amount=' + amount + "&payChannelNo=" + payChannelNo
                });
                return false;
            });
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field" style="margin-left: 20px;margin-right: 20px;margin-top: 30px;">
    <legend>${dto.account!}（${dto.username!}）充值</legend>
    <div class="layui-field-box">
        <div class="layui-row layui-col-space6">
            <div class="layui-col-md6">
                <div class="layui-row" style="font-size: large;">
                    <div class="layui-col-md3">
                        历史充值金额：￥${dto.totalSysBalance!}
                    </div>
                    <div class="layui-col-md9">
                        账户余额：￥${dto.sysBalance!}
                    </div>
                </div>
            </div>
        </div>
        <form class="layui-form" action="" style="margin-top: 20px;">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">充值金额</label>
                    <div class="layui-input-inline">
                        <input type="text" name="amount" lay-verify="required|amount" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">支付方式</label>
                <div class="layui-input-inline">
                    <select name="payChannelNo" lay-verify="required">
                        <option value="">请选择支付方式</option>
                    <#list payChannelList as lst>
                        <option value="${lst.channelNo!}">${lst.payPlat.getName()!}</option>
                    </#list>
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-normal" id="submitPay" lay-submit lay-filter="submitPay">充值</button>
                <#--<input type="button" id="submitPay" class="layui-btn layui-btn-normal" value="充值"/>-->
                </div>
            </div>
    </div>
</fieldset>
</body>
</html>