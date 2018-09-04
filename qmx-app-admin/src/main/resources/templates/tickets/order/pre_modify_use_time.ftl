<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>修改日期</title>
    <link href="${base}/resources/assets/bootstrap/css/bootstrap-modify.css" rel="stylesheet"/>
    <link href="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.css" rel="stylesheet"/>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.js" charset="UTF-8"></script>
    <script type="text/javascript" src="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
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
        <#if distribution??>
            var prices = {<#list distribution.distributionPrices as price>'${price.useDate}':${price.authPrice},</#list>};
            <#if distribution.cannotUseDays??>
                var disabledDates = <<#list distribution.cannotUseDays?split(",") as price>'${price}',</#list>>;
            <#else>
                var disabledDates = [];
            </#if>
            <#if distribution.specifyDate>
                $('input[name=useDate]').datetimepicker({
                    language:  'zh-CN',
                    startDate: '${distribution.vsdate!}',
                    endDate:'${distribution.vedate!}',
                    weekStart: 1,
                    datesDisabled:disabledDates,
                    todayBtn:  0,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    minView: 2,
                    forceParse: 0
                }).on('change',function(ev){
                    var date = $(this).val();
                    console.info(date);
                });
            <#else>
                $('input[name=vsdate]').datetimepicker({
                    language:  'zh-CN',
                    startDate: new Date(),
                    weekStart: 1,
                    todayBtn:  1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    minView: 2,
                    forceParse: 0
                }).on('change',function(ev){
                    var startDate = $('input[name=vsdate]').val();
                    $("input[name=vedate]").datetimepicker('setStartDate',startDate);
                });

                $('input[name=vedate]').datetimepicker({
                    language:  'zh-CN',
                    startDate: new Date(),
                    weekStart: 1,
                    todayBtn:  1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    minView: 2,
                    forceParse: 0
                }).on('change',function(ev){
                    var returnDate = $("input[name=vedate]").val();
                    $("input[name=vsdate]").datetimepicker('setEndDate',returnDate);
                });
            </#if>
        <#else>
            $('input[name=vsdate]').datetimepicker({
                language:  'zh-CN',
                startDate: new Date(),
                weekStart: 1,
                todayBtn:  1,
                autoclose: 1,
                todayHighlight: 1,
                startView: 2,
                minView: 2,
                forceParse: 0
            }).on('change',function(ev){
                var startDate = $('input[name=vsdate]').val();
                $("input[name=vedate]").datetimepicker('setStartDate',startDate);
            });

            $('input[name=vedate]').datetimepicker({
                language:  'zh-CN',
                startDate: new Date(),
                weekStart: 1,
                todayBtn:  1,
                autoclose: 1,
                todayHighlight: 1,
                startView: 2,
                minView: 2,
                forceParse: 0
            }).on('change',function(ev){
                var returnDate = $("input[name=vedate]").val();
                $("input[name=vsdate]").datetimepicker('setEndDate',returnDate);
            });
        </#if>
            //监听提交
            form.on('submit(submitRefund)', function (data) {
                var index = layer.load(2, {time: 6 * 1000}); //设定最长等待10秒
                var reqData = data.field;
                $.ajax({
                    url: 'doModifyUseTime',
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
                                    , content: '<div style="padding: 20px 80px;">修改成功</div>'
                                    , btn: '关闭'
                                    , btnAlign: 'c' //按钮居中
                                    , yes: function () {
                                        parent.layer.close(pindex);
                                        location.href = "orderList";
                                    }
                                });
                            } else {
                                layer.open({
                                    type: 1
                                    , content: '<div style="padding: 20px 80px;">'+resp.errorMsg+'</div>'
                                    , btn: '关闭'
                                    , btnAlign: 'c' //按钮居中
                                    , yes: function () {
                                        parent.layer.close(pindex);
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
                return false;
            });
        });
    </script>
</head>
<body>

<form class="layui-form" action="" style="margin-top: 20px;">
    <input type="hidden" name="id" value="${order.id}"/>
    <div class="layui-form-item" style="margin-bottom: 1px;" >
        <div class="layui-inline" style="margin-bottom: 0px;">
            <label class="layui-form-label" style="width:100px;">产品名称</label>
            <div class="layui-input-inline">
                <label class="layui-form-label2">${order.productName!}</label>
            </div>
        </div>
        <div class="layui-inline" style="margin-bottom: 0px;">
            <label class="layui-form-label" style="width:100px;">当前日期</label>
            <div class="layui-input-inline">
                <label class="layui-form-label2">
                <#if distribution??>
                    <#if distribution.specifyDate>
                    ${order.useDate!}当天
                    <#else>
                        <#if order.vsdate == order.vedate>
                        ${order.vsdate!} 当天
                        <#else>
                        ${order.vsdate!}~${order.vedate!}
                        </#if>
                    </#if>
                <#else>
                    <#if order.vsdate == order.vedate>
                    ${order.vsdate!} 当天
                    <#else>
                    ${order.vsdate!}~${order.vedate!}
                    </#if>
                </#if>
                </label>
            </div>
        </div>
    </div>

    <div class="layui-form-item" style="margin-bottom: 1px;" >
        <div class="layui-inline">
            <label class="layui-form-label" style="width:100px;">修改到:</label>
            <div class="layui-input-inline" style="width:300px;">
            <#if distribution??>
                <#if distribution.specifyDate>
                    <input id="useDate" name="useDate" type="text" class="layui-input" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd"/>
                <#else>
                    <input readonly id="vsdate" placeholder="开始日期" style="width: 100px;float: left;" name="vsdate" type="text" class="layui-input" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd"/>
                    <input readonly id="vedate" placeholder="结束日期" style="width: 100px;float: left;" name="vedate" type="text" class="layui-input" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd"/>
                </#if>
            <#else>
                <input readonly name="vsdate" placeholder="开始日期" style="width: 100px;float: left;" type="text" class="layui-input" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd"/>
                <span style="float: left;width: 10px;">&nbsp;&nbsp;</span>
                <input readonly name="vedate" placeholder="结束日期" style="width: 100px;float: left;" type="text" class="layui-input" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd"/>
            </#if>
            </div>
        </div>
    </div>

    <div class="layui-form-item" style="margin-top: 20px;">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitRefund">立即提交</button>
        </div>
    </div>
</form>
</body>
</html>