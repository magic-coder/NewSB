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
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <input type="hidden" name="updateProductCount" id="updateProductCount"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">旅行社名称</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${travelAgencyDto.name!}</div>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">联系人姓名</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${travelAgencyDto.contactsName!}</div>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">联系人电话</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${travelAgencyDto.contactsMobile!}</div>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">游玩日期</label>
            <div class="layui-input-inline">
                <input id="date" value="${dto.date!}" name="date" type="hidden" autocomplete="off"
                       class="layui-input">
            </div>
            <div class="layui-form-mid">${dto.date!}</div>
        </div>
    </div>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">产品列表</label>
        <div class="layui-input-inline">
            <input type="hidden" name="agreementId" id="agreementId" value="${agreementDto.id!}"/>
            <input type="hidden" id="memberId" name="memberId" value="${agreementDto.travelagencyId!?c}"/>
            <input type="hidden" value="${agreementDto.upQuantity!}" id="upQuantity"/>
            <input type="hidden" value="${agreementDto.downQuantity!}" id="downQuantity"/>
            <input type="hidden" value="${agreementDto.increaseUpQuantity!}" id="increaseUpQuantity"/>
            <input type="hidden" value="${agreementDto.increaseDownQuantity!}" id="increaseDownQuantity"/>
        <#--<input id="addProduct" type="button" class="layui-btn" value="添加主产品">-->
            <br/>
            <label style="color: red;">订单需收取${agreementDto.deposit}%的定金</label>
            <hr/>
            <table id="productTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td>
                        价格
                    </td>
                    <td>
                        数量
                    </td>
                <#--<td>
                    操作
                </td>-->
                </tr>
            <#list dto.infoDtos as info>
                <tr>
                    <td width="200">
                        <input type="hidden" name="productId" class="productId" value="${info.productId!}"/>
                        <labeld title="
                            <#list info.policyDtos as policys>数量大于${policys.minNumber!}小于${policys.maxNumber!}价格为${policys.price!}&#10;</#list>">${info.productName!}</labeld>
                    </td>
                    <td>
                        <input type="hidden" name="price" value="${info.price!}" class="layui-input"/>
                        <labeld class="price">${info.price!}</labeld>
                    </td>
                    <td>
                        <input name="startQuantity" class="startQuantity" value="${info.quantity!}" type="hidden"/>
                        <input name="quantity" id="quantity" value="${info.quantity!}" lay-verify="required"
                               class="layui-input"/>
                        <input name="surplusTotalStock" value="${info.surplusTotalStock!}"
                               type="hidden" class="surplusTotalStock"/>
                    </td>
                <#--<td>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal deleteItem" data-id=""
                           value="删除"/>
                </td>-->
                </tr>
            </#list>
            </table>
            <br/>
        <#--<input id="addIncreaseProduct" type="button" class="layui-btn" value="添加增值产品">-->
            <label style="color: red;">订单需收取${agreementDto.increaseDeposit!}%的定金</label>
            <hr/>
            <table id="increaseProductTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        增值产品名称
                    </td>
                    <td>
                        价格
                    </td>
                    <td>
                        数量
                    </td>
                <#--<td>
                    操作
                </td>-->
                </tr>
            <#list dto.increaseInfoDtos as info>
                <tr>
                    <td width="200">
                        <input type="hidden" name="increaseProductId" class="increaseProductId"
                               value="${info.productId!}"/>
                        <labeld>${info.productName!}</labeld>
                    </td>
                    <td>
                        <input type="hidden" name="inPrice" value="${info.price!}" class="layui-input"/>
                        <labeld class="inPrice">${info.price!}</labeld>
                    </td>
                    <td>
                        <input name="startIncreaseQuantity" class="startIncreaseQuantity" value="${info.quantity!}"
                               type="hidden"/>
                        <input name="inQuantity" id="inQuantity" value="${info.quantity!}" lay-verify="required"
                               class="layui-input"/>
                    </td>
                <#--<td>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal deleteItem" data-id=""
                           value="删除"/>
                </td>-->
                </tr>
            </#list>
            </table>
        </div>
    </div>

<#if infos?? && (infos?index_of("guide") gt -1 || infos?index_of("lead") gt -1)>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">导游/领队列表</label>
        <div class="layui-input-inline">
            <input id="addGuide" type="button" class="layui-btn" value="添加导游/领队">
            &nbsp;
            <input type="checkbox" name="guideShortNote" lay-skin="primary" title="发送短信" value="true"
                   <#if dto.guideShortNote?? && dto.guideShortNote>checked</#if>>
            <hr/>
            <table id="guideTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td>
                        操作
                    </td>
                </tr>
                <#list dto.guideDtos as info>
                    <tr>
                        <td width="200">
                            <input type="hidden" name="guideId" class="guideId"
                                   value="${info.guideId!}"/>${info.guideName!}
                        </td>
                        <td>
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-normal deleteItem" data-id=""
                                   value="删除"/>
                        </td>
                    </tr>
                </#list>
            </table>
        </div>
    </div>
</#if>

<#if infos?? && infos?index_of("car") gt -1>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">车辆列表</label>
        <div class="layui-input-inline">
            <input id="addCar" type="button" class="layui-btn" value="添加车辆">
            <hr/>
            <table id="carTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td>
                        操作
                    </td>
                </tr>
                <#list dto.carDtos as info>
                    <tr>
                        <td width="200">
                            <input type="hidden" name="carId" class="carId"
                                   value="${info.carId!}"/>${info.carName!}
                        </td>
                        <td>
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-normal deleteItem" data-id=""
                                   value="删除"/>
                        </td>
                    </tr>
                </#list>
            </table>
        </div>
    </div>
</#if>

<#if infos?? && infos?index_of("driver") gt -1>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">司机列表</label>
        <div class="layui-input-inline">
            <input id="addDriver" type="button" class="layui-btn" value="添加司机">
            &nbsp;
            <input type="checkbox" name="driverShortNote" lay-skin="primary" value="true" title="发送短信"
                   <#if dto.driverShortNote?? && dto.driverShortNote>checked</#if>>
            <hr/>
            <table id="driverTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td>
                        操作
                    </td>
                </tr>
                <#list dto.driverDtos as info>
                    <tr>
                        <td width="200">
                            <input type="hidden" name="driverId" class="driverId"
                                   value="${info.driverId!}"/>${info.driverName!}
                        </td>
                        <td>
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-normal deleteItem" data-id=""
                                   value="删除"/>
                        </td>
                    </tr>
                </#list>
            </table>
        </div>
    </div>
</#if>


    <div class="layui-form-item">
        <div class="layui-input-block">
            <button id="submit1" class="layui-btn layui-btn-normal" <#--lay-submit="submit"--> lay-filter="submit">立即提交
            </button>
        <#--<button class="layui-btn layui-btn-normal" lay-submit="submit" lay-filter="submit">立即提交</button>-->
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
</body>
<link rel="stylesheet" href="${base}/resources/common/font-awesome-4.7.0/css/font-awesome.min.css"/>
<script type="text/javascript">
    layui.use(['form', 'laydate'], function () {
        var form = layui.form;
        var laydate = layui.laydate;


        form.verify({
            productId: [/[\S]+/, "请选择产品"]
        });

        //提交iframe
        form.on('submit(submit)', function (data) {

            $("#submit").attr("disabled", "disabled");

            var productId = $("input[name='productId']");
            if (productId.length < 1) {
                layer.msg("请选择产品");
                $("#submit").removeAttrs("disabled");
                return false;
            }
            var prices = $("input[name='price']");
            for (var i = 0; i < prices.length; i++) {
                if ($(prices[i]).val() == 0) {
                    layer.msg("存在无价格协议的产品");
                    $("#submit").removeAttrs("disabled");
                    return false;
                }
            }
        <#if infos?? && (infos?index_of("guide") gt -1 || infos?index_of("lead") gt -1)>
            var guideId = $("input[name='guideId']");
            if (guideId.length < 1) {
                layer.msg("请选择导游/领队");
                $("#submit").removeAttrs("disabled");
                return false;
            }
        </#if>
        <#if infos?? && infos?index_of("car") gt -1>
            var carId = $("input[name='carId']");
            if (carId.length < 1) {
                layer.msg("请选择车辆");
                $("#submit").removeAttrs("disabled");
                return false;
            }
        </#if>
        <#if infos?? && infos?index_of("driver") gt -1>
            var driverId = $("input[name='driverId']");
            if (driverId.length < 1) {
                layer.msg("请选择司机");
                $("#submit").removeAttrs("disabled");
                return false;
            }
        </#if>

            //return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
        });
    });
    //添加主产品
    $(document).on("click", "#addProduct", function () {
        var date = $("#date").val();
        var agreementId = $("#agreementId").val();
        /*if (date == "") {
            layer.msg("请先选择时间");
            return;
        }*/
        var index = layer.open({
            type: 2,
            title: '添加产品',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'getProducts?stime=' + date + "&agreementId=" + agreementId
        });
    });
    //添加增值产品
    $(document).on("click", "#addIncreaseProduct", function () {
        var agreementId = $("#agreementId").val();
        /*if (date == "") {
            layer.msg("请先选择时间");
            return;
        }*/
        var index = layer.open({
            type: 2,
            title: '添加产品',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'getIncreaseProducts?agreementId=' + agreementId
        });
    });
    //添加导游/领队
    $(document).on("click", "#addGuide", function () {
        var distributorId = $("#memberId").val();
        var type = "";
    <#if infos?? && infos?index_of("guide") gt -1>
        type = "guide";
    </#if>
    <#if infos?? && infos?index_of("lead") gt -1>
        type = "lead";
    </#if>
    <#if infos?? && infos?index_of("guide") gt -1 && infos?index_of("lead") gt -1>
        type = "";
    </#if>
        var index = layer.open({
            type: 2,
            title: '添加导游/领队',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'getGuide?type=' + type + "&distributorId=" + distributorId
        });
    });
    //添加车辆
    $(document).on("click", "#addCar", function () {
        var distributorId = $("#memberId").val();
        var index = layer.open({
            type: 2,
            title: '添加车辆',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'getCar?distributorId=' + distributorId
        });
    });
    //添加司机
    $(document).on("click", "#addDriver", function () {
        var distributorId = $("#memberId").val();
        var index = layer.open({
            type: 2,
            title: '添加司机',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'getDriver?distributorId=' + distributorId
        });
    });
    // 删除
    $(document).on("click", ".deleteItem", function () {
        var $this = $(this);
        layer.confirm('确定删除吗？', {
            btn: ['确定', '取消'] //按钮
        }, function (index) {
            $this.closest("tr").remove();
            layer.close(index);
        }, function () {
        });
    });
    //获取主产品协议价格
    function queryPolicyList(productId, agreementId, $this) {
        var tr = $this.parents("tr:eq(0)");
        var quantity = $this.val();
        $.ajax({
            url: "getProductPolicyList",
            type: "GET",
            async: false,
            data: {
                productId: productId,
                quantity: quantity,
                agreementId: agreementId
            },
            success: function (json) {
                if (json.length > 0) {
                    var price = tr.find("td:eq(1)").find(".price");
                    price.html(json[0].price);
                    tr.find("td:eq(1)").find("input[name='price']").val(json[0].price);
                } else {
                    var price = tr.find("td:eq(1)").find(".price");
                    tr.find("td:eq(1)").find("input[name='price']").val("0");
                    price.html("无协议价格");
                }
            }
        });
    }
    //获取主产品价格
    $(document).on("blur", "input[name='quantity']", function () {
        var orderStatus = '${dto.orderStatus}';
        var $this = $(this);
        var tr = $(this).parents("tr:eq(0)");
        var productId = tr.find("td:eq(0)").find(".productId").val();
        var agreementId = $("#agreementId").val();
        var startQuantity = tr.find("td:eq(2)").find(".startQuantity").val();
        var surplusTotalStock = tr.find("td:eq(2)").find(".surplusTotalStock").val();
        var upQuantity = $("#upQuantity").val();
        var downQuantity = $("#downQuantity").val();
        //判断库存量
        if (parseInt($this.val()) > (parseInt(surplusTotalStock) + parseInt(startQuantity))) {
            layer.msg("该协议产品库存不足，目前剩余库存为" + surplusTotalStock);
            $(tr.find("td:eq(2)").find("#quantity")).val(startQuantity);
            // tr.find("td:eq(1)").find(".price").html("");
            return;
        }
        //如果是未接单
        if (orderStatus == 'unhaveOrder') {
            queryPolicyList(productId, agreementId, $this);
        } else {
            //上调数量
            if ($this.val() - startQuantity > upQuantity) {
                layer.msg("上调数量超过设置,请重现填写数量");
                $(tr.find("td:eq(2)").find("#quantity")).val(startQuantity);
                return;
            } else if ($this.val() - startQuantity <= upQuantity && $this.val() - startQuantity >= 0) {
                $("#updateProductCount").val(startQuantity - $this.val());
                queryPolicyList(productId, agreementId, $this);
            }
            //下调数量
            if (startQuantity - $this.val() > downQuantity) {
                layer.msg("下调数量超过设置,请重现填写数量");
                $(tr.find("td:eq(2)").find("#quantity")).val(startQuantity);
                return;
            } else if (startQuantity - $this.val() <= downQuantity && startQuantity - $this.val() >= 0) {
                $("#updateProductCount").val(startQuantity - $this.val());
                queryPolicyList(productId, agreementId, $this);
            }
        }
    });
    //获取增值产品协议
    function increasePrice(increaseProductId, agreementId, $this) {
        var inQuantity = $this.val();
        var tr = $this.parents("tr:eq(0)");
        $.ajax({
            url: "getIncreaseProductPolicyList",
            type: "POST",
            async: false,
            data: {increaseProductId: increaseProductId, inQuantity: inQuantity, agreementId: agreementId},
            success: function (json) {
                var inPrice = tr.find("td:eq(1)").find(".inPrice");
                inPrice.html(json[0].inPrice);
                tr.find("td:eq(1)").find("input[name='inPrice']").val(json[0].inPrice);
            }
        });

    }
    //获取增值产品价格
    $(document).on("blur", "input[name='inQuantity']", function () {
        var orderStatus = '${dto.orderStatus}';
        var $this = $(this);
        var tr = $(this).parents("tr:eq(0)");
        var increaseProductId = tr.find("td:eq(0)").find(".increaseProductId").val();
        var agreementId = $("#agreementId").val();
        var startQuantity = tr.find("td:eq(2)").find(".startIncreaseQuantity").val();
        var upQuantity = $("#increaseUpQuantity").val();
        var downQuantity = $("#increaseDownQuantity").val();
        if (orderStatus == 'unhaveOrder') {
            increasePrice(increaseProductId, agreementId, $this);
        } else {
            //上调数量
            if ($this.val() - startQuantity > upQuantity) {
                layer.msg("上调数量超过设置,请重现填写数量");
                $(tr.find("td:eq(2)").find("#inQuantity")).val(startQuantity);
                return;
            } else if ($this.val() - startQuantity <= upQuantity && $this.val() - startQuantity >= 0) {
                increasePrice(increaseProductId, agreementId, $this);
            }
            //下调数量
            if (startQuantity - $this.val() > downQuantity) {
                layer.msg("下调数量超过设置,请重现填写数量");
                $(tr.find("td:eq(2)").find("#inQuantity")).val(startQuantity);
                return;
            } else if (startQuantity - $this.val() <= downQuantity && startQuantity - $this.val() >= 0) {
                increasePrice(increaseProductId, agreementId, $this);
            }
        }
    });


</script>
</html>