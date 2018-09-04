<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>订单-新增</title>
</head>
<body>
<form class="layui-form" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">客户类型</label>
            <div class="layui-input-inline">
                <select id="typeclick" lay-filter="typeclick">
                    <option value="linshi">临时</option>
                    <option value="guding">固定</option>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item linshi">
        <div class="layui-inline">
            <label class="layui-form-label">单位名称</label>
            <div class="layui-input-inline">
                <input name="enterpriseName" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">联系人姓名</label>
            <div class="layui-input-inline">
                <input name="contactName" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">手机号码</label>
            <div class="layui-input-inline">
                <input name="contactMobile" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item guding">
        <div class="layui-inline">
            <label class="layui-form-label">客户列表</label>
            <div class="layui-input-inline" style="width: auto;">
                <input type="hidden" id="customerId" name="customerId"/>
                <input id="addCustomer" type="button" class="layui-btn" value="选择客户">
                <span id="customerSpan"></span>
            </div>
        </div>
    </div>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">产品列表</label>
        <div class="layui-input-inline">
            <input id="addProduct" type="button" class="layui-btn" value="添加产品">
            <hr/>
            <table id="productTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td width="200">
                        产品价格
                    </td>
                    <td width="200">
                        数量
                    </td>
                    <td width="50">
                        操作
                    </td>
                </tr>
            </table>
        </div>
    </div>
<#--<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label">总价格</label>
        <div class="layui-input-inline" style="width: auto">
            <span id="totalprice"></span>
            <input type="hidden" id="price"/>
        </div>
    </div>
</div>-->
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">短信模板</label>
            <div class="layui-input-inline" style="width: auto">
                <select name="smsTemplateId">
                    <option value="">请选择</option>
                <#list smsTemplates as smsTemplate>
                    <option value="${smsTemplate.id!?c}">${smsTemplate.name!}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">使用模式选择</label>
            <div class="layui-input-inline" style="width: auto">
                <input name="phaseNote" value="false" title="团票" type="radio" checked lay-filter="phaseNote">
                <input name="phaseNote" value="true" title="期票" type="radio" lay-filter="phaseNote">
            </div>
        </div>
    </div>
    <div class="layui-form-item" name="phaseNote">
        <div class="layui-inline">
            <label class="layui-form-label">游玩日期</label>
            <div class="layui-input-inline">
                <input id="date" name="date" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item" name="phaseNote1" style="display: none">
        <div class="layui-inline">
            <label class="layui-form-label">有效期</label>
            <div class="layui-input-inline" style="width: auto">
                <input id="sdate" name="date" disabled="disabled" lay-verify="" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-input-inline" style="width: auto">
                <input id="edate" name="edate" disabled="disabled" lay-verify="" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>


    <div class="layui-form-item linshi">
        <div class="layui-inline">
            <label class="layui-form-label">开票单位</label>
            <div class="layui-input-inline">
                <input name="unitName" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">税号</label>
            <div class="layui-input-inline">
                <input name="unitTaxNumber" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item linshi">
        <div class="layui-inline">
            <label class="layui-form-label">单位地址</label>
            <div class="layui-input-inline">
                <input name="unitAddr" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">单位电话</label>
            <div class="layui-input-inline">
                <input name="unitPhone" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item linshi">
        <div class="layui-inline">
            <label class="layui-form-label">银行开户行</label>
            <div class="layui-input-inline">
                <input name="unitBank" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">银行账号</label>
            <div class="layui-input-inline">
                <input name="unitAccount" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">备注</label>
        <div class="layui-input-block">
            <textarea name="remark" placeholder="备注" class="layui-textarea"></textarea>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
</body>
<#include "/include/common_header_include.ftl">
<script type="text/javascript" src="${base}/resources/common/js/area.js"></script>
<script>
    layui.use(['jquery', 'form', 'table', 'laydate'], function () {
        var $ = layui.$;
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;

        laydate.render({
            elem: '#date'
        });
        laydate.render({
            elem: '#edate'
        });
        laydate.render({
            elem: '#sdate'
        });

        form.on('select(typeclick)', function (data) {
            var type = data.value;
            if (type == "linshi") {
                $(".linshi").show();
                $(".guding").hide();
                $("#customerId").val("");
            } else {
                $(".linshi").hide();
                $(".guding").show();
            }
            $("table tbody tr").eq(0).nextAll().remove();
        });
        $(function () {
            var type = $("#typeclick").val();
            if (type == "linshi") {
                $(".linshi").show();
                $(".guding").hide();
                $("#customerId").val("");
            } else {
                $(".linshi").hide();
                $(".guding").show();
            }
        });
        //选择客户
        $(document).on("click", "#addCustomer", function () {
            var index = layer.open({
                type: 2,
                title: '选择客户',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getCustomers'
            });
            $("table tbody tr").eq(0).nextAll().remove();
        });
        //添加产品
        $(document).on("click", "#addProduct", function () {
            var typeclick = $('#typeclick').val();
            var customerId = $('#customerId').val();
            if (typeclick == "guding" && customerId == "") {
                layer.msg("固定客户请先选择客户！");
                return;
            }
            var index = layer.open({
                type: 2,
                title: '添加产品',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getProducts?customerId=' + customerId
            });
        });
        // 删除产品
        $(document).on("click", "#productTable a.deleteItem", function () {
            var $this = $(this);
            layer.confirm('确定删除吗？', {
                btn: ['确定', '取消'] //按钮
            }, function (index) {
                /*if ($this.attr("data-id")) {
                    $.ajax({
                        url: "",
                        type: "POST",
                        data: {id: $this.attr("data-id")},
                        dataType: "json",
                        beforeSend: function () {
                        },
                        success: function (datas) {
                        }
                    });
                }*/
                $this.closest("tr").remove();
                layer.close(index);
            }, function () {
            });
        });

        form.on('radio(phaseNote)', function () {
            if ($(this).val() == 'true') {
                $("div[name='phaseNote1']").attr("style", "display:block");
                $("div[name='phaseNote']").attr("style", "display:none");
                $("#date").attr("lay-verify", "");
                $("#edate").attr("lay-verify", "required");
                $("#sdate").attr("lay-verify", "required");
                $('#date').attr("disabled", true);
                $('#edate').removeAttr("disabled");
                $('#sdate').removeAttr("disabled");
            } else {
                $("div[name='phaseNote1']").attr("style", "display:none");
                $("div[name='phaseNote']").attr("style", "display:block");
                $("#date").attr("lay-verify", "required");
                $("#edate").attr("lay-verify", "");
                $("#sdate").attr("lay-verify", "");
                $('#edate').attr("disabled", true);
                $('#sdate').attr("disabled", true);
                $('#date').removeAttr("disabled");
            }
        });
    });
</script>
</html>