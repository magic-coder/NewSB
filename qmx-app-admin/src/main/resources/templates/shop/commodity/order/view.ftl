<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use('element', 'table', function () {
            var $ = layui.jquery;
            var table = layui.table;
            var element = layui.element; //Tab的切换功能，切换事件监听等，需要依赖element模块

            //触发事件
            var active = {
                tabAdd: function () {
                    //新增一个Tab项
                    element.tabAdd('demo', {
                        title: '新选项' + (Math.random() * 1000 | 0) //用于演示
                        , content: '内容' + (Math.random() * 1000 | 0)
                        , id: new Date().getTime() //实际使用一般是规定好的id，这里以时间戳模拟下
                    })
                }
                , tabDelete: function (othis) {
                    //删除指定Tab项
                    element.tabDelete('demo', '44'); //删除：“商品管理”


                    othis.addClass('layui-btn-disabled');
                }
                , tabChange: function () {
                    //切换到指定Tab项
                    element.tabChange('demo', '22'); //切换到：用户管理
                }
            };

            $('.site-demo-active').on('click', function () {
                var othis = $(this), type = othis.data('type');
                active[type] ? active[type].call(this, othis) : '';
            });

            //Hash地址的定位
            var layid = location.hash.replace(/^#test=/, '');
            element.tabChange('test', layid);

            element.on('tab(test)', function (elem) {
                location.hash = 'test=' + $(this).attr('lay-id');
            });


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

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>订单信息</legend>
</fieldset>
<div class="layui-tab">
    <ul class="layui-tab-title">
        <li class="layui-this">订单信息</li>
        <li>收款信息</li>
        <li>退款信息</li>
        <li>订单日志</li>
    </ul>
    <div class="layui-tab-content">
        <!--订单信息-->
        <div class="layui-tab-item layui-show">
            <table class="layui-table" style="width: auto;text-align: center">
                <tr>
                    <th>产品名称（ID）</th>
                    <td>${dto.releaseName!}(${dto.releaseId!})</td>
                    <th>订单id</th>
                    <td>${dto.id?c!}</td>
                    <th>订单编号</th>
                    <td>${dto.sn!}</td>
                </tr>
                <tr>
                    <th>支付状态</th>
                    <td><#if '${dto.paymentStatus!}'=='unpaid'>
                        <span style="color: red">未支付</span>
                    <#elseif '${dto.paymentStatus!}'=='paid'>
                        <span style="color: green">已支付</span>
                    </#if></td>
                    <th>订单金额</th>
                    <td> ${dto.totalAmount?string("currency")}</td>
                    <th>商品数量</th>
                    <td>${dto.quantity}</td>
                </tr>
                <tr>
                    <th>联系人</th>
                    <td>${dto.contactName!}</td>
                    <th>联系电话</th>
                    <td>${dto.contactPhone!}</td>
                    <th>发货方式</th>
                    <td> <#if '${dto.mailingMethod!}'=='1'>
                        邮寄
                    <#elseif '${dto.mailingMethod!}'=='2'>
                        发码
                    </#if></td>
                </tr>
            <#if dto.userAddressDto??>
                <tr>
                    <th>收货地址</th>
                    <td>${dto.userAddressDto.fullAddress!}</td>
                </tr>
            </#if>
            </table>
        </div>
        <!--收款信息-->
        <div class="layui-tab-item">
            <table class="layui-table" style="width: auto;text-align: center">
                <tr>
                    <th>订单id</th>
                    <th>支付方式</th>
                    <th>状态</th>
                    <th>创建日期</th>
                    <th>支付时间</th>
                </tr>
                <tr>
                    <td> ${dto.id?c!}</td>
                    <td>${dto.payMethod!"未支付"}</td>
                    <td><#if dto.paymentStatus=="paid">
                        <span style="color: red">已支付</span>
                    <#elseif dto.paymentStatus=="unpaid">
                        <span style="color: green">未支付</span>
                    </#if></td>
                    <td>${(dto.createTime!)?datetime}</td>
                    <td><#if dto.payTime??>
                             ${(dto.payTime!)?datetime}
                        </#if></td>
                </tr>
            </table>
        </div>
        <!--退款信息-->
        <div class="layui-tab-item">
            <table class="layui-table" style="width: auto;text-align: center">
                <tr>
                    <th>订单ID</th>
                    <th>退款状态</th>
                    <th>退款数量</th>
                    <th>创建日期</th>
                </tr>
                <tr>
                    <td>${dto.id?c!}</td>
                    <td><#if dto.refundState=="noRefund">
                        <span style="color: green">未退款</span>
                    <#elseif dto.refundState=="applied">
                        <span style="color: red">退款申请中</span>
                    <#elseif dto.refundState=="refunded">
                        <span style="color: green">已退款</span>
                    <#elseif dto.refundState=="disagreeRefunds">
                        <span style="color: green">不同意退款</span>
                    </#if></td>
                    <td><#if dto.refundState=="refundState">${dto.quantity!}<#else>
                        0</#if></td>
                    <td>${(dto.createTime!)?datetime}</td>
                </tr>
            </table>
        </div>
        <!--订单日志-->
        <div class="layui-tab-item">
            <table class="layui-table" style="width: auto;text-align: center">
                <tr>
                    <th>类型</th>
                    <th>操作员</th>
                    <th>内容</th>
                    <th>创建日期</th>
                    <th>备注</th>
                </tr>
            <#list orderLogs as info>
                <tr>
                    <td>${info.logType!}</td>
                    <td>${info.createName!}</td>
                    <td>${info.content!}</td>
                    <td>${info.createTime?datetime!}</td>
                    <td>${info.remark!}</td>
                </tr>
            </#list>
            </table>
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