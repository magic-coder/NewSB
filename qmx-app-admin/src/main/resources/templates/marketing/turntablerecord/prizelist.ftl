<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
</head>
<body>
<#include "../turntable/tab.ftl"/>
<form class="layui-form" action="prizeList" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">券号</label>
            <div class="layui-input-inline">
                <input type="text" name="cardcode" value="${dto.cardcode!}" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='prizeList';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>活动名称</th>
        <th>活动类型</th>
        <th>奖品名称</th>
        <th>优惠券名称</th>
        <th>券号</th>
        <th>领取人</th>
        <th>状态</th>
        <th>有效期</th>
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
        ${dto.activityName!}
        </td>
        <td>
        ${dto.activityType.title!}
        </td>
        <td>
        ${dto.prizeName!}
        </td>
        <td>
        ${dto.productName!}
        </td>
        <td>
        ${dto.cardcode!}
        </td>
        <td>
        ${dto.userName!}
        </td>
        <td>
            <#if dto.state??>
                <#if dto.state=="normal">
                    <span style="color:green;">${dto.state.title!}</span>
                <#elseif dto.state=="used">
                    <span style="color:red;">${dto.state.title!}</span>
                <#else>
                    <span style="color:red;">${dto.state.title!}</span>
                </#if>
            </#if>
        </td>
        <td>
        ${dto.beginDate!?string("yyyy-MM-dd")}至${dto.endDate!?string("yyyy-MM-dd")}
        </td>
        <td>
            <#if !dto.product?? && dto.state=="normal">
                <input type="button" class="layui-btn layui-btn-normal layui-btn-sm"
                       data-id="${dto.id?c}" id="closureBtn"
                       value="核销"/>
            </#if>
        </td>
    </tr>
    </#list>

    </tbody>
</table>
<#include "/include/my_pagination.ftl">
<script type="text/javascript">
    $(document).on("click", "#closureBtn", function () {
        var data = $(this).attr("data-id");
        layer.confirm('确定核销吗？', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: "../WxShareCoupon/closureById",
                type: "POST",
                data: {id: data},
                beforeSend: function () {
                },
                success: function (json) {
                    if (json.type == "success") {
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
</body>
</html>