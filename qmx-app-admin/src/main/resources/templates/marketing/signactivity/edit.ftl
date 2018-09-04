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
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <label class="layui-form-label">活动名称</label>
        <div class="layui-input-inline">
            <input name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.name!}">
        </div>
    </div>
    <input type="hidden" name="subscribe" value="true"/>
    <#assign a = true >
    <#assign b = true >
    <#list dto.prizes as prize>
        <#if prize.weight lt 6 >
            <#if a>
                <div class="layui-form-item">
                    <label class="layui-form-label">连续签到</label>
                    <div class="layui-input-inline" style="width:130px;">
                        <label class="layui-form-label" style="width: 30px;">天数</label>
                        <input id="signDate_${prize.weight!}" style="width: 65px;" name="signDate" value="${dto.rules[prize_index].signNum!}" lay-verify="signDate" autocomplete="off" class="layui-input" placeholder="签到多少天">
                    </div>
                    <div class="layui-input-inline" style="width: 50px;">
                        <input type="hidden" name="prizeWeight" value="${prize.weight!}"/>
                        <input type="hidden" name="isNull_${prize.weight!}" value="${prize.weight!}"/>
                        <input type="checkbox" name="isPrize_${prize.weight!}" value="${prize.weight!}" lay-skin="switch" lay-filter="switch_${prize.weight!}" lay-text="领券|物品" <#if prize.product??>checked</#if> >
                    </div>
                    <div class="layui-input-inline" style="width: 180px;">
                        <label class="layui-form-label" style="width: 30px;">奖品</label>
                        <input id="prizeName_${prize.weight!}" style="width: 110px;" name="prizeName" value="${prize.name!}" lay-verify="required" autocomplete="off" class="layui-input" placeholder="奖品名称">
                    </div>
                    <div class="layui-input-inline" style="width: 110px;">
                        <label class="layui-form-label" style="width: 30px;padding-left: 0px;">库存</label>
                        <input id="prizeAmount_${prize.weight!}" style="width: 50px;" name="prizeAmount" value="${prize.amount!}" lay-verify="maxStock" autocomplete="off" class="layui-input" placeholder="库存">
                    </div>
                    <div class="layui-input-inline" style="width: 300px; <#if !prize.product??> display: none;</#if>" id="selectProduct_${prize.weight!}">
                        <input id="productName_${prize.weight!}" name="productName" value="${prize.productName!}" <#if prize.product??> lay-verify="required" </#if> style="display: inline;width: 190px;" class="layui-input" placeholder="实体奖品不选" readonly>
                        <input type="hidden" id="productId_${prize.weight!}" name="product" value="${prize.product!}"/>
                        <input type="button" class="layui-btn" style="margin-top: -5px;" onclick="selectProduct(${prize.weight!});" value="选择优惠券">
                    </div>
                </div>
            <#else>
                <div class="layui-form-item">
                    <label class="layui-form-label"></label>
                    <div class="layui-input-inline" style="width:130px;">
                        <label class="layui-form-label" style="width: 30px;">天数</label>
                        <input id="signDate_${prize.weight!}" name="signDate" value="${dto.rules[prize_index].signNum!}" style="width: 65px;" lay-verify="signDate" autocomplete="off" class="layui-input" placeholder="签到多少天">
                    </div>
                    <div class="layui-input-inline" style="width: 50px;">
                        <input type="hidden" name="prizeWeight" value="${prize.weight!}"/>
                        <input type="hidden" name="isNull_${prize.weight!}" value="${prize.weight!}"/>
                        <input type="checkbox" name="isPrize_${prize.weight!}" value="${prize.weight!}" lay-skin="switch" lay-filter="switch_${prize.weight!}" lay-text="领券|物品"  <#if prize.product??>checked</#if> >
                    </div>
                    <div class="layui-input-inline" style="width: 180px;">
                        <label class="layui-form-label" style="width: 30px;">奖品</label>
                        <input id="prizeName_${prize.weight!}" name="prizeName" value="${prize.name!}" style="width: 110px;" lay-verify="required" autocomplete="off" class="layui-input" placeholder="奖品名称">
                    </div>
                    <div class="layui-input-inline" style="width: 110px;">
                        <label class="layui-form-label" style="width: 30px;padding-left: 0px;">库存</label>
                        <input id="prizeAmount_${prize.weight!}" name="prizeAmount" value="${prize.amount!}" style="width: 50px;" lay-verify="maxStock" autocomplete="off" class="layui-input" placeholder="库存">
                    </div>
                    <div class="layui-input-inline" style="width: 300px; <#if !prize.product??> display: none;</#if>" id="selectProduct_${prize.weight!}">
                        <input id="productName_${prize.weight!}" name="productName" value="${prize.productName!}" <#if prize.product??> lay-verify="required"</#if> style="display: inline;width: 190px;" class="layui-input" placeholder="实体奖品不选" readonly>
                        <input type="hidden" id="productId_${prize.weight!}" name="product" value="${prize.product!}"/>
                        <input type="button" class="layui-btn" style="margin-top: -5px;" onclick="selectProduct(${prize.weight!});" value="选择优惠券">
                    </div>
                </div>
            </#if>
            <#assign a = false >
        <#else>
            <#if b>
                <div class="layui-form-item">
                    <label class="layui-form-label">累计签到</label>
                    <div class="layui-input-inline" style="width:130px;">
                        <label class="layui-form-label" style="width: 30px;">天数</label>
                        <input id="signDate_${prize.weight!}" name="signDate" value="${dto.rules[prize_index].signNum!}" style="width: 65px;" lay-verify="signDate" autocomplete="off" class="layui-input" placeholder="签到多少天">
                    </div>
                    <div class="layui-input-inline" style="width: 50px;">
                        <input type="hidden" name="prizeWeight" value="${prize.weight!}"/>
                        <input type="hidden" name="isNull_${prize.weight!}" value="${prize.weight!}"/>
                        <input type="checkbox" name="isPrize_${prize.weight!}" value="${prize.weight!}" lay-skin="switch" lay-filter="switch_${prize.weight!}" lay-text="领券|物品"  <#if prize.product??>checked</#if> >
                    </div>
                    <div class="layui-input-inline" style="width: 180px;">
                        <label class="layui-form-label" style="width: 30px;">奖品</label>
                        <input id="prizeName_${prize.weight!}" name="prizeName" value="${prize.name!}" style="width: 110px;" lay-verify="required" autocomplete="off" class="layui-input" placeholder="奖品名称">
                    </div>
                    <div class="layui-input-inline" style="width: 110px;">
                        <label class="layui-form-label" style="width: 30px;padding-left: 0px;">库存</label>
                        <input id="prizeAmount_${prize.weight!}" name="prizeAmount" value="${prize.amount!}" style="width: 50px;" lay-verify="maxStock" autocomplete="off" class="layui-input" placeholder="库存">
                    </div>
                    <div class="layui-input-inline" style="width: 300px; <#if !prize.product??> display: none;</#if>" id="selectProduct_${prize.weight!}">
                        <input id="productName_${prize.weight!}" name="productName" value="${prize.productName!}" <#if prize.product??> lay-verify="required"</#if> style="display: inline;width: 190px;" class="layui-input" placeholder="实体奖品不选" readonly>
                        <input type="hidden" id="productId_${prize.weight!}" name="product" value="${prize.product!}"/>
                        <input type="button" class="layui-btn" style="margin-top: -5px;" onclick="selectProduct(${prize.weight!});" value="选择优惠券">
                    </div>
                </div>
            <#else>
                <div class="layui-form-item">
                    <label class="layui-form-label"></label>
                    <div class="layui-input-inline" style="width:130px;">
                        <label class="layui-form-label" style="width: 30px;">天数</label>
                        <input id="signDate_${prize.weight!}" name="signDate" value="${dto.rules[prize_index].signNum!}" style="width: 65px;" lay-verify="signDate" autocomplete="off" class="layui-input" placeholder="签到多少天">
                    </div>
                    <div class="layui-input-inline" style="width: 50px;">
                        <input type="hidden" name="prizeWeight" value="${prize.weight!}"/>
                        <input type="hidden" name="isNull_${prize.weight!}" value="${prize.weight!}"/>
                        <input type="checkbox" name="isPrize_${prize.weight!}" value="${prize.weight!}" lay-skin="switch" lay-filter="switch_${prize.weight!}" lay-text="领券|物品"  <#if prize.product??>checked</#if> >
                    </div>
                    <div class="layui-input-inline" style="width: 180px;">
                        <label class="layui-form-label" style="width: 30px;">奖品</label>
                        <input id="prizeName_${prize.weight!}" name="prizeName" value="${prize.name!}" style="width: 110px;" lay-verify="required" autocomplete="off" class="layui-input" placeholder="奖品名称">
                    </div>
                    <div class="layui-input-inline" style="width: 110px;">
                        <label class="layui-form-label" style="width: 30px;padding-left: 0px;">库存</label>
                        <input id="prizeAmount_${prize.weight!}" name="prizeAmount" value="${prize.amount!}" style="width: 50px;" lay-verify="maxStock" autocomplete="off" class="layui-input" placeholder="库存">
                    </div>
                    <div class="layui-input-inline" style="width: 300px; <#if !prize.product??> display: none;</#if>" id="selectProduct_${prize.weight!}">
                        <input id="productName_${prize.weight!}" name="productName" value="${prize.productName!}" <#if prize.product??> lay-verify="required"</#if> style="display: inline;width: 190px;" class="layui-input" placeholder="实体奖品不选" readonly>
                        <input type="hidden" id="productId_${prize.weight!}" name="product" value="${prize.product!}"/>
                        <input type="button" class="layui-btn" style="margin-top: -5px;" onclick="selectProduct(${prize.weight!});" value="选择优惠券">
                    </div>
                </div>
            </#if>
            <#assign b = false >
        </#if>
    </#list>
    <div class="layui-form-item">
        <label class="layui-form-label">分享标题</label>
        <div class="layui-input-inline">
            <input name="title" value="${dto.title!}" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label">分享链接</label>
        <div class="layui-input-inline">
            <input name="link" value="${dto.link!}" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">分享描述</label>
        <div class="layui-input-inline">
            <input name="descval" value="${dto.descval!}" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label">分享图标</label>
        <div class="layui-input-inline" style="width: 400px;">
            <input id="imgurl" name="imgurl" value="${dto.imgurl!}" style="width: 190px;display: inline;" autocomplete="off" class="layui-input">
            <input id="uploadImage" type="button" style="margin-top: -3px;" class="layui-btn" value="上传图片">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">活动时间</label>
        <div class="layui-input-inline">
            <input id="startDate" name="startDate" lay-verify="required" autocomplete="off" class="layui-input"
                   value="${dto.startDate!?string("yyyy-MM-dd")}">
        </div>
        <div class="layui-form-mid">-</div>
        <div class="layui-input-inline">
            <input id="endDate" name="endDate" lay-verify="required" autocomplete="off" class="layui-input"
                   value="${dto.endDate!?string("yyyy-MM-dd")}">
        </div>
        <div class="layui-form-mid"><span style="color:red;">凌晨0:00结束</span></div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品有效期</label>
        <div class="layui-input-inline">
            <input id="prizeBeginDate" name="prizeBeginDate" lay-verify="required" autocomplete="off" class="layui-input"
                   value="${dto.prizeBeginDate!?string("yyyy-MM-dd")}">
        </div>
        <div class="layui-form-mid">-</div>
        <div class="layui-input-inline">
            <input id="prizeEndDate" name="prizeEndDate" lay-verify="required" autocomplete="off" class="layui-input"
                   value="${dto.prizeEndDate!?string("yyyy-MM-dd")}">
        </div>
        <div class="layui-form-mid"><span style="color:red;">凌晨0:00结束</span></div>
    </div>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">使用说明</label>
        <div class="layui-input-block">
            <textarea id="demo"  style="display: none;">${dto.content!}</textarea>
            <input id="content" name="content" type="hidden" value="${dto.content!}"/>
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
        //验证
        form.verify({
            signDate: [/^[1-9]\d*$/,"请输入正确的天数"],
            maxStock: [/^[1-9]\d*$/, "请填写正确的库存！"]
        });

        var switch_show_1 = true;
        var show_1 = $('input[name="isPrize_1"]').is(":checked");
        if(!show_1){
            switch_show_1 = false;
        }
        form.on('switch(switch_1)', function(data){
            //alert(data.elem.value);
            if(switch_show_1){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_1").attr("lay-verify", "");
                switch_show_1 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                $("#productName_1").attr("lay-verify", "required");
                switch_show_1 = true;
            }
        });
        var switch_show_2 = true;
        var show_2 = $('input[name="isPrize_2"]').is(":checked");
        if(!show_2){
            switch_show_2 = false;
        }
        form.on('switch(switch_2)', function(data){
            if(switch_show_2){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_2").attr("lay-verify", "");
                switch_show_2 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                $("#productName_2").attr("lay-verify", "required");
                switch_show_2 = true;
            }
        });
        var switch_show_3 = true;
        var show_3 = $('input[name="isPrize_3"]').is(":checked");
        if(!show_3){
            switch_show_3 = false;
        }
        form.on('switch(switch_3)', function(data){
            if(switch_show_3){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_3").attr("lay-verify", "");
                switch_show_3 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                $("#productName_3").attr("lay-verify", "required");
                switch_show_3 = true;
            }
        });
        var switch_show_4 = true;
        var show_4 = $('input[name="isPrize_4"]').is(":checked");
        if(!show_4){
            switch_show_4 = false;
        }
        form.on('switch(switch_4)', function(data){
            if(switch_show_4){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_4").attr("lay-verify", "");
                switch_show_4 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                $("#productName_4").attr("lay-verify", "required");
                switch_show_4 = true;
            }
        });
        var switch_show_5 = true;
        var show_5 = $('input[name="isPrize_5"]').is(":checked");
        if(!show_5){
            switch_show_5 = false;
        }
        form.on('switch(switch_5)', function(data){
            if(switch_show_5){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_5").attr("lay-verify", "");
                switch_show_5 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                $("#productName_5").attr("lay-verify", "required");
                switch_show_5 = true;
            }
        });
        var switch_show_6 = true;
        var show_6 = $('input[name="isPrize_6"]').is(":checked");
        if(!show_6){
            switch_show_6 = false;
        }
        form.on('switch(switch_6)', function(data){
            if(switch_show_6){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_6").attr("lay-verify", "");
                switch_show_6 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                $("#productName_6").attr("lay-verify", "required");
                switch_show_6 = true;
            }
        });
        var switch_show_7 = true;
        var show_7 = $('input[name="isPrize_7"]').is(":checked");
        if(!show_7){
            switch_show_7 = false;
        }
        form.on('switch(switch_7)', function(data){
            if(switch_show_7){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_7").attr("lay-verify", "");
                switch_show_7 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                $("#productName_7").attr("lay-verify", "required");
                switch_show_7 = true;
            }
        });
        var switch_show_8 = true;
        var show_8 = $('input[name="isPrize_8"]').is(":checked");
        if(!show_8){
            switch_show_8 = false;
        }
        form.on('switch(switch_8)', function(data){
            if(switch_show_8){
                $("#selectProduct_"+data.elem.value).css("display","none");
                $("#productName_8").attr("lay-verify", "");
                switch_show_8 = false;
            }else{
                $("#selectProduct_"+data.elem.value).css("display","inline");
                $("#productName_8").attr("lay-verify", "required");
                switch_show_8 = true;
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