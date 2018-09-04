<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            form.verify({
                productId: [/[\S]+/, "请选择产品"]
            });
        });
    </script>
    <script>
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
<form id="inputForm" class="layui-form" action="" method="post">
    <input type="hidden" id="id" name="id" value="${dto.id!}">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <label class="layui-form-label">选择产品</label>
        <div class="layui-input-block">
            <input id="productName" name="productName" value="${dto.productName!}" style="display: inline;width: 190px;" lay-verify="required" class="layui-input" readonly>
            <input type="hidden" id="productId" name="productId" value="<#if dto.productId??>${dto.productId?c}</#if>" lay-verify="required"/>
            <input id="addProduct" type="button" class="layui-btn" value="选择产品">
            <#--<span id="productName"></span>-->
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">规则名称</label>
        <div class="layui-input-inline">
            <input id="name" name="name" value="${dto.name!}" lay-verify="required" class="layui-input" maxlength="30">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">返佣类型</label>
        <div class="layui-input-inline">
            <select name="type">
            <#list types as type>
                <option <#if dto.type?? && type == dto.type>selected</#if> value="${type}">${type.title}</option>
            </#list>
            </select>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">返佣金额</label>
        <div class="layui-input-inline">
            <input id="amount" name="amount" value="${dto.amount!}" lay-verify="required" class="layui-input">
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" onclick="return submitform();">立即提交</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
<script type="text/javascript">
    function submitform(){
        var $productId = $("#productId").val();
        var $name = $("#name").val();
        var $amount = $("#amount").val();
        if($productId==null||$productId==""){
            alert("请选择产品");
            return false;
        }
        if($name==null||$name==""){
            alert("请输入规则名称");
            return false;
        }
        if($amount==null||$amount==""){
            alert("请输入返佣金额");
            return false;
        }
        $.ajax({
            type :"POST",
            url : "checkProductId",
            data:$('#inputForm').serialize(),
            success : function(e) {
                if(e.type=="success"){
                    window.location.href="product";
                }else{
                    alert(e.content);
                }
            },
            error : function (aa) {
                console.log(aa);
                alert("错误!!");
            }

        });
        return false;
    }

</script>
</body>
</html>