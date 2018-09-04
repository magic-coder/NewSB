<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.jqprint.js"></script>
    <style>
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" id="orderFrom" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <input type="hidden" name="updateProductCount" id="updateProductCount" value="0"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item layui-form-text">
    <#--<div class="layui-inline">
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
    </div>-->
        <label class="layui-form-label">客户信息</label>
        <div class="layui-input-inline">
            <table class="layui-table">
                <tr>
                    <th>旅行社</th>
                    <th>联系人</th>
                    <th>联系电话</th>
                    <th>关联分销商账号</th>
                    <th>关联客户经理</th>
                </tr>
                <tr>
                    <td>${travelAgencyDto.name!}</td>
                    <td>${travelAgencyDto.contactsName!}</td>
                    <td>${travelAgencyDto.contactsMobile!}</td>
                    <td>${travelAgencyDto.userName!}</td>
                    <td>${travelAgencyDto.managerName!}</td>
                </tr>
            </table>
        </div>
    </div>


    <div class="layui-form-item layui-form-text">
    <#--<div class="layui-inline">

            <label class="layui-form-label">订单状态</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${dto.orderStatus.title!}</div>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">支付状态</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${dto.taPaymentStatus.title!}</div>
            </div>
        </div>
        <label class="layui-form-label">退款状态</label>
        <div class="layui-input-inline">
            <div class="layui-form-mid">${dto.refundStatus.title!}</div>
        </div>-->
        <label class="layui-form-label">订单状态</label>
        <div class="layui-input-inline">
            <table class="layui-table">
                <tr>
                    <th>支付状态</th>
                    <th>短信通知状态</th>
                    <th>接单状态</th>
                    <th>修改状态</th>
                    <th>退款状态</th>
                    <th>消费状态</th>
                    <th>同步状态</th>
                </tr>
                <tr>
                    <td>${dto.taPaymentStatus.title!}</td>
                    <td>${dto.noteSendStatus.title!}</td>
                    <td>${dto.orderStatus.title!}</td>
                    <td>${dto.checkStatus.title!}</td>
                    <td>${dto.refundStatus.title!}</td>
                    <td><#if dto.ticketStatus||dto.checkTicketStatus>已消费<#else>未消费</#if></td>
                    <td><#if dto.syncStatus>已同步<#else>未同步</#if></td>
                </tr>
            </table>
        </div>
    </div>
    <div class="layui-form-item layui-form-text">

    <#--<div class="layui-inline">
        <label class="layui-form-label">总金额</label>
        <div class="layui-input-inline">
            <div class="layui-form-mid">${dto.totalAmount!}</div>
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">定金</label>
        <div class="layui-input-inline">
            <div class="layui-form-mid">${dto.deposit!}</div>
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">已付金额</label>
        <div class="layui-input-inline">
            <div class="layui-form-mid">${dto.amountPaid!}</div>
        </div>
    </div>-->
        <label class="layui-form-label">订单时间</label>
        <div class="layui-input-inline">
            <table class="layui-table">
                <tr>
                    <th>预约游玩日期</th>
                    <th>下单时间</th>
                    <th>消费时间</th>
                    <th>退款时间</th>
                </tr>
                <tr>
                    <td>${dto.date!}</td>
                    <td>${dto.createTime!?string("yyyy-MM-dd HH:mm:ss")}</td>
                    <td><#if dto.consumeTime??>${dto.consumeTime!}<#else>/</#if></td>
                    <td><#if dto.refundTime??>${dto.refundTime!?string("yyyy-MM-dd HH:mm:ss")}<#else>/</#if></td>
                </tr>
            </table>
        </div>
    </div>
    <div class="layui-form-item layui-form-text">
    <#--<div class="layui-inline">
        <label class="layui-form-label">定金支付方式</label>
        <div class="layui-input-inline">
            <div class="layui-form-mid"><#if dto.depositPayType??&&dto.depositPayType=='WX_NATIVE'>
                微信支付<#elseif dto.depositPayType??&&dto.depositPayType=='ALIPAY_QR'>支付宝支付<#else>
                /</#if></div>
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">尾款支付方式</label>
        <div class="layui-input-inline">
            <div class="layui-form-mid"><#if dto.finalPayType??&&types?seq_contains('${dto.finalPayType}')>
                <#list types as type><#if type==dto.finalPayType>${type.title!}</#if></#list>
            <#elseif dto.finalPayType??&&dto.finalPayType=='ALIPAY_QR'>支付宝支付
            <#elseif dto.finalPayType??&&dto.finalPayType=='WX_NATIVE'>微信支付
            <#else>/</#if></div>
        </div>
    </div>-->
        <label class="layui-form-label">费用信息</label>
        <div class="layui-input-inline">
            <table class="layui-table">
                <tr>
                    <th>订单总金额</th>
                    <th>定金</th>
                    <th>定金支付方式</th>
                    <th>尾款</th>
                    <th>尾款支付方式</th>
                </tr>
                <tr>
                    <td>${dto.totalAmount!}</td>
                    <td>${dto.deposit!}</td>
                    <td>
                    <#if dto.depositPayType??>
                        <#if dto.depositPayType=='WX_NATIVE'>微信支付
                        <#elseif dto.depositPayType=='ALIPAY_QR'>支付宝支付
                        <#elseif dto.depositPayType=='DEPOSIT'>预存款支付
                        </#if>
                    <#else>/
                    </#if>
                    </td>
                    <td>${dto.totalAmount-dto.deposit}</td>
                    <td>
                    <#if dto.finalPayType??>
                        <#if types?seq_contains(dto.finalPayType)>
                            <#list types as type>
                                <#if type==dto.finalPayType>${type.title!}</#if>
                            </#list>
                        <#elseif lineTypes?seq_contains(dto.finalPayType)>
                            <#list lineTypes as type>
                                <#if type==dto.finalPayType>${type.title!}</#if>
                            </#list>
                        <#else>/
                        </#if>
                    <#else>/
                    </#if>
                    </td>
                </tr>
            </table>
        </div>
    </div>
<#--<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label">游玩日期</label>
        <div class="layui-input-inline">
            <div class="layui-form-mid">${dto.date!}</div>
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">下单人</label>
        <div class="layui-input-inline">
            <div class="layui-form-mid">${dto.createName!}</div>
        </div>
    </div>
</div>-->
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">产品信息</label>
        <div class="layui-input-inline">
            <input type="hidden" name="agreementId" id="agreementId" value="${agreementDto.id!}"/>
            <input type="hidden" id="memberId" name="memberId" value="${agreementDto.travelagencyId!?c}"/>
            <input type="hidden" value="${agreementDto.upQuantity!}" id="upQuantity"/>
            <input type="hidden" value="${agreementDto.downQuantity!}" id="downQuantity"/>
            <input type="hidden" value="${agreementDto.increaseUpQuantity!}" id="increaseUpQuantity"/>
            <input type="hidden" value="${agreementDto.increaseDownQuantity!}" id="increaseDownQuantity"/>
        <#--<input id="addProduct" type="button" class="layui-btn" value="添加主产品">-->
        <#--<label style="color: red;">订单需收取${agreementDto.deposit}%的定金</label>-->
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
                    <td>
                        总价格
                    </td>
                    <td>
                        绩效方式
                    </td>
                    <td>
                        绩效金额
                    </td>
                <#--<td>
                    操作
                </td>-->
                </tr>
            <#list dto.infoDtos as info>
                <tr>
                    <td width="200">
                    ${info.productName!}
                    </td>
                    <td>
                    ${info.price!}
                    </td>
                    <td>
                    ${info.quantity!}
                    </td>
                    <td>
                    ${info.price*info.quantity}
                    </td>
                    <td>
                        <#if info.achievementsInfoDto.type??>
                        ${info.achievementsInfoDto.type!}
                        <#else >/
                        </#if>
                    </td>
                    <td>
                        <#if info.achievementsInfoDto.amount??>
                        ${info.achievementsInfoDto.amount!}
                        <#else >/
                        </#if>
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
        <#--<label style="color: red;">订单需收取${agreementDto.increaseDeposit!}%的定金</label>-->
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
                    <td>
                        总价格
                    </td>
                <#--<td>
                    操作
                </td>-->
                </tr>
            <#list dto.increaseInfoDtos as info>
                <tr>
                    <td width="200">
                    ${info.productName!}
                    </td>
                    <td>
                    ${info.price!}
                    </td>
                    <td>
                    ${info.quantity!}
                    </td>
                    <td>
                    ${info.quantity*info.price}
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
    <div class="layui-form-item layui-form-text" id="guide">
        <label class="layui-form-label">导游/领队列表</label>
        <div class="layui-input-inline">
        <#--<input id="addGuide" type="button" class="layui-btn" value="添加导游/领队">-->
            &nbsp;
        <#--<input type="checkbox" name="guideShortNote" lay-skin="primary" title="发送短信" value="true"
               <#if dto.guideShortNote?? && dto.guideShortNote>checked</#if>>-->
            <hr/>
            <table id="guideTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        导游/领队名称
                    </td>
                </tr>
                <#list dto.guideDtos as info>
                    <tr>
                        <td width="200">
                            <input type="hidden" name="guideId" class="guideId"
                                   value="${info.guideId!}"/>${info.guideName!}
                        </td>
                    </tr>
                </#list>
            </table>
        </div>
    </div>
</#if>

<#if infos?? && infos?index_of("car") gt -1>
    <div class="layui-form-item layui-form-text" id="car">
        <label class="layui-form-label">车辆列表</label>
        <div class="layui-input-inline">
        <#--<input id="addCar" type="button" class="layui-btn" value="添加车辆">-->
            <hr/>
            <table id="carTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        车牌号
                    </td>
                <#--<td>
                    操作
                </td>-->
                </tr>
                <#list dto.carDtos as info>
                    <tr>
                        <td width="200">
                            <input type="hidden" name="carId" class="carId"
                                   value="${info.carId!}"/>${info.carName!}
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
</#if>

<#if infos?? && infos?index_of("driver") gt -1>
    <div class="layui-form-item layui-form-text" id="driver">
        <label class="layui-form-label">司机列表</label>
        <div class="layui-input-inline">
        <#--<input id="addDriver" type="button" class="layui-btn" value="添加司机">-->
            &nbsp;
        <#--<input type="checkbox" name="driverShortNote" lay-skin="primary" value="true" title="发送短信"
               <#if dto.driverShortNote?? && dto.driverShortNote>checked</#if>>-->
            <table id="driverTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        司机名称
                    </td>
                <#--<td>
                    操作
                </td>-->
                </tr>
                <#list dto.driverDtos as info>
                    <tr>
                        <td width="200">
                            <input type="hidden" name="driverId" class="driverId"
                                   value="${info.driverId!}"/>${info.driverName!}
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
</#if>
</form>
<div class="layui-form-item">
    <div class="layui-input-block">
        <input type="button" onclick="orderPrint()"
               class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="print" value="打印当前页"/>
        <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" id="back" value="返回"/>
    </div>
</div>
</body>
<script>
    layui.use(['form', 'laydate'], function () {
        var form = layui.form;
        var laydate = layui.laydate;

        form.verify({
            productId: [/[\S]+/, "请选择产品"]
        });

        form.on('submit(submit)', function (data) {
            var productId = $("input[name='productId']");
            if (productId.length < 1) {
                layer.msg("请选择产品");
                return false;
            }
            var prices = $("input[name='price']");
            for (var i = 0; i < prices.length; i++) {
                if ($(prices[i]).val() == 0) {
                    layer.msg("存在无价格协议的产品");
                    return false;
                }
            }
        <#if infos?? && (infos?index_of("guide") gt -1 || infos?index_of("lead") gt -1)>
            var guideId = $("input[name='guideId']");
            if (guideId.length < 1) {
                layer.msg("请选择导游/领队");
                return false;
            }
        </#if>
        <#if infos?? && infos?index_of("car") gt -1>
            var carId = $("input[name='carId']");
            if (carId.length < 1) {
                layer.msg("请选择车辆");
                return false;
            }
        </#if>
        <#if infos?? && infos?index_of("driver") gt -1>
            var driverId = $("input[name='driverId']");
            if (driverId.length < 1) {
                layer.msg("请选择司机");
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

    //获取主产品价格
    $(document).on("blur", "input[name='quantity']", function () {
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
        //上调数量
        if ($this.val() - startQuantity > upQuantity) {
            layer.msg("上调数量超过设置,请重现填写数量");
            $(tr.find("td:eq(2)").find("#quantity")).val(startQuantity);
            return;
        } else if ($this.val() - startQuantity <= upQuantity && $this.val() - startQuantity >= 0) {
            $("#updateProductCount").val(startQuantity - $this.val());
            $.ajax({
                url: "getProductPolicyList",
                type: "POST",
                data: {
                    productId: productId,
                    quantity: $this.val(),
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
        //下调数量
        if (startQuantity - $this.val() > downQuantity) {
            layer.msg("下调数量超过设置,请重现填写数量");
            $(tr.find("td:eq(2)").find("#quantity")).val(startQuantity);
            return;
        } else if (startQuantity - $this.val() <= downQuantity && startQuantity - $this.val() >= 0) {
            $("#updateProductCount").val(startQuantity - $this.val());
            $.ajax({
                url: "getProductPolicyList",
                type: "POST",
                data: {
                    productId: productId,
                    quantity: $this.val(),
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
    });
    //获取增值产品价格
    $(document).on("blur", "input[name='inQuantity']", function () {
        var $this = $(this);
        var tr = $(this).parents("tr:eq(0)");
        var increaseProductId = tr.find("td:eq(0)").find(".increaseProductId").val();
        var agreementId = $("#agreementId").val();
        var startQuantity = tr.find("td:eq(2)").find(".startIncreaseQuantity").val();
        var upQuantity = $("#increaseUpQuantity").val();
        var downQuantity = $("#increaseDownQuantity").val();
        //上调数量
        if ($this.val() - startQuantity > upQuantity) {
            layer.msg("上调数量超过设置,请重现填写数量");
            $(tr.find("td:eq(2)").find("#inQuantity")).val(startQuantity);
            return;
        } else if ($this.val() - startQuantity <= upQuantity && $this.val() - startQuantity >= 0) {
            $.ajax({
                url: "getIncreaseProductPolicyList",
                type: "POST",
                data: {increaseProductId: increaseProductId, inQuantity: $this.val(), agreementId: agreementId},
                success: function (json) {
                    var inPrice = tr.find("td:eq(1)").find(".inPrice");
                    inPrice.html(json[0].inPrice);
                    tr.find("td:eq(1)").find("input[name='inPrice']").val(json[0].inPrice);

                }
            });
        }
        //下调数量
        if (startQuantity - $this.val() > downQuantity) {
            layer.msg("下调数量超过设置,请重现填写数量");
            $(tr.find("td:eq(2)").find("#inQuantity")).val(startQuantity);
            return;
        } else if (startQuantity - $this.val() <= downQuantity && startQuantity - $this.val() >= 0) {
            $.ajax({
                url: "getIncreaseProductPolicyList",
                type: "POST",
                data: {increaseProductId: increaseProductId, inQuantity: $this.val(), agreementId: agreementId},
                success: function (json) {
                    var inPrice = tr.find("td:eq(1)").find(".inPrice");
                    inPrice.html(json[0].inPrice);
                    tr.find("td:eq(1)").find("input[name='inPrice']").val(json[0].inPrice);
                }
            });
        }
    });
</script>
<script language="javascript">
    function orderPrint() {
        $("#orderFrom").jqprint({
            debug: false,//如果是true则可以显示iframe查看效果（iframe默认高和宽都很小，可以再源码中调大），默认是false
            importCSS: true, //true表示引进原来的页面的css，默认是true。（如果是true，先会找$("link[media=print]")，若没有会去找$("link")中的css文件）
            printContainer: true, //表示如果原来选择的对象必须被纳入打印（注意：设置为false可能会打破你的CSS规则）。
            operaSupport: true //表示如果插件也必须支持歌opera浏览器，在这种情况下，它提供了建立一个临时的打印选项卡。默认是true
        });
    }
</script>
</html>