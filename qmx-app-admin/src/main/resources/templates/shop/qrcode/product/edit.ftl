<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <link href="${base}/bak/js/dropdown/dropdown.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${base}/resources/module/shop/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropdown.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropqtable.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/editor/kindeditor.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/openMap.js"></script>
    <script src="${base}/resources/common/js/jquery-migrate-1.2.1.js"></script>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <input name="id" value="${dto.id!}" type="hidden"/>
        <label class="layui-form-label" style="width: 150px;">选择产品</label>
        <div class="layui-input-inline">
            <input type="hidden" id="outId" name="outId" lay-verify="outId" value="${dto.outId!?c}"/>
            <input value="${dto.outName!}" class="layui-input" disabled/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">二维码名称</label>
        <div class="layui-input-inline">
            <input id="name" name="name" class="layui-input" value="${dto.name!}"/>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 700px;">
            <label class="layui-form-label" style="width: 150px;">产品图片</label>
            <div class="layui-input-block">
                <input type="hidden" name="imgurl" lay-verify="imgurl" autocomplete="off" class="layui-input"
                       value="${dto.imgurl!}">
                <img class="imageStyleImg" alt="" height="120" width="120" style="border: solid" src="${dto.imgurl!}"/>
                <button type="button" class="layui-btn test1">
                    <i class="layui-icon">&#xe67c;</i>上传图片
                    <li style="color: red;">(请上传1:1比例且小于1M的图片)</li>
                </button>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">二维码售价</label>
        <div class="layui-input-inline">
            <input name="salePrice" lay-verify="salePrice" class="layui-input"
                   <#if priceFlag?string("true","false")=="true">readonly</#if> value="${dto.salePrice!}"/>
        </div>
        <label class="layui-form-label" style="width: 150px;">序号</label>
        <div class="layui-input-inline">
            <input name="serial" lay-verify="serial" class="layui-input" value="${dto.serial!}"/>
        </div>
    <#--        <label class="layui-form-label" style="width: 150px;">当日剩余库存</label>
            <div class="layui-input-inline">
                <input lay-verify="dayMaxStock" class="layui-input" value="${dto.dayMaxStockFlag!}"
                       readonly="readonly"/>
            </div>-->
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">总库存</label>
        <div class="layui-input-inline">
            <input name="maxStock" lay-verify="maxStock" class="layui-input" value="${dto.maxStock!}"/>
        </div>
        <label class="layui-form-label" style="width: 150px;">日库存</label>
        <div class="layui-input-inline">
            <input name="dayMaxStock" lay-verify="dayMaxStock" class="layui-input" value="${dto.dayMaxStock!}"/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">描述</label>
        <div class="layui-input-block">
            <textarea name="description" class="editor">${dto.description!}</textarea>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
<script>
    layui.use(['form', 'table', 'laydate', 'jquery'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
        var $ = layui.jquery;

        form.verify({
            outId: [/[\S]+/, "请选择产品"],
            imgurl: [/[\S]+/, "请上传图片"],
            dayMaxStock: [/^\d+$/, "请填写正确的日库存！"],
            maxStock: [/^\d+$/, "请填写正确的最大库存！"],
            serial: [/^\d+$/, "请填写正确的序号！"],
            salePrice: [/(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^[0-9]\.[0-9]([0-9])?$)/, "请填写正确的售卖价！"]
        });

        laydate.render({
            elem: '#firstCooperationTime' //指定元素
        });
        laydate.render({
            elem: '#firstCooperationTime1' //指定元素
        });

        //监听是否指定游玩日期
        form.on('radio(playState)', function (data) {
            var flag = data.value;
            if (flag == 1) {
                $("#fixedTerm2").show();
                $("#fixedTerm1").hide();
                $("#usefulWeek").hide();
                $("#saleState").hide();
                $("#selectDate").show();
                $("#stockPrice").hide();
                $("#pricedate").show();
                $("#title").html("批量设置可游玩时间");
            } else {
                $("#fixedTerm1").show();
                $("#fixedTerm2").hide();
                $("#usefulWeek").show();
                $("#saleState").show();
                $("#selectDate").hide();
                $("#stockPrice").show();
                $("#pricedate").hide();
                $("#title").html("批量设置可售时间");
                var val = $('input:radio[name="saleState"]:checked').val();
                if (val == 0) {
                    $("#pricedate").show();
                    $("#stockPrice").hide();
                }
            }
        });
        //监听售卖日期设置
        form.on('radio(saleState)', function (data) {
            var flag = data.value;
            if (flag == 0) {
                $("#stockPrice").hide();
                $("#pricedate").show();
            } else {
                $("#stockPrice").show();
                $("#pricedate").hide();
            }
        });

        $("#bookings").dropqtable({
            vinputid: "bookingRules", //值所存放的区域
            dropwidth: "auto", //下拉层的宽度
            selecteditem: {text: "${dto.bookingName!}", value: "${dto.bookingRules!}"}, //默认值
            editable: false,
            tableoptions: {
                autoload: true,
                url: "getBookRule", //查询响应的地址
                qtitletext: "请输入规则名称", //查询框的默认文字
                textField: 'trueName',
                valueField: 'id',
                colmodel: [
                    {name: "id", displayname: "规则id", width: "150px"},
                    {name: "ruleName", displayname: "规则名称", width: "100px"},
                    // {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                ],
                onSelect: function (rules) {
                    $("#bookingRules").val(rules.id);
                    //$("#username").val(supplier.id);
                    $("#bookings").val(rules.ruleName)
                    $("#bookingRemind").html(rules.remind);
                }
            }
        });
        $("#refund").dropqtable({
            vinputid: "refundRules", //值所存放的区域
            dropwidth: "auto", //下拉层的宽度
            selecteditem: {text: "${dto.refundName!}", value: "${dto.refundRules!}"}, //默认值
            editable: false,
            tableoptions: {
                autoload: true,
                url: "getRefundRule", //查询响应的地址
                qtitletext: "请输入规则名称", //查询框的默认文字
                textField: 'trueName',
                valueField: 'id',
                colmodel: [
                    {name: "id", displayname: "规则id", width: "150px"},
                    {name: "ruleName", displayname: "规则名称", width: "100px"},
                    // {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                ],
                onSelect: function (rules) {
                    $("#refundRules").val(rules.id);
                    //$("#username").val(supplier.id);
                    $("#refund").val(rules.ruleName);
                    $("#refundRemind").val(rules.remind)
                }
            }
        });
        $("#ticket").dropqtable({
            vinputid: "ticketRules", //值所存放的区域
            dropwidth: "auto", //下拉层的宽度
            selecteditem: {text: "${dto.ticketName!}", value: "${dto.ticketRules!}"}, //默认值
            editable: false,
            tableoptions: {
                autoload: true,
                url: "getConsumeRule", //查询响应的地址
                qtitletext: "请输入规则名称", //查询框的默认文字
                textField: 'trueName',
                valueField: 'id',
                colmodel: [
                    {name: "id", displayname: "规则id", width: "150px"},
                    {name: "ruleName", displayname: "规则名称", width: "100px"},
                    // {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                ],
                onSelect: function (relus) {
                    $("#ticketRules").val(relus.id);
                    //$("#username").val(supplier.id);
                    $("#ticket").val(relus.ruleName);
                    $("#ticketRemind").val(relus.remind);
                }
            }
        });
    });

    $().ready(function () {
        jQuery("button.test1").each(function () {
            var $this = $(this);
            uploadCompletes1($this);
        });
        jQuery("button.test2").each(function () {
            var $this = $(this);
            uploadCompletes2($this);
        });
    });

    function uploadCompletes1($this) {
        layui.use('upload', function () {
            var upload = layui.upload;
            //执行实例
            upload.render({
                elem: $this //绑定元素
                , url: '${base}/file/upload?fileType=image&token=' + getCookie("token") //上传接口
                , done: function (res) {
                    //如果上传失败
                    if (res.code > 0) {
                        return layer.msg('上传失败');
                    }
                    //上传成功
                    ($this).prev().attr("src", res.data);
                    ($this).parent().find("input[name='imgurl']").val(res.data);
                }
                , error: function () {
                    //请求异常回调
                    alert("异常!!!");
                }
            });
        });
    }
</script>
</body>
</html>