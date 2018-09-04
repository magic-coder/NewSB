<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>添加</title>
    <link rel="stylesheet" href="${base}/bak/css/wx/wxSystem.css">
    <script type="text/javascript" src="${base}/resources/module/wx/js/operate.js"></script>

<#include "/include/common_header_include.ftl">
    <script>
        var layedit;
        var index;
        layui.use(['form', 'table', 'laydate','layedit'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            laydate.render({elem: "#beginDate"});
            laydate.render({elem: "#endDate"});
        });

        //选择产品
        $(document).on("click", "#addProduct", function () {
            var index = layer.open({
                type: 2,
                title: '选择产品',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'productlist'
            });
        });
    </script>
</head>
<body>
<form class="layui-form" id="inputForm">

    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <label class="layui-form-label">优惠券名称</label>
        <div class="layui-input-inline">
            <input id="name" name="name" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">适用门票</label>
        <div class="layui-input-block">
            <input id="productName" name="productName" style="display: inline;width: 190px;" lay-verify="required" class="layui-input" readonly>
            <input type="hidden" id="productId" name="product" lay-verify="required"/>
            <input id="addProduct" type="button" class="layui-btn" value="选择门票">
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">面值</label>
            <div class="layui-input-inline">
                <input id="price" name="price" lay-verify="required" autocomplete="off" class="layui-input"/>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">发放数量</label>
            <div class="layui-input-inline">
                <input id="totleNumber" name="totleNumber" lay-verify="required" autocomplete="off" class="layui-input"/>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">优惠券有效期</label>
        <div class="layui-input-inline">
            <input id="beginDate" name="beginDate" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <div class="layui-form-mid">-</div>
        <div class="layui-input-inline">
            <input id="endDate" name="endDate" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <input type="button" class="layui-btn layui-btn-normal" onclick="return submitform();" value="立即提交"/>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
<script type="text/javascript">
    function submitform(){
        //验证输入参数
        if($("#name").val()==""){
            alert("请输入优惠券名称");
            return false;
        }
        var $price = /^[0-9]+([.]{1}[0-9]{1,2})?$/;
        if (!$price.test($("#price").val())) {
            alert("请输入正确的面值");
            return false;
        }
        var $number = /^[1-9]\d*$/;
        if (!$number.test($("#totleNumber").val())) {
            alert("请输入正确的库存");
            return false;
        }
        if($("#startDate").val()==""){
            alert("请选择开始时间");
            return false;
        }
        if($("#endDate").val()==""){
            alert("请选择结束时间");
            return false;
        }
        $.ajax({
            type :"POST",
            url : "./save",
            data:$('#inputForm').serialize(),
            success : function(e) {
                if(e.state=="success"){
                    window.location.href="./list";
                }else{
                    alert(e.msg);
                }
            },
            error:function(xhr,textStatus){
                alert("错误!!");
            }
        });
        return false;
    }
</script>
</body>
</html>