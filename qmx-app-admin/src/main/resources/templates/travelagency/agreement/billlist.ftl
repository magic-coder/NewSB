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

        $(document).on("click", "#view", function () {
            var data = $(this).attr("data-id");
            var sn = $(this).attr("data-sn");
            var index = layer.open({
                type: 2,
                title: '绩效明细',
                area: ['80%', '80%'], //宽高
                fix: true, //固定
                content: 'viewBill?agreementId=' + data + '&accountingBillSn=' + sn
            });
        });

        $(document).on("click", "#settle", function () {
            var data = $(this).attr("data-id");
            var index = layer.open({
                type: 2,
                title: '结算绩效',
                area: ['80%', '80%'], //宽高
                fix: true, //固定
                content: 'settleList?memberId=' + data
            });
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
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>绩效规则</legend>
</fieldset>
<form class="layui-form" action="billList" method="post">
    <input name="memberId" value="${dto.memberId!}" type="hidden"/>
    <div class="layui-form-item">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="sn" value="${dto.sn!}" autocomplete="off"
                       class="layui-input" placeholder="清帐编号">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <select class="layui-input" name="channelNo">
                    <option value="">清帐方式</option>
                <#list type as info>
                    <option value="${info}"
                            <#if dto.channelNo??&&info==dto.channelNo>selected</#if>>${info.title}</option>
                </#list>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='billList?memberId=${dto.memberId!}';"
                        class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item" style="margin-left: 10px;">
<@shiro.hasPermission name="admin:taAtExportBill">
    <button onclick="location.href='exportBill?memberId=${dto.memberId!}';" class="layui-btn layui-btn-normal">导出
    </button>
</@shiro.hasPermission>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th><input type="checkbox" id="selectAll"/></th>
        <th>清帐编号</th>
        <th>清帐方式</th>
        <th>清帐金额</th>
        <th>清帐时间</th>
        <th>操作人</th>
        <th>备注</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>${dto.sn!}</td>
        <td><#--${dto.channelNo.title!}--><#list type as info><#if info==dto.channelNo>${info.title}</#if></#list></td>
        <td>
        <#--${(dto.amount)!?string("0.##")}-->#{dto.amount;m2M2}
        </td>
        <td>
        ${dto.createTime!?string("yyyy-MM-dd HH:mm:ss")}
        </td>
        <td>
        ${dto.createName!}
        </td>
        <td>
        ${dto.remark!}
        </td>
        <td>
            <@shiro.hasPermission name="admin:taAtBillList">
                <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.memberId!}"
                       id="view" data-sn="${dto.sn!}" value="明细"/>
            </@shiro.hasPermission>
        <#-- <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.memberId!}" id="settle"
                value="结算"/>-->
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>