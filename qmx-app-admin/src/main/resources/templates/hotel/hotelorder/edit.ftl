<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>编辑</title>
    <#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            form.render('select');
        })
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>订单修改</legend>
</fieldset>
<form action="saveEdit.jhtml" method="post" id="signupForm" class="layui-form">
    <input type="hidden" value="${hotelOrderDto.id!}" name="id"/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label" style="width: 250px;text-align:left">产品名称： ${hotelOrderDto.productName!}</label>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline-block">
            <label class="layui-form-label" style="text-align:left">房间数：${hotelOrderDto.roomNumber!}</label>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label" style="width: 150px;text-align:left">总金额： ${hotelOrderDto.payment!} 元</label>
        </div>
    </div>
    <div class="layui-form-item" >
        <div class="layui-inline-block" style="text-align:left">
            <label class="layui-form-label">联系姓名</label>
            <div class="layui-input-inline">
                <input  type="text" class="layui-input" lay-verify="required"
                        name="contactName" id=contactName"" value="${hotelOrderDto.contactName!}" />
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">手机号码</label>
            <div class="layui-input-inline">
                <input  type="text" class="layui-input" lay-verify="number"
                        name="contactPhone" id=contactPhone"" value="${hotelOrderDto.contactPhone!}" />
            </div>
        </div>
    </div>
    <div class="layui-form-item" >
        <div class="layui-inline-block" >
            <label class="layui-form-label">证件类型</label>
            <div class="layui-input-inline">
                <select name="idCardType" >
                    <option >-证件类型-</option>
                    <option value="Idcard" <#if (hotelOrderDto.idCardType!)=='Idcard'> selected="selected" </#if>>身份证</option>
                    <option value="Passport" <#if (hotelOrderDto.idCardType!)=='Passport'> selected="selected" </#if> >护照</option>
                    <option value="TaiwanPermit" <#if (hotelOrderDto.idCardType!)=='TaiwanPermit'> selected="selected" </#if> >台胞证</option>
                    <option value="HKAndMacauPermit" <#if (hotelOrderDto.idCardType!)=='HKAndMacauPermit'> selected="selected" </#if> >港澳通行证</option>
                </select>
            </div>
            <label class="layui-form-label">证件号码</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="idCard" lay-verify="required" value="${hotelOrderDto.idCard!}"  />
            </div>
        </div>
    </div>

    <div class="layui-form-item" >
        <div class="layui-inline-block" >
            <label class="layui-form-label">备注</label>
            <div class="layui-input-inline">
                <textarea name="message" class="layui-textarea" maxlength="4000" style="width: 320px;height: 180px">${hotelOrderDto.message!}</textarea>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">保存</button>
            <input class="layui-btn layui-btn-primary" onclick="history.back();" style="width: 100px" value="返回"/>
        </div>
    </div>
</form>
<script type="text/javascript">
    function priceChange() {
        var price=$("#price").val();
        var number=$("#number").val();
        var total=price*number;
        $("#total").val(total);
    }
</script>
</body>
</html>