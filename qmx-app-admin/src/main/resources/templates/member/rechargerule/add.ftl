<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>会员规则-新增</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
        //添加会员
        $(document).on("click", "#addProduct", function () {
            var index = layer.open({
                type: 2,
                title: '添加会员',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getProducts'
            });
        });
    </script>
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" id="inputForm" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">会员等级</label>
            <div class="layui-input-inline">
                <select  id="levelId" name="levelId" lay-filter="aihao" >
                    <option value="">请选择</option>
                <#list lList as ls>
                    <option value="${ls.id}">${ls.name}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <#--<div class="layui-form-item">-->
        <#--<div class="layui-inline">-->
            <#--<label class="layui-form-label">充值类型</label>-->
            <#--<div class="layui-input-inline">-->
                <#--<select id="rechargeType" name="rechargeType" lay-filter="aihao">-->
                    <#--<option value="">请选择</option>-->
                <#--<#list typeList as type>-->
                    <#--<option value="${type}">${type.title}</option>-->
                <#--</#list>-->
                <#--</select>-->
            <#--</div>-->
        <#--</div>-->
    <#--</div>-->
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">规则类型</label>
            <div class="layui-input-inline">
                <label><input id="gzlxQJ" type="radio" name="type" value="section" title="区间" checked/></label>
                <label><input id="gzlxGD" type="radio" name="type" value="fixed" title="固定"/></label>
            </div>
        </div>
    </div>
    <div  id="GDczje" class="layui-form-item" style="display: none">
        <div class="layui-inline">
            <label class="layui-form-label">充值金额</label>
            <div class="layui-input-inline">
                <input id="amount" name="amount" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div  id="QJczje" class="layui-form-item" style="">
        <div class="layui-inline">
            <label class="layui-form-label">最小充值金额</label>
            <div class="layui-input-inline">
                <input id="minAmount" name="minAmount" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label"style="text-align: left;">最大充值金额</label>
            <div class="layui-input-inline">
                <input id="maxAmount" name="maxAmount" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">赠送类型</label>
            <div class="layui-input-inline">
                <label><input id="zslxJF" type="radio" name="give" value="zengsong" title="赠送" checked/></label>
                <label><input id="zslxJE" type="radio" name="give" value="zhekou" title="折扣"/></label>
            </div>
        </div>
    </div>
    <div id="ZSjf" class="layui-form-item" style="">
        <div class="layui-inline">
            <label class="layui-form-label">赠送金额比例</label>
            <div class="layui-input-inline">
                <input id="integralPoint" placeholder="充100得120元" name="moneyPoint" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div id="ZSje" class="layui-form-item" style="display: none">
        <div class="layui-inline">
            <label class="layui-form-label">赠送金额折扣</label>
            <div class="layui-input-inline">
                <input id="moneyPoint" placeholder="充100只需要98元" name="discountPoint" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">赠送积分比例</label>
            <div class="layui-input-inline">
                <input  id="JFBL" placeholder="充100得100积分" name="integralPoint" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" onclick="return submitform();">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
<script type="text/javascript">
    $(function(){
        $("#gzlxGD").click(function(){
            $("#gzlxQJ").attr("checked",false);
            $("#GDczje").attr("style","");
            $("#QJczje").attr("style","display:none;");

        });
        $("#gzlxQJ").click(function(){
            $("#gzlxGD").attr("checked",false);
            $("#GDczje").attr("style","display:none;");
            $("#QJczje").attr("style","");
        });
        $("#zslxJF").click(function(){
            $("#zslxJE").attr("checked",false);
            $("#ZSjf").attr("style","");
            $("#ZSje").attr("style","display:none;");
        });
        $("#zslxJE").click(function(){
            $("#zslxJF").attr("checked",false);
            $("#ZSjf").attr("style","display:none;");
            $("#ZSje").attr("style","");
        });
    });
    function submitform(){
        var levelId = $("#levelId").val();
        var rechargeType = $("#rechargeType").val();
        if(levelId == ""){
            layer.msg('请选择会员等级');
            return false;
        }
        if(rechargeType == ""){
            layer.msg('请选择充值类型');
            return false;
        }

        var reg = /^[0-9]+([.]{1}[0-9]{1,2})?$/;
        if($("#gzlxQJ").attr('checked')){
            var minAmount=$("#minAmount").val();
            var maxAmount=$("#maxAmount").val();
            if (!reg.test(minAmount)) {
                layer.msg("请输入正确的最小充值金额");
                return false;
            }
            if (!reg.test(maxAmount)) {
                layer.msg("请输入正确的最大充值金额");
                return false;
            }

            if(minAmount >= maxAmount){
                layer.msg("请输入正确的区间金额");
                return false;
            }

        }
        if($("#gzlxGD").attr('checked')){
            var amount=$("#amount").val();
            if (!reg.test(amount)) {
//                alert(3);
                layer.msg("请输入正确的固定金额");
                return false;
            }
        }
        if($("#zslxJF").attr('checked')){
            var integralPoint=$("#integralPoint").val();
            if (!reg.test(integralPoint)) {
//                alert(4);
                layer.msg("请输入正确的赠送比例");
                return false;
            }
        }
        if($("#zslxJE").attr('checked')){
            var moneyPoint=$("#moneyPoint").val();
            if (!reg.test(moneyPoint)) {
                layer.msg("请输入正确的折扣比例");
                return false;
            }

        }
        var jfbl = $("#JFBL").val();
        if (!reg.test(jfbl)) {
            layer.msg("请输入正确的积分");
            return false;
        }

        $("#inputForm").submit();
//        $.ajax({
//            type :"POST",
//            url : "./save.jhtml",
//            data:$('#inputForm').serialize(),
//            success : function(e) {
//                if(e=="1"){
//                    window.location.href="./list.jhtml";
//                }else{
//                    layer.msg("新增失败");
//                }
//            },
//            error:function(xhr,textStatus){
//                alert("错误!!");
//            }
//        });
//        return false;
    }

</script>
</body>
</html>