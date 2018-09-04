<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>系统钱包充值</title>
    <#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form','laydate'], function(){
            var form = layui.form,laydate = layui.laydate;
            //日期
            laydate.render({
                elem: '#accountCanUseEnd'
            });
            var pindex = parent.layer.getFrameIndex(window.name); //获取窗口索引
            form.verify({
                amount: function(value, item){ //value：表单的值、item：表单的DOM对象
                    if(!new RegExp("^[0-9-.]+$").test(value)){
                        return '金额有误';
                    }
                }
            });

            //监听提交
            form.on('submit(submitUpdate)', function(data){
                var index = layer.load(2, {time: 6*1000}); //设定最长等待10秒
                var reqData = data.field;
                $.ajax({
                    url:'doUpdateChargeType',
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
                                    ,content: '<div style="padding: 20px 80px;">修改成功</div>'
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
        <div class="layui-inline">
            <label class="layui-form-label">账号/用户名</label>
            <div class="layui-input-inline">
                <input type="hidden" name="userId" value="${dto.id!}"/>
                <input type="text" value="${dto.account!}/${dto.username!}" disabled autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">计费类型</label>
            <div class="layui-input-inline">
                <select name="accountChargeType" lay-verify="required">
                    <option value=""></option>
                <#list accountChargeType as act>
                    <option value="${act!}">${act.getName()!}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">计费金额</label>
            <div class="layui-input-inline">
                <input type="text" name="amount" lay-verify="amount" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">截止日期</label>
            <div class="layui-input-inline">
                <input type="text" name="endDate" id="accountCanUseEnd" placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">备注</label>
        <div class="layui-input-block">
            <textarea name="remark" placeholder="请输入备注" class="layui-textarea"></textarea>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitUpdate">立即修改</button>
            </div>
        </div>
    </div>
</form>
</body>
</html>