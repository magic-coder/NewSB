<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'laydate'], function () {
            var form = layui.form;
            var laydate = layui.laydate;
            laydate.render({
                elem: '#stime'
            });
            laydate.render({
                elem: '#etime'
            });
        });
    </script>
    <script>
        //关联旅行社
        $(document).on("click", "#travelagencyBtn", function () {
            var index = layer.open({
                type: 2,
                title: '关联旅行社',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'gettravelagency'
            });
        });
    </script>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>

    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>订单信息</legend>
    </fieldset>

<#--<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label">关联旅行社</label>
        <div class="layui-input-inline" style="width: auto;">
        &lt;#&ndash; <input id="travelagency" name="travelagencyId" type="hidden" lay-verify="required" autocomplete="off"
                class="layui-input" value="${dto.travelagencyId!?c}">&ndash;&gt;

            <div id="travelagencyName" class="layui-form-mid"></div>
            <div class="layui-form-mid">
            <#if dto.agencyDtos??>
                <#list dto.agencyDtos as info>
                    <input type="hidden" name="travelId" value="${info.userId!}"/>${info.name!}
                </#list>
            </#if>
            </div>
            <div id="travelagencyNames" class="layui-form-mid"></div>
        </div>
        <div class="layui-input-inline">
            <button id="travelagencyBtn" type="button" class="layui-btn">
                选择
            </button>
        </div>
    </div>
</div>-->
<#--<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label" style="width:auto;">规则名称</label>
        <div class="layui-input-inline" style="width:auto;">
            <input name="ruleName" value="${dto.ruleName!}" lay-verify="required" autocomplete="off"
                   class="layui-input">
        </div>
    </div>
</div>-->
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label" style="width:auto;">领队/导游信息</label>
            <div class="layui-input-inline" style="width:auto;">
                <input name="orderGuide" value="true" title="打印" type="radio"
                       <#if dto?? && dto.orderGuide>checked</#if>>
                <input name="orderGuide" value="false" title="不打印" type="radio"
                       <#if dto?? && !dto.orderGuide>checked</#if>>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">车辆信息</label>
            <div class="layui-input-inline" style="width:auto;">
                <input name="orderCar" value="true" title="打印" type="radio" <#if dto?? && dto.orderCar>checked</#if>>
                <input name="orderCar" value="false" title="不打印" type="radio"
                       <#if dto?? && !dto.orderCar>checked</#if>>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">司机信息</label>
            <div class="layui-input-inline" style="width:auto;">
                <input name="orderDriver" value="true" title="打印" type="radio"
                       <#if dto?? && dto.orderDriver>checked</#if>>
                <input name="orderDriver" value="false" title="不打印" type="radio"
                       <#if dto?? && !dto.orderDriver>checked</#if>>
            </div>
        </div>
    </div>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>消费内容</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label" style="width:auto;">订单详细价格信息</label>
            <div class="layui-input-inline" style="width:auto;">
                <input name="orderInfoPrice" value="true" title="打印" type="radio"
                       <#if dto?? && dto.orderInfoPrice>checked</#if>>
                <input name="orderInfoPrice" value="false" title="不打印" type="radio"
                       <#if dto?? && !dto.orderInfoPrice>checked</#if>>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label" style="width:auto;">产品二维码</label>
            <div class="layui-input-inline" style="width:auto;">
                <input name="productCode" value="true" title="打印" type="radio"
                       <#if dto.productCode?? && dto.productCode>checked</#if>>
                <input name="productCode" value="false" title="不打印" type="radio"
                       <#if dto.productCode?? && !dto.productCode>checked</#if>>
            </div>
        </div>
    </div>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>核准信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">已收定金</label>
            <div class="layui-input-inline" style="width:auto;">
                <input name="deposit" value="true" title="打印" type="radio" <#if dto?? && dto.deposit>checked</#if>>
                <input name="deposit" value="false" title="不打印" type="radio" <#if dto?? && !dto.deposit>checked</#if>>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">应收尾款</label>
            <div class="layui-input-inline" style="width:auto;">
                <input name="retainage" value="true" title="打印" type="radio" <#if dto?? && dto.retainage>checked</#if>>
                <input name="retainage" value="false" title="不打印" type="radio"
                       <#if dto?? && !dto.retainage>checked</#if>>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">共计应收</label>
            <div class="layui-input-inline" style="width:auto;">
                <input name="receivable" value="true" title="打印" type="radio"
                       <#if dto?? && dto.receivable>checked</#if>>
                <input name="receivable" value="false" title="不打印" type="radio"
                       <#if dto?? && !dto.receivable>checked</#if>>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">实收尾款</label>
            <div class="layui-input-inline" style="width:auto;">
                <input name="realRetainage" value="true" title="打印" type="radio"
                       <#if dto?? && dto.realRetainage>checked</#if>>
                <input name="realRetainage" value="false" title="不打印" type="radio"
                       <#if dto?? && !dto.realRetainage>checked</#if>>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">共计实收</label>
            <div class="layui-input-inline" style="width:auto;">
                <input name="realTotal" value="true" title="打印" type="radio" <#if dto?? && dto.realTotal>checked</#if>>
                <input name="realTotal" value="false" title="不打印" type="radio"
                       <#if dto?? && !dto.realTotal>checked</#if>>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit="" lay-filter="submit">提交</button>
            <input onclick="history.back();" type="button" class="layui-btn" value="返回"/>
        </div>
    </div>
</form>
</body>
</html>