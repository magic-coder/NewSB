<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>添加</title>

<#include "/include/common_header_include.ftl">

</head>
<body>
<form class="layui-form" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <label class="layui-form-label">活动名称</label>
        <div class="layui-input-inline">
            <input name="name" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
    </div>
    <input type="hidden" name="subscribe" value="true"/>
    <div class="layui-form-item">
        <label class="layui-form-label">连续签到</label>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="checkbox" name="state_1" value="1" lay-skin="switch" lay-filter="state_1" lay-text="启用|禁用" checked>
        </div>
        <div class="layui-input-inline" style="width:90px;">
            <input id="signDate_1" name="signDate" lay-verify="signDate" autocomplete="off" class="layui-input" placeholder="签到多少天">
        </div>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="hidden" name="prizeWeight" value="1"/>
            <input type="checkbox" name="isPrize_1" value="1" lay-skin="switch" lay-filter="switch_1" lay-text="领券|物品" checked>
        </div>
        <div class="layui-input-inline" style="width: 150px;">
            <input id="prizeName_1" name="prizeName" lay-verify="required" autocomplete="off" class="layui-input" placeholder="奖品名称">
        </div>
        <div class="layui-input-inline" style="width: 60px;">
            <input id="prizeAmount_1" name="prizeAmount" lay-verify="maxStock" autocomplete="off" class="layui-input" placeholder="库存">
        </div>
        <div class="layui-input-inline" style="width: 300px;" id="selectProduct_1">
            <input id="productName_1" name="productName" lay-verify="required" style="display: inline;width: 190px;" class="layui-input" placeholder="实体奖品不选" readonly>
            <input type="hidden" id="productId_1" name="product"/>
            <input type="button" class="layui-btn" style="margin-top: -5px;" onclick="selectProduct(1);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label"></label>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="checkbox" name="state_2" value="2" lay-skin="switch" lay-filter="state_2" lay-text="启用|禁用" checked>
        </div>
        <div class="layui-input-inline" style="width:90px;">
            <input id="signDate_2" name="signDate" lay-verify="signDate" autocomplete="off" class="layui-input" placeholder="签到多少天">
        </div>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="hidden" name="prizeWeight" value="2"/>
            <input type="checkbox" name="isPrize_2" value="2" lay-skin="switch" lay-filter="switch_2" lay-text="领券|物品" checked>
        </div>
        <div class="layui-input-inline" style="width: 150px;">
            <input id="prizeName_2" name="prizeName" lay-verify="required" autocomplete="off" class="layui-input" placeholder="奖品名称">
        </div>
        <div class="layui-input-inline" style="width: 60px;">
            <input id="prizeAmount_2" name="prizeAmount" lay-verify="maxStock" autocomplete="off" class="layui-input" placeholder="库存">
        </div>
        <div class="layui-input-inline" style="width: 300px;" id="selectProduct_2">
            <input id="productName_2" name="productName" lay-verify="required" style="display: inline;width: 190px;" class="layui-input" placeholder="实体奖品不选" readonly>
            <input type="hidden" id="productId_2" name="product"/>
            <input type="button" class="layui-btn" style="margin-top: -5px;" onclick="selectProduct(2);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label"></label>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="checkbox" name="state_3" value="3" lay-skin="switch" lay-filter="state_3" lay-text="启用|禁用" checked>
        </div>
        <div class="layui-input-inline" style="width:90px;">
            <input id="signDate_3" name="signDate" lay-verify="signDate" autocomplete="off" class="layui-input" placeholder="签到多少天">
        </div>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="hidden" name="prizeWeight" value="3"/>
            <input type="checkbox" name="isPrize_3" value="3" lay-skin="switch" lay-filter="switch_3" lay-text="领券|物品" checked>
        </div>
        <div class="layui-input-inline" style="width: 150px;">
            <input id="prizeName_3" name="prizeName" lay-verify="required" autocomplete="off" class="layui-input" placeholder="奖品名称">
        </div>
        <div class="layui-input-inline" style="width: 60px;">
            <input id="prizeAmount_3" name="prizeAmount" lay-verify="maxStock" autocomplete="off" class="layui-input" placeholder="库存">
        </div>
        <div class="layui-input-inline" style="width: 300px;" id="selectProduct_3">
            <input id="productName_3" name="productName" lay-verify="required" style="display: inline;width: 190px;" class="layui-input" placeholder="实体奖品不选" readonly>
            <input type="hidden" id="productId_3" name="product"/>
            <input type="button" class="layui-btn" style="margin-top: -5px;" onclick="selectProduct(3);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label"></label>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="checkbox" name="state_4" value="4" lay-skin="switch" lay-filter="state_4" lay-text="启用|禁用">
        </div>
        <div class="layui-input-inline" style="width:90px;">
            <input id="signDate_4" name="signDate" autocomplete="off" class="layui-input" placeholder="签到多少天">
        </div>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="hidden" name="prizeWeight" value="4"/>
            <input type="checkbox" name="isPrize_4" value="4" lay-skin="switch" lay-filter="switch_4" lay-text="领券|物品" checked>
        </div>
        <div class="layui-input-inline" style="width: 150px;">
            <input id="prizeName_4" name="prizeName" autocomplete="off" class="layui-input" placeholder="奖品名称">
        </div>
        <div class="layui-input-inline" style="width: 60px;">
            <input id="prizeAmount_4" name="prizeAmount" autocomplete="off" class="layui-input" placeholder="库存">
        </div>
        <div class="layui-input-inline" style="width: 300px;" id="selectProduct_4">
            <input id="productName_4" name="productName" style="display: inline;width: 190px;" class="layui-input" placeholder="实体奖品不选" readonly>
            <input type="hidden" id="productId_4" name="product"/>
            <input type="button" class="layui-btn" style="margin-top: -5px;" onclick="selectProduct(4);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label"></label>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="checkbox" name="state_5" value="5" lay-skin="switch" lay-filter="state_5" lay-text="启用|禁用">
        </div>
        <div class="layui-input-inline" style="width:90px;">
            <input id="signDate_5" name="signDate" autocomplete="off" class="layui-input" placeholder="签到多少天">
        </div>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="hidden" name="prizeWeight" value="5"/>
            <input type="checkbox" name="isPrize_5" value="5" lay-skin="switch" lay-filter="switch_5" lay-text="领券|物品" checked>
        </div>
        <div class="layui-input-inline" style="width: 150px;">
            <input id="prizeName_5" name="prizeName" autocomplete="off" class="layui-input" placeholder="奖品名称">
        </div>
        <div class="layui-input-inline" style="width: 60px;">
            <input id="prizeAmount_5" name="prizeAmount" autocomplete="off" class="layui-input" placeholder="库存">
        </div>
        <div class="layui-input-inline" style="width: 300px;" id="selectProduct_5">
            <input id="productName_5" name="productName" style="display: inline;width: 190px;" class="layui-input" placeholder="实体奖品不选" readonly>
            <input type="hidden" id="productId_5" name="product"/>
            <input type="button" class="layui-btn" style="margin-top: -5px;" onclick="selectProduct(5);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">累计签到</label>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="checkbox" name="state_6" value="6" lay-skin="switch" lay-filter="state_6" lay-text="启用|禁用" checked>
        </div>
        <div class="layui-input-inline" style="width:90px;">
            <input id="signDate_6" name="signDate" lay-verify="signDate" autocomplete="off" class="layui-input" placeholder="签到多少天">
        </div>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="hidden" name="prizeWeight" value="6"/>
            <input type="checkbox" name="isPrize_6" value="6" lay-skin="switch" lay-filter="switch_6" lay-text="领券|物品" checked>
        </div>
        <div class="layui-input-inline" style="width: 150px;">
            <input id="prizeName_6" name="prizeName" lay-verify="required" autocomplete="off" class="layui-input" placeholder="奖品名称">
        </div>
        <div class="layui-input-inline" style="width: 60px;">
            <input id="prizeAmount_6" name="prizeAmount" lay-verify="maxStock" autocomplete="off" class="layui-input" placeholder="库存">
        </div>
        <div class="layui-input-inline" style="width: 300px;" id="selectProduct_6">
            <input id="productName_6" name="productName" lay-verify="required" style="display: inline;width: 190px;" class="layui-input" placeholder="实体奖品不选" readonly>
            <input type="hidden" id="productId_6" name="product"/>
            <input type="button" class="layui-btn" style="margin-top: -5px;" onclick="selectProduct(6);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label"></label>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="checkbox" name="state_7" value="7" lay-skin="switch" lay-filter="state_7" lay-text="启用|禁用" checked>
        </div>
        <div class="layui-input-inline" style="width:90px;">
            <input id="signDate_7" name="signDate" lay-verify="signDate" autocomplete="off" class="layui-input" placeholder="签到多少天">
        </div>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="hidden" name="prizeWeight" value="7"/>
            <input type="checkbox" name="isPrize_7" value="7" lay-skin="switch" lay-filter="switch_7" lay-text="领券|物品" checked>
        </div>
        <div class="layui-input-inline" style="width: 150px;">
            <input id="prizeName_7" name="prizeName" lay-verify="required" autocomplete="off" class="layui-input" placeholder="奖品名称">
        </div>
        <div class="layui-input-inline" style="width: 60px;">
            <input id="prizeAmount_7" name="prizeAmount" lay-verify="maxStock" autocomplete="off" class="layui-input" placeholder="库存">
        </div>
        <div class="layui-input-inline" style="width: 300px;" id="selectProduct_7">
            <input id="productName_7" name="productName" lay-verify="required" style="display: inline;width: 190px;" class="layui-input" placeholder="实体奖品不选" readonly>
            <input type="hidden" id="productId_7" name="product"/>
            <input type="button" class="layui-btn" style="margin-top: -5px;" onclick="selectProduct(7);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label"></label>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="checkbox" name="state_8" value="8" lay-skin="switch" lay-filter="state_8" lay-text="启用|禁用">
        </div>
        <div class="layui-input-inline" style="width:90px;">
            <input id="signDate_8" name="signDate" autocomplete="off" class="layui-input" placeholder="签到多少天">
        </div>
        <div class="layui-input-inline" style="width: 50px;">
            <input type="hidden" name="prizeWeight" value="8"/>
            <input type="checkbox" name="isPrize_8" value="8" lay-skin="switch" lay-filter="switch_8" lay-text="领券|物品" checked>
        </div>
        <div class="layui-input-inline" style="width: 150px;">
            <input id="prizeName_8" name="prizeName" autocomplete="off" class="layui-input" placeholder="奖品名称">
        </div>
        <div class="layui-input-inline" style="width: 60px;">
            <input id="prizeAmount_8" name="prizeAmount" autocomplete="off" class="layui-input" placeholder="库存">
        </div>
        <div class="layui-input-inline" style="width: 300px;" id="selectProduct_8">
            <input id="productName_8" name="productName" style="display: inline;width: 190px;" class="layui-input" placeholder="实体奖品不选" readonly>
            <input type="hidden" id="productId_8" name="product"/>
            <input type="button" class="layui-btn" style="margin-top: -5px;" onclick="selectProduct(8);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">分享标题</label>
        <div class="layui-input-inline">
            <input name="title" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label">分享链接</label>
        <div class="layui-input-inline">
            <input name="link" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">分享描述</label>
        <div class="layui-input-inline">
            <input name="descval" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label">分享图标</label>
        <div class="layui-input-inline" style="width: 400px;">
            <input id="imgurl" name="imgurl" style="width: 190px;display: inline;" autocomplete="off" class="layui-input">
            <input id="uploadImage" type="button" style="margin-top: -3px;" class="layui-btn" value="上传图片">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">活动时间</label>
        <div class="layui-input-inline">
            <input id="startDate" name="startDate" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <div class="layui-form-mid">-</div>
        <div class="layui-input-inline">
            <input id="endDate" name="endDate" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <div class="layui-form-mid"><span style="color:red;">凌晨0:00结束</span></div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品有效期</label>
        <div class="layui-input-inline">
            <input id="prizeBeginDate" name="prizeBeginDate" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <div class="layui-form-mid">-</div>
        <div class="layui-input-inline">
            <input id="prizeEndDate" name="prizeEndDate" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
    </div>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">使用说明</label>
        <div class="layui-input-block">
            <textarea id="demo"  style="display: none;"></textarea>
            <input id="content" name="content" type="hidden" value=""/>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
<script type="text/javascript">
    layui.use(['form', 'table', 'laydate','layedit','upload'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
        var layedit = layui.layedit;
        var upload = layui.upload;

        laydate.render({elem: "#startDate"});
        laydate.render({elem: "#endDate"});
        laydate.render({elem: "#prizeBeginDate"});
        laydate.render({elem: "#prizeEndDate"});

        layedit.set({
            uploadImage: {
                url: '${base}/file/upload?fileType=image&token='+getCookie("token") //接口url
                ,type: 'post' //默认post
            }
        });
        index = layedit.build('demo'); //建立编辑器
        form = layui.form;
        form.on('submit(submit)', function(data){
            $("#content").val(layedit.getContent(index));
            console.log(data.elem); //被执行事件的元素DOM对象，一般为button对象
            console.log(data.form); //被执行提交的form对象，一般在存在form标签时才会返回
            console.log(data.field); //当前容器的全部表单字段，名值对形式：{name: value}
            //return false;
        });
        //验证
        form.verify({
            signDate: [/^[1-9]\d*$/,"请输入正确的天数"],
            maxStock: [/^[1-9]\d*$/, "请填写正确的库存！"]
        });
        var state_1 = true;
        form.on('switch(state_1)', function(data){
            if(state_1){
                $("#signDate_1").attr("lay-verify", "");
                $("#prizeName_1").attr("lay-verify", "");
                $("#prizeAmount_1").attr("lay-verify", "");
                $("#productName_1").attr("lay-verify", "");
                state_1 = false;
            }else{
                $("#signDate_1").attr("lay-verify", "signDate");
                $("#prizeName_1").attr("lay-verify", "required");
                $("#prizeAmount_1").attr("lay-verify", "maxStock");
                var isPrize_1 = $('input[name="isPrize_1"]').is(":checked");
                if(isPrize_1){
                    $("#productName_1").attr("lay-verify", "required");
                }else{
                    $("#productName_1").attr("lay-verify", "");
                }
                state_1 = true;
            }
        });
        var state_2 = true;
        form.on('switch(state_2)', function(data){
            if(state_2){
                $("#signDate_2").attr("lay-verify", "");
                $("#prizeName_2").attr("lay-verify", "");
                $("#prizeAmount_2").attr("lay-verify", "");
                $("#productName_2").attr("lay-verify", "");
                state_2 = false;
            }else{
                $("#signDate_2").attr("lay-verify", "signDate");
                $("#prizeName_2").attr("lay-verify", "required");
                $("#prizeAmount_2").attr("lay-verify", "maxStock");
                var isPrize_2 = $('input[name="isPrize_2"]').is(":checked");
                if(isPrize_2){
                    $("#productName_2").attr("lay-verify", "required");
                }else{
                    $("#productName_2").attr("lay-verify", "");
                }
                state_2 = true;
            }
        });
        var state_3 = true;
        form.on('switch(state_3)', function(data){
            if(state_3){
                $("#signDate_3").attr("lay-verify", "");
                $("#prizeName_3").attr("lay-verify", "");
                $("#prizeAmount_3").attr("lay-verify", "");
                $("#productName_3").attr("lay-verify", "");
                state_3 = false;
            }else{
                $("#signDate_3").attr("lay-verify", "signDate");
                $("#prizeName_3").attr("lay-verify", "required");
                $("#prizeAmount_3").attr("lay-verify", "maxStock");
                var isPrize_3 = $('input[name="isPrize_3"]').is(":checked");
                if(isPrize_3){
                    $("#productName_3").attr("lay-verify", "required");
                }else{
                    $("#productName_3").attr("lay-verify", "");
                }
                state_3 = true;
            }
        });
        var state_4 = false;
        form.on('switch(state_4)', function(data){
            if(state_4){
                $("#signDate_4").attr("lay-verify", "");
                $("#prizeName_4").attr("lay-verify", "");
                $("#prizeAmount_4").attr("lay-verify", "");
                $("#productName_4").attr("lay-verify", "");
                state_4 = false;
            }else{
                $("#signDate_4").attr("lay-verify", "signDate");
                $("#prizeName_4").attr("lay-verify", "required");
                $("#prizeAmount_4").attr("lay-verify", "maxStock");
                var isPrize_4 = $('input[name="isPrize_4"]').is(":checked");
                if(isPrize_4){
                    $("#productName_4").attr("lay-verify", "required");
                }else{
                    $("#productName_4").attr("lay-verify", "");
                }
                state_4 = true;
            }
        });
        var state_5 = false;
        form.on('switch(state_5)', function(data){
            if(state_5){
                $("#signDate_5").attr("lay-verify", "");
                $("#prizeName_5").attr("lay-verify", "");
                $("#prizeAmount_5").attr("lay-verify", "");
                $("#productName_5").attr("lay-verify", "");
                state_5 = false;
            }else{
                $("#signDate_5").attr("lay-verify", "signDate");
                $("#prizeName_5").attr("lay-verify", "required");
                $("#prizeAmount_5").attr("lay-verify", "maxStock");
                var isPrize_5 = $('input[name="isPrize_5"]').is(":checked");
                if(isPrize_5){
                    $("#productName_5").attr("lay-verify", "required");
                }else{
                    $("#productName_5").attr("lay-verify", "");
                }
                state_5 = true;
            }
        });
        var state_6 = true;
        form.on('switch(state_6)', function(data){
            if(state_6){
                $("#signDate_6").attr("lay-verify", "");
                $("#prizeName_6").attr("lay-verify", "");
                $("#prizeAmount_6").attr("lay-verify", "");
                $("#productName_6").attr("lay-verify", "");
                state_6 = false;
            }else{
                $("#signDate_6").attr("lay-verify", "signDate");
                $("#prizeName_6").attr("lay-verify", "required");
                $("#prizeAmount_6").attr("lay-verify", "maxStock");
                var isPrize_6 = $('input[name="isPrize_6"]').is(":checked");
                if(isPrize_6){
                    $("#productName_6").attr("lay-verify", "required");
                }else{
                    $("#productName_6").attr("lay-verify", "");
                }
                state_6 = true;
            }
        });
        var state_7 = true;
        form.on('switch(state_7)', function(data){
            if(state_7){
                $("#signDate_7").attr("lay-verify", "");
                $("#prizeName_7").attr("lay-verify", "");
                $("#prizeAmount_7").attr("lay-verify", "");
                $("#productName_7").attr("lay-verify", "");
                state_7 = false;
            }else{
                $("#signDate_7").attr("lay-verify", "signDate");
                $("#prizeName_7").attr("lay-verify", "required");
                $("#prizeAmount_7").attr("lay-verify", "maxStock");
                var isPrize_7 = $('input[name="isPrize_7"]').is(":checked");
                if(isPrize_7){
                    $("#productName_7").attr("lay-verify", "required");
                }else{
                    $("#productName_7").attr("lay-verify", "");
                }
                state_7 = true;
            }
        });
        var state_8 = false;
        form.on('switch(state_8)', function(data){
            if(state_8){
                $("#signDate_8").attr("lay-verify", "");
                $("#prizeName_8").attr("lay-verify", "");
                $("#prizeAmount_8").attr("lay-verify", "");
                $("#productName_8").attr("lay-verify", "");
                state_8 = false;
            }else{
                $("#signDate_8").attr("lay-verify", "signDate");
                $("#prizeName_8").attr("lay-verify", "required");
                $("#prizeAmount_8").attr("lay-verify", "maxStock");
                var isPrize_8 = $('input[name="isPrize_8"]').is(":checked");
                if(isPrize_8){
                    $("#productName_8").attr("lay-verify", "required");
                }else{
                    $("#productName_8").attr("lay-verify", "");
                }
                state_8 = true;
            }
        });
        var switch_show_1 = true;
        form.on('switch(switch_1)', function(data){
            //alert(data.elem.value);
            if(switch_show_1){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_1").attr("lay-verify", "");
                switch_show_1 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                var pstate_1 = $('input[name="state_1"]').is(":checked");
                if(pstate_1){
                    $("#productName_1").attr("lay-verify", "required");
                }else{
                    $("#productName_1").attr("lay-verify", "");
                }
                switch_show_1 = true;
            }
        });
        var switch_show_2 = true;
        form.on('switch(switch_2)', function(data){
            if(switch_show_2){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_2").attr("lay-verify", "");
                switch_show_2 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                var pstate_2 = $('input[name="state_2"]').is(":checked");
                if(pstate_2){
                    $("#productName_2").attr("lay-verify", "required");
                }else{
                    $("#productName_2").attr("lay-verify", "");
                }
                switch_show_2 = true;
            }
        });
        var switch_show_3 = true;
        form.on('switch(switch_3)', function(data){
            if(switch_show_3){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_3").attr("lay-verify", "");
                switch_show_3 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                var pstate_3 = $('input[name="state_3"]').is(":checked");
                if(pstate_3){
                    $("#productName_3").attr("lay-verify", "required");
                }else{
                    $("#productName_3").attr("lay-verify", "");
                }
                switch_show_3 = true;
            }
        });
        var switch_show_4 = true;
        form.on('switch(switch_4)', function(data){
            if(switch_show_4){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_4").attr("lay-verify", "");
                switch_show_4 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                var pstate_4 = $('input[name="state_4"]').is(":checked");
                if(pstate_4){
                    $("#productName_4").attr("lay-verify", "required");
                }else{
                    $("#productName_4").attr("lay-verify", "");
                }
                switch_show_4 = true;
            }
        });
        var switch_show_5 = true;
        form.on('switch(switch_5)', function(data){
            if(switch_show_5){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_5").attr("lay-verify", "");
                switch_show_5 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                var pstate_5 = $('input[name="state_5"]').is(":checked");
                if(pstate_5){
                    $("#productName_5").attr("lay-verify", "required");
                }else{
                    $("#productName_5").attr("lay-verify", "");
                }
                switch_show_5 = true;
            }
        });
        var switch_show_6 = true;
        form.on('switch(switch_6)', function(data){
            if(switch_show_6){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_6").attr("lay-verify", "");
                switch_show_6 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                var pstate_6 = $('input[name="state_6"]').is(":checked");
                if(pstate_6){
                    $("#productName_6").attr("lay-verify", "required");
                }else{
                    $("#productName_6").attr("lay-verify", "");
                }
                switch_show_6 = true;
            }
        });
        var switch_show_7 = true;
        form.on('switch(switch_7)', function(data){
            if(switch_show_7){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_7").attr("lay-verify", "");
                switch_show_7 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                var pstate_7 = $('input[name="state_7"]').is(":checked");
                if(pstate_7){
                    $("#productName_7").attr("lay-verify", "required");
                }else{
                    $("#productName_7").attr("lay-verify", "");
                }
                switch_show_7 = true;
            }
        });
        var switch_show_8 = true;
        form.on('switch(switch_8)', function(data){
            if(switch_show_8){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_8").attr("lay-verify", "");
                switch_show_8 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                var pstate_8 = $('input[name="state_8"]').is(":checked");
                if(pstate_8){
                    $("#productName_8").attr("lay-verify", "required");
                }else{
                    $("#productName_8").attr("lay-verify", "");
                }
                switch_show_8 = true;
            }
        });
        upload.render({
            elem: '#uploadImage',
            url: '${base}/file/upload?fileType=image&token=' + getCookie("token"),
            done: function (res) {
                //如果上传失败
                if (res.code > 0) {
                    return layer.msg('上传失败');
                }
                //上传成功
                $("#imgurl").val(res.data);
            },
            error: function () {
                //请求异常回调
                alert("异常!!!");
            }
        });
        form.render(); //更新全部
    });
    function selectProduct(e){
        var index = layer.open({
            type: 2,
            title: '选择产品',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'couponlist?num='+e
        });
    }
</script>
</body>
</html>