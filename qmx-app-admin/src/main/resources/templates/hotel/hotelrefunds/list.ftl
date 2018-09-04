<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            //执行一个laydate实例
            laydate.render({
                elem: '#cTime'
            });
            laydate.render({
                elem: '#uTime'
            });
        })
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>退款列表</legend>
</fieldset>
<form action="list" method="post" class="layui-form">
    <!--第一行-->
    <div class="layui-form-item" style="margin-left: 10px;">
        <div class="layui-input-inline">
            <select name="state">
                <option value="">-退款状态-</option>
                <option value="apply"  <#if '${hotelRefundsDto.state!}'='apply'> selected='selected'</#if>>退款申请</option>
                <option value="agree"   <#if '${hotelRefundsDto.state!}'='agree'>selected='selected' </#if>>同意退款
                </option>
                <option value="disagree"   <#if '${hotelRefundsDto.state!}'='disagree'>selected='selected' </#if>>
                    不同意退款
                </option>
            </select>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="productName" autocomplete="off"
                   value="${hotelRefundsDto.productName!}" placeholder="产品名称"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="orderSn" autocomplete="off"
                   value="${hotelRefundsDto.orderSn!}" placeholder="订单编号"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="cTime" id="cTime" autocomplete="off"
                   value="${hotelRefundsDto.cTime!}" placeholder="订房时间起"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="uTime" id="uTime" autocomplete="off"
                   value="${hotelRefundsDto.uTime!}" placeholder="订房时间止"/>
        </div>
    </div>
    <!--第二行-->
    <div class="layui-form-item" style="margin-left: 10px;">
        <div class="layui-inline">
            <div class="layui-input-inline-block">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="button" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
        <div class="layui-input-inline-block">
            <button onclick="location.href='export';" class="layui-btn layui-btn-normal">导出</button>
        </div>
    </div>
</div>
<#--<div class="bar">-->
<#--<br/>-->
<#--<select name="state">-->
<#--<option value="">--退款状态--</option>-->
<#--<option value="apply"  <#if '${hotelRefundsDto.state!}'='apply'> selected ='selected'</#if>>退款申请</option>-->
<#--<option value="agree"   <#if '${hotelRefundsDto.state!}'='agree'>selected ='selected' </#if>>同意退款</option>-->
<#--<option value="disagree"   <#if '${hotelRefundsDto.state!}'='disagree'>selected ='selected' </#if>>不同意退款</option>-->
<#--</select>-->
<#--<input type="text" name="productName" value="${hotelRefundsDto.productName!}" placeholder="产品名称" />-->
<#--<input type="text" name="orderSn" value="${hotelRefundsDto.orderSn!}" placeholder="订单编号" />-->
<#--<input name="cTime" type="text" onclick="WdatePicker()" placeholder="订房时间起" value="${hotelRefundsDto.cTime!}"/>-->
<#--<input name="uTime" type="text" onclick="WdatePicker()" placeholder="订房时间止" value="${hotelRefundsDto.uTime!}"/>-->
<#--<br/>-->
<#--<button type="submit" class="button">查询</button>-->
<#--<button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>-->
<#--</div>-->
<#--  <div class="bar">
      <a href="export" class="button" style="width:100px;text-align: center;font-size: medium;font-weight: bold;">导出</a>
  </div>-->
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;">
    <tbody>
    <thead>
    <tr>
        <th class="check"><input type="checkbox" id="selectAll"/></th>
        <th>订单编号</th>
        <th>退款方式</th>
        <th>姓名</th>
        <th>联系电话</th>
        <th>产品名称</th>
        <th>退款数量</th>
        <th>退款金额</th>
        <th>退款状态</th>
        <th>申请时间</th>
        <th>结束时间</th>
        <th>创建人</th>
        <th>备注</th>
        <th><span>操作</span></th>
    </tr>
    </thead>
<#list page.records as dto>
    <tr>
        <td><input type="checkbox" class="checkboxes" name="test" value="${dto.id!}"/></td>
        <td>${dto.orderSn!}</td>
        <td></td>
        <td>${dto.contactName!}</td>
        <td>${dto.contactMobile!}</td>
        <td>${dto.productName!}</td>
        <td>${dto.quantity!}</td>
        <td>${dto.amount!}</td>
        <td>
            <#if (dto.state!)='apply'>
                <p style="color: red">退款申请</p>
            <#elseif (dto.state!)='agree'>
                <p style="color: green">同意退款</p>
            <#elseif (dto.state!)='disagree'>
                <p style="color: red">不同意退款</p>
            </#if>
        </td>
        <td>${(dto.createTime?datetime)!}</td>
        <td>${(dto.updateTime?datetime)!}</td>
        <td>
        ${dto.createName!}
                <#--<#list name?keys as key>
                    <#if '${dto.createBy!}'=='${key!}'>
                ${name[key]!}
                </#if>
                </#list>-->
        </td>
        <td>${dto.memo!}</td>
        <td><a href="disPlay?id=${dto.id!}" class="layui-btn layui-btn-sm layui-btn-normal">查看</a>
            <#if (dto.state!)=='disagree'>
            <#elseif (dto.state!)=='agree'>
            <#elseif (dto.state!)=='apply'>
                <@shiro.hasPermission name = "orderRefund">
                    <a href="javascript:;" class="layui-btn layui-btn-sm layui-btn-normal"
                       onclick="bombBox('${dto.id?number}','agree','${dto.orderId!}')">同意</a>
                    <a href="javascript:;" class="layui-btn layui-btn-sm layui-btn-normal"
                       onclick="bombBox('${dto.id?number}','disagree','${dto.orderId!}')">不同意</a>
                </@shiro.hasPermission>
            </#if>
        </td>
    </tr>
</#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">

<script type="text/javascript">
    function bombBox(id, state, orderId) {
        if ('agree' == state) {
            var txt = "请确认是否同意退款？";
        } else {
            var txt = "请确认是否不同意退款？";
        }
        var option = {
            title: "提示",
            btn: parseInt("0011", 2),
            onOk: function () {
                console.log("确认啦");
                window.location.href = 'update?id=' + id + '&state=' + state + '&orderId=' + orderId;
            }
        }
        window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.confirm, option);

    }

    //修改订单
    function edit() {
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
        alert(ipts);
        window.location.href = 'edit?id=' + ipts;
    }
    //删除订单
    function delById() {
        var id = $(".checkboxes:checked").val();
        if ($(".checkboxes:checked").length < 1) {
            alert('请选择一条数据');
            return;
        }
//        if ($(".checkboxes:checked").length > 1) {
//            alert('一次只能修改一条数据');
//            return;
//        }
        var ids = "";
        $("input[name='test']:checked").each(function () { // 遍历选中的checkbox
            var id = $(this).val();
            ids = ids + "," + id;
            n = $(this).parents("tr").index();  // 获取checkbox所在行的顺序
            $("table#listTable").find("tr:eq(" + n + ")").remove();
        });
        ids = ids.substring(1, ids.length);
        var msg = "您真的确定要删除吗？\n\n请确认！";
        if (confirm(msg) == true) {
            $.ajax({
                url: '/hotelOrder/delete',
                type: 'POST', //GET
                async: true,    //或false,是否异步
                data: {"ids": ids},
                success: function (data) {
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
    }
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