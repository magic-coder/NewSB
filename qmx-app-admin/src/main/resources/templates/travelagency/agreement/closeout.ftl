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
    </script>
</head>
<body>
<hr/>
<#--<form class="layui-form" action="closeout" method="post">
    <input type="hidden" name="customerId" value="${dto.customerId!?c}"/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">产品名称</label>
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='getProducts';" class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>-->
<div class="layui-form-item" style="margin-right: 10px;text-align: right">
<#--<input type="button" class="layui-btn layui-btn-sm" data-id="${dto.id!?c}" value="账单"
       onclick="window.location.href='billList?memberId=${dto.id!}'" style="text-align: right"/>-->
<@shiro.hasPermission name="admin:taAtAccountingBill">
    <a href="billList?memberId=${dto.agreementId!}" target="_parent"
       style="color: blue;font-size: 15px;text-decoration:underline;letter-spacing:2px;">已结账单查询</a>
</@shiro.hasPermission>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable">
    <thead>
    <tr>
        <th><input type="checkbox" id="selectAll"/></th>
        <th>旅行社</th>
        <th>订单号</th>
        <th>购买日期</th>
        <th>总金额</th>
        <th>状态</th>

    </tr>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>${dto.memberName!}</td>
        <td>${dto.sn!}</td>
        <td><span title="${dto.createTime?datetime}">${dto.createTime?datetime}</span></td>
        <td>${dto.totalAmount!}</td>
        <td>
            <span style="color: red;">${dto.taPaymentStatus.title!}</span>
        </td>

    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">

<div class="layui-form-item">
    <div align="center">
        <div>
            <input id="submitIframe" type="button" class="layui-btn layui-btn-normal" value="确定"/>
            <input id="closeIframe" type="button" class="layui-btn layui-btn-primary" value="取消"/>
        </div>
    </div>
</div>
</body>
</html>