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
            //执行一个laydate实例
            laydate.render({
                elem: '#cTime'
            });
            laydate.render({
                elem: '#eTime'
            });
        })
    </script>
</head>
<body>

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>订单审核列表</legend>
</fieldset>
<form action="list" method="post" class="layui-form">
    <!--第一行-->
    <div class="layui-form-item" style="margin-left: 10px;">
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="contactName" autocomplete="off"
                   value="${dto.contactName!}" placeholder="联系人"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="contactPhone" autocomplete="off"
                   value="${dto.contactPhone!}" placeholder="联系电话"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="productName" autocomplete="off"
                   value="${dto.productName!}" placeholder="产品名称"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="orderId" autocomplete="off"
                   value="${dto.orderId!}" placeholder="订单ID"/>
        </div>
        <div class="layui-input-inline">
            <select name="state">
                <option value="">--退款状态--</option>
                <option value="unchecked"  <#if '${dto.state!}'=='unchecked'> selected='selected'</#if>>未审核</option>
                <option value="approve"   <#if '${dto.state!}'=='approve'>selected='selected' </#if>>审核通过</option>
                <option value="Unapprove"   <#if '${dto.state!}'=='Unapprove'>selected='selected' </#if>>审核未通过</option>
            </select>
        </div>
    </div>
    <div class="layui-form-item" style="margin-left: 10px;">
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="cTime" id="cTime" autocomplete="off"
                   value="${dto.cTime!}" placeholder="创建时间起"/>
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" name="eTime" id="eTime" autocomplete="off"
                   value="${dto.eTime!}" placeholder="创建时间止"/>
        </div>
        <div class="layui-input-inline">
            <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
            <button type="button" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
        </div>
    </div>
</form>
<#--<div class="bar">
    <br/>
    <input type="text" name="contactName" value="${dto.contactName!}" placeholder="联系人姓名" />
    <input type="text" name="contactPhone" value="${dto.contactPhone!}" placeholder="联系电话" />
    <input type="text" name="productName" value="${dto.productName!}" placeholder="产品名称" />
    <input type="text" name="orderId" value="${dto.orderId!}" placeholder="订单编号" />
    <select name="state">
        <option value="">--退款状态--</option>
        <option value="unchecked"  <#if '${dto.state!}'='unchecked'> selected ='selected'</#if>>未审核</option>
        <option value="approve"   <#if '${dto.state!}'='approve'>selected ='selected' </#if>>审核通过</option>
        <option value="Unapprove"   <#if '${dto.state!}'='Unapprove'>selected ='selected' </#if>>审核未通过</option>
    </select>
    <input name="cTime" id="cTime" type="text" onclick="WdatePicker()" placeholder="创建时间起" value="${dto.cTime!}"/>
    <input name="eTime" id="eTime" type="text" onclick="WdatePicker({minDate: '#F{$dp.$D(\'startDate1\')}'})" placeholder="创建时间止" value="${dto.eTime!}"/>
    <br/>
    <button type="submit" class="button">查询</button>
    <button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
</div>-->

<#--    <div class="bar">
        <a href="export" class="button" style="width:100px;text-align: center;font-size: medium;font-weight: bold;">导出</a>
    </div>-->
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
        <div class="layui-input-inline-block">
            <button onclick="location.href='export';" class="layui-btn layui-btn-normal">导出</button>
        </div>
    </div>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;">
    <tbody>
    <thead>
    <tr>
        <th class="check"><input type="checkbox" id="selectAll"/></th>
        <th>订单id</th>
        <th>客户姓名</th>
        <th>联系电话</th>
        <th>产品名称（id）</th>
        <th>审核状态</th>
        <th>创建时间</th>
        <th>创建人</th>
        <th><span>操作</span></th>
    </tr>
    </thead>
<#list page.records as dto>
    <tr>
        <td><input type="checkbox" class="checkboxes" name="test" value="${dto.id!}"/></td>
        <td>${dto.orderId!}</td>
        <td>${dto.contactName!}</td>
        <td>${dto.contactPhone!}</td>
        <td>${dto.productName!}（${dto.productId!}）</td>
        <td>
            <#if (dto.state!)=='unchecked'>
                未审核
            <#elseif (dto.state!)=='approve'>
                <p style="color:green">审核通过</p>
            <#elseif (dto.state!)=='Unapprove'>
                <p style="color:red">审核未通过</p>
            </#if>
        </td>
        <td>${dto.createTime?datetime}</td>
        <td>${dto.createName}</td>
        <td>
            <#if (dto.state!)=='unchecked'>
                <@shiro.hasPermission name = "checkorder">
                    <a class="layui-btn layui-btn-sm layui-btn-normal"
                       href="check?state=approve&id=${dto.id!}&orderId=${dto.orderId!}">通过审核</a>
                    <a class="layui-btn layui-btn-sm layui-btn-normal"
                       href="check?state=Unapprove&id=${dto.id!}&orderId=${dto.orderId!}">审核不通过</a>
                </@shiro.hasPermission>
            <#elseif (dto.state!)=='approve'>
                <p style="color:green">已审核</p>
            <#elseif (dto.state!)=='Unapprove'>
                <p style="color:red">已审核</p>
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
</script>
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