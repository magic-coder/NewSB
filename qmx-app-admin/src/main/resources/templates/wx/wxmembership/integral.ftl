<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加模块</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" action="saveIntegral" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>积分消费</legend>
    </fieldset>
    <input type="hidden" name="id" value="${dto.id!}">
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">卡号:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="cardNum" disabled="true" value="${dto.cardNum!}" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 120px;">名字:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="userName" disabled="true" value="${dto.userName!}" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">电话:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="phone" disabled="true" value="${dto.phone!}" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 120px;">积分:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="integral" type="hidden" value="${dto.integral!}"/>
                <span style="color:red;font-size: 22px;float: left;padding: 9px 15px;line-height: 20px;">${dto.integral!}</span>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">兑换积分:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <select id="useIntegral" name="useIntegral" class="input_1">
                    <#if rules?? && rules?size !=0>
                        <#list rules as r>
                            <option value="${r.gNum!}">消费${r.gNum!}积分兑换：${r.remarks!}</option>
                        </#list>
                    <#else>
                        <option value="">无</option>
                    </#if>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" onclick="return submitForm();">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
<script type="text/javascript">
    function submitForm(){
        var integral = ${dto.integral!};
        var now_ = $("#useIntegral").val();
        if(now_==null||now_==""){
            alert("消费积分不能为空");
            return false;
        }
        if(now_<0||now_==0){
            alert("请输入0以上的数字");
            return false;
        }
        if(integral<now_){
            alert("积分不足");
            return false;
        }
        $("#inputForm").submit();

    }

</script>
</body>
</html>