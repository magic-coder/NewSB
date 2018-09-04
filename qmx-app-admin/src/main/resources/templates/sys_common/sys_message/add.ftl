<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>发送消息</title>
	<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form','laydate'], function(){
            var form = layui.form;
            var pindex = parent.layer.getFrameIndex(window.name); //获取窗口索引
            //监听提交
            form.on('submit(submitUpdate)', function(data){
                var index = layer.load(2, {time: 6*1000}); //设定最长等待10秒
                var reqData = data.field;
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
                                    ,content: '<div style="padding: 20px 80px;">发送成功</div>'
                                    ,btn: '关闭'
                                    ,btnAlign: 'c' //按钮居中
                                    ,yes: function(){
                                        parent.layer.close(pindex);
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

            <label class="layui-form-label">标题</label>
            <div class="layui-input-block">
                <input type="text" placeholder="请输入标题" lay-verify="required" name="title" autocomplete="off" class="layui-input">
            </div>

    </div>
    <div class="layui-form-item">

            <label class="layui-form-label">用户类型</label>
            <div class="layui-input-block">
                <select name="reciveUserType" lay-verify="required">
                    <option value=""></option>
                <#list reciveTypes as act>
                    <option value="${act!}">${act.getName()!}</option>
                </#list>
                </select>
            </div>

    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">发送内容</label>
        <div class="layui-input-block">
            <textarea name="content" cols="20" rows="10" lay-verify="required" placeholder="请输入发送内容" class="layui-textarea"></textarea>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitUpdate">立即发送</button>
            </div>
        </div>
    </div>
</form>
</body>
</html>