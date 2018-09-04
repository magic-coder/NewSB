<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>钱包信息</title>
<#include "/include/common_header_include.ftl">
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>${dto.account!}（${dto.username!}）钱包信息</legend>
</fieldset>
<fieldset class="layui-elem-field" style="margin-left: 20px;margin-right: 20px;">
    <legend>消费总览</legend>
<#if dto.userWallet??>
    <div class="layui-field-box">
        <div class="layui-row layui-col-space6">
            <div class="layui-col-md6">
            <div class="layui-row" style="font-size: large;">
                <div class="layui-col-md3">
                    冻结金额：￥${dto.userWallet.freezeAmount?string('0.00')}
                </div>
                <div class="layui-col-md3">
                    可提现余额：￥${dto.userWallet.walletBalance?string('0.00')}
                </div>
                <div class="layui-col-md3">
                    历史提现：￥${dto.userWallet.totalWithdrawBalance?string('0.00')}
                </div>
            </div>
        </div>
            <div class="layui-input-inline">
                <a href="/userWithdraw/applyWithdraw" class="layui-btn layui-btn-normal">申请提现</a>
            </div>
        </div>
    </div>
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