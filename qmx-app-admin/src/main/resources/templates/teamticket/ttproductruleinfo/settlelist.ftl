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
    </script>
    <script>
        //注意：parent 是 JS 自带的全局对象，可用于操作父页面
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
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
                layer.msg("请至少选择一条绩效结算!");
                return;
            }
            window.location.href = 'createBill?ids=' + checkedIds + "&memberId=${dto.memberId!}";
            /*layer.confirm('确定结算吗？', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                window.location.href = 'createBill';
                /!*$.ajax({
                    url: 'settle',
                    type: 'POST',
                    data: {'ids': checkedIds},
                    dataType: 'json',
                    traditional: true,
                    success: function (data) {
                        if (data.state == 'success') {
                            layer.msg(data.msg);
                            parent.layer.close(index);
                            setTimeout(function () {
                                location.reload(true);
                            }, 500);
                        } else {
                            layer.msg(data.msg);
                        }
                    }
                });*!/
            }, */
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>结算绩效</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="memberName" value="${dto.memberName!}" autocomplete="off"
                       class="layui-input" placeholder="员工">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item" style="margin-left: 10px;">
</div>

<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th><input type="checkbox" id="selectAll"/></th>
        <th>员工</th>
        <th>订单编号</th>
        <th>下单时间</th>
        <th>消费时间</th>
        <th>提成产品</th>
        <th>提成方式</th>
        <th>提成金额</th>
    <#--<th>操作</th>-->
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>${dto.memberName!}</td>
        <td>${dto.ttOrderDto.sn!}</td>
        <td>${dto.ttOrderDto.createTime!?string("yyyy-MM-dd HH:mm:ss")}</td>
        <td>${dto.ttOrderDto.createTime!?string("yyyy-MM-dd HH:mm:ss")}</td>
        <td>${dto.productName!}</td>
        <td>${dto.type.title!}</td>
        <td>
        ${dto.number!}
        </td>
    <#--<td>
        <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}" id="settles"
               value="结算"/>
    </td>-->
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
<div class="layui-form-item">
    <div align="center">
        <div>
            <input id="submitIframe" type="button" class="layui-btn layui-btn-normal" value="结算"/>
            <input id="closeIframe" type="button" class="layui-btn layui-btn-primary" value="取消"/>
        </div>
    </div>
</div>
</body>
</html>