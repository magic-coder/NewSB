<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>提现</title>
    <#include "/include/common_header_include.ftl">
    <script type="text/javascript">

        function submitInfo() {
            var reqData = {};
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
                                    location.href='/userWallet/walletInfo'
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
        }

        layui.use('form', function() {
            var form = layui.form;
            $(document).on("click","#getWxOpenId",function(){
                layer.open({
                    type: 2,
                    title: '获取openId',
                    area: ['500px', '450px'], //宽高
                    fix: true, //固定
                    content: '/common/getWxOpenId'
                });
            });

            //监听提交
            form.on('submit(submitConfirm)', function(data){
                var reqData = data.field;
                var index = layer.load(2, {time: 6*1000}); //设定最长等待10秒
                var val = $("select[name=bankNo]").find("option:selected").text();
                reqData.bank = val;
                $.ajax({
                    url:'/userWithdraw/savePreWithdraw',
                    type:'POST', //GET
                    //async:true,    //或false,是否异步
                    data:reqData,
                    //timeout:5000,    //超时时间
                    dataType:'json',    //返回的数据格式：json/xml/html/script/jsonp/text
                    success:function(resp){
                        if(resp){
                            if(resp.errorCode == 0){
                                layer.open({
                                    type: 2,
                                    title: '提示',
                                    area: ['452px', '580px'], //宽高
                                    fix: true, //固定
                                    content: '/userWithdraw/preWithdraw'
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

                /*var index = layer.open({
                    type: 2,
                    title: '提示',
                    area: ['452px', '450px'], //宽高
                    fix: true, //固定
                    content: '/userWithdraw/preWithdraw?amount='+reqData
                });*/
                return false;
            });
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>${userInfo.account!}（${userInfo.username!}）钱包信息</legend>
</fieldset>
<fieldset class="layui-elem-field" style="margin-left: 20px;margin-right: 20px;">
    <legend>用户提现</legend>
<#if userInfo.userWallet??>
    <form class="layui-form" action="" style="margin-top: 10px;" method="get">
        <input id="bank" type="hidden" name="bank"/>
        <#if userWithdraw.withdrawTarget == 'ALIPAY_TRANSFER'>
            <div class="layui-form-item" id="aliAccount">
                <div class="layui-inline">
                    <label class="layui-form-label">支付宝账号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="aliAccount" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item" id="aliName">
                <div class="layui-inline">
                    <label class="layui-form-label">支付宝名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="aliName" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
        <#elseif userWithdraw.withdrawTarget == 'WXPAY_TRANSFER'>
            <div class="layui-form-item" id="wxOpenId">
                <div class="layui-inline">
                    <label class="layui-form-label">微信openid</label>
                    <div class="layui-input-inline">
                        <input type="text" name="wxOpenId" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                    <input type="button" id="getWxOpenId" class="layui-btn layui-btn-normal" value="获取微信openId"/>
                </div>
            </div>
            <div class="layui-form-item" id="wxName">
                <div class="layui-inline">
                    <label class="layui-form-label">姓名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="wxName" lay-verify="required"autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
        <#elseif userWithdraw.withdrawTarget == 'WXPAY_BANK' || userWithdraw.withdrawTarget == 'ALIPAY_BANK' || userWithdraw.withdrawTarget == 'BANK_TRANSFER'>
            <div class="layui-form-item" id="bankDiv">
                <div class="layui-inline">
                    <label class="layui-form-label">提现到</label>
                    <div class="layui-input-inline">
                        <select name="bankNo" lay-verify="required">
                            <option value="">选择银行</option>
                            <#if bankInfo??>
                            <#list bankInfo as bank>
                                <option value="${bank.code}">${bank.name!}</option>
                            </#list>
                            </#if>
                        </select>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">银行卡号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="bankCardNo" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">持卡人名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="bankCardName" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
        <#elseif userWithdraw.withdrawTarget == 'CASH'>
            <div class="layui-form-item" id="wxOpenId">
                <div class="layui-inline">
                    <label class="layui-form-label">收款人姓名</label>
                    <div class="layui-input-inline">
                        <input type="text" maxlength="12" name="cashName" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item" id="wxName">
                <div class="layui-inline">
                    <label class="layui-form-label">收款人手机</label>
                    <div class="layui-input-inline">
                        <input type="text" maxlength="11" name="cashPhone" lay-verify="required"autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
        </#if>
        <div class="layui-form-item">
            <div class="layui-input-block" style="margin-top: 10px;">
                <div class="layui-input-inline">
                    <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitConfirm">确定</button>
                    <input type="button" class="layui-btn layui-btn-primary" onclick="history.back();" value="返回"/>
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