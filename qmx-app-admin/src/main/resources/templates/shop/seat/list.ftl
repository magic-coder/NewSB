<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">

</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>订单列表</legend>
</fieldset>
<form action="list" method="post" class="layui-form">
    <!--表头第一行-->
    <div class="layui-form-item">
        <div class="layui-inline" style="margin-left: 10px;">
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="sn" autocomplete="off"
                       value="${dto.sn!}" placeholder="订单编号"/>
            </div>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="mobile" autocomplete="off"
                       value="${dto.mobile!}" placeholder="电话号码"/>
            </div>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="showType" autocomplete="off"
                       value="${dto.showType!}" placeholder="演出类型"/>
            </div>
            <div class="layui-input-inline">
                <select name="orderStatus" class="layui-input">
                    <option value="">请选择订单状态</option>
                <#list types as info>
                    <option value="${info}" <#if info=='${dto.orderStatus!}'>selected</#if>>${info.type}</option>
                </#list>
                </select>
            </div>
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="button" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>
<!--操作按钮-->
<div class="layui-form-item">
<#--<div class="layui-inline">
        <div class="layui-input-inline-block">
        <@shiro.hasPermission name = "deleteOrder">
            <button id="deleteButton" class="layui-btn layui-btn-normal">删除订单</button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "exportOrder">
            <button onclick="location.href='export';" class="layui-btn layui-btn-normal">导出订单</button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "applyRefund">
            <button id="btn1" class="layui-btn layui-btn-normal">申请退款</button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name = "payOrder">
            <button id="pay" class="layui-btn layui-btn-normal">支付订单</button>
        </@shiro.hasPermission>
        </div>
    </div>-->
</div>
<!--表格-->
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable">
    <thead>
    <tr>
        <th class="check"><input type="checkbox" id="selectAll"/></th>
        <th>订单编号</th>
        <th>电话号码</th>
        <th>演出类型</th>
        <th>场次</th>
        <th>数量</th>
        <th>金额</th>
        <th>订单状态</th>
        <th>下单时间</th>
        <th><span>操作</span></th>
    </tr>
    </thead>
<#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" class="checkboxes" name="ids" value="${dto.id!}"/>
        </td>
        <td>${dto.sn!}</td>
        <td>${dto.mobile!}</td>
        <td>${dto.showType!}</td>
        <td>${dto.actionCutting!}</td>
        <td>${dto.number!}</td>
        <td>${dto.amount!}</td>
        <td>${dto.orderStatus.type!}</td>
        <td>${dto.createTime?datetime!}</td>
        <td>
        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">
<script>
    layui.use(['form', 'table', 'laydate', 'jquery'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
        form.render();
        //执行一个laydate实例
        laydate.render({
            elem: '#startDate'
        });
        laydate.render({
            elem: '#endDate'
        });
        //修改支付状态
        $(function () {
            $("#pay").click(function () {
                if ($(".checkboxes:checked").length < 1) {
                    layer.msg('请选择一条数据！');
                    return;
                }
                if ($(".checkboxes:checked").length > 1) {
                    layer.msg('只能选择一条数据！');
                    return;
                }
                var id;
                $("input[name='ids']:checked").each(function () { // 遍历选中的checkbox
                    id = $(this).val();
                });
                layer.confirm('是否确认支付？', {btn: ['确定', '取消']}, function () {
                    window.location.href = 'changePay?orderId=' + id;
                });
            })
        });
        //删除订单
        $(document).on("click", "#deleteButton", function () {
            var id = $(".checkboxes:checked").val();
            if ($(".checkboxes:checked").length < 1) {
                layer.msg('请选择一条数据！');
                return;
            }
            layer.confirm('您真的确定要删除吗？\n\n请确认！', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                var ids = "";
                $("input[name='ids']:checked").each(function () {
                    var id = $(this).val();
                    ids = ids + "," + id;
                    var n = $(this).parent().parent().remove();
                });
                ids = ids.substring(1, ids.length);
                $.ajax({
                    url: '/commodity/order/deleteOrder',
                    type: 'GET', //GET
                    async: true,    //或false,是否异步
                    data: {"ids": ids},
                    success: function (result) {
                        if (result.data == "1") {
                            layer.msg('操作成功');
                        } else {
                            layer.msg('操作失败');
                        }
                    }
                });
            });
        })
        //修改订单
        $(function () {
            $("#editButton").click(function () {
                if ($(".checkboxes:checked").length < 1) {
                    layer.msg('请选择一条数据！');
                    return;
                }
                if ($(".checkboxes:checked").length > 1) {
                    layer.msg('只能选择一条数据！');
                    return;
                }
                var id;
                $("input[name='ids']:checked").each(function () { // 遍历选中的checkbox
                    id = $(this).val();
                });
                var ipts = $(":checkbox:checked").parents("tr").find("input:hidden").val();
                window.location.href = 'update?orderId=' + ipts;
            })
        })
        //退款提示信息
        $(function () {
            $("#btn1").click(function () {
                if ($(".checkboxes:checked").length < 1) {
                    layer.msg('请选择一条数据！');
                    return;
                }
                if ($(".checkboxes:checked").length > 1) {
                    layer.msg('只能选择一条数据！');
                    return;
                }
                var id;
                $("input[name='ids']:checked").each(function () { // 遍历选中的checkbox
                    id = $(this).val();
                    //n = $(this).parents("tr").index();  // 获取checkbox所在行的顺序
                });

                layer.confirm('是否确认退款？', {
                    btn: ['确认', '取消'] //按钮
                }, function () {
                    window.location.href = '/commodity/refund/refundsOrder?id=' + id;
                }, function () {
                });
            });
        })

        $(document).on("click", ".shipment", function () {
            layer.open({
                type: 2,
                area: ['500px', '350px'],
                title: '填写发货信息',
                shade: 0.6, //遮罩透明度
                maxmin: true, //允许全屏最小化
                anim: 1,//0-6的动画形式，-1不开启
                shadeClose: true,
                content: 'skipShipment?id=' + $(this).val()
            });
        });

        function showTip(tip, type) {
            layer.msg(tip);
        }

        var Script = function () {
        <#if msg??>
            showTip("${msg}", "success");
        </#if>
        }();
    })
</script>
</body>
</html>