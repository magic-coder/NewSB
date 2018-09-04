<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>订单查看</title>
    <#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        layui.use(['form', 'table', 'element'], function () {
            var table = layui.table;
            var form = layui.form;
            var $ = layui.jquery;
            var element = layui.element; //Tab的切换功能，切换事件监听等，需要依赖element模块
        });
    </script>
    <style type="text/css">
        .roles label {
            width: 150px;
            display: block;
            float: left;
            padding-right: 6px;
        }
    </style>
</head>
<body>

<div class="layui-tab">
    <ul class="layui-tab-title">
        <li class="layui-this">订单信息</li>
        <li>收款信息</li>
        <li>退款信息</li>
        <li>订单日志</li>
    </ul>
    <div class="layui-tab-content">

        <div class="layui-tab-item layui-show">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>订单信息</legend>
            </fieldset>
            <!--第一行-->
            <div class="layui-form-item" >
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left">订单编号：${dto.sn!}</label>
                </div>
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left"> 产品名称（ID）：${dto.productName!}（${dto.productId!}）</label>
                </div>
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left"> 退款数量：${dto.roomNumber}</label>
                </div>
            </div>
            <!--第二行-->
            <div class="layui-form-item" >
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left">订单状态：
                    <#if '${dto.status!}'=='inited'>
                        未消费
                    <#elseif '${dto.status!}'=='completed'>
                        已消费
                    <#elseif '${dto.status!}'=='cancelled'>
                        已取消
                    </#if></label>
                </div>
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left"> 支付状态：
                    <#if '${dto.paymentStatus!}'=='unpaid'>
                        未支付
                    <#elseif '${dto.paymentStatus!}'=='paid'>
                        已支付
                    </#if></label>
                </div>
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left"> 支付时间：${dto.payTime?string("yyyy-MM-dd HH:mm:ss")}</label>
                </div>
            </div>
            <!--第三行-->
            <div class="layui-form-item" >
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left">房间数量：${dto.roomNumber!}</label>
                </div>
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left"> 入住几晚：${dto.nights!}晚</label>
                </div>
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left"> 下单人： ${dto.contactName!}</label>
                </div>
            </div>
            <!--第四行-->
            <div class="layui-form-item" >
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left">联系方式：${dto.contactPhone!}</label>
                </div>
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left"> 入住时间：${dto.checkIn!}</label>
                </div>
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left"> 离店时间：${dto.checkOut!}</label>
                </div>
            </div>
            <!--第五行-->
            <div class="layui-form-item" >
                <div class="layui-inline" >
                    <label class="layui-form-label" style="width: 400px;text-align: left">总房费：${dto.payment!}元</label>
                </div>
            </div>

            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>用户信息</legend>
            </fieldset>

            <div class="layui-form">
                <table class="layui-table">
                    <colgroup>
                        <col width="150">
                        <col width="150">
                        <col width="200">
                        <col>
                    </colgroup>
                    <thead>
                    <tr>
                        <th>姓名</th>
                        <th>手机</th>
                        <th>身份证号</th>
                        <th>自定义</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>${dto.contactName!}</td>
                        <td>${dto.contactPhone!}</td>
                        <td>${dto.contactIdCard!}</td>
                        <td>${dto.message!}</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>订单价格信息</legend>
            </fieldset>
            <div class="layui-form">
                <table class="layui-table">
                    <colgroup>
                        <col width="150">
                        <col width="150">
                        <col width="200">
                        <col>
                    </colgroup>
                    <thead>
                    <tr>
                        <th>日期</th>
                        <th>单价</th>
                        <th>优惠额</th>
                        <th>成交价</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list priceList as info>
                    <tr>
                        <td>${info.orderDate!}</td>
                        <td>${info.price!}</td>
                        <td>${info.discounts!}</td>
                        <td>${info.transactionPrice!}&nbsp;x&nbsp;${dto.roomNumber!}</td>
                    </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="layui-tab-item">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>收款信息</legend>
            </fieldset>
            <div class="layui-form">
                <table class="layui-table">
                    <colgroup>
                        <col width="150">
                        <col width="150">
                        <col width="200">
                        <col>
                    </colgroup>
                    <thead>
                    <tr>
                        <th>编号</th>
                        <th>支付方式</th>
                        <th>支付状态</th>
                        <th>创建日期</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="layui-tab-item">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>退款信息</legend>
            </fieldset>
            <div class="layui-form">
                <table class="layui-table">
                    <colgroup>
                        <col width="150">
                        <col width="150">
                        <col width="200">
                        <col>
                    </colgroup>
                    <thead>
                    <tr>
                        <th>编号</th>
                        <th>退款方式</th>
                        <th>支付方式</th>
                        <th>退订数量</th>
                        <th>创建日期</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if refunds??>
                    <tr>
                        <td>
                        ${refunds.orderSn!}
                        </td>
                        <td>
                            -
                        </td>
                        <td>
                            -
                        </td>
                        <td>
                        ${refunds.quantity!}
                        </td>
                        <td>
                        <#--${(refunds.createTime!)?string("yyyy-MM-dd HH:mm:ss")}-->
             ${(refunds.createTime!)?datetime}
                        </td>
                    </tr>
                    </#if>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="layui-tab-item">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>订单日志</legend>
            </fieldset>
            <div class="layui-form">
                <table class="layui-table">
                    <colgroup>
                        <col width="150">
                        <col width="150">
                        <col width="200">
                        <col width="200">
                        <col>
                    </colgroup>
                    <thead>
                    <tr>
                        <th>类型</th>
                        <th>操作员</th>
                        <th>内容</th>
                        <th>创建日期</th>
                        <th>备注</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list logList as info>
                    <tr>
                        <td>
                            <#list type?keys as key>
                <#if '${key!}'='${info.type!}'>
                            ${type[key]}
                            </#if>
            </#list>
                        </td>
                        <td>
                        ${info.createName!}
<#--            <#list sysUserDto?keys as key>
                <#if '${key!}'='${info.createBy!}'>
            ${sysUserDto[key]}
            </#if>
            </#list>-->
                        </td>
                        <td>
                        ${info.content!}
                        </td>
                        <td>
                        <#--${info.createTime!}-->
            ${(info.createTime!)?datetime}
                        </td>
                        <td>

                        </td>
                    </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="layui-form-item">
    <div class="layui-input-block">
        <input type="button" class="layui-btn layui-btn-primary" onclick="history.back();" value="返回"/>
    </div>
</div>

</body>
</html>