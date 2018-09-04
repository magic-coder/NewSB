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
                elem: '#accountCanUseEnd'
            });
            /*table.render({
                id:"id",
                elem: '#sysBalanceTable',
                //height: 600,
                url:'/sysBalance/jsonList',
                cols: [[
                    {type:'numbers'}
                    ,{field:'userName', title: '用户名'}
                    ,{field:'account', title: '账号'}
                    ,{field:'phone', title: '联系电话'}
                    ,{field:'sysBalance', width:100, title: '余额'}
                    ,{field:'totalSysBalance', width:110, title: '历史充值'}
                    ,{field:'chargeRulesName', title: '扣款规则'}
                    ,{field:'enable', width:60, title: '状态'}
                    ,{toolbar: '#sysBalanceBar', title: '操作'}
                ]]
                ,page: true
            });*/
            $(document).on("click","#edit",function(){
                var data = $(this).attr("data-id");
                var index = layer.open({
                    type: 2,
                    title: '修改计费规则',
                    area: ['500px', '500px'], //宽高
                    fix: true, //固定
                    content: '/userCharge/preUpdateChargeType?userId='+data
                });
            });
            $(document).on("click","#reCharge",function(){
                var data = $(this).attr("data-id");
                var index = layer.open({
                    type: 2,
                    title: '系统充值',
                    area: ['500px', '450px'], //宽高
                    fix: true, //固定
                    content: '/sysBalance/preRecharge?userId='+data
                });
            });
            $(document).on("click","#viewLog",function(){
                var data = $(this).attr("data-id");
                var index = layer.open({
                    type: 2,
                    title: '修改日志列表',
                    area: ['660px', '450px'], //宽高
                    fix: true, //固定
                    content: '/userCharge/findChargeTypePage?memberId='+data
                });
            });
            $(document).on("click","#editSmsCharge",function () {
                var data = $(this).attr("data-id");
                var index = layer.open({
                    type: 2,
                    title: '修改短信计费方式',
                    area: ['500px', '520px'], //宽高
                    fix: true, //固定
                    content: '/userCharge/preUpdateSmsCharge?userId='+data
                });
            })
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>系统钱包用户列表</legend>
</fieldset>
<form class="layui-form" action="list" method="get">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">登录账号</label>
            <div class="layui-input-inline">
                <input type="text" name="account" value="${userQueryVo.account!}" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-inline">
                <input type="text" name="username" value="${userQueryVo.username!}" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">账号类型</label>
            <div class="layui-input-inline">
                <select name="userType">
                    <option value=""></option>
                    <option <#if userQueryVo.userType?? && userQueryVo.userType == 'group_supplier'>selected</#if> value="group_supplier">集团供应商</option>
                    <option <#if userQueryVo.userType?? && userQueryVo.userType == 'supplier'>selected</#if> value="supplier">供应商</option>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <#--<div class="layui-inline">
            <label class="layui-form-label">扣款规则</label>
            <div class="layui-input-inline">
                <select name="accountChargesType">
                    <option value=""></option>
				<#list chargeRules as rule>
                    <option <#if userQueryVo.accountChargesType?? && userQueryVo.accountChargesType == rule>selected</#if> value="${rule!}">${rule.getName()!}</option>
				</#list>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">截止日期</label>
            <div class="layui-input-inline">
                <input type="text" name="accountCanUseEnd" value="${(userQueryVo.accountCanUseEnd?date)!}" id="accountCanUseEnd" placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input">
            </div>
        </div>-->
        <div class="layui-inline">
            <label class="layui-form-label">是否启用</label>
            <div class="layui-input-inline">
                <select name="enable">
                    <option value=""></option>
                    <option <#if (!userQueryVo.enable?? || userQueryVo.enable)>selected</#if> value="true">启用</option>
                    <option <#if userQueryVo.enable?? && !userQueryVo.enable>selected</#if> value="false">禁用</option>
                </select>
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
        <col width="110">
        <col width="80">
        <col width="50">
        <col width="50">
        <col width="50">
        <col width="250">
        <col width="50">
        <col>
    </colgroup>
    <thead>
    <tr>
		<th>NO</th>
        <th>账号/用户名</th>
        <th>账号类型</th>
        <th>联系电话</th>
        <th>余额</th>
        <th>历史充值</th>
        <th>扣款规则</th>
        <th>状态</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
	<#list page.records as dto>
		<tr>
			<td align="center">${dto_index+1!}</td>
			<td>${dto.account!}/${dto.username!}</td>
			<td>${dto.userType.getName()!}</td>
			<td>${dto.phone!}</td>
            <#if dto.userBalance??>
                <td align="center">${dto.userBalance.sysBalance!}</td>
                <td align="center">${dto.userBalance.rechargedSysBalance!}</td>
            <#else>
                <td align="center">-</td>
                <td align="center">-</td>
            </#if>
            <td>
			<#if dto.userChargeInfo??>
                <#assign userChargeInfoDto = dto.userChargeInfo/>
			    <#if userChargeInfoDto.accountChargesType == 'DATE_RANGE'>
					至${userChargeInfoDto.accountCanUseEnd?date}前不收费
				<#elseif userChargeInfoDto.accountChargesType == 'DAY'>
                    ${userChargeInfoDto.accountChargeAmount?string("#.##")}元/天
				<#elseif userChargeInfoDto.accountChargesType == 'MONTH'>
					${userChargeInfoDto.accountChargeAmount?string("#.##")}元/月，有效期至：${userChargeInfoDto.accountCanUseEnd?date}
				<#elseif userChargeInfoDto.accountChargesType == 'YEAR'>
					${userChargeInfoDto.accountChargeAmount?string("#.##")}元/年，有效期至：${userChargeInfoDto.accountCanUseEnd?date}
				<#elseif userChargeInfoDto.accountChargesType == 'ORDER'>
					${userChargeInfoDto.accountChargeAmount?string("#.##")}元/单
				<#elseif userChargeInfoDto.accountChargesType == 'TICKET'>
					${userChargeInfoDto.accountChargeAmount?string("#.##")}元/单品
			    </#if>
			</#if>
            <td>
				<#if dto.enable>
                    <i class="layui-icon">&#xe605;</i>
				<#else>
                    <i class="layui-icon">&#x1006;</i>
				</#if>
			</td>
            <td>
                <@shiro.hasPermission name="admin:updateChargeType">
				<button class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="edit">修改计费类型</button>
                </@shiro.hasPermission>
                <@shiro.hasPermission name="admin:updateSmsChargeInfo">
                <button class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="editSmsCharge">修改短信计费</button>
                </@shiro.hasPermission>
                <@shiro.hasPermission name="admin:sysBalanceRecharge">
                <button class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}" id="reCharge">充值</button>
                </@shiro.hasPermission>
                <@shiro.hasPermission name="admin:sysBalanceChangeLog">
                <button class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}" id="viewLog">日志</button>
                </@shiro.hasPermission>
			</td>
		</tr>
	</#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>