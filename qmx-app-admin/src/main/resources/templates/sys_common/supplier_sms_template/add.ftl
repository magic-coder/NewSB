<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>短信模版授权</title>
<#include "/include/common_header_include.ftl">
<script type="text/javascript">

layui.use(['form','laydate'], function(){
    var form = layui.form;
    $(document).on("click","#selectSupplier",function(){
        var index = layer.open({
            type: 2,
            title: '供应商列表',
            area: ['680px', '500px'], //宽高
            fix: true, //固定
            content: '/supplierSmsTemplate/supplierList'
        });
    });
    $(document).on("click","#selectSmsTemplate",function(){
        var index = layer.open({
            type: 2,
            title: '短信模板列表',
            area: ['660px', '500px'], //宽高
            fix: true, //固定
            content: '/supplierSmsTemplate/templateList'
        });
    });

    //监听提交
    form.on('submit(submitUpdate)', function(data){
        var index = layer.load(2, {time: 6*1000}); //设定最长等待10秒
        var reqData = data.field;
        //layer.alert(JSON.stringify(reqData));
        $.ajax({
            url:'save',
            type:'POST', //GET
            //async:true,    //或false,是否异步
            data:reqData,
            //timeout:5000,    //超时时间
            dataType:'json',    //返回的数据格式：json/xml/html/script/jsonp/text
            success:function(resp){
                if(resp){
                    if(resp.errorCode == 0){
                        layer.open({
                            type: 1
                            ,content: '<div style="padding: 20px 80px;">授权成功</div>'
                            ,btn: '关闭'
                            ,btnAlign: 'c' //按钮居中
                            ,yes: function(){
                                location.href='/supplierSmsTemplate/list'
                            },cancel:function () {
                                location.href='/supplierSmsTemplate/list'
                            }
                        });

                    }else {
                        layer.alert(resp.errorMsg, {
                            title: '提示'
                        });
                    }
                }
            },
            error:function(xhr,textStatus){
                layer.alert(xhr.responseText, {
                    title: '提示'
                });
            },
            complete:function(){
                layer.close(index);
            }
        });
        return false;
    });
});

</script>

</head>
<body>
<form class="layui-form" style="margin-top: 20px;margin-right: 50px;" action="" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">授权供应商</label>
            <div class="layui-input-inline">
                <input type="hidden" name="memberId"/>
                <input disabled type="text" lay-verify="required" id="suppliername" autocomplete="off" class="layui-input">
            </div>
			<input type="button" id="selectSupplier" class="layui-btn layui-btn-normal" value="选择供应商"/>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">短信模板</label>
            <div class="layui-input-inline">
				<input type="hidden" lay-verify="required" name="templateIds"/>
                <input type="text" disabled id="templateNameId" autocomplete="off" class="layui-input">
            </div>
            <input type="button" id="selectSmsTemplate" class="layui-btn layui-btn-normal" value="选择短信模板"/>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitUpdate">保存</button>
            </div>
        </div>
    </div>
</form>
</body>
</html>