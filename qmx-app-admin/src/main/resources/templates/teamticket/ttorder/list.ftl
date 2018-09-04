<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>订单列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            //订单退款
            $(document).on("click", "#refundOrder", function () {
                var data = $(this).attr("data-id");
                layer.confirm('确定退款吗？', {
                    btn: ['确定', '取消'] //按钮
                }, function () {
                    $.ajax({
                        url: "refundOrder",
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
            //订单查看
            $(document).on("click", "#viewBtn", function () {
                var data = $(this).attr("data-id");
                var index = layer.open({
                    type: 2,
                    title: '订单查看',
                    area: ['85%', '90%'], //宽高
                    fix: true, //固定
                    content: 'view?id=' + data
                });
            });
            //订单支付
            $(document).on("click", "#paymentBtn", function () {
                var data = $(this).attr("data-id");
                var index = layer.open({
                    type: 2,
                    title: '订单支付',
                    area: ['70%', '70%'], //宽高
                    fix: true, //固定
                    content: 'payment?id=' + data
                });
            });
            //订单审核通过
            $(document).on("click", "#agreeBtn", function () {
                var data = $(this).attr("data-id");
                layer.confirm('同意审核？', {
                    btn: ['确定', '取消'] //按钮
                }, function () {
                    $.ajax({
                        url: "agree",
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
            //订单审核不通过
            $(document).on("click", "#disagreeBtn", function () {
                var data = $(this).attr("data-id");
                layer.confirm('不同意审核？', {
                    btn: ['确定', '取消'] //按钮
                }, function () {
                    $.ajax({
                        url: "disagree",
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
            //发送短信
            $(document).on("click", "#sendMessages", function () {
                var data = $(this).attr("data-id");
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
            })
        });
    </script>
    <script>
        $(document).ready(function (e) {
            $("#selectAll").click(function () {
                if (this.checked) {
                    $("[name=ids]").attr("checked", true);
                } else {
                    $("[name=ids]").attr("checked", false);
                }
            });
            $("tr").slice(1).click(function (e) {
                // 找到checkbox对象
                var ids = $("input[name=ids]", this);
                if (ids.length < 1) {
                    return;
                }
                if (ids[0].checked) {
                    // 之前已选中，设置为未选中
                    $("[name=ids]", this).attr("checked", false);
                } else {
                    // 之前未选中，设置为选中
                    $(this).attr("tag", "selected");
                    $("[name=ids]", this).attr("checked", true);
                }
            });
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>订单列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">取票人姓名</label>
            <div class="layui-input-inline">
                <input type="text" name="contactName" value="${dto.contactName!}" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label" style="width: auto;">取票人手机号</label>
            <div class="layui-input-inline">
                <input type="text" name="contactMobile" value="${dto.contactMobile!}" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">订单号</label>
            <div class="layui-input-inline">
                <input type="text" name="sn" value="${dto.sn!}" autocomplete="off"
                       class="layui-input">
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
<@shiro.hasPermission name = "ttorder:add">
    <div class="layui-inline">
        <div class="layui-input-inline">
            <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
        </div>
    </div>
</@shiro.hasPermission>
</div>

<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th><input type="checkbox" id="selectAll"/></th>
        <th>客户信息</th>
        <th>订单号</th>
        <th>数量</th>
        <th>总金额</th>
        <th>已付金额</th>
        <th>支付状态</th>
    <#--<th>审核状态</th>-->
        <th>同步状态</th>
        <th>发送状态</th>
        <th>销售人员</th>
        <th>购买日期</th>
        <th>使用日期</th>
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
                <span title="${dto.contactName!}">
                    ${dto.contactName!}
                        <br/>
                    ${dto.contactMobile!}
                </span>
        </td>
        <td>
        ${dto.sn!}
        </td>
        <td>
        ${dto.totalQuantity!}
        </td>
        <td>
        ${dto.totalAmount!}
        </td>
        <td>
        ${dto.amountPaid!}
        </td>
        <td>
            <#if dto.paymentStatus=="unpaid">
                <span style="color: red;">${dto.paymentStatus.title!}</span>
            <#elseif dto.paymentStatus=="guazhang">
                <span style="color: red;">${dto.paymentStatus.title!}</span>
            <#elseif dto.paymentStatus=="settlement">
                <span style="color: #0aad00;">${dto.paymentStatus.title!}</span>
            <#elseif dto.paymentStatus=="paid">
                <span style="color: #0aad00;">${dto.paymentStatus.title!}</span>
            </#if>
        </td>
    <#--<td>
        <#if dto.orderStatus=="audit">
            <span style="color: #0aad00;">已审核</span>
        <#elseif dto.orderStatus=="applied">
            审核中
        <#elseif dto.orderStatus=="disagreeAudit">
            <span style="color: red;">审核不通过</span>
        <#elseif dto.orderStatus=="updateApplied">
            修改待审核
        <#elseif dto.orderStatus=="consumed">
            已消费
        <#elseif dto.orderStatus=="partialConsume">
            部分消费
        </#if>
    </td>-->
        <td>${dto.syncStatus?string("<span style='color: #0aad00;'>已同步</span>","<span style='color: red;'>未同步</span>")}</td>
        <td>
            <#if dto.shippingStatus == "shipped">
                <span style='color: #0aad00;'>${(dto.shippingStatus.title)!}</span>
            <#else>
                <span style='color: red;'>${(dto.shippingStatus.title)!}</span>
            </#if>
        </td>
        <td>
        ${dto.operatorName!}
        </td>
        <td>
            <span title="${dto.createTime?datetime}">${dto.createTime?datetime}</span>
        </td>
        <td>
        ${dto.date!}<br/>${dto.edate!}
        </td>
        <td>
            <@shiro.hasPermission name = "ttorder:view">
                <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="viewBtn"
                       value="查看订单"/>
            </@shiro.hasPermission>

            <@shiro.hasPermission name = "ttorder:edit">
                <#if dto.orderStatus == "applied">
                    <input type="button" onclick="location.href='edit?id=${dto.id!?c}';"
                           class="layui-btn layui-btn-normal layui-btn-sm" value="编辑"/>
                </#if>
            </@shiro.hasPermission>

            <@shiro.hasPermission name = "ttorder:payment">
                <#if dto.paymentStatus == "unpaid" && dto.orderStatus == "audit">
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                           id="paymentBtn"
                           value="支付订单"/>
                </#if>
            </@shiro.hasPermission>
            <@shiro.hasPermission name = "ttorder:agree">
                <#if dto.orderStatus == "applied">
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                           id="agreeBtn"
                           value="审核通过"/>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                           id="disagreeBtn"
                           value="审核不通过"/>
                </#if>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="admin:ttOrderSendsms">
                <#if dto.paymentStatus == "paid">
                    <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}"
                           id="sendMessages"
                           value="发送短信"/>
                </#if>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="admin:ttOrderRefund">
                <#if dto.paymentStatus == "paid" && (dto.refundStatus == "noRefund" || dto.refundStatus == "refuseRefund")>
                    <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}"
                           id="refundOrder" value="申请退款"/>
                </#if>
            </@shiro.hasPermission>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
<#--
<script type="text/javascript">
    function del(id) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg) == true) {
            alert(id);
            window.location.href = "delete.jhtml?id=" + id;
        } else {
            return false;
        }
    }

    $().ready(function () {

        $(".agreeBtn").click(function () {
            var $this = $(this);
            $.dialog({
                type: "warn",
                content: "同意审核？",
                ok: message("admin.dialog.ok"),
                cancel: message("admin.dialog.cancel"),
                onOk: function () {
                    $.ajax({
                        url: "agree",
                        type: "POST",
                        data: {id: $this.attr("data-id")},
                        beforeSend: function () {
                        },
                        success: function (json) {
                            if (json.state == "success") {
                                alert(json.msg);
                                setTimeout(function () {
                                    location.reload(true);
                                }, 500);
                            } else {
                                alert(json.msg);
                            }
                        }
                    });
                }
            });
        });

        $(".disagreeBtn").click(function () {
            var $this = $(this);
            $.dialog({
                type: "warn",
                content: "不同意审核？",
                ok: message("admin.dialog.ok"),
                cancel: message("admin.dialog.cancel"),
                onOk: function () {
                    $.ajax({
                        url: "disagree",
                        type: "POST",
                        data: {id: $this.attr("data-id")},
                        beforeSend: function () {
                        },
                        success: function (json) {
                            if (json.state == "success") {
                                alert(json.msg);
                                setTimeout(function () {
                                    location.reload(true);
                                }, 500);
                            } else {
                                alert(json.msg);
                            }
                        }
                    });
                }
            });
        });

        $(".paymentBtn").click(function () {
            var $this = $(this);

            var browserFrameId = "browserFrame" + (new Date()).valueOf() + Math.floor(Math.random() * 1000000);
            var $browser = $('<div class="xxBrowser" style="height:350px;"><\/div>');
            $browserFrame = $('<iframe id="' + browserFrameId + '" name="' + browserFrameId + '" src="payment?id=' + $this.attr("data-id") + '" style="width:100%; height:100%;" frameborder="0"><\/iframe>').appendTo($browser);
            var $dialog = $.dialog({
                title: "支付订单",
                content: $browser,
                width: 570,
                modal: true,
                ok: "确定",
                cancel: "取消",
                onOk: function () {
                    return true;
                }
            });
        });


    });

</script>
</body>
</html>-->
