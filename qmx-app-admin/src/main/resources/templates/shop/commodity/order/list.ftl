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
        <div class="layui-inline">
            <label class="layui-form-label">联系人</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="contactName" autocomplete="off"
                       value="${dto.contactName!}" placeholder="收件人"/>
            </div>
            <label class="layui-form-label">联系人电话</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="contactPhone" autocomplete="off"
                       value="${dto.contactPhone!}" placeholder="收件人电话"/>
            </div>
            <label class="layui-form-label">订单id</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="id" autocomplete="off"
                       value="${dto.id!}" placeholder="订单id"/>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">商品ID</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="releaseId" autocomplete="off"
                       value="${dto.releaseId!}" placeholder="产品id"/>
            </div>
            <label class="layui-form-label">订单编号</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="sn" autocomplete="off"
                       value="${dto.sn!}" placeholder="产品id"/>
            </div>
            <label class="layui-form-label">支付状态</label>
            <div class="layui-input-inline">
                <select name="paymentStatus">
                    <option value="">-支付状态-</option>
                    <option value="unpaid"  <#if '${dto.paymentStatus!}'=='unpaid'>
                            selected='selected'</#if>>未支付
                    </option>
                    <option value="paid"   <#if '${dto.paymentStatus!}'=='paid'>
                            selected='selected' </#if>>已支付
                    </option>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">退款状态</label>
            <div class="layui-input-inline">
                <select name="refundState">
                    <option value="">-退款状态-</option>
                    <option value="noRefund"  <#if '${dto.refundState!}'=='noRefund'>
                            selected='selected'</#if>>未退款
                    </option>
                    <option value="applied"<#if '${dto.refundState!}'=='applied'>
                            selected='selected' </#if>>申请退款中
                    </option>
                    <option value="refunded"<#if '${dto.refundState!}'=='refunded'>
                            selected='selected' </#if>>已退款
                    </option>
                </select>
            </div>
            <label class="layui-form-label">订单时间起</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="startDate" id="startDate" autocomplete="off"
                       value="${dto.startDate!}" placeholder="时间起"/>
            </div>
            <label class="layui-form-label">订单时间止</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="endDate" id="endDate" autocomplete="off"
                       value="${dto.endDate!}" placeholder="时间止"/>
            </div>
            <div class="layui-input-inline">
                &nbsp;
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="button" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>
<!--操作按钮-->
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
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
    </div>
</div>
<!--表格-->
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable">
    <thead>
    <tr>
        <th class="check"><input type="checkbox" id="selectAll"/></th>
        <th>订单信息</th>
        <th>商品名称(id)</th>
        <th>数量</th>
        <th>金额</th>
        <th>状态信息</th>
        <th>创单日期/创建人</th>
    <#-- <th>创建人</th>-->
        <th><span>操作</span></th>
    </tr>
    </thead>
<#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" class="checkboxes" name="ids" value="${dto.id!}"/>
        <#--<input type="hidden" name="orderId"
               value="${dto.id!}&productId=${dto.releaseId!}&productName=${dto.releaseName!}"/>-->
        </td>
        <td>
            <#if dto.mailingMethod==1>
                <li>联系人:${dto.userAddressDto.consignee!}</li>
                <li>联系电话:${dto.userAddressDto.phone!}</li>
                <li>邮寄地址:${dto.userAddressDto.fullAddress!}</li>
            <#else >
                <li>联系人:${dto.contactName}</li>
                <li>联系电话:${dto.contactPhone}</li>
            </#if>
            订单id：${dto.id!}<br/>
        </td>
        <td>
            <li>${dto.releaseName!}</li>
            <li>${dto.releaseId!}</li>
        </td>
        <td>${dto.quantity!}</td>
        <td>${dto.totalAmount?string("currency")}</td>
        <td>
            <div>
                <table class="layui-table" lay-skin="nob">
                    <tr>
                        <td>
                            支付状态:
                            <#if (dto.paymentStatus!)=='unpaid'>
                                <p style="color:red">未支付</p>
                            <#elseif (dto.paymentStatus!)=='paid'>
                                <p style="color:green">已支付</p>
                            <#elseif (dto.paymentStatus!)=='play_closed'>
                                <p style="color:green">交易关闭</p>
                            </#if>
                        </td>
                        <td>
                            发货状态:
                            <#if dto.mailingMethod==1>
                                <#if (dto.shippingStatusEnum!)=="SHIPPED">
                                    <li style="color: green">邮寄</li>
                                    <li style="color: green">已发货</li>
                                <#else>
                                    <li style="color: red">邮寄</li>
                                    <li style="color: red">未发货</li>
                                </#if>
                            <#else >
                                <#if dto.shippingStatusEnum=="CODESENDING">
                                    <li style="color: green">发码</
                                    </li>
                                    <li style="color: green">已发码</li>
                                <#else >
                                    <li style="color: red">发码</
                                    </li>
                                    <li style="color:red">未发码</li>
                                </#if>
                            </#if>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            验证状态:
                            <#if (dto.paymentStatus!)=='paid'>
                                <#if dto.mailingMethod==2>
                                    <#if (dto.verifyStateEnum!)=="VERIFYED">
                                        <li style="color: green">发码</li>
                                        <li style="color: green">已验证</li>
                                    <#elseif  (dto.verifyStateEnum!)=="UNVERIFIED">
                                        <li style="color: red">发码</li>
                                        <li style="color: red">未验证</li>
                                    <#else >
                                        <li style="color: red">请重新发码</li>
                                    </#if>
                                </#if>
                            </#if>
                        </td>
                        <td>
                            退款状态:
                            <#if (dto.refundState!)=='noRefund'>
                                <p style="color:green">未退款</p>
                            <#elseif (dto.refundState!)=='applied'>
                                <p style="color:red">退款申请中</p>
                            <#elseif (dto.refundState!)=='refunded'>
                                <p style="color:green">已退款</p>
                            <#elseif (dto.refundState!)=='disagreeRefunds'>
                                <p style="color:green">拒绝退款</p>
                            <#elseif (dto.refundState!)=='CanNotRefund'>
                                <p style="color:green">不能退款</p>
                            </#if>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
        <td>创建人：${dto.createName!}<br/>
            时间：${dto.createTime?datetime!}</td>
        <td>
            <button type="button" class="layui-btn layui-btn-sm layui-btn-normal"
                    onclick="window.location='viewOrder?orderId=${dto.id?c!}';">查看
            </button>
            <@shiro.hasPermission name = "shipments">
                <#if dto.mailingMethod==1>
                    <#if (dto.paymentStatus!)=='paid'>
                        <#if (dto.shippingStatusEnum!)=="UNSHIPPED">
                            <button class="layui-btn layui-btn-sm layui-btn-normal shipment" value="${dto.id?c!}">发货
                            </button>
                        </#if>
                    </#if>
                </#if>
            </@shiro.hasPermission>
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