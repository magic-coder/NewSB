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
                <select name="qgType" class="input_1">
                    <option value="">规则方式</option>
                    <option value="guding" <#if dto.qgType?? && dto.qgType=="guding">selected</#if>>固定方式</option>
                    <option value="qujian" <#if dto.qgType?? && dto.qgType=="qujian">selected</#if>>区间方式</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select name="enable" class="input_1">
                    <option value="">是否启用</option>
                    <option value="1" <#if dto.enable?? && dto.enable==true>selected</#if>>启用</option>
                    <option value="0" <#if dto.enable?? && dto.enable==false>selected</#if>>关闭</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select name="type" class="input_1">
                    <option value="">用途</option>
                    <option value="recharge" <#if dto.type?? && dto.type=="recharge">selected</#if>>充值</option>
                    <option value="consumption" <#if dto.type?? && dto.type=="consumption">selected</#if>>消费</option>
                    <option value="opencard" <#if dto.type?? && dto.type=="opencard">selected</#if>>开卡</option>
                    <option value="minimum" <#if dto.type?? && dto.type=="minimum">selected</#if>>最低充值</option>
                    <option value="sign" <#if dto.type?? && dto.type=="sign">selected</#if>>签到</option>
                    <option value="pay" <#if dto.type?? && dto.type=="pay">selected</#if>>支付</option>
                    <option value="promotion" <#if dto.type?? && dto.type=="promotion">selected</#if>>升级会员</option>
                    <option value="sendIntegral" <#if dto.type?? && dto.type=="sendIntegral">selected</#if>>送积分</option>
                    <option value="integralConsumption" <#if dto.type?? && dto.type=="integralConsumption">selected</#if>>积分消费</option>
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
    <div class="layui-inline">
        <div class="layui-input-inline">
            <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
        </div>
    </div>
</div>
    <table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
           lay-size="sm" lay-filter="sysBalanceTableEvent">
        <tr>
            <th class="check">
                <input type="checkbox" id="selectAll"/>
            </th>
            <th>
                规则
            </th>
            <th>
                赠送值
            </th>
            <th>
                赠送类型
            </th>
            <th>
                规则方式
            </th>
            <th>
                用途
            </th>
            <th>
                开始时间
            </th>
            <th>
                结束时间
            </th>
            <th>
                是否启用
            </th>
            <th>
                <span>操作</span>
            </th>
        </tr>
    <#list page.records as dto>
        <tr>
            <td>
                <input type="checkbox" name="ids" value="${dto.id}"/>
            </td>
            <td>
                <#if  dto.type=="integralConsumption">
                    消耗<font color="red">${dto.gNum!}</font>积分兑换：<font color="red">${dto.remarks!}</font>
                <#elseif dto.type=="recharge" || dto.type=="consumption">
                    <#if dto.qgType=="qujian">
                        <span style="color:red;">${dto.minimum}</span>元&nbsp至&nbsp<span style="color:red;">${dto.maximum}</span>元
                    <#elseif dto.qgType=="guding">
                        达到&nbsp<span style="color:red;">${dto.gNum}</span>&nbsp元
                    </#if>
                <#elseif dto.type=="opencard">
                    开卡送<span style="color:red;">${dto.openCardNum!}</span>
                    <#if dto.giveType=="integral">
                        积分
                    </#if>
                    <#if dto.giveType=="money">
                        元
                    </#if>
                <#elseif dto.type=="minimum">
                    最低充值<span style="color:red;">${dto.minRecharge}</span>元
                <#elseif dto.type=="sign">
                    签到送<span style="color:red;">${dto.openCardNum!}</span>
                <#elseif dto.type=="pay">
                    <span style="color:red;">相同金额的积分</span>
                <#elseif dto.type=="promotion">
                    单次充值<span style="color:red;">${dto.jsNum!}</span>
                <#elseif dto.type=="sendIntegral">
                    <span style="color:red;">
                        <#if dto.enable>
                            开启
                        <#else>
                            关闭
                        </#if>
                    </span>
                </#if>
            </td>
            <td>
                <#if  dto.type=="integralConsumption">
                    ————
                <#elseif dto.qgType?? && dto.qgType=="qujian">
                    <span style="color:red;">
                        <#if dto.qType=="percentage">
                            ${dto.qPercentage}%
                        <#elseif dto.qType=="fixed">
                            ${dto.qFixed}
                        </#if>
                    </span>
                <#elseif dto.qgType?? && dto.qgType=="guding">
                    <span style="color:red;">
                        <#if dto.gType=="percentage">
                            ${dto.gPercentage}%
                        <#elseif dto.gType=="fixed">
                            ${dto.gFixed}
                        </#if>
                    </span>
                <#else>
                    ————
                </#if>
            </td>
            <td>
                <#if  dto.type=="integralConsumption">
                    ————
                <#elseif dto.giveType?? && dto.giveType=="integral">
                    <#if dto.type=="promotion"||dto.type=="sendIntegral">
                        ————
                    <#else>
                        积分
                    </#if>
                <#elseif dto.giveType?? && dto.giveType=="money">
                    金额
                <#else>
                    ————
                </#if>
            </td>
            <td>
                <#if dto.qgType?? && dto.qgType=="qujian">
                    区间
                <#elseif dto.qgType?? && dto.qgType=="guding">
                    固定
                <#else>
                    ————
                </#if>
            </td>
            <td>
                <#if dto.type=="recharge">
                    <span style="color:red;">充值</span>
                <#elseif dto.type=="consumption">
                    <span style="color:green;">消费</span>
                <#elseif dto.type=="opencard">
                    开卡
                <#elseif dto.type=="minimum">
                    最低充值
                <#elseif dto.type=="sign">
                    签到
                <#elseif dto.type=="pay">
                    支付
                <#elseif dto.type=="promotion">
                    升级会员
                <#elseif dto.type=="sendIntegral">
                    高级会员送积分/金额
                <#elseif dto.type=="integralConsumption">
                    积分消费
                </#if>
            </td>
            <td>
                <#if (dto.startDate)??>
                    <#if .now?date gt dto.startDate?date && dto.endDate?date gt .now?date>
                        <span style="color:green;">${dto.startDate?string('yyyy-MM-dd HH:mm:ss')}</span>
                    <#else>
                        <span style="color:red;">${dto.startDate?string('yyyy-MM-dd HH:mm:ss')}</span>
                    </#if>
                <#else>
                    ————
                </#if>
            </td>
            <td>
                <#if (dto.endDate)??>
                    <#if .now?date gt dto.startDate?date && dto.endDate?date gt .now?date>
                        <span style="color:green;">${(dto.endDate)?string('yyyy-MM-dd HH:mm:ss')}</span>
                    <#else>
                        <span style="color:red;">${(dto.endDate)?string('yyyy-MM-dd HH:mm:ss')}</span>
                    </#if>
                <#else>
                    ————
                </#if>
            </td>
            <td>
                <#if dto.enable>
                    <span style="color:green;">√</span>
                <#else>
                    <span style="color:red;">×</span>
                </#if>
            </td>
            <td>
                <input type="button" onclick="location.href='edit?id=${dto.id!?c}';"
                       class="layui-btn layui-btn-normal layui-btn-sm"
                       value="编辑"/>
                <input type="button" onclick="del('${dto.id?c}')" class="layui-btn layui-btn-normal layui-btn-sm"
                       value="删除"/>
            </td>
        </tr>
    </#list>
    </table>
<#include "/include/my_pagination.ftl">

<script type="text/javascript">
    function del(id) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg)==true){
            window.location.href="delete.jhtml?id="+id;
        }else{
            return false;
        }
    }

</script>
</body>
</html>