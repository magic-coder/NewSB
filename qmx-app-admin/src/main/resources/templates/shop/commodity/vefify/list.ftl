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

            $(document).on("click", ".type", function () {

                layer.open({
                    type: 2,
                    area: ['600px', '400px'],
                    title: '订单信息',
                    shade: 0.6, //遮罩透明度
                    maxmin: true, //允许全屏最小化
                    anim: 1,//0-6的动画形式，-1不开启
                    shadeClose: true,
                    content: 'skipverifycode?verifycode=' + $("#verifycode").val()
                });
            })

            //删除订单
            $(document).on("click", "#deleteButton", function () {
                var id = $(".checkboxes:checked").val();
                if ($(".checkboxes:checked").length < 1) {
                    layer.msg('请选择一条数据！', {
                        time: 1500 //20s后自动关闭
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
                        url: '/commodity/orderverify/delete',
                        type: 'GET', //GET
                        async: true,    //或false,是否异步
                        data: {"ids": ids},
                        success: function (result) {
                            if (result.data == "success") {
                                layer.msg('操作成功');
                            } else {
                                layer.msg('操作失败');
                            }
                        }
                    });
                });
            })
            //重发短信
            $(document).on("click", ".sendMessage", function () {
                var orderId = $(this).val();
                $.ajax({
                    url: '/commodity/orderverify/send',
                    type: 'GET', //GET
                    async: true,    //或false,是否异步
                    data: {"orderId": orderId},
                    success: function (result) {
                        if (result.data == "success") {
                            layer.msg('操作成功');
                        } else {
                            ayer.msg('操作失败');
                        }
                    }
                })
            })
        })
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>退款审核列表</legend>
</fieldset>
<form action="list" method="post" class="layui-form">
<@shiro.hasPermission name = "verifycode">
    <div class="layui-form-item" style="width: 100%;">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline" style="width: auto;">

                <input type="text" class="layui-input" id="verifycode" autocomplete="off"
                       placeholder="电子验证码" value="" style="width: 190px;display: inline;"/>
                <a href="javascript:;" id="consumeTicket" class="layui-btn layui-btn-normal type">查询电子票</a>

            </div>
        </div>
    </div>
</@shiro.hasPermission>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">联系人姓名</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="contactName" value="${dto.contactName!}"
                       placeholder="联系人姓名"/>
            </div>
            <label class="layui-form-label">联系人电话</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="contactPhone" value="${dto.contactPhone!}"
                       placeholder="联系人电话"/>
            </div>
            <label class="layui-form-label">产品名称</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="releaseName" value="${dto.releaseName!}"
                       placeholder="产品名称"/>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">订单id</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" name="orderId" value="${dto.orderId!}" placeholder="订单id"/>
            </div>
            <label class="layui-form-label">验证状态</label>
            <div class="layui-input-inline">
                <select name="verifyStateEnum">
                    <option value="">-验证状态-</option>
                    <option value="VERIFYED"  <#if '${dto.verifyStateEnum!}'=='VERIFYED'>selected</#if>>已验证</option>
                    <option value="UNVERIFIED"   <#if '${dto.verifyStateEnum!}'=='UNVERIFIED'>selected</#if>>未验证
                    </option>
                    <option value="VERFICATIONFAILED"<#if '${dto.verifyStateEnum!}'=='VERFICATIONFAILED'>selected</#if>>
                        验证失败
                    </option>
                    <option value="SHIPPED"   <#if '${dto.verifyStateEnum!}'=='SHIPPED'>selected</#if>>已发货</option>
                    <option value="UNSHIPPED"   <#if '${dto.verifyStateEnum!}'=='UNSHIPPED'>selected</#if>>未发货</option>
                </select>
            </div>
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
    <@shiro.hasPermission name = "exportCheck">
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
        <th class="check"><input type="checkbox" id="selectAll"/></th>
        <th>订单id</th>
        <th>联系人（电话）</th>
        <th>产品名称（id）</th>
        <th>验证状态</th>
        <th>创建时间</th>
        <th>创建人</th>
        <th><span>操作</span></th>
    </tr>
    </thead>
<#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" class="checkboxes" name="ids" value="${dto.id!}"/>
        </td>
        <td>
        ${dto.orderId!}
        </td>
        <td>
            <#if dto.mailingMethod==1>
                <li>${dto.userAddressDto.consignee!}</li>
                <li>${dto.userAddressDto.phone!}</li>
                <li>${dto.userAddressDto.fullAddress!}</li>

            <#else >
                <li>${dto.contactName!}</li>
                <li>${dto.contactPhone!}</li>
            </#if>
        </td>
        <td>
            <li>${dto.releaseName!}</li>
            <li>${dto.releaseId!}</li>
        </td>
        <td>
            <#if dto.mailingMethod==1>
                <#if (dto.verifyStateEnum!)=="SHIPPED">
                    <li style="color: green">邮寄</li>
                    <li style="color: green">已发货</li>
                <#else>
                    <li style="color: red">邮寄</li>
                    <li style="color: red">未发货</li>
                </#if>
            <#else >

                <#if dto.verifyStateEnum=="VERIFYED">
                    <li style="color: green">发码</li>
                    <li style="color: green">已验证</li>
                <#elseif dto.verifyStateEnum=="VERFICATIONFAILED">
                    <li style="color: red">发码</li>
                    <li style="color:red">验证失败</li>
                <#elseif dto.verifyStateEnum=="UNVERIFIED">
                    <li style="color: red">发码</li>
                    <li style="color:red">未验证</li>
                </#if>
            </#if>
        </td>
        <td>
        ${dto.createTime?datetime}
        </td>
        <td>
        ${dto.createName}
        </td>
        <td>
            <button class="layui-btn layui-btn-sm layui-btn-normal sendMessage" value="${dto.orderId?c!}">重发短信
            </button>
        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">
<#--消息提示框-->
<style>
    #tip {
        position: absolute;
        top: 50px;
        left: 50%;
        display: none;
        z-index: 9999;
    }
</style>
<#--<strong id="tip"></strong>
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
</script>-->
<#--消息提示框END-->
</body>
</html>