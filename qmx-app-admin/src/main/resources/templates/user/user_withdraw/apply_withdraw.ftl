<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>提现</title>
    <#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form','table','laydate'], function(){
            var table = layui.table,laydate = layui.laydate, form = layui.form;
            //日期
            laydate.render({
                elem: 'input[name=withdrawMonth]'
                ,type: 'month'
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
    <form class="layui-form" action="applyWithdrawStep2" style="margin-top: 10px;" method="post">
        <input type="hidden" name="charge" value="${(userInfo.userWallet.walletBalance - remainAmount)!0}"/>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">提现账号</label>
                <div class="layui-input-inline">
                    <input type="hidden" name="memberId" value="${userInfo.id!}"/>
                    <input type="text" name="account" disabled value="${userInfo.account!}" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <input type="hidden" name="applyAmount" value="${remainAmount!}" >
        <#--<div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">最高提现</label>
                <div class="layui-input-inline">
                    <input type="text" name="walletBalance" disabled value="${remainAmount!}" autocomplete="off" class="layui-input">
                </div>
                <input type="hidden" name="applyAmount" value="${remainAmount!}" >
                <div class="layui-form-mid layui-word-aux">钱包余额：${userInfo.userWallet.walletBalance?string('0.00')}，提现费率:千分之${userInfo.userWallet.charge?string('0')}</div>
            </div>
        </div>-->
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">提现月份</label>
                <div class="layui-input-inline">
                    <input type="text" name="withdrawMonth" readonly autocomplete="off" lay-verify="required" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">提现方式</label>
                <div class="layui-input-inline">
                    <select lay-filter="withdrawTarget" name="withdrawTarget" lay-verify="required">
                        <option value="">请选择提现方式</option>
                        <#list userWithdrawTypes as t>
                            <option value="${t}">${t.getName()!}</option>
                        </#list>
                    </select>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block" style="margin-top: 10px;">
                <div class="layui-input-inline">
                    <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitConfirm">下一步</button>
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