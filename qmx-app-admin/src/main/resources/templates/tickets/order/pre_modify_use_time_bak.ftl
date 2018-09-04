<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>授权产品</title>
    <link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/resources/admin/dropdown/dropdown.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/resources/admin/css/product.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.lSelect.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropdown.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropqtable.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        修改使用日期
    </div>
</div>
<form id="inputForm" action="updateDistribution" method="post">
    <input type="hidden" name="id" value="${order.id}"/>
    <table class="input">
        <tr>
            <th>产品名称：</th>
            <td>
            ${order.productName!}
            </td>
        </tr>
        <tr>
            <th>
                当前有效日期:
            </th>
            <td>
                <#if distribution??>
                    <#if distribution.specifyDate>
                    ${order.useDate!}当天
                    <#else>
                        <#if order.vsdate == order.vedate>
                        ${order.vsdate!} 当天
                        <#else>
                        ${order.vsdate!}~${order.vedate!}
                        </#if>
                    </#if>
                <#else>
                    <#if order.vsdate == order.vedate>
                    ${order.vsdate!} 当天
                    <#else>
                    ${order.vsdate!}~${order.vedate!}
                    </#if>
                </#if>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>修改到:
            </th>
            <td>
                <#if distribution??>
                    <#if distribution.specifyDate>
                        <input id="useDate" name="useDate" type="text" class="text Wdate" maxlength="300"/>
                    <#else>
                        <input id="vsdate" name="vsdate" type="text" class="text Wdate" maxlength="300"/>
                        <input id="vedate" name="vedate" type="text" class="text Wdate" maxlength="300"/>
                    </#if>
                <#else>
                    <input name="vsdate" type="text" class="text Wdate" maxlength="300"/>
                    <input name="vedate" type="text" class="text Wdate" maxlength="300"/>
                </#if>
            </td>
        </tr>
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="submit" class="button" value="保存"/>
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript">
$(function () {

    <#if distribution??>
        var prices = {<#list distribution.distributionPrices as price>'${price.useDate}':${price.authPrice},</#list>};
        <#if distribution.cannotUseDays??>
        var disabledDates = <<#list distribution.cannotUseDays?split(",") as price>'${price}',</#list>>;
        <#else>
        var disabledDates = [];
        </#if>
        <#if distribution.specifyDate>
            $("input[name=useDate]").click(function () {
                WdatePicker({
                    minDate:'${distribution.vsdate}',
                    maxDate:'${distribution.vedate}',
                    dateFmt:'yyyy-MM-dd',
                    doubleCalendar:true,
                    opposite:true,
                    disabledDates:disabledDates,
                    onpicked:function(dp){
                    }
                });
            });
        <#else>
            $("input[name=vsdate]").click(function () {
                WdatePicker({
                    minDate:'${distribution.vsdate}',
                    maxDate:'${distribution.vedate}',
                    dateFmt:'yyyy-MM-dd',
                    doubleCalendar:true,
                    opposite:true,
                    disabledDates:disabledDates,
                    onpicked:function(dp){
                    }
                });
            });
            $("input[name=vedate]").click(function () {
                WdatePicker({
                    minDate:'${distribution.vsdate}',
                    maxDate:'${distribution.vedate}',
                    dateFmt:'yyyy-MM-dd',
                    doubleCalendar:true,
                    opposite:true,
                    disabledDates:disabledDates,
                    onpicked:function(dp){
                    }
                });
            });
        </#if>
    <#else>
        $("input[name=vsdate]").click(function () {
            WdatePicker({

                minDate:'${.now?string("yyyy-MM-dd")}',
                maxDate:'#F{$dp.$D(\'vedate\',{d:-1});}',
                dateFmt:'yyyy-MM-dd',
                doubleCalendar:true,
                opposite:true,
                onpicked:function(dp){
                    //$dp.$('vedate').value = '';
                }

            });
        });
        $("input[name=vedate]").click(function () {
            WdatePicker({
                minDate:'#F{$dp.$D(\'beginDate\',{d:1});}',
                dateFmt:'yyyy-MM-dd',
                doubleCalendar:true,
                opposite:true,
                onpicked:function(dp){
                }
            });
        });
    </#if>
});
</script>
</body>
</html>