<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>客户-编辑</title>
<#include "/include/common_header_include.ftl">
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

<@shiro.hasPermission name = "ttcustomer:menber">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">客户所属人</label>
            <div class="layui-input-inline">
                <select id="memberId" name="memberId" lay-verify="required">
                    <option value=""></option>
                    <#list users as user>
                        <option value="${user.id!?c}"
                                <#if dto.memberId == user.id>selected</#if>>${user.username!}</option>
                    </#list>
                </select>
            </div>
        </div>
    </div>
</@shiro.hasPermission>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">协议编号</label>
            <div class="layui-input-inline">
                <input name="sn" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.sn!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">协议名称</label>
            <div class="layui-input-inline">
                <input name="title" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.title!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">行业码</label>
            <div class="layui-input-inline">
                <input name="code" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.code!}">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">客户类型</label>
            <div class="layui-input-inline">
                <select name="type" lay-verify="required">
                    <option value="">----</option>
                <#list types as type>
                    <option value="${type}" <#if type==dto.type>selected="selected"</#if>>${type.title}</option>
                </#list>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">单位名称</label>
            <div class="layui-input-inline">
                <input name="enterpriseName" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.enterpriseName!}">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">联系人姓名</label>
            <div class="layui-input-inline">
                <input name="contactName" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.contactName!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">联系人手机</label>
            <div class="layui-input-inline">
                <input name="contactMobile" lay-verify="required|phone" autocomplete="off" class="layui-input"
                       value="${dto.contactMobile!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">联系人邮箱</label>
            <div class="layui-input-inline">
                <input name="email" lay-verify="required|email" autocomplete="off" class="layui-input"
                       value="${dto.email!}">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">备用联系人姓名</label>
            <div class="layui-input-inline">
                <input name="contactName2" autocomplete="off" class="layui-input" value="${dto.contactName2!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">备用联系人手机</label>
            <div class="layui-input-inline">
                <input name="contactMobile2" autocomplete="off" class="layui-input" value="${dto.contactMobile2!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">备用联系人邮箱</label>
            <div class="layui-input-inline">
                <input name="email2" autocomplete="off" class="layui-input" value="${dto.email2!}">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">公司规模</label>
            <div class="layui-input-inline">
                <select name="scale" lay-verify="required">
                    <option value="1" <#if dto.scale=='1'>selected</#if>>50人以下</option>
                    <option value="2" <#if dto.scale=='2'>selected</#if>>50人至300人</option>
                    <option value="3" <#if dto.scale=='3'>selected</#if>>300人至1000人</option>
                    <option value="4" <#if dto.scale=='4'>selected</#if>>1000人至5000人</option>
                    <option value="5" <#if dto.scale=='5'>selected</#if>>5000人以上</option>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">地理位置</label>
            <div class="layui-input-inline" style="width: auto;">
                <div class="layui-input-inline">
                    <select name="province" lay-filter="province" lay-verify="required">
                        <option value="">请选择</option>
                    </select>
                </div>
                <div class="layui-input-inline" style="display: none;">
                    <select name="city" lay-filter="city">
                    </select>
                </div>
                <div class="layui-input-inline" style="display: none;">
                    <select name="county" lay-filter="area">
                    </select>
                </div>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label" style="width: auto;">客户结算类型</label>
            <div class="layui-input-inline" style="width: auto">
                <input name="guazhang" value="true" title="挂账客户" type="radio"
                       <#if dto.guazhang?? && dto.guazhang>checked</#if> lay-filter="guazhang">
                <input name="guazhang" value="false" title="普通客户" type="radio"
                       <#if dto.guazhang?? && !dto.guazhang>checked</#if> lay-filter="guazhang">
            </div>
        </div>
    </div>

    <div class="layui-form-item" <#if dto.guazhang?? && !dto.guazhang>style="display: none"</#if>>
        <div class="layui-inline">
            <label class="layui-form-label">结算周期</label>
            <div class="layui-input-inline" style="width: auto;">
                <input name="period" value="day" title="日" type="radio"
                       <#if dto.period?? && dto.period=='day' >checked</#if>>
                <input name="period" value="week" title="周" type="radio"
                       <#if dto.period?? && dto.period=='week' >checked</#if>>
                <input name="period" value="month" title="月" type="radio"
                       <#if dto.period?? && dto.period=='month' >checked</#if>>
                <input name="period" value="quarter" title="季" type="radio"
                       <#if dto.period?? && dto.period=='quarter' >checked</#if>>
                <input name="period" value="year" title="年" type="radio"
                       <#if dto.period?? && dto.period=='year' >checked</#if>>
            </div>
        </div>
    </div>

    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>产品信息</legend>
    </fieldset>

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
                        协议价格
                    </td>
                    <td width="50">
                        操作
                    </td>
                </tr>
            <#list dto.products as product>
                <tr>
                    <td>
                        <input type="hidden" name="cpid" class="cpid" value="${product.id!}">
                        <input type="hidden" name="productId" class="productId" value="${product.productId!}">
                    ${product.productName!}
                    </td>
                    <td><input name="price" class="layui-input" value="${product.price!}"></td>
                    <td><a href="javascript:;" class="deleteItem" data-id="${product.id!?c}">删除</a></td>
                </tr>
            </#list>
            </table>
        </div>
    </div>

    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>开票信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">开票单位名称</label>
            <div class="layui-input-inline">
                <input name="unitName" autocomplete="off" class="layui-input" value="${dto.unitName!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">纳税人识别号</label>
            <div class="layui-input-inline">
                <input name="unitTaxNumber" autocomplete="off" class="layui-input" value="${dto.unitTaxNumber!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">单位地址</label>
            <div class="layui-input-inline">
                <input name="unitAddr" autocomplete="off" class="layui-input" value="${dto.unitAddr!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">单位电话</label>
            <div class="layui-input-inline">
                <input name="unitPhone" autocomplete="off" class="layui-input" value="${dto.unitPhone!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">单位银行开户行</label>
            <div class="layui-input-inline">
                <input name="unitBank" autocomplete="off" class="layui-input" value="${dto.unitBank!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">单位银行卡号</label>
            <div class="layui-input-inline">
                <input name="unitAccount" autocomplete="off" class="layui-input" value="${dto.unitAccount!}">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <input onclick="history.back();" class="layui-btn layui-btn-primary" value="返回" type="button">
        </div>
    </div>
</form>
<script type="text/javascript" src="${base}/resources/common/js/area.js"></script>
<script>
    layui.use(['form', 'table', 'laydate'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;

        loadArea();
        //var area = JSON.parse('${dto.area!}');
        bindArea(${dto.area!});

        form.on('radio(guazhang)', function () {
            if ($(this).val() == 'false') {
                $(this).parents().parents().next().attr("style", "display:none;");
            } else {
                $(this).parents().parents().next().attr("style", "display:block");
            }
        });

        form.verify({
            price: function (value, item) {
                if (value == '') {
                    return '请填写金额!';
                }
                if (!(/^[1-9]\d*(\.\d+)?$/).test(value) || !(/^[1-9]\d*(\.\d+)?$/).test(value)) {
                    return '金额输入格式不正确!';
                }

            }
        })
    });
    //添加产品
    $(document).on("click", "#addProduct", function () {
        var userId = -1;
        if ($("#memberId").length > 0) {
            userId = $("#memberId").val();
            if (userId == "") {
                layer.msg("请先选择客户所属人");
                return;
            }
        }
        /*if(userId == ""){
            layer.msg("请先选择客户所属人");
            return;
        }*/
        var index = layer.open({
            type: 2,
            title: '添加产品',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'getProducts?userId=' + userId
        });
    });
    // 删除产品
    $(document).on("click", "#productTable a.deleteItem", function () {
        var $this = $(this);
        layer.confirm('确定删除吗？', {
            btn: ['确定', '取消'] //按钮
        }, function (index) {
            if ($this.attr("data-id")) {
                $.ajax({
                    url: "deleteCustomerProduct",
                    type: "POST",
                    data: {id: $this.attr("data-id")},
                    dataType: "json",
                    beforeSend: function () {
                    },
                    success: function (datas) {
                    }
                });
            }
            $this.closest("tr").remove();
            layer.close(index);
        }, function () {
        });
    });
</script>
</body>
</html>