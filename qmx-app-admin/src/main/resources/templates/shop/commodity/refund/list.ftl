<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            form.render('select');
            //执行一个laydate实例
            laydate.render({
                elem: '#startTime'
            });
            laydate.render({
                elem: '#endTime'
            });
            //操作退款
            $(function () {
                $("input[name='refund']").click(function () {
                    var state = $(this).val();
                    var id = $(this).parent().find("input[name='id']").val();
                    var orderId = $(this).parent().find("input[name='orderId']").val();
                    if ('同意' == state) {
                        state = 'agree';
                    } else if ('不同意' == state) {
                        state = 'disagree';
                    }
                    console.log(state + ":" + id + ":" + orderId);
                    $.ajax({
                        url: '/commodity/refund/update',
                        type: 'GET', //GET
                        async: false,    //或false,是否异步
                        data: {"id": id, "state": state, "orderId": orderId},
                        success: function (data) {
                            layer.msg(data.msg);
                            setTimeout("window.location.reload()",5000);
                            //window.location.reload();
                        }
                    })
//                    if ('同意' == state) {
//                        layer.confirm('是否确认退款？', {
//                            btn: ['确认', '取消'] //按钮
//                        }, function () {
//                            window.location.href = 'update?id=' + id + '&state=' + 'agree' + '&orderId=' + orderId;
//                        });
//                    }
//                    if ('不同意' == state) {
//                        layer.confirm('是否确认拒绝退款？', {
//                            btn: ['确认', '取消'] //按钮
//                        }, function () {
//                            window.location.href = 'update?id=' + id + '&state=' + 'disagree' + '&orderId=' + orderId;
//                        });
//                    }
                })
            })

            //删除订单
            $(document).on("click", "#deleteButton", function () {
                var id = $(".checkboxes:checked").val();
                if ($(".checkboxes:checked").length < 1) {
                    layer.msg('请选择一条数据！', {
                        time: 3000 //20s后自动关闭
                    });
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
                        url: '/commodity/refund/delete',
                        type: 'GET', //GET
                        async: true,    //或false,是否异步
                        data: {"ids": ids},
                        success: function (data) {
                            if (data == "1") {
                                layer.msg('操作成功');
                            } else {
                                layer.msg('操作失败');
                            }
                        }
                    });
                });
            })
        })
    </script>
</head>
<body>

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>退款申请列表</legend>
</fieldset>
<form action="list" method="post" class="layui-form">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">产品名称</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="releaseName" value="${commodityRefundDto.releaseName!}"
                       placeholder="产品名称"/>
            </div>
            <label class="layui-form-label">订单ID</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="orderId" value="${commodityRefundDto.orderId!}"
                       placeholder="订单ID"/>
            </div>
            <label class="layui-form-label">退款状态</label>
            <div class="layui-input-inline">
                <select name="state">
                    <option value="">-退款状态${commodityRefundDto.state!}-</option>
                    <option value="apply"  <#if '${commodityRefundDto.state!}'=='apply'> selected='selected'</#if>>
                        退款申请
                    </option>
                    <option value="agree"   <#if '${commodityRefundDto.state!}'=='agree'>selected='selected' </#if>>
                        同意退款
                    </option>
                    <option value="disagree"
                            <#if '${commodityRefundDto.state!}'=='disagree'>selected='selected' </#if>>不同意退款
                    </option>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">时间起</label>
            <div class="layui-input-inline">
                <input type="text" name="startTime" id="startTime" class="layui-input" autocomplete="off"
                       value="${commodityRefundDto.startTime!}" placeholder="时间起"/>
            </div>
            <label class="layui-form-label">时间止</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="endTime" id="endTime" autocomplete="off"
                       value="${commodityRefundDto.endTime!}" placeholder="时间止"/>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="button" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<div class="layui-inline">
    &nbsp;
    <div class="layui-inline">
    <@shiro.hasPermission name = "refundExport">
        <a href="export" class="layui-btn layui-btn-normal">导出</a>
    </@shiro.hasPermission>
    <@shiro.hasPermission name = "delete">
        <button id="deleteButton" class="layui-btn layui-btn-normal">删除</button>
    </@shiro.hasPermission>
    </div>
</div>

<table id="listTable" class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>订单id</th>
        <th>联系人姓名（电话）</th>
        <th>产品名称</th>
        <th>退款数量</th>
        <th>退款金额</th>
        <th>退款状态</th>
        <th>创建时间</th>
        <th>创建人</th>
        <th><span>操作</span></th>
    </tr>
    </thead>
<#list page.records as dto>
    <tr>
        <td><input type="checkbox" class="checkboxes" name="ids" value="${dto.id!}"/></td>
        <td>${dto.orderId!}</td>
        <td>
            <li>${dto.contactName!}</li>
            <li>${dto.contactPhone!}</li>
        </td>
        <td>${dto.releaseName!}</td>
        <td>${dto.quantity!}</td>
        <td>${dto.amount?string("currency")!}</td>
        <td>
            <#if (dto.state!)=='apply'>
                <p style="color: red">退款申请</p>
            <#elseif (dto.state!)='agree'>
                <p style="color: green">同意退款</p>
            <#elseif (dto.state!)='disagree'>
                <p style="color: red">不同意退款</p>
            </#if>
        </td>
        <td>${(dto.createTime?datetime)!}</td>
        <td>
        ${dto.createName!}
        </td>
        <td>
            <@shiro.hasPermission name="refundCheck">
                <#if (dto.state!)='disagree'>
                <#elseif (dto.state!)='agree'>
                <#elseif (dto.state!)='apply'>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" name="refund" value="同意"/>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" name="refund" value="不同意"/>
                    <input type="hidden" name="orderId" value="${dto.orderId!}"/>
                    <input type="hidden" name="id" value="${dto.id!}"/>
                </#if>
            </@shiro.hasPermission>
        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">

<script>
    <#if msg??>
    showTip("${msg}", "success");
    </#if>
</script>
<#--消息提示框END-->
</body>
</html>