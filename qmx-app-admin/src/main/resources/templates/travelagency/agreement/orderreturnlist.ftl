<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>产品列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        //注意：parent 是 JS 自带的全局对象，可用于操作父页面
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            laydate.render({
                elem: '#date'
                , type: 'month'
            });
        });
        //关闭iframe
        $(document).on("click", "#closeIframe", function () {
            parent.layer.close(index);
        });
        //提交iframe
        $(document).on("click", "#submitIframe", function () {
            var checkedIds = [];
            $('input[name="ids"]:checked').each(function () {
                checkedIds.push($(this).val());
            });
            if (checkedIds.length == 0) {
                layer.msg("请至少选择一条订单清帐!");
                return;
            }
            window.location.href = 'createBill?ids=' + checkedIds + '&memberId=${dto.agreementId!}';
            /*$.ajax({
                url: "settlement",
                type: "POST",
                data: $checkedIds.serialize(),
                success: function (json) {
                    if (json.state == "success") {
                        layer.msg("操作成功！");
                        setTimeout(function () {
                            parent.layer.close(index);
                        }, 500);
                    } else {
                        layer.msg("操作失败！");
                    }
                }
            });*/
        });
        $(document).on("click", "#btn", function () {
            var date = $("#date").val();
            var id = $(this).attr("data-id");
            if (date == null || date == undefined || date == '') {
                layer.msg("请选择月份!");
                return;
            }
            $.ajax({
                url: 'returnCount',
                type: 'GET',
                data: {"date": date, "memberId": id},
                dataType: 'json',
                success: function (json) {
                    if (json.moneySum == 0 && json.amountSum == 0) {
                        layer.msg("该月不存在未量返的订单!");
                    } else {
                        var index = layer.open({
                            type: 2,
                            title: '订单支付',
                            area: ['70%', '70%'], //宽高
                            fix: true, //固定
                            content: 'returnInfo?moneySum=' + json.moneySum + "&amountSum=" + json.amountSum + "&date=" + date + "&memberId=" + id
                        });
                    }

                }
            })
        })
    </script>
</head>
<body>
<hr/>
<form class="layui-form" action="orderReturnList" method="post">
    <input type="hidden" name="memberId" value="${dto.memberId!}"/>
    <div class="layui-form-item">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="date" id="date" value="${dto.date!}" autocomplete="off"
                       class="layui-input" placeholder="请选择月份">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='orderReturnList?memberId=${dto.memberId!}';"
                        class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item" style="margin-right: 10px;text-align: right">
    <button class="layui-btn layui-btn-normal" id="btn" data-id="${dto.memberId!}">结算当月量返</button>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable">
    <thead>
    <tr>
        <th>旅行社</th>
        <th>订单号</th>
        <th>消费时间</th>
        <th>量返类型</th>
        <th>量返产品</th>
        <th>量返数</th>
        <th>是否已量返</th>
    </tr>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>${dto.memberName!}</td>
        <td>${dto.orderDto.sn!}</td>
        <td>${dto.orderDto.consumeTime!}</td>
        <td>${dto.returnType.title!}</td>
        <td>${dto.productName!}</td>
        <td>${dto.returnPrice!}</td>
        <td>
            <#if dto.status>
                <span style="color: green"> 已量返</span>
            <#else>
                <span style="color: red"> 未量返</span>
            </#if>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">

<#--<div class="layui-form-item">
    <div align="center">
        <div>
            <input id="submitIframe" type="button" class="layui-btn layui-btn-normal" value="确定"/>
            <input id="closeIframe" type="button" class="layui-btn layui-btn-primary" value="取消"/>
        </div>
    </div>
</div>-->
</body>
</html>