<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
    <title>产品授权分销商</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        layui.use(['form', 'table', 'laydate', 'jquery'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.jquery;

            form.on('submit(submit)', function (data) {
                var productId = $("input[name='userId']");
                if (productId.length < 1) {
                    layer.msg("请选择分销商");
                    return false;
                }
                //return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
            });

            //监听需要授权的酒店
            form.on('select(hid)', function (data) {
                var type = data.value;
                if (type == null || type == undefined || type == '') {
                    $("#productId").find("option").remove();
                    form.render('select');
                    return;
                }
                $.ajax({
                    type: 'GET',
                    url: '/HotelProductImpower/chooseProduct',
                    dataType: 'json',
                    data: {'hid': type},
                    success: function (result) {
                        $("#productId").find("option").remove();
                        for (var key in result.data) {
                            $("#productId").append("<option value='" + key + "'>" + result.data[key] + "</option>");
                        }
                        form.render('select');
                    }
                });
            });
        });
        //分销商列表
        $(document).on("click", "#addDistributorItem", function () {
            var index = layer.open({
                type: 2,
                title: '分销商列表',
                area: ['70%', '80%'], //宽高
                fix: true, //固定
                content: 'getUser'
            });
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>添加产品授权</legend>
</fieldset>
<form action="add" method="get" class="layui-form" id="inputForm">
    <input type="hidden" id="distributorId" name="distributorId"/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label" style="width: 220px;">选择要查看产品授权的所属酒店</label>
            <div class="layui-input-inline">
                <select name="hid" id="hid" lay-filter="hid" class="layui-input" lay-verify="required">
                    <option value="">请选择</option>
                <#if hotelInfo??>
                    <#list hotelInfo as info>
                        <option value="${info.id!}">${info.name!}</option>
                    </#list>
                <#else >
                    <#list impowerHotel as info>
                        <option value="${info.hid!}">${info.hidName!}</option>
                    </#list>
                </#if>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label" style="width: 220px;">选择需要授权给分销商的产品</label>
            <div class="layui-input-inline">
                <select name="productId" id="productId" class="layui-input" lay-verify="required">
                    <option value="" class="slectProcuct" id="slectProcuct">请选择</option>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label" style="width: 220px;">选择要授权的分销商</label>
        <div class="layui-input-inline">
            <input id="addDistributorItem" name="addDistributorItem" type="button" class="layui-btn"
                   value="选择分销商">
            <hr/>
            <table id="userTable" class="layui-table" style="width: 100%">
                <tr>
                    <td>
                        分销商id
                    </td>
                    <td>
                        分销商名称
                    </td>
                    <td>
                        操作
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="submit" lay-filter="submit">下一步</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        </div>
    </div>
</form>
</body>
</html>