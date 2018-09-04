<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>订单列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item" align="left">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="sn" value="${dto.sn!}" autocomplete="off"
                       class="layui-input" placeholder="订单编号">
            </div>
            <div class="layui-input-inline">
                <input type="text" name="memberName" value="${dto.memberName!}" autocomplete="off"
                       class="layui-input" placeholder="旅行社">
            </div>
            <div class="layui-input-inline">
                <input type="text" name="createName" value="${dto.createName!}" autocomplete="off"
                       class="layui-input" placeholder="创单人">
            </div>
            <div class="layui-input-inline">
                <select class="layui-input" name="orderStatus">
                    <option value="">接单状态</option>
                <#list orderStatus as info>
                    <option value="${info}"
                            <#if dto.orderStatus??&&info==dto.orderStatus>selected</#if>>${info.title}</option>
                </#list>
                </select>
            </div>
            <div class="layui-input-inline">
                <select class="layui-input" name="checkStatus">
                    <option value="">修改状态</option>
                <#list checkStatus as info>
                    <option value="${info}"
                            <#if dto.checkStatus??&&info==dto.checkStatus>selected</#if>>${info.title}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item" align="left">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline">
                <select class="layui-input" name="refundStatus">
                    <option value="">退款状态</option>
                <#list refundStatus as info>
                    <option value="${info}"
                            <#if dto.refundStatus??&&info==dto.refundStatus>selected</#if>>${info.title}</option>
                </#list>
                </select>
            </div>
            <div class="layui-input-inline">
                <select class="layui-input" name="syncStatus">
                    <option value="">同步状态</option>
                    <option value="true" <#if dto.syncStatus??&&dto.syncStatus>selected</#if>>已同步</option>
                    <option value="false" <#if dto.syncStatus??&&!dto.syncStatus>selected</#if>>未同步</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select class="layui-input" name="ticketStatus">
                    <option value="">消费状态</option>
                    <option value="true"
                            <#if dto.ticketStatus??&&dto.ticketStatus>selected</#if>>已消费
                    </option>
                    <option value="false"
                            <#if dto.ticketStatus??&&!dto.ticketStatus>selected</#if>>未消费
                    </option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select class="layui-input" name="taPaymentStatus">
                    <option value="">支付状态</option>
                <#list payStatus as info>
                    <option value="${info}"
                            <#if dto.taPaymentStatus??&&info==dto.taPaymentStatus>selected</#if>>${info.title}</option>
                </#list>
                </select>
            </div>
            <div class="layui-input-inline">
                <select class="layui-input" name="noteSendStatus">
                    <option value="">通知状态</option>
                <#list notStatus as info>
                    <option value="${info}"
                            <#if dto.noteSendStatus??&&info==dto.noteSendStatus>selected</#if>>${info.title}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>

    <div class="layui-form-item" align="left">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="date" value="${dto.date!}" id="date" autocomplete="off"
                       class="layui-input" placeholder="游玩日期">
            </div>
            <div class="layui-input-inline">
                <input type="text" name="sDate" value="${dto.sDate!}" id="sDate" autocomplete="off"
                       class="layui-input" placeholder="下单日期起">
            </div>
            <div class="layui-input-inline">
                <input type="text" name="eDate" value="${dto.eDate!}" id="eDate" autocomplete="off"
                       class="layui-input" placeholder="下单日期止">
            </div>
            <div class="layui-input-inline">
                <input type="text" name="sTime" value="${dto.sTime!}" id="sTime" autocomplete="off"
                       class="layui-input" placeholder="消费时间起">
            </div>
            <div class="layui-input-inline">
                <input type="text" name="eTime" value="${dto.eTime!}" id="eTime" autocomplete="off"
                       class="layui-input" placeholder="消费时间止">
            </div>
        </div>
    </div>
    <div class="layui-form-item" align="left">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item" style="margin-left: 10px;">
</div>

<table id="listTable" class="layui-table">
    <thead>
    <tr>
        <th class="check"><input type="checkbox" id="selectAll"/></th>
        <th>客户信息</th>
        <th>订单状态</th>
        <th>时间及价格</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>
        ${dto.memberName!}<br/>订单号:${dto.sn!}<br/>创单人:${dto.createName!}
        </td>
        <td>
            <div>
                <table class="layui-table" lay-skin="nob">
                    <tr>
                        <td>
                            支付状态: <#if dto.taPaymentStatus=='finalpaid'||dto.taPaymentStatus=='paid'||dto.taPaymentStatus=='withoutmargin'>
                        <span style="color: green">
                        <#else>
                        <span style="color: red">
                        </#if>
                        ${dto.taPaymentStatus.title!}</span>
                        </td>
                        <td>
                            通知状态: <#if dto.noteSendStatus=='unsent'>
                        <span style="color: red">
                        <#else>
                        <span style="color: green">
                        </#if>
                        ${dto.noteSendStatus.title!}</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            接单状态:<#if dto.orderStatus=='unhaveOrder'>
                        <span style="color: red">
                        <#elseif dto.orderStatus=='updateApplied'>
                        <span style="color: red">
                        <#else>
                        <span style="color: green">
                        </#if>
                        ${dto.orderStatus.title!}</span>
                        </td>
                        <td>
                            修改状态:<#if dto.checkStatus=='applied'>
                        <span style="color: red">
                        <#elseif dto.checkStatus=='audit'>
                        <span style="color: green">
                        <#elseif dto.checkStatus=='disagreeAudit'>
                        <span style="color: green">
                        </#if>
                        ${dto.checkStatus.title!}</span>
                        </td>
                    </tr>
                    <tr>
                        <td>退款状态:<#if dto.refundStatus=='applied'>
                        <span style="color: red">
                        <#else>
                        <span style="color: green">
                        </#if>
                        ${dto.refundStatus.title!}</span>
                        </td>
                        <td>
                            同步状态:<#if dto.syncStatus>已同步<#else>未同步</#if>
                        </td>
                    </tr>
                    <tr>
                        <td>消费状态:<#if dto.ticketStatus||dto.checkTicketStatus><span
                                style="color: green">已消费</span><#else>未消费</#if></td>
                    </tr>
                </table>
            </div>
        </td>
        <td>
            总价:${dto.totalAmount!}/定金:${dto.deposit!}/尾款:${dto.totalAmount-dto.deposit}
            <br/>
            游玩日期:${dto.date!}
            <br/>
            创单时间:${dto.createTime!?string("yyyy-MM-dd HH:mm:ss")}
            <br/>
            <#if dto.consumeTime??>消费时间:${dto.consumeTime!}</#if>
        </td>
        <td>
            <@shiro.hasPermission name="admin:taOrderEdit">
                <#if (dto.refundStatus=='noRefund'||dto.refundStatus=='unRefund')  && (dto.taPaymentStatus!="finalpaid" && dto.taPaymentStatus!="paid") && (!dto.ticketStatus||!dto.checkTicketStatus)>
                    <input type="button" onclick="location.href='edit?id=${dto.id!}';"
                           class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="editBtn"
                           value="编辑"/>
                </#if>
            </@shiro.hasPermission>
            <#if dto.taPaymentStatus=='unpaid'>
                <@shiro.hasPermission name="admin:taOrderPaydt">
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                           id="paymentBtn" value="支付定金" data-type="deposit"/>
                </@shiro.hasPermission>
            <#elseif (dto.taPaymentStatus=='depositpaid'||dto.taPaymentStatus=='withoutmargin')&&(dto.refundStatus=='noRefund'||dto.refundStatus=='unRefund')&&dto.orderStatus=='haveOrder'&&(dto.totalAmount-dto.deposit!=0)>
                <@shiro.hasPermission name="admin:taOrderPayfinal">
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                           id="paymentBtn" value="支付尾款" data-type="finalPay"/>
                </@shiro.hasPermission>
            </#if>
            <#if dto.taPaymentStatus!='unpaid' && (dto.orderStatus=='unhaveOrder' || dto.orderStatus == "updateApplied")&&(dto.refundStatus=='noRefund'||dto.refundStatus=='unRefund')>
                <@shiro.hasPermission name="admin:taOrderReceiving">
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                           id="orderReceiving" value="接单"/>
                </@shiro.hasPermission>
            </#if>

            <#if dto.taPaymentStatus=='finalpaid' || dto.taPaymentStatus=='buyer'>
                <#if !dto.noticeSync?? || (dto.noticeSync?? && !dto.noticeSync)>
                    <@shiro.hasPermission name="admin:taNoticeSync">
                        <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                               id="noticeSync" value="通知出票"/>
                    </@shiro.hasPermission>
                </#if>
            </#if>

            <@shiro.hasPermission name="admin:taOrderDelete">
                <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}" id="deleteBtn"
                       value="删除"/>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="admin:taOrderView">
                <input type="button" onclick="location.href='view?id=${dto.id!}';"
                       class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}"
                       value="查看"/>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="admin:taOrderSendsms">
                <#if (dto.taPaymentStatus=='depositpaid' && dto.orderStatus!='haveOrder') && dto.refundStatus!='refunded'>
                    <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}"
                           id="sendMessages" data-type="manager"
                           value="通知接单"/>
                </#if>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="admin:taOrderRefund">
                <#if dto.taPaymentStatus=='depositpaid'&&(dto.refundStatus=='noRefund'||dto.refundStatus=='unRefund')&&(dto.totalAmount-dto.deposit!=0)>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                           id="orderRefund" value="申请退款"/>
                </#if>
            </@shiro.hasPermission>
        <#--<@shiro.hasPermission name="admin:taOrderSingle">-->
            <#if dto.taPaymentStatus=='buyer'||dto.taPaymentStatus=='finalpaid'||dto.taPaymentStatus=='paid'>
                <input type="button" onclick="location.href='/taOrderPrint/print?id=${dto.id!}';"
                       class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" value="单据下载"/>
            </#if>
        <#--</@shiro.hasPermission>-->
            <@shiro.hasPermission name="admin:taOrderAmend">
                <#if dto.taPaymentStatus!='finalpaid'&&dto.taPaymentStatus!='paid'&&dto.orderStatus=='haveOrder'>
                    <input type="button" onclick="location.href='/taOrderCheck/edit?id=${dto.id!}';"
                           class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}"
                           value="修改"/>
                </#if>
            </@shiro.hasPermission>
            <#if dto.checkStatus??&&dto.checkStatus=='applied'>
                <@shiro.hasPermission name="admin:taOrderCheck">
                    <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="check"
                           value="审核"/>
                </@shiro.hasPermission>
            </#if>
            <@shiro.hasPermission name="admin:taOrderConsume">
                <#if (dto.taPaymentStatus=='finalpaid'||dto.taPaymentStatus=='buyer'||dto.taPaymentStatus=='paid')&&!dto.ticketStatus>
                    <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}"
                           id="consume"
                           value="确认消费"/>
                </#if>
            </@shiro.hasPermission>
        <#--<input type="button" onclick="location.href='consumeCount';"
               class="layui-btn layui-btn-normal layui-btn-sm" value="统计"/>-->
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">

</body>
<script>
    layui.use(['form', 'table', 'laydate'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;

        laydate.render({
            elem: '#date'
        });
        laydate.render({
            elem: '#sTime'
        });
        laydate.render({
            elem: '#eTime'
        });
        laydate.render({
            elem: '#sDate'
        });
        laydate.render({
            elem: '#eDate'
        });
        form.render();
    });
</script>
<script>
    //删除
    $(document).on("click", "#deleteBtn", function () {
        var data = $(this).attr("data-id");
        layer.confirm('确定删除吗？', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: "delete",
                type: "POST",
                data: {id: data},
                beforeSend: function () {
                },
                success: function (json) {
                    if (json.state == "success") {
                        layer.msg(json.msg);
                        setTimeout(function () {
                            location.reload(true);
                        }, 500);
                    } else {
                        layer.msg(json.msg);
                    }
                }
            });
        }, function () {

        });
    });
    //订单支付
    $(document).on("click", "#paymentBtn", function () {
        var data = $(this).attr("data-id");
        var type = $(this).attr("data-type");
        var index = layer.open({
            type: 2,
            title: '订单支付',
            area: ['70%', '70%'], //宽高
            fix: true, //固定
            content: 'payment?id=' + data + "&type=" + type,
            end: function () {
            }
        });
    });
    //接单
    $(document).on("click", "#orderReceiving", function () {
        var data = $(this).attr("data-id");
        layer.confirm('确定接单吗？', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: "orderReceiving",
                type: "POST",
                async: false,
                data: {id: data},
                beforeSend: function () {
                },
                success: function (json) {
                    if (json.state == "success") {
                        layer.msg(json.msg);
                        setTimeout(function () {
                            location.reload(true);
                        }, 500);
                    } else {
                        layer.msg(json.msg);
                    }
                }
            });
        }, function () {

        });
    });
    //通知订单同步
    $(document).on("click", "#noticeSync", function () {
        var data = $(this).attr("data-id");
        layer.confirm('警告：当通知出票以后将无法撤回出票操作，也无法对订单做更改以及退款，需至少在通知10秒后方可使用，确认出票吗？', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: "noticeSync?id=" + data,
                type: "GET",
                success: function (json) {
                    if (json.state == "success") {
                        layer.msg(json.msg);
                    } else {
                        layer.msg(json.msg);
                    }
                }
            });
        }, function () {

        });
    });

    //发送短信
    /*$(document).on("click", "#sendMessages", function () {
        var data = $(this).attr("data-id");
        var type = $(this).attr("data-type");
        layer.confirm('确定发送吗？', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: "sendMessages",
                type: "POST",
                data: {id: data, type: type},
                beforeSend: function () {
                },
                success: function (json) {
                    if (json.state == "success") {
                        layer.msg(json.msg);
                        setTimeout(function () {
                            location.reload(true);
                        }, 500);
                    } else {
                        layer.msg(json.msg);
                    }
                }
            });
        }, function () {

        });
    });*/

    //发送短信通知客户经理接单
    $(document).on("click", "#sendMessages", function () {
        var data = $(this).attr("data-id");
        var type = $(this).attr("data-type");
        layer.confirm('确定发送吗？', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: "sendMessages",
                type: "POST",
                data: {id: data},
                beforeSend: function () {
                },
                success: function (json) {
                    if (json.state == "success") {
                        layer.msg(json.msg);
                        setTimeout(function () {
                            location.reload(true);
                        }, 500);
                    } else {
                        layer.msg(json.msg);
                    }
                }
            });
        }, function () {

        });
    });

    //申请退款
    $(document).on("click", "#orderRefund", function () {
        var data = $(this).attr("data-id");
        layer.confirm('确定申请退款吗？', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: "orderRefund",
                type: "GET",
                data: {id: data},
                beforeSend: function () {
                },
                success: function (json) {
                    if (json.state == "success") {
                        layer.msg(json.msg);
                        setTimeout(function () {
                            location.reload(true);
                        }, 500);
                    } else {
                        layer.msg(json.msg);
                    }
                }
            });
        }, function () {

        });
    });

    //审核
    $(document).on("click", "#check", function () {
        var data = $(this).attr("data-id");
        layer.confirm('确定审核吗？', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                type: 'Get',
                url: '/taOrderCheck/check',
                data: {id: data},
                success: function (result) {
                    if (result.flag == '审核成功') {
                        layer.msg(result.flag);
                        setTimeout(function () {
                            location.reload(true);
                        }, 500);
                    } else {
                        layer.msg(result.flag);
                    }
                }
            });
        }, function () {

        });
    });

    //消费
    $(document).on("click", "#consume", function () {
        var data = $(this).attr("data-id");
        layer.confirm('确定消费吗？', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                type: 'Get',
                url: 'orderConsume',
                data: {id: data},
                success: function (result) {
                    if (result.state == 'success') {
                        layer.msg(result.msg);
                        setTimeout(function () {
                            location.reload(true);
                        }, 500);
                    } else {
                        layer.msg(result.msg);
                    }
                }
            });
        }, function () {

        });
    });
</script>

</html>