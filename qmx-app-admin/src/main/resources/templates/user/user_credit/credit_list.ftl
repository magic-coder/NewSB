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
            });
            laydate.render({
                elem: '#endDate'
            });
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>预存款消费记录</legend>
</fieldset>
<form class="layui-form" action="depositList" method="get">
    <div class="layui-form-item">
        <@shiro.hasRole name = "admin">
            <div class="layui-inline">
                <label class="layui-form-label">用户名</label>
                <div class="layui-input-inline">
                    <input type="text" name="userName" value="${queryVo.userName!}" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">操作员</label>
                <div class="layui-input-inline">
                    <input type="text" name="operator" value="${queryVo.operator!}" autocomplete="off" class="layui-input">
                </div>
            </div>
        </@shiro.hasRole>
        <#--<div class="layui-inline">
            <label class="layui-form-label">交易类型</label>
            <div class="layui-input-inline">
                <select name="tradingType">
                    <option value=""></option>
                    <#list tradingTypes as tt>
                        <option <#if queryVo.tradingType?? && queryVo.tradingType == tt>selected</#if> value="${tt!}">${tt.getName()!}</option>
                    </#list>
                </select>
            </div>
        </div>-->
        <#--<div class="layui-inline">
            <label class="layui-form-label">充值来源</label>
            <div class="layui-input-inline">
                <select name="rechargeSource">
                    <option value=""></option>
                <#list rechargeSources as rs>
                    <option <#if queryVo.rechargeSource?? && queryVo.rechargeSource == rs>selected</#if> value="${rs!}">${rs.getName()!}</option>
                </#list>
                </select>
            </div>
        </div>-->
        <#--<div class="layui-inline">
            <label class="layui-form-label">支付方式</label>
            <div class="layui-input-inline">
                <select name="payMethod">
                    <option value=""></option>
                    <#list payMethods as pm>
                        <option <#if queryVo.payMethod?? && queryVo.payMethod == pm>selected</#if> value="${pm!}">${pm.getName()!}</option>
                    </#list>
                </select>
            </div>
        </div>-->
        <div class="layui-inline">
            <label class="layui-form-label">开始日期</label>
            <div class="layui-input-inline">
                <input type="text" name="startDate" value="${(queryVo.startDate?date)!}" id="startDate" placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">结束日期</label>
            <div class="layui-input-inline">
                <input type="text" name="endDate" value="${(queryVo.endDate?date)!}" id="endDate" placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <input type="button" class="layui-btn layui-btn-primary" onclick="location.href='depositList'" value="重置"/>
            </div>
        </div>
    </div>
</form>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceDepositTable" lay-size="sm" lay-filter="sysBalanceDepositTable">
    <colgroup>
        <col width="20">
        <col width="110">
        <col width="100">
        <col width="100">
        <col width="100">
        <col>
        <col width="100">
        <col width="100">
        <col width="150">
        <col width="150">
        <col width="100">
        <col width="100">
        <col width="100">
    </colgroup>
    <thead>
    <tr>
		<th>NO</th>
        <th>用户</th>
        <th>当前余额</th>
        <th>交易金额</th>
        <th>交易类型</th>
        <th>交易内容</th>
        <th>交易时间</th>
        <th>系统订单号</th>
        <th>支付订单号</th>
        <th>支付方式</th>
        <#--<th>充值来源</th>-->
        <th>操作员</th>
    </tr>
    </thead>
    <tbody>
	<#list page.records as dto>
		<tr>
			<td align="center">${dto_index+1!}</td>
			<td>${dto.userName!}</td>
			<td>${dto.balance?string("0.00")}</td>
			<td>${dto.amount?string("0.00")}</td>
			<td>
                <#if dto.tradingType??>
                    ${dto.tradingType.getName()!}
                <#else>
                    -
                </#if>

            </td>
            <td>${dto.body!}</td>
            <td>${dto.createTime?datetime}</td>
            <td>${dto.orderId!}</td>
            <td>${dto.payOrderId!}</td>
            <td>
                <#if dto.payMethod??>
                ${dto.payMethod.getName()!}
                <#else>
                    -
                </#if>
            </td>
            <#--<td>
                <#if dto.rechargeSource??>
                    ${dto.rechargeSource.getName()!}
                <#else>
                    -
                </#if>
            </td>-->
            <td>${dto.operator!}</td>
		</tr>
	</#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>