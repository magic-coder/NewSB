<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>提现</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        layui.use('form', function() {
            var form = layui.form;
            var pindex = parent.layer.getFrameIndex(window.name); //获取窗口索引
            //监听提交
            form.on('submit(submitWithdraw)', function(data){
                var reqData = data.field;
                //return false;
                var index = layer.load(2, {time: 6*1000}); //设定最长等待10秒
                $.ajax({
                    url:'/userWithdraw/doDisagreeWithdraw',
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
                                    ,content: '<div style="padding: 20px 80px;">提交成功</div>'
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
<form class="layui-form" action="" style="margin-top: 10px;" method="get">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">提现账号</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${userWithdraw.member.username!}</div>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">提现方式</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${userWithdraw.withdrawTarget.getName()!}</div>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">提现金额</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${userWithdraw.applyAmount!}</div>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">提现手续费</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${userWithdraw.charge!}</div>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">拒绝理由</label>
            <div class="layui-input-inline" style="padding-right: 20px;">
                <input name="id" type="hidden" value="${userWithdraw.id!}"/>
                <textarea placeholder="必填拒绝理由" lay-verify="required" name="remark" class="layui-textarea"></textarea>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block" style="margin-top: 10px;">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitWithdraw">提交</button>
            </div>
        </div>
    </div>
</form>
</body>
</html>