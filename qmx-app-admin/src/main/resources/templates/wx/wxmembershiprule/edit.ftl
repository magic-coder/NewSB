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

            var laydate = layui.laydate;

            //执行一个laydate实例
            laydate.render({
                elem: '#saleStartTime' //指定元素
                ,type: 'datetime'
            });
            laydate.render({
                elem: '#endDate' //指定元素
                ,type: 'datetime'
            });
        });
    </script>
</head>
<body>
<form class="layui-form" id="inputForm" action="" method="post">
    <input type="number" style="display:none;" id="ids" name="id" value="${dto.id}" />
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>编辑规则</legend>
    </fieldset>
    <div <#if dto.type=='minimum'||dto.type=='sign'||dto.type=='pay'||dto.type=='promotion'||dto.type=='sendIntegral'>style="display:none;"</#if> class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">赠送类型:</label>
            <div class="layui-input-inline" style="width: 70%;">
                <label><input id="jftype" name="giveType" type="radio" value="integral" title="积分" <#if dto.giveType=='integral'> checked="checked"</#if>/></label>
                <label><input id="jetype" name="giveType" type="radio" value="money" title="金额" <#if dto.giveType=='money'> checked="checked"</#if>/></label>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">用途:</label>
            <div class="layui-input-inline" style="width: 80%;">
                <#if dto.type=="recharge"||dto.type=="consumption">
                    <label><input id="ytcz" name="type" type="radio" value="recharge" title="充值" <#if dto.type=='recharge'> checked="checked"</#if>/></label>
                    <label><input id="ytxf" name="type" type="radio" value="consumption" title="消费" <#if dto.type=='consumption'> checked="checked"</#if>/></label>
                <#else>
                    <#if dto.type=='opencard'>
                        <label><input id="ytkk" name="type" type="radio" value="opencard" title="开卡" <#if dto.type=='opencard'> checked="checked"</#if>/></label>
                    <#elseif dto.type=='minimum'>
                        <label><input id="ytzdcz" name="type" type="radio" value="minimum" title="最低充值" <#if dto.type=='minimum'> checked="checked"</#if>/></label>
                    <#elseif dto.type=='sign'>
                        <label><input id="ytqd" name="type" type="radio" value="sign" title="签到" <#if dto.type=='sign'> checked="checked"</#if>/></label>
                    <#elseif dto.type=='pay'>
                        <label><input id="ytzf" name="type" type="radio" value="pay" title="支付" <#if dto.type=='pay'> checked="checked"</#if>/></label>
                    <#elseif dto.type=='promotion'>
                        <label><input id="ytsjhy" name="type" type="radio" value="promotion" title="升级会员" <#if dto.type=='promotion'> checked="checked"</#if>/></label>
                    <#elseif dto.type=='sendIntegral'>
                        <label><input id="ytgjsjf" name="type" type="radio" value="sendIntegral" title="高级送积分/金额" <#if dto.type=='sendIntegral'> checked="checked"</#if>/></label>
                    <#elseif dto..type=='integralConsumption'>
                        <label><input id="ytjfxf" name="type" type="radio" value="integralConsumption" title="积分消费" <#if dto.type=='integralConsumption'> checked="checked"</#if>/></label>
                    </#if>
                </#if>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">是否启用:</label>
            <div class="layui-input-inline" style="width: 70%;">
                <label><input id="qy" name="enable" type="radio" value="1" title="启用" <#if dto.enable==true> checked="checked"</#if>/></label>
                <label><input id="gb" name="enable" type="radio" value="0" title="关闭" <#if dto.enable==false> checked="checked"</#if>/></label>
            </div>
        </div>
    </div>
    <#if dto.type=="recharge"||dto.type=="consumption">
        <div id="yxsj" class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">有效时间:</label>
                <div class="layui-input-inline" style="width: 70%;">
                    <input id="saleStartTime" name="startDate" <#if (dto.startDate)??>value="${dto.startDate?string('yyyy-MM-dd HH:mm:ss')}"</#if> style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input"/>&nbsp;至
                    <input id="endDate" name="endDate" <#if (dto.endDate)??> value="${dto.endDate?string('yyyy-MM-dd HH:mm:ss')}"</#if> style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input"/>
                </div>
            </div>
        </div>
        <div id="gzfs" class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">规则方式:</label>
                <div class="layui-input-inline" style="width: 70%;">
                    <label><input id="gdfs" name="qgType" type="radio" value="guding" title="固定" <#if dto.qgType=="guding"> checked="checked"</#if>/></label>
                    <label><input id="qjfs" name="qgType" type="radio" value="qujian" title="区间" <#if dto.qgType=="qujian"> checked="checked"</#if>/></label>
                </div>
            </div>
        </div>
        <div id="qjlx" <#if dto.qgType=="guding"> style="display:none;"</#if> class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">赠送类型:</label>
                <div class="layui-input-inline" style="width: 70%;">
                    <label><input id="aqjzdi" name="qType" type="radio" value="fixed" title="指定值"  <#if dto.qType?? && dto.qType=="fixed"> checked="checked"</#if>/></label>
                    <label><input id="aqjbfb" name="qType" type="radio" value="percentage" title="百分比" <#if dto.qType?? && dto.qType=="percentage"> checked="checked"</#if>/></label>
                </div>
            </div>
        </div>
        <div id="qjlxxq" <#if dto.qgType=="guding"> style="display:none;"</#if> class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">范围:</label>
                <div class="layui-input-inline" style="width: 70%;">
                    <input id="min" name="minimum" value="${dto.minimum!}" lay-verify="required" min="0" value="0" style="display: inline;width: 80px;" autocomplete="off" class="layui-input"/>&nbsp;至
                    <input id="max" name="maximum" value="${dto.maximum!}" lay-verify="required" min="0" value="0" style="display: inline;width: 80px;" autocomplete="off" class="layui-input"/>

                    <span id="qjbfb" <#if dto.qType?? && dto.qType=="fixed"> style="display:none;"</#if>>
                        赠送:&nbsp;
                        <input id="qjbfbs" name="qPercentage" value="${dto.qPercentage!}" lay-verify="required" min="0" value="0" style="display: inline;width: 80px;" autocomplete="off" class="layui-input"/>
                        %<span name="givetypes"><#if dto.giveType=='integral'>积分<#elseif dto.giveType=='money'>金额<#else>积分</#if></span>
                    </span>
                    <span id="qjzdz" <#if dto.qType?? && dto.qType=="percentage"> style="display:none;"</#if>>
                        赠送:&nbsp;
                        <input id="qjzdzs" name="qFixed" value="${dto.qFixed!}" lay-verify="required" min="0" value="0" style="display: inline;width: 80px;" autocomplete="off" class="layui-input"/>
                        <span name="givetypes"><#if dto.giveType=='integral'>积分<#elseif dto.giveType=='money'>金额<#else>积分</#if></span>
                    </span>
                </div>
            </div>
        </div>
        <div id="gdlx" <#if dto.qgType=="qujian"> style="display:none;"</#if> class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">固定类型:</label>
                <div class="layui-input-inline" style="width: 70%;">
                    <label><input id="agdzdz" name="gType" type="radio" value="fixed" title="指定值"  <#if dto.gType=="fixed"> checked="checked"</#if>/></label>
                    <label><input id="agdbfb" name="gType" type="radio" value="percentage" title="百分比" <#if dto.gType=="percentage"> checked="checked"</#if>/></label>
                </div>
            </div>
        </div>
        <div id="gdlxxq" <#if dto.qgType=="qujian"> style="display:none;"</#if> class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">固定:</label>
                <div class="layui-input-inline" style="width: 70%;">
                    达到:&nbsp
                    <input id="gdz" name="gNum" value="${dto.gNum!}" lay-verify="required" style="display: inline;width: 80px;" autocomplete="off" class="layui-input"/>
                    <span id="gdbfb" <#if dto.gType=="fixed"> style="display:none;"</#if>>
                        赠送:&nbsp
                        <input id="gdbfbs" name="gPercentage" value="${dto.gPercentage!}" lay-verify="required" style="display: inline;width: 80px;" autocomplete="off" class="layui-input"/>
                        %<span name="givetypes"><#if dto.giveType=='integral'>积分<#elseif dto.giveType=='money'>金额<#else>积分</#if></span>
                    </span>
                    <span id="gdzdz" <#if dto.gType=="percentage"> style="display:none;"</#if>>
                        赠送:&nbsp
                        <input id="gdzdzs" name="gFixed" value="${dto.gFixed!}" lay-verify="required" style="display: inline;width: 80px;" autocomplete="off" class="layui-input"/>
                        <span name="givetypes"><#if dto.giveType=='integral'>积分<#elseif dto.giveType=='money'>金额<#else>积分</#if></span>
                    </span>
                </div>
            </div>
        </div>
    </#if>
    <#if dto.type=="opencard"||dto.type=="minimum"||dto.type=="sign"||dto.type=="promotion"||dto.type=="sendIntegral">
        <div id="akkjf" <#if dto.type!="opencard"> style="display:none;"</#if> class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">开卡:</label>
                <div class="layui-input-inline" style="width: 70%;">
                    赠送
                    <span name="givetypes"><#if dto.giveType=='integral'>积分<#elseif dto.giveType=='money'>金额<#else>积分</#if></span>:
                    <input id="bkkjf" name="openCardNum" style="display: inline;width: 190px;" lay-verify="required" value="${dto.openCardNum!}" autocomplete="off" class="layui-input"/>
                </div>
            </div>
        </div>
        <div id="azdcz" <#if dto.type!="minimum"> style="display:none;" </#if> class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">最低充值:</label>
                <div class="layui-input-inline" style="width: 70%;">
                    <input id="bzdcz" name="minRecharge" value="${dto.minRecharge!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input"/>
                </div>
            </div>
        </div>
        <div id="aqd" <#if dto.type!="sign">style="display:none;"</#if> class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">每天签到送:</label>
                <div class="layui-input-inline" style="width: 70%;">
                    <input id="bqd" name="openCardNum" value="${dto.openCardNum!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input"/>
                </div>
            </div>
        </div>
        <div id="asjhy" <#if dto.type!="promotion"> style="display:none;" </#if> class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">需充值:</label>
                <div class="layui-input-inline" style="width: 70%;">
                    <input id="bsjhy" name="jsNum" value="${dto.jsNum!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input"/><span style="color:red;">(注:0为取消)</span>
                </div>
            </div>
        </div>
        <div id="ajfxf" <#if dto.type!="integralConsumption"> style="display:none;" </#if> class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">消费:</label>
                <div class="layui-input-inline" style="width: 70%;">
                    <input id="bxfjf" name="xfNum" value="${dto.gNum!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input"/>
                </div>
            </div>
        </div>
        <div id="adhwp" <#if dto.type!="integralConsumption"> style="display:none;" </#if> class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">兑换物品:</label>
                <div class="layui-input-inline" style="width: 70%;">
                    <input id="bdhwp" name="remarks" value="${dto.remarks!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input"/>
                </div>
            </div>
        </div>

    </#if>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <input type="button" class="layui-btn layui-btn-normal" onclick="return submitform();" value="立即提交"/>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>

</form>
<script type="text/javascript">
    $(function(){

        $("#jftype").click(function(){
            var els =document.getElementsByName("givetypes");
            for (var i = 0, j = els.length; i < j; i++){
                els[i].innerHTML = "积分";
            }

        })

        $("#jetype").click(function(){
            var els =document.getElementsByName("givetypes");
            for (var i = 0, j = els.length; i < j; i++){
                els[i].innerHTML = "金额";
            }

        })
        $("#gdfs").click(function(){
            $("#gdlx").attr("style","");
            $("#qjlx").attr("style","display:none;");
            $("#qjlxxq").attr("style","display:none;");
            $("#gdlxxq").attr("style","");
            $("#agdzdz").attr("checked","checked");
            $("#gdbfb").attr("style","display:none;");
            $("#gdzdz").attr("style","display:inline;");
        })
        $("#qjfs").click(function(){
            $("#gdlx").attr("style","display:none;");
            $("#qjlx").attr("style","");
            $("#qjlxxq").attr("style","");
            $("#gdlxxq").attr("style","display:none;");
            $("#aqjzdi").attr("checked","checked");
            $("#qjbfb").attr("style","display:none;");
            $("#qjzdz").attr("style","display:inline;");
        })
        //区间类型指定值
        $("#aqjzdi").click(function(){
            $("#qjbfb").attr("style","display:none;");
            $("#qjzdz").attr("style","display:inline;");
        });
        //区间类型百分比
        $("#aqjbfb").click(function(){
            $("#qjbfb").attr("style","display:inline;");
            $("#qjzdz").attr("style","display:none;");
        });
        //固定类型指定值
        $("#agdzdz").click(function(){
            $("#gdbfb").attr("style","display:none;");
            $("#gdzdz").attr("style","display:inline;");
        });
        //固定类型百分比
        $("#agdbfb").click(function(){
            $("#gdbfb").attr("style","display:inline;");
            $("#gdzdz").attr("style","display:none;");
        });
    })
    function submitform(){
        if($("input[id='ytkk']:checked").val()!=null||
                $("input[id='ytzdcz']:checked").val()!=null||
                $("input[id='ytqd']:checked").val()!=null||
                $("input[id='ytzf']:checked").val()!=null||
                $("input[id='ytsjhy']:checked").val()!=null||
                $("input[id='ytgjsjf']:checked").val()!=null||
                $("input[id='ytjfxf']:checked").val()!=null){
        }else{
            if($(".startDate").val()==""){
                alert("请选择时间");
                return false;
            }
            if($("#endDate").val()==""){
                alert("请选择时间");
                return false;
            }
        }

        //判断是否是浮点数
        var reg = /^[0-9]+([.]{1}[0-9]{1,2})?$/;
        if($("input[id='ytkk']:checked").val()!=null||
                $("input[id='ytzdcz']:checked").val()!=null||
                $("input[id='ytqd']:checked").val()!=null||
                $("input[id='ytzf']:checked").val()!=null||
                $("input[id='ytsjhy']:checked").val()!=null||
                $("input[id='ytgjsjf']:checked").val()!=null||
                $("input[id='ytjfxf']:checked").val()!=null){
            if($("input[id='ytkk']:checked").val()!=null){
                var ytkks=$("#bkkjf").val();
                if (!reg.test(ytkks)) {
                    alert("请输入正确的规则");
                    return false;
                }
            }
            if($("input[id='ytzdcz']:checked").val()!=null){
                var bzdczs = $("#bzdcz").val();
                if (!reg.test(bzdczs)) {
                    alert("请输入正确的规则");
                    return false;
                }
            }
            if($("input[id='ytqd']:checked").val()!=null){
                var qd = $("#bqd").val();
                if (!reg.test(qd)) {
                    alert("请输入正确的规则");
                    return false;
                }
                $("#bkkjf").val($("#bqd").val());
            }
            if($("input[id='ytsjhy']:checked").val()!=null){
                var sjhy = $("#bsjhy").val();
                if (!reg.test(sjhy)) {
                    alert("请输入正确的规则");
                    return false;
                }
            }
            if($("input[id='ytjfxf']:checked").val()!=null){
                var jfxf = $("#bxfjf").val();
                if (!reg.test(jfxf)) {
                    alert("请输入正确的规则");
                    return false;
                }
            }
        }else{
            if($("input[id='gdfs']:checked").val()!=null){
                if($("input[id='agdzdz']:checked").val()!=null){
                    var gdz = $("#gdz").val();
                    var gdzdz = $('input[name="gFixed"]').val();
                    if(gdz==0){
                        alert("请输入正确的规则");
                        return false;
                    }
                    if (!reg.test(gdz)) {
                        alert("请输入正确的规则");
                        return false;
                    }
                    if (!reg.test(gdzdz)) {
                        alert("请输入正确的规则");
                        return false;
                    }
                    $("#min").val(0);
                    $("#max").val(0);
                    $("#qjbfbs").val(0);
                    $("#qjzdzs").val(0);
                    $("#gdbfbs").val(0);
                }
                if($("input[id='agdbfb']:checked").val()!=null){
                    var gdz = $("#gdz").val();
                    var gPercentage = $('input[name="gPercentage"]').val();
                    if(gdz==0){
                        alert("请输入正确的规则");
                        return false;
                    }
                    if (!reg.test(gdz)) {
                        alert("请输入正确的规则");
                        return false;
                    }
                    if (!reg.test(gPercentage)) {
                        alert("请输入正确的规则");
                        return false;
                    }
                    $("#min").val(0);
                    $("#max").val(0);
                    $("#qjbfbs").val(0);
                    $("#qjzdzs").val(0);
                    $("#gdzdzs").val(0);
                }
            }
            if($("input[id='qjfs']:checked").val()!=null){
                if($("input[id='aqjzdi']:checked").val()!=null){
                    var min = $("#min").val();
                    var max = $("#max").val();
                    var qFixed = $('input[name="qFixed"]').val();
                    if (!reg.test(min)) {
                        alert("请输入正确的规则");
                        return false;
                    }
                    if(max==0){
                        alert("请输入正确的规则");
                        return false;
                    }
                    if (!reg.test(max)) {
                        alert("请输入正确的规则");
                        return false;
                    }
                    if (!reg.test(qFixed)) {
                        alert("请输入正确的规则");
                        return false;
                    }

                    $("#qjbfbs").val(0);
                    $("#gdzdzs").val(0);
                    $("#gdbfbs").val(0);
                    $("#bkkjf").val(0);
                    $("#bzdcz").val(0);

                }
                if($("input[id='aqjbfb']:checked").val()!=null){
                    var min = $("#min").val();
                    var max = $("#max").val();
                    var qPercentage = $('input[name="qPercentage"]').val();
                    if (!reg.test(min)) {
                        alert("请输入正确的规则");
                        return false;
                    }
                    if(max==0){
                        alert("请输入正确的规则");
                        return false;
                    }
                    if (!reg.test(max)) {
                        alert("请输入正确的规则");
                        return false;
                    }
                    if (!reg.test(qPercentage)) {
                        alert("请输入正确的规则");
                        return false;
                    }
                    $("#qjzdzs").val(0);
                    $("#gdzdzs").val(0);
                    $("#gdbfbs").val(0);
                    $("#bkkjf").val(0);
                    $("#bzdcz").val(0);
                }
            }

            if ($("input[id='qjfs']:checked").val()!=null) {
                if(parseFloat($("#min").val())>=parseFloat($("#max").val())){
                    alert("区间值输入有误");
                    return false;
                }
            }
        }
        if("${dto.type}"=="recharge" || "${dto.type}"=="consumption"){
            if($("#min").val().length<1){
                alert("null");
            }
            if($("#min").val().length<1){
                $("#min").val(0);
            }

            if($("#max").val().length<1){
                $("#max").val(0);
            }

            if($("#qjbfb").val().length<1){
                $("#qjbfb").val(0);
            }

            if($("#qjzdz").val().length<1){
                $("#qjzdz").val(0);
            }

            if($("#gdz").val().length<1){
                $("#gdz").val(0);
            }

            if($("#gdbfb").val().length<1){
                $("#gdbfb").val(0);
            }

            if($("#gdzdz").val().length<1){
                $("#gdzdz").val(0);
            }
        }else{

            if($("#ytqd").attr('checked')||$("#ytzf").attr('checked')||$("#ytsjhy").attr('checked')||$("#ytgjsjf").attr('checked')){
                if($("#ytqd").attr('checked')){
                    $("#").val($("#bqd").val());
                }

            }else{
                if($("#bkkjf").val()==null){
                    $("#bkkjf").val(0);
                }
                if($("#bzdcz").val()==null){
                    $("#bzdcz").val(0);
                }
            }
        }
        formaction();
    }
    function formaction(){
        $.ajax({
            type :"POST",
            url : "./update",
            data:$('#inputForm').serialize(),
            success : function(e) {
                if(e.type=="1"){
                    window.location.href="list";
                }else{
                    alert(e.data);
                }
            },
            error : function (aa) {
                alert(aa.responseText);
            }

        });
    }

</script>
</body>
</html>