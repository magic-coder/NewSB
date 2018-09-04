<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
</head>
<body>
<#include "../wxmembership/tab.ftl"/>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="carNum" value="${dto.carNum!}" autocomplete="off"
                       class="layui-input" placeholder="请输入会员卡号">
            </div>
            <div class="layui-input-inline">
                <select name="type" class="input_1">
                    <option value="">类型</option>
                    <option value="recharge" <#if dto.type?? && dto.type=="recharge">selected</#if>>充值</option>
                    <option value="consumption" <#if dto.type?? && dto.type=="consumption">selected</#if>>消费</option>
                    <option value="receive" <#if dto.type?? && dto.type=="receive">selected</#if>>领卡赠送</option>
                    <option value="sign" <#if dto.type?? && dto.type=="sign">selected</#if>>签到</option>
                    <option value="pay" <#if dto.type?? && dto.type=="pay">selected</#if>>支付</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select name="enable" class="input_1">
                    <option value="">充值/消费状态</option>
                    <option value="1" <#if dto.enable?? && dto.enable>selected</#if>>成功</option>
                    <option value="0" <#if dto.enable?? && dto.enable==false>selected</#if>>未成功</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select name="synState" class="input_1">
                    <option value="">同步线下</option>
                    <option value="1" <#if dto.synState?? && dto.synState==true>selected</#if>>成功</option>
                    <option value="0" <#if dto.synState?? && dto.synState==false>selected</#if>>未成功</option>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item">
    &nbsp;
</div>
    <table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
           lay-size="sm" lay-filter="sysBalanceTableEvent">
        <tr>
            <th>
                卡号
            </th>
            <th>
                充值/消费金额
            </th>
            <th>
                类型
            </th>
            <th>
                获得积分
            </th>
            <th>
                赠送金额
            </th>
            <th>
                时间
            </th>
            <th>
                状态
            </th>
            <th>
                同步线下状态
            </th>
        </tr>
    <#list page.records as dto>
        <tr>
            <td>
            ${dto.carNum!}
            </td>
            <td>
                <#if dto.type == "integralConsumption">
                    消耗<font color="green">${dto.integral!}</font>积分
                <#else>
                    <#if dto.money &gt; 0 >
                        <#if dto.type == "recharge">
                            <span style="color:red;">+${dto.money!}</span>
                        <#elseif dto.type == "consumption">
                            <span style="color:green;">-${dto.money!}<span>
                        <#elseif dto.type == "receive">
                            ${dto.money!}
                        </#if>
                    <#else>
                        ${dto.money!}
                    </#if>
                </#if>
            </td>
            <td>
                <#if dto.type == "recharge">
                    <span style="color:red;">充值</span>
                </#if>
                <#if dto.type == "consumption">
                    <span style="color:green;">消费</span>
                </#if>
                <#if dto.type == "receive">
                    领卡赠送
                </#if>
                <#if dto.type == "pay">
                    支付
                </#if>
                <#if dto.type == "sign">
                    签到
                </#if>
                <#if dto.type == "integralConsumption">
                    积分兑换
                </#if>
            </td>
            <td>
                <#if dto.type == "integralConsumption">
                    兑换:${dto.goods!}
                <#else>
                    ${dto.integral!}
                </#if>
            </td>
            <td>
                <span style="color:red;"><#if dto.givemoney??>${dto.givemoney!}￥</#if></span>
            </td>
            <td>
                ${dto.time?string("yyyy-MM-dd HH:mm:ss")}
            </td>
            <td>
                <#if dto.enable>
                    <span style="color:green;">成功</span>
                <#else>
                    <span style="color:red;">未成功</span>
                </#if>
            </td>
            <td>
                <#if dto.synState>
                    <span style="color:green;">成功</span>
                <#else>
                    <span style="color:red;">未成功</span>
                </#if>
            </td>
        </tr>
    </#list>
    </table>
<#include "/include/my_pagination.ftl">

<script type="text/javascript">

</script>
</body>
</html>