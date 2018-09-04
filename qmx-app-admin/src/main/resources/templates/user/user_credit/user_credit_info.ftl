<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>授信信息</title>
<#include "/include/common_header_include.ftl">
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>${dto.account!}（${dto.username!}）授信信息</legend>
</fieldset>
<fieldset class="layui-elem-field" style="margin-left: 20px;margin-right: 20px;">
    <legend>消费总览</legend>
<#if dto.userDeposit??>
    <div class="layui-field-box">
        <div class="layui-row layui-col-space6">
            <div class="layui-col-md6">
                <div class="layui-row" style="font-size: large;">
                    <div class="layui-col-md3">
                        历史授信总额：￥${dto.userCredit.rechargedCreditBalance?string("0.00")}
                    </div>
                    <div class="layui-col-md9">
                        账户余额：￥${dto.userCredit.creditBalance?string("0.00")}
                    </div>
                    <#--<div class="layui-col-md9">
                        授信消费总额：￥${dto.userCredit.consumedAmount!}
                    </div>-->
                </div>
            </div>
            <div class="layui-input-inline">
                <a href="javascript:;" class="layui-btn layui-btn-normal">授信额调整统计</a>
                <a href="javascript:;" class="layui-btn layui-btn-normal">授信额消费统计</a>
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