<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form','table','laydate'], function(){
            var table = layui.table
                    ,laydate = layui.laydate,
                    form = layui.form;
            //日期
            laydate.render({
                elem: '#startDate'
                ,type: 'datetime'
            });
            //日期
            laydate.render({
                elem: '#endDate'
                ,type: 'datetime'
            });
            //日期
            laydate.render({
                elem: '#startAuditDate'
                ,type: 'datetime'
            });
            //日期
            laydate.render({
                elem: '#endAuditDate'
                ,type: 'datetime'
            });
            $(document).on("click","#agreeWithdraw",function(){
                var data = $(this).attr("data-id");
                var index = layer.open({
                    type: 2,
                    title: '同意提现',
                    area: ['450px', '500px'], //宽高
                    fix: true, //固定
                    content: '/userWithdraw/agreeWithdraw?id='+data
                });
            });
            $(document).on("click","#disAgreeWithdraw",function(){
                var data = $(this).attr("data-id");
                var index = layer.open({
                    type: 2,
                    title: '不同意提现',
                    area: ['450px', '500px'], //宽高
                    fix: true, //固定
                    content: '/userWithdraw/disAgreeWithdraw?id='+data
                });
            });
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>钱包用户列表</legend>
</fieldset>
<form class="layui-form" action="withdraw" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-inline">
                <input type="text" name="username" value="${queryDto.username!}" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">申请时间</label>
            <div class="layui-input-inline">
                <input type="text" id="startDate" readonly name="startDate" value="<#if queryDto.startDate??>${queryDto.startDate?datetime}</#if>" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-input-inline">
                <input type="text" id="endDate" readonly name="endDate" value="<#if queryDto.endDate??>${queryDto.endDate?datetime}</#if>" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">审核时间</label>
            <div class="layui-input-inline">
                <input type="text" id="startAuditDate" readonly name="startAuditDate" value="<#if queryDto.startAuditDate??>${queryDto.startAuditDate?datetime}</#if>" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-input-inline">
                <input type="text" id="endAuditDate" readonly name="endAuditDate" value="<#if queryDto.endAuditDate??>${queryDto.endAuditDate?datetime}</#if>" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">提现方式</label>
            <div class="layui-input-inline">
                <select name="withdrawTarget">
                    <option value=""></option>
                <#list withdrawTargets as t>
                    <option <#if (queryDto.withdrawTarget?? && queryDto.withdrawTarget == t)>selected</#if> value="${t!}">${t.getName()!}</option>
                </#list>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">处理人</label>
            <div class="layui-input-inline">
                <input type="text" name="operator" value="${queryDto.operator!}" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <input type="button" class="layui-btn layui-btn-primary" onclick="location.href='list'" value="重置"/>
            </div>
        </div>
    </div>
</form>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable" lay-size="sm" lay-filter="sysBalanceTableEvent">
    <colgroup>
        <col width="20">
        <col width="150">
        <col width="150">
        <col width="150">
        <col width="150">
        <col width="150">
        <col width="150">
        <col width="150">
        <col width="150">
        <col width="150">
    </colgroup>
    <thead>
    <tr>
        <th>NO</th>
        <th>申请账号</th>
        <th>申请时间</th>
        <th>提现方式</th>
        <th>收款账户</th>
        <th>审核时间</th>
        <th>提现金额</th>
        <th>提现手续费</th>
        <th>处理人</th>
        <th>处理进度</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td align="center">${dto_index+1!}</td>
        <td>
            <#if dto.member??>
            ${dto.member.account!}/${dto.member.username!}
            <#else>-
            </#if>
        </td>
        <td>${dto.createTime?datetime}</td>
        <td>
            <#if dto.withdrawTarget??>
                ${dto.withdrawTarget.getName()!}
            </#if>
        </td>
        <td>
        ${dto.body!}
        </td>
        <td>${dto.auditDate!}</td>
        <td>${dto.applyAmount!}</td>
        <td>${dto.charge!}</td>
        <td>${dto.operator!}</td>
        <td>
            <#if dto.status??>
                ${dto.status.getName()!}
            </#if>
        </td>
        <td>
            <@shiro.hasPermission name="admin:agreeWithdraw">
            <button class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}" id="agreeWithdraw">同意提现</button>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="admin:disAgreeWithdraw">
            <button class="layui-btn layui-btn-sm layui-btn-normal" style="margin-top: 6px;margin-left: 0px;" data-id="${dto.id!}" id="disAgreeWithdraw">拒绝提现</button>
            </@shiro.hasPermission>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>