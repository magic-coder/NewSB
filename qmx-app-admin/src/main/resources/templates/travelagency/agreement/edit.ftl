<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">

    <style>
        .layui-form-label {
            width: auto;
        }
    </style>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">关联旅行社</label>
            <div class="layui-input-inline" style="width: auto;">
                <input id="travelagency" name="travelagencyId" type="hidden" lay-verify="required" autocomplete="off"
                       class="layui-input" value="${dto.travelagencyId!}">
                <div id="travelagencyName" class="layui-form-mid">${dto.travelagencyName!}</div>
            </div>
            <div class="layui-input-inline">
                <button id="travelagencyBtn" type="button" class="layui-btn">
                    选择
                </button>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">协议开始时间</label>
            <div class="layui-input-inline">
                <input id="sdate" name="sdate" value="${dto.sdate!}" lay-verify="required" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">协议结束时间</label>
            <div class="layui-input-inline">
                <input id="edate" name="edate" value="${dto.edate!}" lay-verify="required" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>

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
                <input name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.name!}">
            </div>
        </div>
    </div>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">产品列表</label>
        <div class="layui-input-inline">
            <input id="addProduct" type="button" class="layui-btn" value="添加主产品">
            <label style="color: red;">添加产品后，需设置价格政策才会保存产品信息</label>
            <hr/>
            <table id="productTable" width="50%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td>
                        操作
                    </td>
                </tr>
            <#list products as product>
                <tr>
                    <td>
                    ${product.productName!}
                    </td>
                    <td>
                        <input class="layui-btn layui-btn-sm layui-btn-normal productPolicy"
                               data-id="${product.productId!}" value="梯度价格" type="button">
                        <input class="layui-btn layui-btn-sm layui-btn-normal quantityBack"
                               data-id="${product.productId!}"
                               value="量返政策"
                               type="button">
                        <input class="layui-btn layui-btn-sm layui-btn-normal deleteItem"
                               data-id="${product.productId!}"
                               value="删除" type="button">
                        <div id="${product.productId!}" style="display:none">
                            <table>
                                <#list product.policyDtos as info>
                                    <tr>
                                        <input type="hidden" name="ppid" value="${info.id!}"/>
                                        <input type="hidden" name="productId" value="${info.productId!}"/>
                                        <input type="hidden" name="minNumber" value="${info.minNumber!}"/>
                                        <input type="hidden" name="maxNumber" value="${info.maxNumber!}"/>
                                        <input type="hidden" name="price" value="${info.price!}"/>
                                    </tr>
                                </#list>
                            </table>
                        </div>
                        <div id="qb${product.productId!}" style="display:none">
                            <#if product.returnPolicyDto??>
                                <input type="hidden" name="ppid" value="${product.returnPolicyDto.ppid!}"/>
                                <input type="hidden" name="qbProductId" value="${product.returnPolicyDto.productId!}"/>
                                <input type="hidden" name="type" value="${product.returnPolicyDto.type!}"/>
                                <input type="hidden" name="returnType" value="${product.returnPolicyDto.returnType!}"/>
                                <input type="hidden" name="number" value="${product.returnPolicyDto.number!}"/>
                                <input type="hidden" name="returnNumber"
                                       value="${product.returnPolicyDto.returnNumber!}"/>
                                <input type="hidden" name="repeat" value="${product.returnPolicyDto.repeat!?c}"/>
                            </#if>
                        </div>
                        <input id="json${product.productId!}" type="hidden" value='${product.productPolicyJson!}'>
                        <input id="jsonqb${product.productId!}" type="hidden" value='${product.returnPolicyJson!}'>
                    </td>
                </tr>
            </#list>
            </table>
            <label class="layui-form-label">订单修改规则</label>
            <div class="layui-input-inline" style="width:auto;">
                <div class="layui-form-mid">景区接单前可随意修改订单、景区接单后可修改</div>
                <div class="layui-input-inline" style="width:auto;">
                    <input name="updateNumber" lay-verify="required|count" autocomplete="off" class="layui-input"
                           style="width:50px;" value="${dto.updateNumber!}">
                </div>
                <div class="layui-form-mid">次，每次修改上调数量</div>
                <div class="layui-input-inline" style="width:auto;">
                    <input name="upQuantity" lay-verify="required|positiveInteger" autocomplete="off"
                           class="layui-input"
                           style="width:50px;" value="${dto.upQuantity!}">
                </div>
                <div class="layui-form-mid">减少数量</div>
                <div class="layui-input-inline" style="width:auto;">
                    <input name="downQuantity" lay-verify="required|positiveInteger" autocomplete="off"
                           class="layui-input"
                           style="width:50px;" value="${dto.downQuantity!}">
                </div>
            </div>
            <br/>
            <div class="layui-inline">
                <label class="layui-form-label">订单退款规则</label>
                <div class="layui-input-inline" style="width:auto;">
                    <div class="layui-form-mid">接单前默认退款不收手续费、接单后</div>
                    <div class="layui-input-inline" style="width:auto;">
                        <select name="refunds" style="width:auto;" lay-filter="refunds">
                            <option value="true" <#if dto.refunds?? && dto.refunds>selected</#if>>可退款</option>
                            <option value="false" <#if dto.refunds?? && !dto.refunds>selected</#if>>不可退款</option>
                        </select>
                    </div>
                    <div class="layui-form-mid">退款手续费为订单金额的</div>
                    <div class="layui-input-inline" style="width:auto;">
                        <input name="productNumber" id="number"
                               <#if dto.refunds?? && dto.refunds>lay-verify="required|number"</#if> autocomplete="off"
                               class="layui-input" style="width:50px;" value="${dto.productNumber!}">
                    </div>
                    <div class="layui-form-mid">%</div>
                </div>
            </div>
            <br/>
            <input id="addIncreaseProduct" type="button" class="layui-btn" value="添加增值产品">
            <hr/>
            <table id="increaseProductTable" width="50%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td width="100">
                        结算价
                    </td>
                    <td>
                        操作
                    </td>
                </tr>
            <#list increaseProducts as increaseProduct>
                <tr>
                    <td>
                    ${increaseProduct.productName!}
                    </td>
                    <td>
                        <input autocomplete="off" lay-verify="number" name="ipPrice" value="${increaseProduct.price!}"
                               id="ipPrice" class="layui-input">
                    </td>
                    <td>
                    <#--<input class="layui-btn layui-btn-sm layui-btn-normal increaseProductPolicy"
                           data-id="${increaseProduct.productId!}" value="价格设置" type="button">-->

                        <input class="layui-btn layui-btn-sm layui-btn-normal increaseDeleteItem"
                               data-id="${increaseProduct.productId!}"
                               value="删除" type="button">
                        <div id="ip${increaseProduct.productId!}" style="display: none;">
                            <table>
                                <tr>
                                    <input type="hidden" name="ppid" value="${increaseProduct.id!}"/>
                                    <input type="hidden" name="ipProductId" value="${increaseProduct.productId!}"/>
                                <#--<input type="text" name="ipPrice" value="${increaseProduct.price!}"/>-->
                                </tr>
                            </table>
                        </div>
                        <input id="jsonip${increaseProduct.productId!}" type="hidden"
                               value='${increaseProduct.increasePolicyJson!}' style="width: 400px;">
                    </td>
                </tr>
            </#list>
            </table>
            <label class="layui-form-label">订单修改规则</label>
            <div class="layui-input-inline" style="width:auto;">
                <div class="layui-form-mid">到场前</div>
                <div class="layui-input-inline" style="width:auto;">
                    <select name="increaseHour" lay-verify="required">
                    <#list 0..72 as a>
                        <option value="${a}" <#if '${a}'=='${dto.increaseHour!}'>selected</#if>>${a}</option>
                    </#list>
                    </select>
                </div>
                <div class="layui-form-mid">小时支持上调数量</div>
                <div class="layui-input-inline" style="width:auto;">
                    <input name="increaseUpQuantity" lay-verify="required|positiveInteger" autocomplete="off"
                           class="layui-input"
                           style="width:50px;" value="${dto.increaseUpQuantity!}">
                </div>
                <div class="layui-form-mid">减少数量</div>
                <div class="layui-input-inline" style="width:auto;">
                    <input name="increaseDownQuantity" lay-verify="required|positiveInteger" autocomplete="off"
                           class="layui-input"
                           style="width:50px;" value="${dto.increaseDownQuantity!}">
                </div>
            </div>
            <br/>
            <div class="layui-input-inline" style="width:auto;">
                <label class="layui-form-label">订单退款规则</label>
                <div class="layui-form-mid">接单后</div>
                <div class="layui-input-inline" style="width:auto;">
                    <select name="retreat" style="width:auto;" lay-filter="retreat">
                        <option value="true" <#if dto.retreat?? && dto.retreat>selected</#if>>可退款</option>
                        <option value="false" <#if dto.retreat?? && !dto.retreat>selected</#if>>不可退款</option>
                    </select>
                </div>
                <div class="layui-form-mid">退款手续费为订单金额的</div>
                <div class="layui-input-inline" style="width:auto;">
                    <input name="increaseNumber" id="increaseNumber"
                           <#if dto.retreat?? && dto.retreat>lay-verify="required"</#if>
                           autocomplete="off" class="layui-input" style="width:50px;" value="${dto.increaseNumber!}">
                </div>
                <div class="layui-form-mid">%</div>
            </div>
        </div>
    </div>

<#--<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label">提前几天预定</label>
        <div class="layui-input-inline" style="width:auto;">
            <input name="day" lay-verify="required|number" autocomplete="off" class="layui-input"
                   value="${dto.day!}">
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">几点前可预定</label>
        <div class="layui-input-inline" style="width:auto;">
            <input name="hour" lay-verify="required|number" autocomplete="off" class="layui-input"
                   value="${dto.hour!}">
        </div>
    </div>
</div>-->
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">付款类型</label>
            <div class="layui-input-inline" style="width:auto;">
                <input name="payType" lay-filter="payType" title="挂账" type="radio" value="0"
                       <#if '${dto.payType!?c}'=='false'>checked</#if>>
                <input name="payType" lay-filter="payType" title="常规" type="radio" value="1"
                       <#if '${dto.payType!?c}'=='true'>checked</#if>>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">付款方式</label>
            <div class="layui-input-inline" style="width:auto;">
            <#--<input name="payWay" lay-skin="primary" title="微信支付" type="checkbox"
                   value="WX_NATIVE" <#if '${dto.payWay!}'?contains('WX_NATIVE')>checked</#if>>
            <input name="payWay" lay-skin="primary" title="支付宝支付" type="checkbox" value="ALIPAY_QR"
                   <#if '${dto.payWay!}'?contains('ALIPAY_QR')>checked</#if>>-->
            <#list types as info>
                <input name="payWay" lay-skin="primary" title="${info.title}" type="checkbox" value="${info}"
                       <#if dto.payWay?contains(info)>checked</#if>>
            </#list>
            </div>
        </div>
    </div>
    <div class="layui-form-item" id="deposit" <#if '${dto.payType!?c}'=='false'>style="display: none"</#if>>
        <div class="layui-inline">
            <label class="layui-form-label">主产品定金收取比例</label>
            <div class="layui-input-inline">
                <input name="deposit" id="primaryDeposit" lay-verify="required|number" autocomplete="off"
                       class="layui-input"
                       value="${dto.deposit!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">增值产品定金收取比例</label>
            <div class="layui-input-inline">
                <input name="increaseDeposit" id="increaseDeposit" lay-verify="required|number" autocomplete="off"
                       class="layui-input"
                       value="${dto.increaseDeposit!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">下单需要信息</label>
            <div class="layui-input-inline" style="width:auto;">
            <#list infos as info>
                <input name="infos" lay-skin="primary" value="${info!}"
                       <#if dto.infos?? && dto.infos?index_of(info) gt -1>checked</#if> title="${info.title!}"
                       type="checkbox">
            </#list>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
</body>
<script>
    layui.use(['form', 'table', 'laydate', 'jquery'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
        var $ = layui.jquery;

        laydate.render({
            elem: '#sdate'
        });
        laydate.render({
            elem: '#edate'
        });
        form.verify({
            positiveInteger: [/^([1-9]\d*|[0]{1,1})$/, '请输入正确的数量!']
        });

        form.verify({
            count: [/^([1-9]\d*|[0]{1,1})$/, '请输入正确的次数!']
        });

        form.verify({
            hour: [/^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/, '请输入正确的小时数!']
        });

        //监听付款类型
        form.on('radio(payType)', function (data) {
            var flag = data.value;
            if (flag == 0) {
                $("#deposit").hide();
                $("#primaryDeposit").attr("lay-verify", "");
                $("#increaseDeposit").attr("lay-verify", "");
            } else {
                $("#deposit").show();
                $("#primaryDeposit").attr("lay-verify", "required|number");
                $("#increaseDeposit").attr("lay-verify", "required|number");
            }
        });
        //监听主产品生是否可退款
        form.on('select(refunds)', function (data) {
            var type = data.value;
            if (type == 'false') {
                $("#number").attr("lay-verify", "");
                $("#number").attr("disabled", 'disabled');
            } else {
                $("#number").attr("lay-verify", "required|number");
                $("#number").attr("disabled", false);
            }
        });
        //监听增值产品生是否可退款
        form.on('select(retreat)', function (data) {
            var type = data.value;
            if (type == 'false') {
                $("#increaseNumber").attr("lay-verify", "");
                $("#increaseNumber").attr("disabled", 'disabled');
            } else {
                $("#increaseNumber").attr("lay-verify", "required|number");
                $("#increaseNumber").attr("disabled", false);
            }
        });
        form.render();
    });
    //添加主产品
    $(document).on("click", "#addProduct", function () {
        var index = layer.open({
            type: 2,
            title: '添加产品',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'getProducts'
        });
    });
    //添加增值产品
    $(document).on("click", "#addIncreaseProduct", function () {
        var index = layer.open({
            type: 2,
            title: '添加增值产品',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'getIncreaseProducts'
        });
    });
    // 删除主产品
    $(document).on("click", "#productTable .deleteItem", function () {
        var $this = $(this);
        layer.confirm('确定删除吗？', {
            btn: ['确定', '取消'] //按钮
        }, function (index) {
            $this.closest("tr").remove();
            layer.close(index);
        }, function () {
        });
    });
    // 删除增值产品
    $(document).on("click", "#increaseProductTable .increaseDeleteItem", function () {
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
    //添加梯度价格
    $(document).on("click", "#productTable .productPolicy", function () {
        var travelagency = $("#travelagency").val();
        if (travelagency == "") {
            layer.msg("请先选择旅行社");
            return;
        }
        var data = $(this).attr("data-id");
        var index = layer.open({
            type: 2,
            title: '添加梯度价格',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'getProductPolicyList?memberId=' + travelagency + '&productId=' + data
        });
    });
    //量返政策
    $(document).on("click", "#productTable .quantityBack", function () {
        var travelagency = $("#travelagency").val();
        if (travelagency == "") {
            layer.msg("请先选择旅行社");
            return;
        }
        var data = $(this).attr("data-id");
        var index = layer.open({
            type: 2,
            title: '添加量反政策',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'getProductReturnPolicy?memberId=' + travelagency + '&productId=' + data
        });
    });
    //增值产品价格设置
    $(document).on("click", "#increaseProductTable .increaseProductPolicy", function () {
        var travelagency = $("#travelagency").val();
        if (travelagency == "") {
            layer.msg("请先选择旅行社");
            return;
        }
        var data = $(this).attr("data-id");
        var index = layer.open({
            type: 2,
            title: '添加价格设置',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'getIncreasePrice?memberId=' + travelagency + '&productId=' + data
        });
    });
    //关联旅行社
    $(document).on("click", "#travelagencyBtn", function () {
        var index = layer.open({
            type: 2,
            title: '关联旅行社',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'gettravelagency'
        });
    });
    $(document).on("blur", "input[name='deposit']", function () {
        //获取主产品定金收取比例
        var deposit = $(this).val();
        //获取主产品退款手续费比例
        var number = $("#number").val();
        if (number != "") {
            if (parseFloat(deposit) < parseFloat(number)) {
                layer.msg("定金不能小于退款手续费，请重新填写");
                $(this).val("");
            }
        }
    });
    $(document).on("blur", "input[name='productNumber']", function () {
        //获取主产品退款手续费比例
        var number = $(this).val();
        //获取主产品定金收取比例
        var deposit = $("#primaryDeposit").val();
        if (deposit != "") {
            if (parseFloat(deposit) < parseFloat(number)) {
                layer.msg("定金不能小于退款手续费，请重新填写");
                $(this).val("");
            }
        }
    });
    $(document).on("blur", "input[name='increaseDeposit']", function () {
        //获取增值产品产品定金收取比例
        var increaseDeposit = $(this).val();
        //获取主产品退款手续费比例
        var increaseNumber = $("#increaseNumber").val();
        if (increaseNumber != "") {
            if (parseFloat(increaseDeposit) < parseFloat(increaseNumber)) {
                layer.msg("定金不能小于退款手续费，请重新填写");
                $(this).val("");
            }
        }
    });
    $(document).on("blur", "input[name='increaseNumber']", function () {
        //获取增值产品产品定金收取比例
        var increaseNumber = $(this).val();
        //获取主产品退款手续费比例
        var increaseDeposit = $("#increaseDeposit").val();
        if (increaseDeposit != "") {
            if (parseFloat(increaseDeposit) < parseFloat(increaseNumber)) {
                layer.msg("定金不能小于退款手续费，请重新填写");
                $(this).val("");
            }
        }
    });
</script>
</html>