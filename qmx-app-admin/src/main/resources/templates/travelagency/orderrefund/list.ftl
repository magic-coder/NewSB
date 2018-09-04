<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
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


        //同意退款申请
        $(document).on("click", "#refundAgree", function () {
            var data = $(this).attr("data-id");
            var type = $(this).attr("data-type");
            layer.confirm('确定同意退款申请吗？', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                $.ajax({
                    url: "refundCheck",
                    type: "GET",
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
        })

        //不同意退款申请
        $(document).on("click", "#refundDisagree", function () {
            var data = $(this).attr("data-id");
            var type = $(this).attr("data-type");
            layer.confirm('确定不同意退款申请吗？', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                $.ajax({
                    url: "refundCheck",
                    type: "GET",
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
        });
        //最终确认同意退款
        $(document).on("click", "#resultAgree", function () {
            var data = $(this).attr("data-id");
            var type = $(this).attr("data-type");
            layer.confirm('确定同意退款吗？', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                $.ajax({
                    url: "resultCheck",
                    type: "GET",
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
        });
        //最终确认不同意退款
        $(document).on("click", "#resultDisagree", function () {
            var data = $(this).attr("data-id");
            var type = $(this).attr("data-type");
            layer.confirm('确定不同意退款吗？', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                $.ajax({
                    url: "resultCheck",
                    type: "GET",
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
        })
    </script>
    <script>
        /*$(document).ready(function (e) {
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
                    $("[name=ids]", this).attr("checked", false);
                } else {
                    $("[name=ids]", this).attr("checked", true);
                }
            });
        });*/
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>订单列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="sn" value="${dto.sn!}" autocomplete="off"
                       class="layui-input" placeholder="订单编号">
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
<div class="layui-form-item" style="margin-left: 10px;">
</div>

<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th><input type="checkbox" id="selectAll"/></th>
        <th>订单编号</th>
        <th>所属旅行社</th>
        <th>主产品退款手续费</th>
        <th>增值产品退款手续费</th>
        <th>总退款手续费</th>
        <th>客户经理审核结果</th>
        <th>财务审核结果</th>
        <th>申请人</th>
        <th>申请时间</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>${dto.orderDto.sn!}</td>
        <td>${dto.orderDto.memberName!}</td>
        <td><#if dto.productNumber!=0>${dto.productNumber!}<#else>/</#if></td>
        <td><#if dto.increaseProductNumber!=0>${dto.increaseProductNumber!}<#else>/</#if></td>
        <td><#if dto.totalNumber!=0>${dto.totalNumber!}<#else>无</#if></td>
        <td <#if dto.applyRefund='applied'>style="color: red" </#if>>${dto.applyRefund.title!}</td>
        <td <#if dto.applyRefund='applied'>style="color: red" </#if>>${dto.refundResult.title!}</td>
        <td>
        ${dto.createName!}
        </td>
        <td>
        ${dto.createTime!?string("yyyy-MM-dd HH:mm:ss")}
        </td>
        <td>
            <@shiro.hasPermission name="admin:taRefundCheck">
                <#if dto.applyRefund=='applied'>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                           data-type="agree"
                           id="refundAgree" value="同意申请"/>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                           data-type="disagree"
                           id="refundDisagree" value="不同意申请"/>
                </#if>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="admin:taRefundFinal">
                <#if dto.applyRefund=='agree'&&dto.refundResult=='applied'>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                           data-type="agree"
                           id="resultAgree" value="确认退款"/>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                           data-type="disagree"
                           id="resultDisagree" value="驳回退款"/>
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