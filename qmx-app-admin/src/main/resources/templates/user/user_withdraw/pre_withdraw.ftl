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
                parent.layer.close(pindex);
                parent.submitInfo();
                /*var reqData = data.field;
                var index = layer.load(2, {time: 6*1000}); //设定最长等待10秒
                var val = $("select[name=bankNo]").find("option:selected").text();
                reqData.bank = val;
                $.ajax({
                    url:'/userWithdraw/submitWithdraw',
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
                                        parent.layer.msg('Hi, man', {shade: 0.3})
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
                });*/

                return false;
            });
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field" style="margin-left: 20px;margin-right: 20px;margin-top: 20px;">
    <legend>用户提现</legend>
<#if userWithdraw??>
    <form class="layui-form" action="" style="margin-top: 10px;" method="get">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">提现账号</label>
                <div class="layui-input-inline">
                    <input type="text" name="account" disabled value="${userInfo.account!}" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">金额</label>
                <div class="layui-input-inline">
                    <input type="text" name="applyAmount" value="${userWithdraw.applyAmount!}" disabled autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">提现手续费</label>
                <div class="layui-input-inline">
                    <input type="text" name="charge" lay-verify="number" disabled value="${userWithdraw.charge!}" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">提现方式</label>
                <div class="layui-input-inline">
                    <input type="text" disabled value="${userWithdraw.withdrawTarget.getName()!}" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <#if userWithdraw.withdrawTarget == 'ALIPAY_TRANSFER'>
            <div class="layui-form-item" id="aliAccount">
                <div class="layui-inline">
                    <label class="layui-form-label">支付宝账号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="aliAccount" readonly value="${userWithdraw.aliAccount!}" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item" id="aliName">
                <div class="layui-inline">
                    <label class="layui-form-label">支付宝名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="aliName" readonly value="${userWithdraw.aliName!}" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
        <#elseif userWithdraw.withdrawTarget == 'WXPAY_TRANSFER'>
            <div class="layui-form-item" id="wxOpenId">
                <div class="layui-inline">
                    <label class="layui-form-label">微信openid</label>
                    <div class="layui-input-inline">
                        <input type="text" name="wxOpenId" readonly value="${userWithdraw.wxOpenId!}" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item" id="wxName">
                <div class="layui-inline">
                    <label class="layui-form-label">微信名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="wxName" readonly value="${userWithdraw.wxName!}" lay-verify="required"autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
        <#elseif userWithdraw.withdrawTarget == 'WXPAY_BANK' || userWithdraw.withdrawTarget == 'ALIPAY_BANK' || userWithdraw.withdrawTarget == 'BANK_TRANSFER'>
            <div class="layui-form-item" id="bankDiv">
                <div class="layui-inline">
                    <label class="layui-form-label">提现到</label>
                    <div class="layui-input-inline">
                        <input type="hidden" name="bankNo" value="${userWithdraw.bankNo!}"/>
                        <input type="text" name="bank" disabled value="${userWithdraw.bank!}" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">银行卡号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="bankCardNo" disabled value="${userWithdraw.bankCardNo!}" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">持卡人名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="bankCardName" disabled value="${userWithdraw.bankCardName!}" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
        <#elseif userWithdraw.withdrawTarget == 'CASH'>
            <div class="layui-form-item" id="wxOpenId">
                <div class="layui-inline">
                    <label class="layui-form-label">收款人姓名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="cashName" disabled value="${userWithdraw.cashName!}" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item" id="wxName">
                <div class="layui-inline">
                    <label class="layui-form-label">收款人手机</label>
                    <div class="layui-input-inline">
                        <input type="text" name="cashPhone" disabled value="${userWithdraw.cashPhone!}" lay-verify="required"autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
        </#if>
        <div class="layui-form-item">
            <div class="layui-input-block" style="margin-top: 10px;">
                <div class="layui-input-inline">
                    <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitWithdraw">提交</button>
                </div>
            </div>
        </div>
    </form>
<#else>
    <div class="layui-field-box">
        <div class="layui-row layui-col-space6">
            <div class="layui-col-md6">
                <div class="layui-row" style="font-size: large;">
                    <div class="layui-col-md3">
                        暂无
                    </div>
                </div>
            </div>
        </div>
    </div>
</#if>
</fieldset>
</body>
</html>