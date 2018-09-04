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
        layui.use(['form', 'table', 'laydate','layedit','upload'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var upload = layui.upload;

            laydate.render({elem: "#startDate"});
            laydate.render({elem: "#endDate"});

            layedit = layui.layedit;
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
                    $("#image").val(res.data);
                },
                error: function () {
                    //请求异常回调
                    alert("异常!!!");
                }
            });
            upload.render({
                elem: '#uploadImageUrl',
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
        });
        function selectProduct(){
            var index = layer.open({
                type: 2,
                title: '选择产品',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'couponlist'
            });
        }
    </script>
</head>
<body>
<form class="layui-form" id="inputForm">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <label class="layui-form-label">活动名称</label>
        <div class="layui-input-inline">
            <input id="name" name="name" value="${dto.name!}" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">选择优惠券</label>
        <div class="layui-input-inline" style="width: 350px;">
            <input id="productName" name="productName" value="${dto.productName!}" style="display: inline;width: 190px;" class="layui-input" readonly>
            <input type="hidden" id="productId" name="product" value="${dto.product!?c}"/>
            <input type="button" class="layui-btn" onclick="selectProduct();" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">活动图片</label>
        <div class="layui-input-inline" style="width: 300px;">
            <input id="image" name="image" style="display: inline;width: 190px;" class="layui-input" value="${dto.image!}">
            <input id="uploadImage" type="button" class="layui-btn" value="上传图片">
        </div>
    </div>
    <div class="layui-form-item">
        <input type="hidden" name="subscribe" value="true"/>
        <div class="layui-inline">
            <label class="layui-form-label">助力者</label>
            <div class="layui-input-inline">
                <input name="subscribeHelp" value="true" title="需要" <#if dto.subscribeHelp>checked</#if> type="radio">
                <input name="subscribeHelp" value="false" title="不需要" <#if !dto.subscribeHelp>checked</#if> type="radio">
            </div>
            <div class="layui-form-mid">关注</div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">活动数量</label>
            <div class="layui-input-inline">
                <input id="number" name="number" value="${dto.number!}" lay-verify="required" autocomplete="off" class="layui-input" placeholder="请输入整数" />
            </div>
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
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">起始金额</label>
            <div class="layui-input-inline">
                <input id="minPrice" name="minPrice" value="${dto.minPrice!}" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">目标金额</label>
            <div class="layui-input-inline">
                <input id="maxPrice" name="maxPrice" value="${dto.maxPrice!}" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">助力范围</label>
            <div class="layui-input-inline">
                <input id="minAssistancePrice" name="minAssistancePrice" value="${dto.minAssistancePrice!}" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-mid">-</div>
            <div class="layui-input-inline">
                <input id="maxAssistancePrice" name="maxAssistancePrice" value="${dto.maxAssistancePrice!}" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">分享标题</label>
        <div class="layui-input-inline">
            <input name="title" value="${dto.title!}" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label">分享描述</label>
        <div class="layui-input-inline">
            <input name="descval" value="${dto.descval!}" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">分享图标</label>
        <div class="layui-input-inline" style="width: 400px;">
            <input id="imgurl" name="imgurl" value="${dto.imgurl!}" style="width: 190px;display: inline;" autocomplete="off" class="layui-input">
            <input id="uploadImageUrl" type="button" style="margin-top: -5px;" class="layui-btn" value="上传图片">
        </div>
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
            <input type="button" class="layui-btn layui-btn-normal" onclick="return submitform();" value="立即提交"/>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
<script type="text/javascript">
    function submitform(){
        //验证输入参数
        if($("#name").val()==""){
            alert("请输入活动名称");
            return false;
        }
        if($("#productId").val()==""){
            alert("请选择门票");
            return false;
        }
        var $number = /^[1-9]\d*$/;
        if (!$number.test($("#number").val())) {
            alert("请输入正确的数量");
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
        var $minPrice = /^[0-9]+([.]{1}[0-9]{1,2})?$/;
        if (!$minPrice.test($("#minPrice").val())) {
            alert("请输入正确的起始金额");
            return false;
        }
        if (!$minPrice.test($("#maxPrice").val())) {
            alert("请输入正确的目标金额");
            return false;
        }
        if(parseFloat($("#minPrice").val())>=parseFloat($("#maxPrice").val())){
            alert("目标金额必须比起始金额大");
            return false;
        }
        if(!$minPrice.test($("#minAssistancePrice").val())){
            alert("请输入正确的助力金额");
            return false;
        }
        if(!$minPrice.test($("#maxAssistancePrice").val())){
            alert("请输入正确的助力金额");
            return false;
        }
        if(parseFloat($("#minAssistancePrice").val())>=parseFloat($("#maxAssistancePrice").val())){
            alert("助力金额范围出错");
            return false;
        }
        $("#content").val(layedit.getContent(index));
        $.ajax({
            type :"POST",
            url : "./update",
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