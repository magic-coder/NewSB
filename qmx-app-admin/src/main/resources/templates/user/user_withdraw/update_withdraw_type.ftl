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
            $("input[name=applyAmount]").on('input',function(e){
                var val = $(this).val();
                var max = $(this).attr('max');
                $(this).val(val.replace(/^[0]*/g,''));
                $(this).val(val.replace(/[^\d]/g,''));
                val = parseFloat(val);
                max = parseFloat(max);
                if(max < val){
                    $(this).val(max);
                }
            });

            //监听提交
            form.on('submit(submitConfirm)', function(data){
                var index = layer.load(2, {time: 6*1000}); //设定最长等待10秒
                var reqData = data.field;
                var withdrawTypes = new Array();
                var $check_boxes = $('input:checkbox:checked[name=withdrawTypes]');
                $check_boxes.each(function(){
                    withdrawTypes.push($(this).val());
                });
                reqData.withdrawTypes = withdrawTypes;
                $.ajax({
                    url:'doUpdateWithdrawType',
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

<fieldset class="layui-elem-field" style="margin-left: 20px;margin-right: 20px;margin-top: 20px;">
    <legend>用户提现设置</legend>
<#if userInfo.userWallet??>
    <form class="layui-form" action="" style="margin-top: 20px;" method="POST">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">账号</label>
                <div class="layui-input-inline">
                    <input type="hidden" name="userId" value="${userInfo.id!}"/>
                    <input type="text" name="account" disabled value="${userInfo.account!}" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">提现手续费</label>
                <div class="layui-input-inline">
                    <input type="text" name="charge" value="${userInfo.userWallet.charge?string('0')}" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">‰（千分之）注：只针对提现到银行卡的有效</div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">最低提现</label>
                <div class="layui-input-inline">
                    <input type="text" name="withdrawStartAmount" lay-verify="required|number" autocomplete="off" value="${userInfo.userWallet.withdrawStartAmount!0}" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">提现方式</label>
                <div class="layui-input-block">
                    <#if allWithdrawTypes??>
                        <#if userWithdrawTypes??>
                            <#assign x = userWithdrawTypes?split(',')>
                        </#if>
                        <#list allWithdrawTypes as t>
                            <input <#if x?? && x?seq_contains('${t!}')>checked="checked"</#if> type="checkbox" name="withdrawTypes" value="${t!}"  lay-skin="primary" title="${t.getName()!}"  >
                        </#list>
                    <#else>
                        <input type="checkbox" name="withdrawTypes" lay-skin="primary" title="暂无可用提现方式" disabled="disabled">
                    </#if>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="padding-left: 20px;">
                <input type="checkbox" name="applyAll" value="true" lay-skin="primary" title="该提现设置应用给所有分销商">
            </div>
        </div>
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