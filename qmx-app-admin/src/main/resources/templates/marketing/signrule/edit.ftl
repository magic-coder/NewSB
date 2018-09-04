<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>编辑</title>

<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            laydate.render({elem: "#startDate"});
            laydate.render({elem: "#endDate"});
        });
        //选择活动
        $(document).on("click", "#addSign", function () {
            var index = layer.open({
                type: 2,
                title: '选择活动',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'signActivityList'
            });
        });
        //选择奖品
        $(document).on("click", "#addPrize", function () {
            var index = layer.open({
                type: 2,
                title: '选择奖品',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'prizeList'
            });
        });
    </script>
</head>
<body>
<form id="inputForm" class="layui-form" action="save" method="post">
    <input type="hidden" id="id" name="id" value="${dto.id!}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <label class="layui-form-label">选择活动</label>
        <div class="layui-input-inline" style="width: 400px;">
            <input id="signName" name="signName" value="${dto.signName!}" lay-verify="required" style="width: 190px;display: inline;" autocomplete="off" class="layui-input" readonly>
            <input type="hidden" id="signActivity" name="signActivity" value="${dto.signActivity!}"/>
            <input id="addSign" type="button" class="layui-btn" value="选择活动">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">选择奖品</label>
        <div class="layui-input-inline" style="width: 400px;">
            <input id="prizeName" name="prizeName" value="${dto.prizeName!}" lay-verify="required" style="width: 190px;display: inline;" autocomplete="off" class="layui-input" readonly>
            <input type="hidden" id="signPrize" name="signPrize" value="${dto.signPrize!}"/>
            <input id="addPrize" type="button" class="layui-btn" value="选择奖品">
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 50%;">
            <label class="layui-form-label">签到状态</label>
            <div class="layui-input-inline" style="width:50%;">
                <input name="signType" value="LIANXU" title="连续签到" <#if dto.signType=="LIANXU">checked</#if> type="radio">
                <input name="signType" value="LEIJI" title="累计签到" <#if dto.signType=="LEIJI">checked</#if> type="radio">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">签到次数</label>
        <div class="layui-input-inline">
            <input id="signNum" name="signNum" value="${dto.signNum!}" lay-verify="required|number" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">有效时间</label>
        <div class="layui-input-inline">
            <input id="startDate" name="startDate" value="${dto.startDate!?string("yyyy-MM-dd")}" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <div class="layui-form-mid">-</div>
        <div class="layui-input-inline">
            <input id="endDate" name="endDate" value="${dto.endDate!?string("yyyy-MM-dd")}" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <div class="layui-form-mid"><span style="color:red;">凌晨0:00结束</span></div>
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
        if($("#signActivity").val()==""){
            alert("请选择活动");
            return false;
        }
        if($("#signPrize").val()==""){
            alert("请选择奖品");
            return false;
        }
        var reg = /^[1-9]\d*$/;
        if (!reg.test($("#signNum").val())) {
            alert("请输入正确的次数");
            return false;
        }
        if($("#startDate").val()==""){
            alert("请选择时间");
            return false;
        }
        if($("#endDate").val()==""){
            alert("请选择时间");
            return false;
        }

        $.ajax({
            type :"POST",
            url : "./update",
            data:$('#inputForm').serialize(),
            success : function(e) {
                if(e.state=="success"){
                    window.location.href="list";
                }else{
                    alert(e.msg);
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