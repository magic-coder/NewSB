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
    <hr>
    <input type="hidden" name="id" id="orderId" value="${dto.id!?c}"/>
    <input type="hidden" name="type" id="type" value="${type!}"/>
<#if user!='distributor'&&type!='deposit'>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">支付类型</label>
            <div class="layui-input-inline">
                <select name="payType" lay-filter="payType">
                    <option value="online">在线支付</option>
                    <option value="offline">线下支付</option>
                </select>
            </div>
        </div>
    </div>
</#if>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">支付方式</label>
            <div class="layui-input-inline">
                <select name="payChannelNo" id="payChannelNo">
                <#list paytypes as paytype>
                    <#if paytype.channelNo=='DEPOSIT'>
                        <option value="${paytype.channelNo!}">${paytype.channelName!}</option>
                    <#else>
                        <option value="${paytype.channelNo!}">${paytype.payPlat.getName()!}</option>
                    </#if>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item" style="display: none" id="content">
        <div class="layui-inline">
            <label class="layui-form-label">支付备注</label>
            <div class="layui-input-inline">
              <textarea name="remark" id="remark" autocomplete="off" class="layui-input"
                        style="width: 537px;height: 127px;"></textarea>
            </div>
        </div>
    </div>

    <div class="layui-form-item" id="onlinePay">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">下一步</button>
        </div>
    </div>

</form>
<div class="layui-form-item" id="offlinePay" style="display: none">
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


        //监听支付类型
        form.on('select(payType)', function (data) {
            var type = data.value;
            var id = $("#orderId").val();
            if (type == 'offline') {
                $("#payChannelNo").html("");
                $("#content").show();
                $("#offlinePay").show();
                $("#onlinePay").hide();
                $.ajax({
                    url: "getOfflinePayType",
                    type: "GET",
                    data: {id: id},
                    success: function (result) {
                        for (var i = 0; i < result.length; i++) {
                            $("#payChannelNo").append("<option value=" + result[i].name + ">" + result[i].title + "</option>");
                        }
                        form.render();
                    }
                });
            } else {
                $("#payChannelNo").html("");
                $("#content").hide();
                $("#offlinePay").hide();
                $("#onlinePay").show();
                $.ajax({
                    url: "getOnlinePayType",
                    type: "GET",
                    data: {id: id},
                    success: function (result) {
                        for (var i = 0; i < result.length; i++) {
                            $("#payChannelNo").append("<option value=" + result[i].type + ">" + result[i].name + "</option>");
                        }
                        form.render();
                    }
                });
            }
        });

        $(document).on("click", "#btn", function () {
            var orderId = $("#orderId").val();
            var remark = $("#remark").val();
            var payChannelNo = $("#payChannelNo").val();
            var type = $("#type").val();
            $.ajax({
                url: "offlinePayOrder",
                type: "GET",
                data: {id: orderId, remark: remark, payChannelNo: payChannelNo, type: type},
                success: function (result) {
                    if (result.state == 'success') {
                        layer.msg(result.msg, {
                            time: 1000 //1秒关闭（如果不配置，默认是3秒）
                        }, function () {
                            parent.layer.close(index);
                            window.parent.location.reload(true);
                        });
                    } else {
                        layer.msg(result.msg);
                        parent.layer.close(index);
                    }
                }
            });
        });

        form.render();
    });
</script>
</body>

</html>