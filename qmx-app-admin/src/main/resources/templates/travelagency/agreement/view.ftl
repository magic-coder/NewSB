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
        <#--<div class="layui-input-inline">
            <button id="travelagencyBtn" type="button" class="layui-btn">
                选择
            </button>
        </div>-->
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">协议开始时间</label>
            <div class="layui-input-inline">
            <#--<input id="sdate" name="sdate" value="${dto.sdate!}" lay-verify="required" autocomplete="off"
                   class="layui-input">-->
                <div id="travelagencyName" class="layui-form-mid">${dto.sdate!}</div>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">协议结束时间</label>
            <div class="layui-input-inline">
            <#--<input id="edate" name="edate" value="${dto.edate!}" lay-verify="required" autocomplete="off"
                   class="layui-input">-->
                <div id="travelagencyName" class="layui-form-mid">${dto.edate!}</div>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">协议编号</label>
            <div class="layui-input-inline">
                <div id="travelagencyName" class="layui-form-mid">${dto.sn!}</div>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">协议名称</label>
            <div class="layui-input-inline">
                <div id="travelagencyName" class="layui-form-mid">${dto.name!}</div>
            </div>
        </div>
    </div>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">产品列表</label>
        <div class="layui-input-inline">
        <#--<input id="addProduct" type="button" class="layui-btn" value="添加主产品">-->
        <#--<label style="color: red;">添加产品后，需设置价格政策才会保存产品信息</label>-->
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
                    <#--<input class="layui-btn layui-btn-sm layui-btn-normal deleteItem"
                           data-id="${product.productId!}"
                           value="删除" type="button">-->
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
                           style="width:50px;" value="${dto.updateNumber!}" disabled>
                </div>
                <div class="layui-form-mid">次，每次修改上调数量</div>
                <div class="layui-input-inline" style="width:auto;">
                    <input name="upQuantity" lay-verify="required|positiveInteger" autocomplete="off"
                           class="layui-input"
                           style="width:50px;" value="${dto.upQuantity!}" disabled>
                </div>
                <div class="layui-form-mid">减少数量</div>
                <div class="layui-input-inline" style="width:auto;">
                    <input name="downQuantity" lay-verify="required|positiveInteger" autocomplete="off"
                           class="layui-input"
                           style="width:50px;" value="${dto.downQuantity!}" disabled>
                </div>
            </div>
            <br/>
            <div class="layui-inline">
                <label class="layui-form-label">订单退款规则</label>
                <div class="layui-input-inline" style="width:auto;">
                    <div class="layui-form-mid">接单前默认退款不收手续费、接单后</div>
                    <div class="layui-input-inline" style="width:auto;">
                        <select name="refunds" style="width:auto;" lay-filter="refunds" disabled>
                            <option value="true" <#if dto.refunds?? && dto.refunds>selected</#if>>可退款</option>
                            <option value="false" <#if dto.refunds?? && !dto.refunds>selected</#if>>不可退款</option>
                        </select>
                    </div>
                    <div class="layui-form-mid">退款手续费为订单金额的</div>
                    <div class="layui-input-inline" style="width:auto;">
                        <input name="productNumber" id="number"
                               <#if dto.refunds?? && dto.refunds>lay-verify="required|number"</#if> autocomplete="off"
                               class="layui-input" style="width:50px;" value="${dto.productNumber!}" disabled>
                    </div>
                    <div class="layui-form-mid">%</div>
                </div>
            </div>
            <br/>
        <#--<input id="addIncreaseProduct" type="button" class="layui-btn" value="添加增值产品">-->
            <hr/>
            <table id="increaseProductTable" width="50%" class="layui-table">
                <tr>
                    <td width="200">
                        增值产品名称
                    </td>
                    <td width="100">
                        结算价
                    </td>
                <#--<td>
                    操作
                </td>-->
                </tr>
            <#list increaseProducts as increaseProduct>
                <tr>
                    <td>
                    ${increaseProduct.productName!}
                    </td>
                    <td>
                        <input autocomplete="off" lay-verify="number" name="ipPrice" value="${increaseProduct.price!}"
                               id="ipPrice" class="layui-input" disabled>
                    </td>
                <#--<td>
                &lt;#&ndash;<input class="layui-btn layui-btn-sm layui-btn-normal increaseProductPolicy"
                       data-id="${increaseProduct.productId!}" value="价格设置" type="button">&ndash;&gt;

                &lt;#&ndash;<input class="layui-btn layui-btn-sm layui-btn-normal increaseDeleteItem"
                       data-id="${increaseProduct.productId!}"
                       value="删除" type="button">&ndash;&gt;
                    <div id="ip${increaseProduct.productId!}" style="display: none;">
                        <table>
                            <tr>
                                <input type="hidden" name="ppid" value="${increaseProduct.id!}"/>
                                <input type="hidden" name="ipProductId" value="${increaseProduct.productId!}"/>
                            &lt;#&ndash;<input type="text" name="ipPrice" value="${increaseProduct.price!}"/>&ndash;&gt;
                            </tr>
                        </table>
                    </div>
                    <input id="jsonip${increaseProduct.productId!}" type="hidden"
                           value='${increaseProduct.increasePolicyJson!}' style="width: 400px;">
                </td>-->
                </tr>
            </#list>
            </table>
            <label class="layui-form-label">订单修改规则</label>
            <div class="layui-input-inline" style="width:auto;">
                <div class="layui-form-mid">到场前</div>
                <div class="layui-input-inline" style="width:auto;">
                    <select name="increaseHour" lay-verify="required" disabled>
                    <#list 0..72 as a>
                        <option value="${a}" <#if '${a}'=='${dto.increaseHour!}'>selected</#if>>${a}</option>
                    </#list>
                    </select>
                </div>
                <div class="layui-form-mid">小时支持上调数量</div>
                <div class="layui-input-inline" style="width:auto;">
                    <input name="increaseUpQuantity" lay-verify="required|positiveInteger" autocomplete="off"
                           class="layui-input"
                           style="width:50px;" value="${dto.increaseUpQuantity!}" disabled>
                </div>
                <div class="layui-form-mid">减少数量</div>
                <div class="layui-input-inline" style="width:auto;">
                    <input name="increaseDownQuantity" lay-verify="required|positiveInteger" autocomplete="off"
                           class="layui-input"
                           style="width:50px;" value="${dto.increaseDownQuantity!}" disabled>
                </div>
            </div>
            <br/>
            <div class="layui-input-inline" style="width:auto;">
                <label class="layui-form-label">订单退款规则</label>
                <div class="layui-form-mid">接单后</div>
                <div class="layui-input-inline" style="width:auto;">
                    <select name="retreat" style="width:auto;" lay-filter="retreat" disabled>
                        <option value="true" <#if dto.retreat?? && dto.retreat>selected</#if>>可退款</option>
                        <option value="false" <#if dto.retreat?? && !dto.retreat>selected</#if>>不可退款</option>
                    </select>
                </div>
                <div class="layui-form-mid">退款手续费为订单金额的</div>
                <div class="layui-input-inline" style="width:auto;">
                    <input name="increaseNumber" id="increaseNumber"
                           <#if dto.retreat?? && dto.retreat>lay-verify="required"</#if>
                           autocomplete="off" class="layui-input" style="width:50px;" value="${dto.increaseNumber!}"
                           disabled>
                </div>
                <div class="layui-form-mid">%</div>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">付款类型</label>
            <div class="layui-input-inline" style="width:auto;">
            <#-- <input name="payType" lay-filter="payType" title="挂账" type="radio" value="0"
                    <#if !dto.payType>checked</#if>>
             <input name="payType" lay-filter="payType" title="常规" type="radio" value="1"
                    <#if dto.payType>checked</#if>>-->
                <div class="layui-form-mid"><#if dto.payType>常规<#elseif !dto.payType>挂账</#if></div>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">付款方式</label>
            <div class="layui-input-inline" style="width:auto;">
                <input name="payWay" lay-skin="primary" title="微信支付" type="checkbox"
                       value="WX_NATIVE" <#if '${dto.payWay!}'?contains('WX_NATIVE')>checked</#if> disabled>
                <input name="payWay" lay-skin="primary" title="支付宝支付" type="checkbox" value="ALIPAY_QR"
                       <#if '${dto.payWay!}'?contains('ALIPAY_QR')>checked</#if> disabled>
            <#--<div class="layui-form-mid"></div>-->
            </div>
        </div>
    </div>
    <div class="layui-form-item" id="deposit" <#if !dto.payType>style="display: none"</#if>>
        <div class="layui-inline">
            <label class="layui-form-label">主产品定金收取比例</label>
            <div class="layui-input-inline">
            <#--<input name="deposit" id="primaryDeposit" lay-verify="required|number" autocomplete="off"
                   class="layui-input"
                   value="${dto.deposit!}">-->
                <div class="layui-form-mid">${dto.deposit!}</div>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">增值产品定金收取比例</label>
            <div class="layui-input-inline">
            <#--<input name="increaseDeposit" id="increaseDeposit" lay-verify="required|number" autocomplete="off"
                   class="layui-input"
                   value="${dto.increaseDeposit!}">-->
                <div class="layui-form-mid">${dto.increaseDeposit!}</div>
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
                       type="checkbox" disabled>
            </#list>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
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
</script>
</html>