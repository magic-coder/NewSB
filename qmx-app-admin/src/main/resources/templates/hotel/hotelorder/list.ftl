<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">
    <style type="text/css">
        .sgBtn {
            width: 135px;
            height: 35px;
            line-height: 35px;
            margin-left: 10px;
            margin-top: 10px;
            text-align: center;
            background-color: #0095D9;
            color: #FFFFFF;
            float: left;
            border-radius: 5px;
        }
    </style>
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            form.render('select');

            //执行一个laydate实例
            laydate.render({
                elem: '#startDate1'
            });
            laydate.render({
                elem: '#endDate1'
            });
            //修改支付状态
            $(function () {
                $("#pay").click(function () {
                    if ($(".checkboxes:checked").length < 1) {
                        layer.msg('请选择一条数据！', {
                            time: 20000, //20s后自动关闭
                            btn: ['确定']
                        });
                        return;
                    }
                    if ($(".checkboxes:checked").length > 1) {
                        layer.msg('只能选择一条数据！', {
                            time: 20000, //20s后自动关闭
                            btn: ['确定']
                        });
                        return;
                    }
                    var id;
                    $("input[name='checkId']:checked").each(function () { // 遍历选中的checkbox
                        id = $(this).val();
                    });
                    window.location.href = 'changePay?id=' + id;
                })
            })
            //删除订单
            $(document).on("click", "#deleteButton", function () {
                var id = $(".checkboxes:checked").val();
                if ($(".checkboxes:checked").length < 1) {
                    layer.msg('请选择一条数据！', {
                        time: 20000, //20s后自动关闭
                        btn: ['确定']
                    });
                    return;
                }
                layer.confirm('您真的确定要删除吗？\n\n请确认！', {
                    btn: ['确定', '取消'] //按钮
                }, function () {
                    var ids = "";
                    $("input[name='checkId']:checked").each(function () {
                        var id = $(this).val();
                        ids = ids + "," + id;
                        var n = $(this).parent().parent().remove();
                    });
                    ids = ids.substring(1, ids.length);
                    $.ajax({
                        url: '/hotel/hotelOrder/delete',
                        type: 'GET', //GET
                        async: true,    //或false,是否异步
                        data: {"ids": ids},
                        success: function (data) {
                            if (data == "1") {
                                layer.msg('操作成功', {icon: 1});
                            } else {
                                layer.msg('操作失败', {icon: 1});
                            }
                        }
                    });
                });
            })
            //修改订单
            $(function () {
                $("#editButton").click(function () {
                    if ($(".checkboxes:checked").length < 1) {
                        layer.msg('请选择一条数据！', {
                            time: 20000, //20s后自动关闭
                            btn: ['确定']
                        });
                        return;
                    }
                    if ($(".checkboxes:checked").length > 1) {
                        layer.msg('只能选择一条数据！', {
                            time: 20000, //20s后自动关闭
                            btn: ['确定']
                        });
                        return;
                    }
                    var id;
                    $("input[name='checkId']:checked").each(function () { // 遍历选中的checkbox
                        id = $(this).val();
                    });
                    var ipts = $(":checkbox:checked").parents("tr").find("input:hidden").val();
                    window.location.href = 'edit?id=' + ipts;
                })
            })
            //退款提示信息
            $(function () {
                $("#btn1").click(function () {
                    if ($(".checkboxes:checked").length < 1) {
                        layer.msg('请选择一条数据！', {
                            time: 20000, //20s后自动关闭
                            btn: ['确定']
                        });
                        return;
                    }
                    if ($(".checkboxes:checked").length > 1) {
                        layer.msg('只能选择一条数据！', {
                            time: 20000, //20s后自动关闭
                            btn: ['确定']
                        });
                        return;
                    }
                    var id;
                    $("input[name='checkId']:checked").each(function () { // 遍历选中的checkbox
                        id = $(this).val();
                        //n = $(this).parents("tr").index();  // 获取checkbox所在行的顺序
                    });

                    layer.confirm('是否确认退款？', {
                        btn: ['确认', '取消'] //按钮
                    }, function () {
                        window.location.href = '/hotel/hotelOrder/refundsOrder?id=' + id;
                    }, function () {
                    });
                    /* $.ajax({
                         url: '/shop/commodityOrder/getRefundsOrderByOrderId',
                         type: 'get',
                         async: true,
                         data: {'id': id},
                         success: function (data) {

                         }
                     })*/
                });
            })
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>订单列表</legend>
</fieldset>
<form action="list" method="post" class="layui-form">
    <!--第一行-->
    <div class="layui-form-item" style="margin-left: 10px;">
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="contactName" autocomplete="off"
                   value="${hotelOrderDto.contactName!}" placeholder="联系人"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="contactPhone" autocomplete="off"
                   value="${hotelOrderDto.contactPhone!}" placeholder="联系人电话"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="id" autocomplete="off"
                   value="${hotelOrderDto.id!}" placeholder="订单编号"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="productName" autocomplete="off"
                   value="${hotelOrderDto.productName!}" placeholder="产品名称"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="productId" autocomplete="off"
                   value="${hotelOrderDto.productId!}" placeholder="产品ID"/>
        </div>
    </div>
    <!--第二行-->
    <div class="layui-form-item" style="margin-left: 10px;">
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="message" autocomplete="off"
                   value="${dto.message!}" placeholder="备注"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="startDate1" id="startDate1" autocomplete="off"
                   value="${dto.startDate1!}" placeholder="订房时间起"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="endDate1" id="endDate1" autocomplete="off"
                   value="${dto.endDate1!}" placeholder="订房时间止"/>
        </div>
        <div class="layui-input-inline">
            <select name="status">
                <option value="">-订单状态-</option>
                <option value="inited"  <#if '${dto.status!}' = 'inited'>selected='selected'</#if>>未消费</option>
                <option value="completed" <#if '${dto.status!}' = 'completed'> selected='selected'</#if>>已消费
                </option>
                <option value="cancelled" <#if '${dto.paymentStatus!}' = 'cancelled'> selected='selected'</#if>>
                    已取消
                </option>
            </select>
        </div>
        <div class="layui-input-inline">
            <select name="paymentStatus">
                <option value="">--支付状态--</option>
                <option value="unpaid"  <#if '${dto.paymentStatus!}'='unpaid'> selected='selected'</#if>>未支付
                </option>
                <option value="paid"   <#if '${dto.paymentStatus!}'='paid'>selected='selected' </#if>>已支付</option>
            </select>
        </div>
    </div>
    <!--第三行-->
    <div class="layui-form-item" style="margin-left: 10px;">
        <div class="layui-input-inline">
            <select name="refundState">
                <option value="">-退款状态-</option>
                <option value="noRefund"  <#if '${dto.refundState!}'='noRefund'> selected='selected'</#if>>未退款
                </option>
                <option value="applied"   <#if '${dto.refundState!}'='applied'>selected='selected' </#if>>申请退款中
                </option>
                <option value="refunded"   <#if '${dto.refundState!}'='refunded'>selected='selected' </#if>>已退款
                </option>
            </select>
        </div>
        <div class="layui-input-inline">
            <select name="checkStatus">
                <option value="">-订单审核-</option>
                <option value="unchecked"  <#if '${dto.checkStatus!}'='noRefund'> selected='selected'</#if>>未审核
                </option>
                <option value="approve"   <#if '${dto.checkStatus!}'='applied'>selected='selected' </#if>>审核通过
                </option>
                <option value="Unapprove"   <#if '${dto.checkStatus!}'='refunded'>selected='selected' </#if>>审核未通过
                </option>
            </select>
        </div>
        <div class="layui-input-inline">
            <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
            <button type="button" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
        </div>

    </div>
</form>
<#--<div class="bar">
    <br/>
    <input type="text" name="contactName" value="${dto.contactName!}" placeholder="客户姓名"/>
    <input type="text" name="contactPhone" value="${dto.contactPhone!}" placeholder="客户电话"/>
    <input type="text" name="id" value="${dto.id!}" placeholder="订单编号"/>
    <input type="text" name="productName" value="${dto.productName!}" placeholder="产品名称"/>
    <input type="text" name="productId" value="${dto.productId!}" placeholder="产品ID"/>
    <input type="text" name="message" value="${dto.message!}" placeholder="备注"/>
    <br/>
    <input name="startDate1" type="text" onclick="WdatePicker()" placeholder="订房时间起" value="${dto.startDate1!}"/>
    <input name="endDate1" type="text" onclick="WdatePicker()"
           placeholder="订房时间止" value="${dto.endDate1!}"/>
    <select name="status">
        <option value="">--订单状态--</option>
        <option value="inited"  <#if '${dto.status!}' = 'inited'>selected='selected'</#if>>未消费</option>
        <option value="completed" <#if '${dto.status!}' = 'completed'> selected='selected'</#if>>已消费
        </option>
        <option value="cancelled" <#if '${dto.paymentStatus!}' = 'cancelled'> selected='selected'</#if>>
            已取消
        </option>
    </select>
    <select name="paymentStatus">
        <option value="">--支付状态--</option>
        <option value="unpaid"  <#if '${dto.paymentStatus!}'='unpaid'> selected='selected'</#if>>未支付
        </option>
        <option value="paid"   <#if '${dto.paymentStatus!}'='paid'>selected='selected' </#if>>已支付</option>
    </select>
    <select name="refundState">
        <option value="">--退款状态--</option>
        <option value="noRefund"  <#if '${dto.refundState!}'='noRefund'> selected='selected'</#if>>未退款
        </option>
        <option value="applied"   <#if '${dto.refundState!}'='applied'>selected='selected' </#if>>申请退款中
        </option>
        <option value="refunded"   <#if '${dto.refundState!}'='refunded'>selected='selected' </#if>>已退款
        </option>
    </select>
    <select name="checkStatus">
        <option value="">--订单审核--</option>
        <option value="unchecked"  <#if '${dto.checkStatus!}'='noRefund'> selected='selected'</#if>>未审核
        </option>
        <option value="approve"   <#if '${dto.checkStatus!}'='applied'>selected='selected' </#if>>审核通过
        </option>
        <option value="Unapprove"   <#if '${dto.checkStatus!}'='refunded'>selected='selected' </#if>>审核未通过
        </option>
    </select>
    <br/>
    <button type="submit" class="button">查询</button>
    <button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
    <span style="color:green;">${flash_message_attribute_name!}</span>
</div>-->

<!--操作按钮-->
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
        <div class="layui-input-inline-block">
        <@shiro.hasPermission name = "deleteOrder">
            <button id="deleteButton" class="layui-btn layui-btn-normal">删除订单</button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "modifyOrder">
            <button id="editButton" class="layui-btn layui-btn-normal">修改订单</button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "exportOrder">
            <button onclick="location.href='export';" class="layui-btn layui-btn-normal">导出订单</button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "orderRoom">
            <button id="btn1" class="layui-btn layui-btn-normal">申请退款</button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "payOrder">
            <button id="pay" class="layui-btn layui-btn-normal">支付订单</button>
        </@shiro.hasPermission>
        </div>
    </div>
</div>

<#--<div class="bar">
        <@shiro.hasPermission name = "admin:editCompany">
        <@shiro.hasPermission name="user:create">
            <a href="add" class="button"
                style="width:100px;text-align: center;font-size: medium;font-weight: bold;">新建订单</a>
        </@shiro.hasPermission>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "modifyOrder">
        <a onclick="edit()" class="but button">修改订单</a>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "deleteOrder">
        <a onclick="delById()" id="deleteButton" class="button">删除</a>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "orderRoom">
        <a href="javascript:;" class="refundsButton button" id="btn1">申请退款</a>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "exportOrder">
        <a href="export" id="export" class="refundsButton button">导出订单</a>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "payOrder">
        <a href="javascript:;" id="pay" class="refundsButton button">立即支付</a>
        </@shiro.hasPermission>
    </div>-->
<!--表格-->
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;"
       id="sysBalanceTable" lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th class="check"><input type="checkbox" id="selectAll"/></th>
        <th>订单id</th>
        <th>联系人</th>
        <th>电话</th>
        <th>产品名称(id)</th>
        <th>房间数量</th>
        <th>总金额</th>
        <th>支付状态</th>
        <th>订单状态</th>
        <th>退款状态</th>
        <th>订单审核</th>
        <th>入住时间</th>
        <th>离店时间</th>
        <th>订房日期</th>
        <th>创建人</th>
        <th><span>操作</span></th>
    </tr>
    </thead>
<#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" class="checkboxes" name="checkId" value="${dto.id!}"/>
            <input type="hidden" name="orderId"
                   value="${dto.id!}&productId=${dto.productId!}&productName=${dto.productName!}"/>
        </td>
        <td>${dto.id!}</td>
        <td>${dto.contactName!}</td>
        <td>${dto.contactPhone!}</td>
        <td>${dto.productName!}（${dto.productId!}）</td>
        <td>${dto.roomNumber!}</td>
        <td>${dto.payment!}</td>
        <td>
            <#if (dto.paymentStatus!)=='unpaid'>
                <p style="color:red">未支付</p>
            <#elseif (dto.paymentStatus!)=='paid'>
                <p style="color:green">已支付</p>
            </#if>
        </td>
        <td>
            <#if (dto.status!)=='inited'>
                <p style="color:green">未消费</p>
            <#elseif (dto.status!)=='completed'>
                已消费
            <#elseif (dto.status!)=='cancelled'>
                <p style="color:red">已取消</p>
            <#elseif (dto.status!)=='refunded'>
                已退款
            <#elseif (dto.status!)=='unrefunded'>
                未退款
            <#elseif (dto.status!)=='loseEfficacy'>
                已失效
            </#if>
        </td>
        <td>
            <#if (dto.refundState!)=='noRefund'>
                <p style="color:green">未退款</p>
            <#elseif (dto.refundState!)=='applied'>
                <p style="color:red">退款申请中</p>
            <#elseif (dto.refundState!)=='refunded'>
                <p style="color:red">已退款</p>
            <#elseif (dto.refundState!)=='CanNotRefund'>
                <p style="color:red">不能退款</p>
            </#if>
        </td>
        <td>
            <#if (dto.checkStatus!)=='unchecked'>
                <p style="color:green">未审核</p>
            <#elseif (dto.checkStatus!)=='approve'>
                <p style="color:green">审核通过</p>
            <#elseif (dto.checkStatus!)=='Unapprove'>
                <p style="color:red">审核未通过</p>
            </#if>
        </td>
        <td>${dto.checkIn!}</td>
        <td>${dto.checkOut!}
        </td>
        <td>${dto.createTime?datetime!}</td>
        <td>${dto.createName!}</td>
        <td><#--<a href="disPlay?id=${dto.id}">[查看]</a>-->
            <input type="button" class="layui-btn layui-btn-sm layui-btn-normal"
                   onclick="window.location='disPlay?id=${dto.id}';" value="查看"/></td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">

<script type="text/javascript">
    //修改支付状态
    /*$(function () {
        $("#pay").click(function () {
            if ($(".checkboxes:checked").length < 1) {
                alert('请选择一条数据');
                return;
            }
            if ($(".checkboxes:checked").length > 1) {
                alert('一次只能选择一条订单');
                return;
            }
            var id;
            $("input[name='test']:checked").each(function () { // 遍历选中的checkbox
                id = $(this).val();
                //n = $(this).parents("tr").index();  // 获取checkbox所在行的顺序
            });
            window.location.href = 'changePay?id=' + id;
        })
    })*/
    //修改订单
    /*function edit() {
        var id = $(".checkboxes:checked").val();
        if ($(".checkboxes:checked").length < 1) {
            alert('请选择一条数据');
            return;
        }
        if ($(".checkboxes:checked").length > 1) {
            alert('一次只能修改一条数据');
            return;
        }
        var ipts = $(":checkbox:checked").parents("tr").find("input:hidden").val();
        window.location.href = 'edit?id=' + ipts;
    }*/
    //删除订单
    /*function delById() {
        var id = $(".checkboxes:checked").val();
        if ($(".checkboxes:checked").length < 1) {
            alert('请选择一条数据');
            return;
        }
//        if ($(".checkboxes:checked").length > 1) {
//            alert('一次只能修改一条数据');
//            return;
//        }
        var msg = "您真的确定要删除吗？\n\n请确认！";
        if (confirm(msg) == true) {
            var ids = "";
            $("input[name='test']:checked").each(function () { // 遍历选中的checkbox
                var id = $(this).val();
                ids = ids + "," + id;
                var n = $(this).parents("tr").index();  // 获取checkbox所在行的顺序
                $("table#listTable").find("tr:eq(" + n + ")").remove();
            });
            ids = ids.substring(1, ids.length);
            $.ajax({
                url: '/hotel/hotelOrder/delete',
                type: 'POST', //GET
                async: true,    //或false,是否异步
                data: {"ids": ids},
                success: function (data) {
                    alert(data);
                    if (data == "1") {
                        showTip("操作成功", "success");
                    } else {
                        showTip("操作失败", "danger");
                    }
                }
            });
            return true;
        } else {
            return false;
        }
    }*/
    //退款提示信息
    $(function () {
        $("#btn1").click(function () {
            //var id = $(".checkboxes:checked").val();
            //alert(id);
            if ($(".checkboxes:checked").length < 1) {
                alert('请选择一条数据');
                return;
            }
            if ($(".checkboxes:checked").length > 1) {
                alert('一次只能选择一条订单');
                return;
            }
            var id;
            $("input[name='test']:checked").each(function () { // 遍历选中的checkbox
                id = $(this).val();
                n = $(this).parents("tr").index();  // 获取checkbox所在行的顺序
            });
            $.ajax({
                url: '/hotel/hotelOrder/getRefundsOrderByOrderId',
                type: 'post',
                async: true,
                data: {'id': id},
                success: function (data) {
                    var txt;
                    if (data.message == null) {
                        txt = '创建日期：' + data.createTime + '<br/><br/>' +
                                '订单号：' + data.sn + '<br/><br/>' +
                                '订单金额：' + data.payment + '<br/><br/>' +
                                '备注：' + '无';
                    } else {
                        txt = '创建日期：' + data.date + '<br/><br/>' +
                                '订单号：' + data.sn + '<br/><br/>' +
                                '订单金额：' + data.payment + '<br/><br/>' +
                                '备注：' + data.message;
                    }
                    var option = {
                        title: "自定义",
                        btn: parseInt("0011", 2),
                        onOk: function () {
                            console.log("确认啦");
                            window.location.href = '/hotel/hotelOrder/refundsOrder?id=' + id;
                        }
                    }
                    window.wxc.xcConfirm(txt, "custom", option);
                }
            })
        });
    })
</script>
<#--消息提示框-->
<style>
    #tip {
        position: absolute;
        top: 100px;
        color: red;
        left: 50%;
        display: none;
        z-index: 9999;
    }
</style>
<strong id="tip"></strong>
<script>
    //tip是提示信息，type:'success'是成功信息，'danger'是失败信息,'info'是普通信息,'warning'是警告信息
    function showTip(tip, type) {
        var $tip = $('#tip');
        $tip.stop(true).prop('class', 'alert alert-' + type).text(tip).css('margin-left', -$tip.outerWidth() / 2).fadeIn(500).delay(2000).fadeOut(500);
    }

    var Script = function () {
    <#if msg??>
        showTip("${msg}", "success");
    </#if>
    }();
</script>
<#--消息提示框END-->
</body>
</html>