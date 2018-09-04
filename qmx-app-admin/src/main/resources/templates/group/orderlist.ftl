<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>订单列表</title>
    <link href="${base}/resources/assets/bootstrap/css/bootstrap-modify.css" rel="stylesheet"/>
    <link href="${base}/resources/module/system/css/bootstrap-tags.css" rel="stylesheet"/>
    <link href="${base}/resources/assets/bootstrap-select/css/bootstrap-select.css" rel="stylesheet"/>
    <link href="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.css" rel="stylesheet"/>
    <link href="${base}/resources/common/css/qmx-gds.css" rel="stylesheet"/>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/resources/assets/bootstrap/js/bootstrap.js" charset="UTF-8"></script>
    <script type="text/javascript" src="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.js"
            charset="UTF-8"></script>
    <script type="text/javascript"
            src="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js"
            charset="UTF-8"></script>
    <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <script src="${base}/resources/module/system/js/bootstrap-select.js"></script>
    <script src="${base}/resources/module/system/js/bootstrap-tags.js"></script>
</head>
<body class="gds">
<div class="container-fluid">
    <form class="form-inline" action="">
        <div id="flex" class="gds-search flex">
            <div class="row">
                <div class="form-group">
                    <label for="exampleInputName2">电子票号</label>
                    <input type="text" value="" name="contactMobile" class="form-control gds-input"
                           placeholder="电子票号/手机号">
                </div>
                <div class="form-group">
                    <label>产品</label>
                    <input type="text" value="" name="snAndName" class="form-control gds-input" placeholder="门票名称/编码">
                </div>
                <div class="gds-group">
                    <button type="submit" class="btn btn-default gds-btn-1">查询</button>
                    <a class="btn btn-default gds-btn-1" href="">重置</a>
                </div>
            </div>
            <div class="row">
                <div class="form-group">
                    <label>游玩日期</label>
                    <input type="text" value="" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd"
                           name="useDate" class="form-control gds-input" placeholder="游玩日期">
                </div>
                <div class="form-group">
                    <label>下单日期起</label>
                    <input type="text" value="" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd"
                           name="createTimeStart" class="form-control gds-input" placeholder="下单日期起">
                </div>
                <div class="form-group">
                    <label>下单日期止</label>
                    <input type="text" value="" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd"
                           name="createTimeEnd" class="form-control gds-input" placeholder="下单日期止">
                </div>
            </div>
        <#assign flagCollapsed = true/>
            <input type="hidden" name="flagCollapsed" value="${flagCollapsed?string("true","false")}"/>
            <span class="serach-flex <#if !flagCollapsed>collapsed</#if>" data-toggle="collapse" data-parent="#flex"
                  href="#searchMore" aria-expanded="<#if flagCollapsed>true<#else>false</#if>"></span>
            <div id="searchMore" class="collapse <#if flagCollapsed>in</#if>">
                <div class="row">
                    <div class="form-group">
                        <label>游客姓名</label>
                        <input type="text" value="" name="contactName" class="form-control gds-input"
                               placeholder="游客姓名">
                    </div>
                    <div class="form-group">
                        <label>销售人</label>
                        <input type="text" value="" name="createAccount" class="form-control gds-input"
                               placeholder="销售人">
                    </div>
                    <div class="form-group">
                        <label>检票人</label>
                        <input type="text" value="" name="checkAccount" class="form-control gds-input"
                               placeholder="检票人">
                    </div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label>外平台订单号</label>
                        <input type="text" value="" name="outSn" class="form-control gds-input"
                               placeholder="外平台订单号">
                    </div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label>支付状态</label>
                        <select class="selectpicker" name="payStatus">
                            <option value="">选择支付状态</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>支付方式</label>
                        <select class="selectpicker" name="paymentMethod">
                            <option value="">请选择</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>退款状态</label>
                        <select class="selectpicker" name="refundStatus">
                            <option value="">请选择</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>发货状态</label>
                        <select class="selectpicker" name="shippingStatus">
                            <option value="">请选择</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label>交易场景</label>
                        <select class="selectpicker" name="saleChannel">
                            <option value="">请选择</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>部分退款订单</label>
                        <select class="selectpicker" name="partRefundFlag">
                            <option value="">请选择</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
        <div class="gds-container">
        <#--<ul id="myTab" class="nav nav-tabs">
            <li>
                <a href="#all" data-toggle="tab">全部记录</a>
            </li>
            <li>
                <a href="#self" data-toggle="tab">自营记录</a>
            </li>
            <li>
                <a href="#cooperate" data-toggle="tab">合作记录</a>
            </li>
        </ul>-->
            <div id="myTabContent" class="tab-content">
                <div class="tab-pane fade in active">
                    <table class="table gds-table table-bordered">
                        <tr>
                            <th>姓名 / 手机号</th>
                            <th>订单编号</th>
                            <th>产品名称 / 产品编码</th>
                            <th>价格*张数=</th>
                            <th>购买时间</th>
                            <th>消费时间</th>
                            <th>订单有效期</th>
                            <th>状态</th>
                            <th>同步状态</th>
                        </tr>


                        <tr>
                            <td>测试<br>17608322940</td>
                            <td>内：996296976481959937</td>
                            <td>恐龙主题房双人套餐（467963）</td>
                            <td>998.00 * 1 = 998.00</td>
                            <td>2018-05-15<br>15:51:24</td>
                            <td><br></td>
                            <td>
                                2018-05-15当天
                            </td>
                            <td>
                                未支付
                            </td>
                            <td>
                                <span class="text-muted">线下</span><br>
                                <span class="text-muted">未同步</span>
                            </td>
                        </tr>
                        <tr>
                            <td>cs<br>17608322940</td>
                            <td>内：996276228610637826</td>
                            <td>恐龙主题房双人套餐（467963）</td>
                            <td>998.00 * 1 = 998.00</td>
                            <td>2018-05-15<br>14:28:57</td>
                            <td><br></td>
                            <td>
                                2018-05-15当天
                            </td>
                            <td>
                                未支付
                            </td>
                            <td>
                                <span class="text-muted">线下</span><br>
                                <span class="text-muted">未同步</span>
                            </td>
                        </tr>
                        <tr>
                            <td>ces<br>13565685626</td>
                            <td>内：996215002690011138</td>
                            <td>恐龙园水陆套票（10153）</td>
                            <td>358.00 * 1 = 358.00</td>
                            <td>2018-05-15<br>10:25:39</td>
                            <td>2018-05-15<br>10:29:14</td>
                            <td>
                                2018-05-15当天
                            </td>
                            <td>
                                已发货
                            </td>
                            <td>
                                <span class="text-muted">线下</span><br>
                                <span class="text-muted">未同步</span>
                            </td>
                        </tr>


                    <#--<#list page.records as order>
                        <tr>
                            <td>${order.contactName!}<br/>${order.contactMobile!}</td>
                            <td>内：${order.id!}<#if order.outSn??><br/>外：${order.outSn!}</#if></td>
                            <td>${order.productSn!}<br/>${order.productName!}</td>
                            <td>${order.salePrice?string("0.00")} * ${order.quantity!}
                                = ${order.totalAmount?string("0.00")}</td>
                            <td>${order.createTime?date}<br/>${order.createTime?time}</td>
                            <td><#if order.consumeDate??>${order.consumeDate?date}</#if>
                                <br/><#if order.consumeDate??>${order.consumeDate?time}</#if></td>
                            <td>
                                <#if order.vsdate == order.vedate>
                                ${order.vsdate!}当天
                                <#else>
                                ${order.vsdate!}<br/>~<br/>${order.vedate!}
                                </#if>
                            </td>
                            <td>
                                <#if order.payStatus = 'PAID'>
                                    <#if order.shippingStatus == 'SHIPPED'>
                                        消费${order.consumeQuantity!}张<br/> 退款${order.returnQuantity!}
                                        张<br/>申请退款${order.returningQuantity!}张
                                    <#else>
                                    ${order.shippingStatus.getName()!}
                                    </#if>
                                <#else>
                                ${order.payStatus.getName()!}
                                </#if>
                            </td>
                            <td>
                                <span class="text-muted"><#if order.offLineStatus == 'No'>线上<#else>线下</#if></span><br/>
                                <span class="text-muted">
                                    <#if order.offLineStatus != 'No'>
                                        <#if order.offLineStatus == 'NotSynchronized'>未同步<#else>已同步</#if>
                                    </#if>
                        </span>
                            </td>
                            <td>
                                <a class="table-action orderView" data-id="${order.id!}">订单详情</a>&nbsp;
                                <@shiro.hasPermission name = "admin:refundTicketsOrder">
                                    <#if order.canRefund && order.payStatus == "PAID" && order.consumeStatus != 'CONSUMED' && (order.refundStatus == 'NO_REFUND' || order.refundStatus == 'PARTIAL_REFUNDED' || order.refundStatus == 'WAITING_THIRD')>
                                        <a class="table-action applyRefund" data-id="${order.id!}">申请退款</a>
                                    </#if>
                                </@shiro.hasPermission>
                                <br/>
                                <@shiro.hasPermission name = "admin:auditTicketsOrderRefund">
                                    <#if order.refundStatus == 'APPLIED'>
                                        <a class="table-action auditRefund" data-id="${order.id!}">退款审核</a>&nbsp;
                                    </#if>
                                </@shiro.hasPermission>
                                <@shiro.hasPermission name = "admin:modifyTicketsOrder">
                                    <#if order.payStatus == "PAID" && order.consumeStatus == 'UNCONSUME' && order.refundStatus == 'NO_REFUND'>
                                        <a class="table-action modifyUseTime" data-id="${order.id!}">修改订单</a>
                                    </#if>
                                </@shiro.hasPermission>
                                <@shiro.hasPermission name = "admin:payTicketsOrder">
                                    <#if order.payStatus == "UNPAID" && order.expire?? && order.expire?datetime gt .now?datetime>
                                        <a href="onlinePayPage?orderId=${order.id!}" class="table-action">支付订单</a>&nbsp;
                                    </#if>
                                </@shiro.hasPermission>
                                <@shiro.hasPermission name = "admin:shippingTicketsOrder">
                                    <#if order.payStatus == "PAID" && (order.quantity - order.consumeQuantity - order.returnQuantity-order.returningQuantity >0)>
                                        <a data-id="${order.id!}" class="table-action shppingTicketsOrder">重发短信</a>
                                    </#if>
                                </@shiro.hasPermission>
                            </td>
                        </tr>
                    </#list>-->
                    </table>
                </div>
            </div>
            <!--分页-->
        <#--<#include "/include/pagination_new.ftl">-->
    </form>
</div>
<script>
    $(function () {
        //$('#myTab li:eq(0) a').tab('show');
        $('a[href="#all"]').click(function (e) {
            $("input[name=supplierFlag]").val(null);
            $("form").submit();
        });
        $('a[href="#self"]').click(function (e) {
            //e.preventDefault();
            $("input[name=supplierFlag]").val(false);
            $("form").submit();
        });
        $('a[href="#cooperate"]').click(function (e) {
            $("input[name=supplierFlag]").val(true);
            $("form").submit();
        });
        $('span[href="#searchMore"]').click(function () {
            var flag = $(this).attr("aria-expanded");
            if (flag == 'true') {
                $("input[name=flagCollapsed]").val(false)
            } else {
                $("input[name=flagCollapsed]").val(true)
            }
        });

        $(".orderView").click(function () {
            var data = $(this).attr("data-id");
            layer.open({
                type: 2,
                title: '订单详情',
                area: ['880px', '600px'], //宽高
                fix: true, //固定
                content: 'view?id=' + data
            });
        });
        $(".applyRefund").click(function () {
            var data = $(this).attr("data-id");
            layer.open({
                type: 2,
                title: '申请退款',
                area: ['680px', '400px'], //宽高
                fix: true, //固定
                content: 'preRefund?id=' + data
            });
        });
        $(".auditRefund").click(function () {
            var data = $(this).attr("data-id");
            layer.open({
                type: 2,
                title: '退款审核',
                area: ['680px', '450px'], //宽高
                fix: true, //固定
                content: 'preAuditRefund?id=' + data
            });
        });
        $(".modifyUseTime").click(function () {
            var data = $(this).attr("data-id");
            layer.open({
                type: 2,
                title: '修改使用日期',
                area: ['450px', '360px'], //宽高
                fix: true, //固定
                content: 'preModifyUseTime?id=' + data
            });
        });

        //使用日期
        $('input[name=useDate]').datetimepicker({
            language: 'zh-CN',
            weekStart: 1,
            todayBtn: 1,
            autoclose: 1,
            todayHighlight: 1,
            startView: 2,
            minView: 2,
            forceParse: 0
        });

        //下单起
        $('input[name=createTimeStart]').datetimepicker({
            language: 'zh-CN',
            weekStart: 1,
            todayBtn: 1,
            autoclose: 1,
            todayHighlight: 1,
            startView: 2,
            minView: 2,
            forceParse: 0
        }).on('change', function (ev) {
            var startDate = $('input[name=createTimeStart]').val();
            $("input[name=createTimeEnd]").datetimepicker('setStartDate', startDate);
            //$("#startDate").datetimepicker('hide');
        });

        //下单止
        $('input[name=createTimeEnd]').datetimepicker({
            language: 'zh-CN',
            //startDate: new Date(),
            weekStart: 1,
            todayBtn: 1,
            autoclose: 1,
            todayHighlight: 1,
            startView: 2,
            minView: 2,
            forceParse: 0
        }).on('change', function (ev) {
            var returnDate = $("input[name=createTimeEnd]").val();
            $("input[name=createTimeStart]").datetimepicker('setEndDate', returnDate);
            //$("#returnDate").datetimepicker('hide');
        });
        $(".shppingTicketsOrder").click(function () {
            var flag = window.confirm("确定发送短信?");
            //alert(flag);
            if (flag == true) {
                var id = $(this).attr("data-id");
                $.ajax({
                    url: 'shipping?orderId=' + id,
                    type: 'POST', //GET
                    //async:true,    //或false,是否异步
                    success: function (resp) {
                        if (resp.errorCode == 0) {
                            alert("发送成功");
                        } else {
                            alert(resp.errorMsg);
                        }
                    },
                    error: function (xhr, textStatus) {
                        alert(xhr.responseText);
                    }
                });
            }
        });
    });
</script>
</body>
</html>