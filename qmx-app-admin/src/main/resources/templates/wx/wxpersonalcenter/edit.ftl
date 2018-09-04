<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加模块</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/bak/js/ZeroClipboard.js"></script>
    <script type="text/javascript">
        $(function(){
            $("a.copy").each(function(){

                var Zero = ZeroClipboard;
                Zero.moviePath = "${base}/resources/module/shop/swf/ZeroClipboard.swf";

                var clip = new ZeroClipboard.Client();
                clip.setHandCursor(true);
                var obj = $(this);
                var id = $(this).attr("id");
                clip.glue(id);

                var txt=$("#"+id).attr("title");//设置文本框中的内容

                //鼠标移上时改变按钮的样式
                clip.addEventListener( "mouseOver", function(client) {
                    obj.css("color","#FF6600");
                    clip.setText(txt);
                });
                //鼠标移除时改变按钮的样式
                clip.addEventListener( "mouseOut", function(client) {
                    obj.css("color","");
                });
                //这个是复制成功后的提示
                clip.addEventListener( "complete", function(){
                    alert("已经复制到剪切板！\n"+txt);
                });
            });
        });
    </script>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">
                <input type="button" class="layui-btn layui-btn-normal layui-btn-sm copy" id="copy" title="${url!}" value="复制发布地址"/>
            </label>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">基本信息:</label>
            <div class="layui-input-inline">
            </div>
            <label class="layui-form-label">会员中心</label>
            <div class="layui-input-inline">
                <label><input id="hyzxT" name="memberzx" type="radio" value="true" onclick="change('memberzx',true);" title="是" <#if dto.memberzx> checked="checked" </#if>/></label>
                <label><input id="hyzxF" name="memberzx" type="radio" value="false" onclick="change('memberzx',false);" title="否" <#if !dto.memberzx> checked="checked" </#if>/></label>
            </div>
            <label class="layui-form-label">投诉建议</label>
            <div class="layui-input-inline">
                <label><input id="tsjyT" name="advice" type="radio" value="true" onclick="change('advice',true);" title="是" <#if dto.advice> checked="checked" </#if>/></label>
                <label><input id="tsjyF" name="advice" type="radio" value="false" onclick="change('advice',false);" title="否" <#if !dto.advice> checked="checked" </#if>/></label>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline">
            </div>
            <label class="layui-form-label">联系我们</label>
            <div class="layui-input-inline">
                <label><input id="lxwmT" name="isrelation" type="radio" value="true" onclick="change('isrelation',true);" title="是" <#if dto.isrelation> checked="checked" </#if>/></label>
                <label><input id="lxwmF" name="isrelation" type="radio" value="false" onclick="change('isrelation',false);" title="否" <#if !dto.isrelation> checked="checked" </#if>/></label>
            </div>
            <label class="layui-form-label">联系号码</label>
            <div class="layui-input-inline">
                <input id="input" type="text" name="phone" value="${dto.phone!}" autocomplete="off" class="layui-input">
            </div>
            <button class="layui-btn layui-btn-normal" onclick="return sure();">确定</button>
        </div>
    </div>
    <#--<div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">我的订单:</label>
            <div class="layui-input-inline">
            </div>
            <label class="layui-form-label">票卡订单</label>
            <div class="layui-input-inline">
                <label><input id="pkddT" name="pkorder" type="radio" value="true" onclick="change('pkorder',true);" title="是" <#if dto.pkorder> checked="checked" </#if>/></label>
                <label><input id="pkddF" name="pkorder" type="radio" value="false" onclick="change('pkorder',false);" title="否" <#if !dto.pkorder> checked="checked" </#if> /></label>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">我的优惠:</label>
            <div class="layui-input-inline">
            </div>
            <label class="layui-form-label">我的优惠券</label>
            <div class="layui-input-inline">
                <label><input id="wdyhjT" name="mycard" type="radio" value="true" onclick="change('mycard',true);" title="是" <#if dto.mycard> checked="checked" </#if>/></label>
                <label><input id="wdyhjF" name="mycard" type="radio" value="false" onclick="change('mycard',false);" title="否" <#if !dto.mycard> checked="checked" </#if>/></label>
            </div>
            <label class="layui-form-label">我的礼品</label>
            <div class="layui-input-inline">
                <label><input id="wdlpT" name="mypressie" type="radio"  value="true" onclick="change('mypressie',true);" title="是" <#if dto.mypressie> checked="checked" </#if>/></label>
                <label><input id="wdlpF" name="mypressie" type="radio" value="false" onclick="change('mypressie',false);" title="否" <#if !dto.mypressie> checked="checked" </#if>/></label>
            </div>
        </div>
    </div>-->
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">我的佣金:</label>
            <div class="layui-input-inline">
            </div>
            <label class="layui-form-label">可得佣金</label>
            <div class="layui-input-inline">
                <label><input id="kdyjT" name="cancommission" type="radio" value="true" onclick="change('cancommission',true);" title="是" <#if dto.cancommission> checked="checked" </#if>/></label>
                <label><input id="kdyjF" name="cancommission" type="radio" value="false" onclick="change('cancommission',false);" title="否" <#if !dto.cancommission> checked="checked" </#if>/></label>
            </div>
            <label class="layui-form-label">已得佣金</label>
            <div class="layui-input-inline">
                <label><input id="ydyjT" name="getcommission" type="radio" value="true" onclick="change('getcommission',true);" title="是" <#if dto.getcommission> checked="checked" </#if>/></label>
                <label><input id="ydyjF" name="getcommission" type="radio" value="false" onclick="change('getcommission',false);" title="否" <#if !dto.getcommission> checked="checked" </#if>/></label>
            </div>
        </div>
    </div>
</form>
<script type="text/javascript" src="${base}/bak/js/ZeroClipboard.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $("input.copy").each(function(){
            var Zero = ZeroClipboard;
            Zero.moviePath = "${base}/resources/module/shop/swf/ZeroClipboard.swf";

            var clip = new ZeroClipboard.Client();
            clip.setHandCursor(true);
            var obj = $(this);
            var id = $(this).attr("id");
            clip.glue(id);

            var txt=$("#"+id).attr("title");//设置文本框中的内容

            //鼠标移上时改变按钮的样式
            clip.addEventListener( "mouseOver", function(client) {
                obj.css("color","#FF6600");
                clip.setText(txt);
            });
            //鼠标移除时改变按钮的样式
            clip.addEventListener( "mouseOut", function(client) {
                obj.css("color","");
            });
            //这个是复制成功后的提示
            clip.addEventListener( "complete", function(){
                alert("已经复制到剪切板！\n"+txt);
            });
        });
    });
    function sure(){
        var phone = $("#input").val();
        $.ajax({
            type: "post",
            url: "save?aid=${dto.authorizer!}&type=false&age=null&phone="+phone,
            success: function(msg){
                if(msg==1){
                    window.location.reload();
                }
            }
        });
        return false;
    }

    function change(age,bool){
        var phone = $("#input").val();
        $.ajax({
            type: "post",
            url: "save?aid=${dto.authorizer!}&type="+bool+"&age="+age+"&phone="+phone,
            success: function(msg){
                if(msg==1){

                }
            }
        });

    }
</script>
</body>
</html>