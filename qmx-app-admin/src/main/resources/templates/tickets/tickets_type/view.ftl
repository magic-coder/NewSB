[#assign shiro=JspTaglibs["/WEB-INF/tld/shiro.tld"] /]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>查看商品</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/ext.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/product.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropdown.js"></script>
<script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropqtable.js"></script>
<script type="text/javascript" src="${base}/resources/admin/editor/kindeditor.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/json2.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/ajaxupload.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/image.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $productCategoryId = $("#productCategoryId");
	var $isMemberPrice = $("#isMemberPrice");
	var $memberPriceTr = $("#memberPriceTr");
	var $memberPrice = $("#memberPriceTr input");
	var $browserButton = $("#browserButton");
	var $productImageTable = $("#productImageTable");
	var $addProductImage = $("#addProductImage");
	var $deleteProductImage = $("a.deleteProductImage");
	var $parameterTable = $("#parameterTable");
	var $attributeTable = $("#attributeTable");
	var $specificationProductTable = $("#specificationProductTable");
	var $addSpecificationProduct = $("#addSpecificationProduct");
	var $deleteSpecificationProduct = $("a.deleteSpecificationProduct");
	var productImageIndex = ${(product.productImages?size)!"0"};
	
	[@flash_message /]
	
	$("input:radio,input:checkbox").change(function(){
		$("input[name='"+$(this).attr("name")+"']:checked").each(function(){
			$($(this).attr("dest")).attr("disabled", false);
		});
		$("input[name='"+$(this).attr("name")+"']").not(":checked").each(function(){
			$($(this).attr("dest")).attr("disabled", true);
		});
	});
	
	$("input:radio,input:checkbox").trigger("change");
	
});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			查看商品
	    </div>
	</div>
		<input type="hidden" id="datePriceData" name="datePriceData" value='${product.datePriceData}' />
		<ul id="tab" class="tab">
			<li>
				<input type="button" value="基本信息" onclick="location.href='#jbxx';" />
			</li>
			<li>
				<input type="button" value="预定设置" onclick="location.href='#ydsz';" />
			</li>
			<li>
				<input type="button" value="入园设置" onclick="location.href='#rysz';" />
			</li>
			<li>
				<input type="button" value="价格库存" onclick="location.href='#jgkc';" />
			</li>
			<li>
				<input type="button" value="退款信息" onclick="location.href='#tkxx';" />
			</li>
			<li>
				<input type="button" value="产品说明" onclick="location.href='#cpsm';" />
			</li>
		</ul>
		<table class="input ">
			<tr id="jbxx">
				<td style="text-align: right; padding-right: 10px;">
					<strong>基本信息:</strong>
				</td>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>产品名称:
				</th>
				<td>
					${product.name}
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>目的地:
				</th>
				<td>
					${product.company.name}
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>供应商:
				</th>
				<td>
					${product.supplier.username}
				</td>
			</tr>
			<tr>
				<th>
					供应商授权:
				</th>
				<td>
					<label>
						<input type="checkbox" name="supplierAuth" value="true"[#if product.supplierAuth] checked="checked"[/#if] />
						允许供应商授权
					</label>
				</td>
			</tr>
			[#--
			<tr>
				<th>
					${message("Product.image")}:
				</th>
				<td>
					<div class="productImageArea">
						<div class="example"></div>
						<a class="prev browse" href="javascript:void(0);" hidefocus="true"></a>
						<div class="scrollable">
							<ul class="items">
								[#list product.productImages as productImage]
									<li>
										<div class="productImageBox">
											<div class="productImagePreview png">
												<img src="${(productImage.source)!}" />
											</div>
										</div>
									</li>
								[/#list]
							</ul>
						</div>
						<a class="next browse" href="javascript:void(0);" hidefocus="true"></a>
						<div class="blank"></div>
					</div>
				</td>
			</tr>
			--]
			<tr>
				<th>
					预定电话:
				</th>
				<td>
					${product.company.orderPhone}
				</td>
			</tr>
			<tr>
				<th>
					咨询电话:
				</th>
				<td>
					${product.company.consultPhone}
				</td>
			</tr>
			<tr id="ydsz">
				<td style="text-align: right; padding-right: 10px;">
					<strong>预定设置:</strong>
				</td>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>支付方式:
				</th>
				<td>
					[#if 'PREPAY'==product.paymentType]
					在线支付（预付）
					[#else]
					到店支付（现付）
					[/#if]
				</td>
			</tr>
			<tr>
				<th>
					订单取消设置:
				</th>
				<td>
					${product.autoCancelTime!120} 分钟后不支付自动取消 <span class="tips">默认2×60，最短5分钟，最大值不可超过21600分钟</span>
				</td>
			</tr>
			<tr>
				<th>
					联系人信息:
				</th>
				<td>
					<label><input type="hidden" name="needContactInfo" value="phone" /><input type="checkbox" name="needContactInfo" value="phone" checked disabled /> 手机号</label>
					<label><input type="hidden" name="needContactInfo" value="name" /><input type="checkbox" name="needContactInfo" value="name" checked disabled /> 姓名</label>
					<label><input type="checkbox" name="needContactInfo"[#if product.needContactInfo?index_of('pinyin') > -1] checked[/#if] value="pinyin" /> 拼音</label>
					<label><input type="checkbox" name="needContactInfo"[#if product.needContactInfo?index_of('email') > -1] checked[/#if] value="email" /> Email</label>
					<label><input type="checkbox" name="needContactInfo"[#if product.needContactInfo?index_of('postal') > -1] checked[/#if] value="postal" /> 地址/邮编</label>
				</td>
			</tr>
			<tr>
				<th>
					<input type="checkbox" name="needPassengerInfoCheck" dest="input[name=passengerInfoPerNum],input[name=needPassengerInfo],input[name=needPassengerInfoOther_Check],#passengerInfoPerNumInput"[#if product.passengerInfoPerNum && product.passengerInfoPerNum gt 0] checked[/#if] /> 客人信息:
				</th>
				<td class="needPassengerInfoCheckTd">
					<label><input type="radio" name="passengerInfoPerNum" value="1" checked[#if product.passengerInfoPerNum == 1] checked[/#if] disabled />需要每个客人的信息</label>
					<label><input id="passengerInfoPerNum" type="radio" name="passengerInfoPerNum" dest="#passengerInfoPerNumInput"[#if product.passengerInfoPerNum gt 1 && product.passengerInfoPerNum lt 9999] checked[/#if] value="${product.passengerInfoPerNum}" disabled />每 <input id="passengerInfoPerNumInput" type="text" class="text digits required" value="[#if product.passengerInfoPerNum gt 1 && product.passengerInfoPerNum lt 9999]${product.passengerInfoPerNum}[#else]0[/#if]" style="width: 80px;" disabled /> 个客人共享一个客人信息</label>
					<label><input type="radio" name="passengerInfoPerNum" value="9999"[#if product.passengerInfoPerNum gte 9999] checked[/#if] disabled />仅需要一位客人信息</label>
					<br/>
					<div style="background: #f5f5f5; margin: 5px; padding: 5px;">
						<label><input type="checkbox" name="needPassengerInfo" value="name"[#if product.needPassengerInfo?index_of('name') > -1] checked[/#if] disabled /> 姓名</label>
						<label><input type="checkbox" name="needPassengerInfo" value="pinyin"[#if product.needPassengerInfo?index_of('pinyin') > -1] checked[/#if] disabled /> 拼音</label>
						<br/>
						<label><input type="checkbox" name="needPassengerInfo" value="Idcard"[#if product.needPassengerInfo?index_of('Idcard') > -1] checked[/#if] disabled /> 身份证</label>
						<label><input type="checkbox" name="needPassengerInfo" value="Passport"[#if product.needPassengerInfo?index_of('Passport') > -1] checked[/#if] disabled /> 护照</label>
						<label><input type="checkbox" name="needPassengerInfo" value="TaiwanPermit"[#if product.needPassengerInfo?index_of('TaiwanPermit') > -1] checked[/#if] disabled /> 台胞证</label>
						<label><input type="checkbox" name="needPassengerInfo" value="HKAndMacauPermit"[#if product.needPassengerInfo?index_of('HKAndMacauPermit') > -1] checked[/#if] disabled /> 港澳通行证</label>
						<span class="tips">若勾选多个，客人只需填写一个</span>
						<br/>
						<label><input type="checkbox" name="needPassengerInfoOther_Check" dest="input[name=needPassengerInfoOther1]"[#if product.needPassengerInfoOther1] checked[/#if] disabled /><input type="text" name="needPassengerInfoOther1" class="text digits required" placeholder="其他1" value="${product.needPassengerInfoOther1}" style="width: 80px;" disabled /></label>
						<label><input type="checkbox" name="needPassengerInfoOther_Check" dest="input[name=needPassengerInfoOther2]"[#if product.needPassengerInfoOther2] checked[/#if] disabled /><input type="text" name="needPassengerInfoOther2" class="text digits required" placeholder="其他2" value="${product.needPassengerInfoOther2}" style="width: 80px;" disabled /></label>
						<span class="tips">您可以自定义客人信息，如航班号等</span>
					</div>
				</td>
			</tr>
			<tr>
				<th>
					预订时间限制:
				</th>
				<td>
					<label>
						<input type="radio" name="enterSightLimitType" class="required" value="NO_LIMIT" checked [#if product.enterSightLimitType=='NO_LIMIT'] checked[/#if]/>
						无预订时间限制
					</label><br/>
					<label>
						<input type="radio" name="enterSightLimitType" dest="input[id=ADVANCE_BOOK_TIME]" class="required" value="ADVANCE_BOOK_TIME"[#if product.enterSightLimitType=='ADVANCE_BOOK_TIME'] checked[/#if]/>
						提前 <input id="ADVANCE_BOOK_TIME" type="text" name="enterSightAdvanceDay" class="text digits required" value="${product.enterSightAdvanceDay!0}" style="width: 30px;" disabled/> 天的 <input id="ADVANCE_BOOK_TIME" type="text" name="enterSightAdvanceHour" class="text" value="${product.enterSightAdvanceHour!'0'}" style="width: 30px;" disabled/> : <input id="ADVANCE_BOOK_TIME" type="text" name="enterSightAdvanceMinute" class="text digits required" max="59" value="${(product.enterSightAdvanceMinute?string('00'))!'00'}" style="width: 30px;" disabled/> 点之前预定
					</label><br/>
					<label>
						<input type="radio" name="enterSightLimitType" dest="input[id=DELAY_BOOK_HOURS]" class="required" value="DELAY_BOOK_HOURS"[#if product.enterSightLimitType=='DELAY_BOOK_HOURS'] checked[/#if]/>
						预订后 <input id="DELAY_BOOK_HOURS" type="text" name="enterSightDelayBookHour" class="text digits required" value="${product.enterSightDelayBookHour}" style="width: 30px;" disabled/> 小时才能使用
					</label><br/>
				</td>
			</tr>
			<tr>
				<th>
					<input type="checkbox" name="perPhoneMaxNumCheck" dest="input[name=perPhoneMaxNum]"[#if product.perPhoneMaxNum] checked[/#if] /> 手机号预定限制:
				</th>
				<td>
					[#if product.perPhoneMaxNum??]
					同一手机号最多每天预订 <input type="text" name="perPhoneMaxNum" class="text digits required" value="${product.perPhoneMaxNum}" style="width: 80px;" /> 数量
					[#else]
					同一手机号最多每天预订 <input type="text" name="perPhoneMaxNum" class="text digits required" value="${product.perPhoneMaxNum}" style="width: 80px;" disabled /> 数量
					[/#if]
				</td>
			</tr>
			[#--
			<tr>
				<th>
					<input type="checkbox" name="perIdcardMaxNumCheck" dest="input[name=perIdcardMaxNum]"[#if product.perIdcardMaxNum] checked[/#if] /> 身份证号预定限制:
				</th>
				<td>
					[#if product.perIdcardMaxNum]
					同一身份证号最多只能预订 ${product.perIdcardMaxNum} 张门票
					[#else]
					同一身份证号最多只能预订 ${product.perIdcardMaxNum} 张门票
					[/#if]
				</td>
			</tr>
			--]
			<tr>
				<th>
					是否需要预约:
				</th>
				<td>
					[#if product.needReserve]
					是
					[#else]
					否
					[/#if]
				</td>
			</tr>
			<tr id="rysz">
				<td style="text-align: right; padding-right: 10px;">
					<strong>入园设置:</strong>
				</td>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>兑换凭证:
				</th>
				<td>
					<label><input type="radio" class="required" name="exchangeVoucherType" value="SMS"[#if product.exchangeVoucherType=='SMS'] checked[/#if] /> 确认短信</label>
					<label><input type="radio" class="required" name="exchangeVoucherType" value="IDCARD"[#if product.exchangeVoucherType=='IDCARD'] checked[/#if] /> 身份证</label>
					<label><input type="radio" class="required" name="exchangeVoucherType" value="SMS_AND_IDCARD"[#if product.exchangeVoucherType=='SMS_AND_IDCARD'] checked[/#if] /> 短信和身份证</label>
					<label><input type="radio" class="required" name="exchangeVoucherType" value="EMAIL"[#if product.exchangeVoucherType=='EMAIL'] checked[/#if] /> 电子邮件确认单</label>
					[#--<label><input type="radio" class="required" name="exchangeVoucherType" value="ENTITY"[#if product.exchangeVoucherType=='ENTITY'] checked[/#if] /> 供应商寄送的实物</label>--]
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>入园方式:
				</th>
				<td>
					<label><input type="radio" class="required" name="passType" value="VIRTUAL"[#if product.passType=='VIRTUAL'] checked[/#if] /> 凭兑换凭证直接入园</label>
					<label><input type="radio" class="required" name="passType" value="ENTITY"[#if product.passType=='ENTITY'] checked[/#if] /> 凭兑换凭证换票</label>
				</td>
			</tr>
			[#--
			<tr>
				<th>
					<span class="requiredField">*</span>发码时间:
				</th>
				<td>
					<label><input type="radio" class="required" name="sendVoucherTimeType" value="IMMEDIATELY"[#if product.sendVoucherTimeType=='IMMEDIATELY'] checked[/#if] /> 用户支付完成后一分钟内发送入园码</label><br/>
					<label><input type="radio" class="required" name="sendVoucherTimeType" dest="input[name=delaySendVoucherMinutes]" value="DELAY"[#if product.sendVoucherTimeType=='DELAY'] checked[/#if] /> 用户支付完成后 <input type="text" name="delaySendVoucherMinutes" value="${product.delaySendVoucherMinutes}" class="text digits required" style="width: 40px;" disabled /> 分钟内发送入园码</label><br/>
					<label><input type="radio" class="required" name="sendVoucherTimeType" dest="input[name=customSendVoucherTime]" value="CUSTOM"[#if product.sendVoucherTimeType=='CUSTOM'] checked[/#if] /> 自定义发送入园码时间 <input type="text" name="customSendVoucherTime" value="${product.customSendVoucherTime}" class="text digits required" style="width: 40px;" disabled /></label>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>电子票类型:
				</th>
				<td>
					<label><input type="radio" class="required" name="ticketType" value="S_CODE"[#if product.ticketType=='S_CODE'] checked[/#if] /> 平台系统提供的串码作为电子票</label><br/>
					<label><input type="radio" class="required" name="ticketType" value="O_CODE"[#if product.ticketType=='O_CODE'] checked[/#if] /> OTA提供的串码作为电子票</label><br/>
					<label><input type="radio" class="required" name="ticketType" value="S_STRING"[#if product.ticketType=='S_STRING'] checked[/#if] /> 平台系统提供的入园凭证文案</label><br/>
					<label><input type="radio" class="required" name="ticketType" value="S_PIC"[#if product.ticketType=='S_PIC'] checked[/#if] /> 平台系统提供的入园凭证图片url地址</label><br/>
					<label><input type="radio" class="required" name="ticketType" value="NO_CODE"[#if product.ticketType=='NO_CODE'] checked[/#if] /> 无串码提供</label>
				</td>
			</tr>
			--]
			<tr>
				<th>
					<span class="requiredField">*</span>发货方式:
				</th>
				<td>
					${product.smsTheme.title}
				</td>
			</tr>
			[#--
			<tr>
				<th>
					<span class="requiredField">*</span>发送方式:
				</th>
				<td>
					<label><input type="radio" class="required" name="sendType" value="ORDER"[#if product.sendType=='ORDER'] checked[/#if] /> 1单1码</label><br/>
					<label><input type="radio" class="required" name="sendType" value="PERSON"[#if product.sendType=='PERSON'] checked[/#if] /> 1人1码</label>
				</td>
			</tr>
			--]
			<tr>
				<th>
					入园地址:
				</th>
				<td>
					${product.passAddress}
				</td>
			</tr>
			<tr>
				<th>
					门票类型:
				</th>
				<td>
					<label><input name="productType" [#if (product.productType)?? && product.productType == 'SINGLE_TICKET' ]checked[/#if] type="radio" value="SINGLE_TICKET"/>单次票</label>&nbsp;
					<label><input name="productType" [#if (product.productType)?? && product.productType == 'REPEATEDLYDLY_TICKETS' ]checked[/#if] type="radio" value="REPEATEDLYDLY_TICKETS"/>多次票</label>&nbsp;
				</td>
			</tr>
			<tr>
				<th>
					<input type="checkbox" name="limitUseTimeRange" dest="input[name=useTimeRangeStart],input[name=useTimeRangeEnd]" value="true"[#if product.limitUseTimeRange] checked[/#if] />使用时间:
				</th>
				<td>
					<input type="text" class="text required" name="useTimeRangeStart" value="${product.useTimeRangeStart!'0:00'}" style="width: 40px;" disabled /> - <input type="text" class="text required" name="useTimeRangeEnd" value="${product.useTimeRangeEnd!'23:59'}" style="width: 40px;" disabled />
				</td>
			</tr>
			<tr id="jgkc">
				<td style="text-align: right; padding-right: 10px;">
					<strong>价格库存:</strong>
				</td>
				<td>
					&nbsp;
				</td>
			</tr>
			[#--
			<tr>
				<th>
					<span class="requiredField">*</span>是否指定使用日期:
				</th>
				<td>
					<label><input type="radio" class="required" name="isSpecifyDate" dest="#needdate_useEffectiveDay" hidefocus="true" value="true"[#if product.isSpecifyDate] checked[/#if] />
					需用户指定使用日期，用户选定的使用日期起
					<input type="text" id="needdate_useEffectiveDay" name="useEffectiveDay" class="text required digits" min="1" style="width:40px;" title="当天开始算起，当天就是1" value="${product.useEffectiveDay!1}" disabled/> 天内有效
					</label><br/>
					<label><input type="radio" class="required" name="isSpecifyDate" dest="#dontneeddate_useEffectiveDay" hidefocus="true" value="false"[#if !product.isSpecifyDate] checked[/#if] />
					无需用户指定使用日期，用户购买的日期起
					<input type="text" id="dontneeddate_useEffectiveDay" name="useEffectiveDay" class="text required digits" min="1" style="width:40px;" title="当天开始算起，当天就是1" value="${product.useEffectiveDay!1}" disabled/> 天内有效
					</label>
				</td>
			</tr>
			--]
			<tr>
				<th>
					<span class="requiredField">*</span>价格库存:
				</th>
				<td>
					<label><input type="radio" class="required" name="stockType" hidefocus="true" value="DAY"[#if product.stockType == 'DAY'] checked[/#if] />
					需要客人指定使用日期
					</label>
					<label><input type="radio" class="required" name="stockType" hidefocus="true" value="TOTAL"[#if product.stockType == 'TOTAL'] checked[/#if] />
					不需要客人指定使用日期
					</label>
				</td>
			</tr>
			<tr class="dontneeddate [#if product.stockType == 'DAY']hidden[/#if]">
				<th>
				</th>
				<td>
					[#if product.stockType == 'TOTAL']
					[#if product.productPrices?size > 0]
					[#assign productPrice = (product.productPrices[0])!/]
					<table class="input">
						<tr><td>票面价：<span id="marketpricecontainer">${productPrice.marketPrice}</span></td></tr>
						<tr><td>售卖价：<span id="pricecontainer">${productPrice.sellPrice}</span></td></tr>
						<tr><td>结算价：<span id="distpricecontainer">${productPrice.distPrice}</span></td></tr>
						<tr><td>库存：<span id="stockcontainer">${productPrice.stock}</span></td></tr>
						<tr><td>有效期：<span id="timecontainer">${productPrice.beginDate} ~ ${productPrice.endDate} 星期${productPrice.weekDays}</span></td></tr>
					</table>
					[#else]
					<table class="input">
						<tr><td>票面价：<span id="marketpricecontainer"></span></td></tr>
						<tr><td>售卖价：<span id="pricecontainer"></span></td></tr>
						<tr><td>结算价：<span id="distpricecontainer"></span></td></tr>
						<tr><td>库存：<span id="stockcontainer"></span></td></tr>
						<tr><td>有效期：<span id="timecontainer"></span></td></tr>
					</table>
					[/#if]
					[#else]
					<table class="input">
						<tr><td>票面价：<span id="marketpricecontainer"></span></td></tr>
						<tr><td>售卖价：<span id="pricecontainer"></span></td></tr>
						<tr><td>结算价：<span id="distpricecontainer"></span></td></tr>
						<tr><td>库存：<span id="stockcontainer"></span></td></tr>
						<tr><td>有效期：<span id="timecontainer"></span></td></tr>
					</table>
					[/#if]
				</td>
			</tr>
			<tr class="needdate [#if product.stockType == 'TOTAL']hidden[/#if]">
				<th>
				</th>
				<td>
<div class="choose_date_month">
		<div id="calendarcontainer" ndate="${.now?string('yyyy-MM-dd')}" date="${.now?string('yyyy-MM')}-01" month="${.now?string('MM')}">
		<div class="choose_month_bar">
			<div id="prevbutton" class="month_bar prev" title="前一月">
				<span>&lt;</span>
				<strong id="prevmonth"></strong>
			</div>
			<div id="nextbutton" class="month_bar next" title="后一月">
				<strong id="nextmonth"></strong>
				<span>&gt;</span>
			</div>
		</div>
		<div class="year_month">
			<span id="year"></span>
			<span class="month" id="month"></span>
		</div>
		<div class="week clrfix">
			<span>周日</span>
			<span>周一</span>
			<span>周二</span>
			<span>周三</span>
			<span>周四</span>
			<span>周五</span>
			<span>周六</span>
		</div>
		<div class="date" id="date" ></div>
		</div>
</div>
<div id="calender-right" class="module_calendar_data" style="display:none;">	
		<div class="data_item">
		<label class="cap">
		日期：</label><span id="showDate"></span>
		<input id="useDate" type="hidden" />
		</div>
		<div class="data_item">
		<label for="marketPrice" class="cap">
		<span class="must_be">*</span>票面价：</label>
		<input type="text" value="" class="input_small" name="marketPrice" id="marketPrice" />	
		<span class="data_unit">元</span></div>
		<div class="data_item">
		<label for="sellPrice" class="cap">
		<span class="must_be">*</span>售卖价：</label>
		<input type="text" value="" class="input_small" name="sellPrice" id="sellPrice" />					
		<span class="data_unit">元</span></div>						
		<div class="data_item">
		<label for="distPrice" class="cap">
		<span class="must_be">*</span>结算价：</label>
		<input type="text" value="" class="input_small" name="distPrice" id="distPrice" />					
		<span class="data_unit">元</span>				</div>
		<div class="data_item">					
		<label for="stockNum" class="cap">当日库存：</label>					
		<input type="text" value="1" class="input_small" name="stockNum" id="stockNum" />					
		<span class="data_unit">张</span>				</div>				
		<div class="data_item">					
		<label for="minBuyNum" class="cap">最少购买：</label>					
		<input type="text" value="1" class="input_small" name="minBuyNum" id="minBuyNum"/>					
		<span class="data_unit">张</span>				</div>				
		<div class="data_item">					
		<label for="maxBuyNum" class="cap">最多购买：</label>					
		<input type="text" value="999" class="input_small" name="maxBuyNum" id="maxBuyNum"/>					
		<span class="data_unit">张</span>				</div>				
		<div class="data_item_do">					
		<input type="button" id="pricesave" hidefocus="true" value="上架" class="do_btn do_btn_gray"/>					
		<input type="button" id="pricecancel" hidefocus="true" value="取消" class="do_btn do_btn_gray"/>				
		</div>	
</div>
				</td>
			</tr>
			<tr>
				<th>
					产品使用有效期:
				</th>
				<td>
				[#if product.validDateType=='' || product.validDateType=='NOLIMIT']
				不限制
				[#elseif product.validDateType=='VALIDDAY']
				 ${(product.validStartDate)!}&nbsp;-&nbsp;${(product.validEndDate)!}
				[#elseif product.validDateType=='SELECTDAY']
				用户购买/选定日期&nbsp;${(product.useEffectiveDay)!}&nbsp;天内有效
				[/#if]<br/>星期&nbsp;${(product.weeks)!}&nbsp;<span class="tips">(1:星期一,2:星期二,3:星期三,4:星期四,5:星期五,6:星期六,0:星期天)</span><br/>
				</td>
			</tr>
			<tr>
				<th>
					出售时间:
				</th>
				<td>
					<label><input type="radio" name="displayWay" value="NOW" checked[#if product.displayWay=='NOW'] checked[/#if]/>立刻上架出售，过期自动下架</label><br/>
					<label><input type="radio" name="displayWay" dest="input[name=saleStartTime],input[name=saleEndTime]" value="CLOCKING"[#if product.displayWay=='CLOCKING'] checked[/#if]/>设定出售时间 <input id="saleStartTime" name="saleStartTime" value="${(product.saleStartTime?string('yyyy-MM-dd'))!}" class="text Wdate required" onfocus="WdatePicker({readOnly:true,minDate:'${.now?string('yyyy-MM-dd')}'})" disabled /> 至  <input name="saleEndTime" value="${(product.saleEndTime?string('yyyy-MM-dd'))!}" class="text Wdate required" onfocus="WdatePicker({readOnly:true,minDate:'#F{$dp.$D(\'saleStartTime\',{d:0});}'})" disabled /></label><br/>
					<label><input type="radio" name="displayWay" value="WAREHOUSE"[#if product.displayWay=='WAREHOUSE'] checked[/#if]/>放入仓库（下架）</label>
				</td>
			</tr>
			<tr id="tkxx">
				<td style="text-align: right; padding-right: 10px;">
					<strong>退款信息:</strong>
				</td>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<th>
					退款设置:
				</th>
				<td>
					<label><input type="radio" name="canRefund" value="true" checked[#if product.canRefund] checked[/#if] />可以退款</label>
					<label><input type="radio" name="canRefund" value="false"[#if product.canRefund==false] checked[/#if] />不可退款</label>
					<span class="tips">请务必保证退款设置与退款说明的内容一致</span>
				</td>
			</tr>
			<tr>
				<th>
					退款是否需要审核:
				</th>
				<td>
					<label><input type="radio" name="refundNeedAudit" value="true"[#if product.refundNeedAudit] checked[/#if] />需要</label>
					<label><input type="radio" name="refundNeedAudit" value="false"[#if !product.refundNeedAudit] checked[/#if] />不需要</label>
				</td>
			</tr>
			[#--
			<tr>
				<th>
					<input type="checkbox" name="limitRefundAdvance" dest="input[name=refundAdvanceDay],input[name=refundAdvanceHour]"[#if product.limitRefundAdvance] checked[/#if] /> 最晚退款日期:
				</th>
				<td>
					有效期截止前 <input type="text" name="refundAdvanceDay" value="${product.refundAdvanceDay}" class="text digits required" style="width: 40px;" disabled /> 天的 <input type="text" name="refundAdvanceHour" value="${product.refundAdvanceHour}" class="text required" style="width: 40px;" disabled /> 前可以申请退款
				</td>
			</tr>
			<tr>
				<th>
					退款手续费:
				</th>
				<td>
					<select name="refundChargeType">
						<option value="TICKET"[#if product.refundChargeType == 'TICKET'] selected[/#if]>每张票需要手续费</option>
						<option value="ORDER"[#if product.refundChargeType == 'ORDER'] selected[/#if]>每笔订单需要手续费</option>
					</select>
					<input type="text" name="refundCharge" value="${product.refundCharge}" class="text" style="width: 40px;" /> 元
				</td>
			</tr>
			--]
			<tr>
				<th>
					退款说明:
				</th>
				<td>
					${product.refundInfo?replace("\n", "<br/>")}
				</td>
			</tr>
			<tr id="cpsm">
				<td style="text-align: right; padding-right: 10px;">
					<strong>产品说明:</strong>
				</td>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<th>
					费用说明:
				</th>
				<td>
					${product.feeInfo?replace("\n", "<br/>")}
				</td>
			</tr>
			<tr>
				<th>
					预定须知:
				</th>
				<td>
					${product.remind?replace("\n", "<br/>")}
				</td>
			</tr>
		</table>
		[#--
		<table class="input tabContent">
			<tr>
				<th>
					自定义短信:
				</th>
				<td>
					<textarea name="smsTemplate" class="text" maxlength="80">${product.smsTemplate?html}</textarea>
					<div class="blank"></div>
					<span class="tips">客人预订成功时发送该短信  80字内</span>
				</td>
			</tr>
			<tr>
				<th>
					产品特色:
				</th>
				<td>
					<textarea name="introduction" class="text">${product.introduction}</textarea>
				</td>
			</tr>
			<tr>
				<th>
					产品图片:
				</th>
				<td>
					<table id="productImageTable" class="input">
						<tr>
							<td colspan="4">
								<a href="javascript:;" id="addProductImage" class="button">${message("admin.product.addProductImage")}</a>
							</td>
						</tr>
						<tr class="title">
							<th>
								${message("ProductImage.file")}
							</th>
							<th>
								${message("ProductImage.title")}
							</th>
							<th>
								${message("admin.common.order")}
							</th>
							<th>
								${message("admin.common.delete")}
							</th>
						</tr>
						[#list product.productImages as productImage]
							<tr>
								<td>
									<input type="hidden" name="productImages[${productImage_index}].source" value="${productImage.source}" />
									<input type="hidden" name="productImages[${productImage_index}].large" value="${productImage.large}" />
									<input type="hidden" name="productImages[${productImage_index}].medium" value="${productImage.medium}" />
									<input type="hidden" name="productImages[${productImage_index}].thumbnail" value="${productImage.thumbnail}" />
									<input type="file" name="productImages[${productImage_index}].file" class="productImageFile ignore" />
									<a href="${productImage.large}" target="_blank">${message("admin.common.view")}</a>
								</td>
								<td>
									<input type="text" name="productImages[${productImage_index}].title" class="text" maxlength="200" value="${productImage.title}" />
								</td>
								<td>
									<input type="text" name="productImages[${productImage_index}].order" class="text productImageOrder" value="${productImage.order}" maxlength="9" style="width: 50px;" />
								</td>
								<td>
									<a href="javascript:;" class="deleteProductImage">[${message("admin.common.delete")}]</a>
								</td>
							</tr>
						[/#list]
					</table>
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.memberPrice")}:
				</th>
				<td>
					<label>
						<input type="checkbox" id="isMemberPrice" name="isMemberPrice" value="true"[#if product.memberPrice?has_content] checked="checked"[/#if] />${message("admin.product.isMemberPrice")}
					</label>
				</td>
			</tr>
			<tr id="memberPriceTr"[#if !product.memberPrice?has_content] class="hidden"[/#if]>
				<th>
					&nbsp;
				</th>
				<td>
					[#list memberRanks as memberRank]
						${memberRank.name}: <input type="text" name="memberPrice_${memberRank.id}" class="text memberPrice" value="${product.memberPrice.get(memberRank)}" maxlength="16" style="width: 60px; margin-right: 6px;"[#if !product.memberPrice?has_content] disabled="disabled"[/#if] />
					[/#list]
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.point")}:
				</th>
				<td>
					<input type="text" name="point" class="text" value="${product.point}" maxlength="9" title="${message("admin.product.pointTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.brand")}:
				</th>
				<td>
					<select name="brandId">
						<option value="">${message("admin.common.choose")}</option>
						[#list brands as brand]
							<option value="${brand.id}"[#if brand == product.brand] selected="selected"[/#if]>
								${brand.name}
							</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.tags")}:
				</th>
				<td>
					[#list tags as tag]
						<label>
							<input type="checkbox" name="tagIds" value="${tag.id}"[#if product.tags?seq_contains(tag)] checked="checked"[/#if] />${tag.name}
						</label>
					[/#list]
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.setting")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isList" value="true"[#if product.isList] checked="checked"[/#if] />${message("Product.isList")}
						<input type="hidden" name="_isList" value="false" />
					</label>
					<label>
						<input type="checkbox" name="isTop" value="true"[#if product.isTop] checked="checked"[/#if] />${message("Product.isTop")}
						<input type="hidden" name="_isTop" value="false" />
					</label>
					<label>
						<input type="checkbox" name="isGift" value="true"[#if product.isGift] checked="checked"[/#if] />${message("Product.isGift")}
						<input type="hidden" name="_isGift" value="false" />
					</label>
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.memo")}:
				</th>
				<td>
					<input type="text" name="memo" class="text" value="${product.memo}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.keyword")}:
				</th>
				<td>
					<input type="text" name="keyword" class="text" value="${product.keyword}" maxlength="200" title="${message("admin.product.keywordTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.seoTitle")}:
				</th>
				<td>
					<input type="text" name="seoTitle" class="text" value="${product.seoTitle}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.seoKeywords")}:
				</th>
				<td>
					<input type="text" name="seoKeywords" class="text" value="${product.seoKeywords}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.seoDescription")}:
				</th>
				<td>
					<input type="text" name="seoDescription" class="text" value="${product.seoDescription}" maxlength="200" />
				</td>
			</tr>
		</table>
		--]
		<table class="input">
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back()" />
				</td>
			</tr>
		</table>
	</form>
	
<script type="text/javascript">
function addHourPrice(target,data) {
	var i = $(target+" .hourPrice").length;
	var tr = $(
			[@compress single_line = true]
			'<tr class="hourPrice">
		<td>
			<select id="hourBeginHour_'+i+'" class="required">
				<option value="08:30">08:30</option>
				<option value="09:00">09:00</option>
				<option value="09:30">09:30</option>
				<option value="10:00">10:00</option>
				<option value="10:30">10:30</option>
				<option value="11:00">11:00</option>
				<option value="11:30">11:30</option>
				<option value="12:00">12:00</option>
				<option value="12:30">12:30</option>
				<option value="13:00">13:00</option>
				<option value="13:30">13:30</option>
				<option value="14:00">14:00</option>
				<option value="14:30">14:30</option>
				<option value="15:00">15:00</option>
				<option value="15:30">15:30</option>
				<option value="16:00">16:00</option>
				<option value="16:30">16:30</option>
				<option value="17:00">17:00</option>
				<option value="17:30">17:30</option>
				<option value="18:00">18:00</option>
				<option value="18:30">18:30</option>
				<option value="19:00">19:00</option>
			</select>
			<select id="hourEndHour_'+i+'" class="required">
				<option value="08:30">08:30</option>
				<option value="09:00">09:00</option>
				<option value="09:30">09:30</option>
				<option value="10:00">10:00</option>
				<option value="10:30">10:30</option>
				<option value="11:00">11:00</option>
				<option value="11:30">11:30</option>
				<option value="12:00">12:00</option>
				<option value="12:30">12:30</option>
				<option value="13:00">13:00</option>
				<option value="13:30">13:30</option>
				<option value="14:00">14:00</option>
				<option value="14:30">14:30</option>
				<option value="15:00">15:00</option>
				<option value="15:30">15:30</option>
				<option value="16:00">16:00</option>
				<option value="16:30">16:30</option>
				<option value="17:00">17:00</option>
				<option value="17:30">17:30</option>
				<option value="18:00">18:00</option>
				<option value="18:30">18:30</option>
				<option value="19:00">19:00</option>
			</select></td>
		<td>
		<label>市场价：<input class="text marketPrice" style="width: 50px;" onkeyup="this.value=this.value.replace(/[^\\d.]/g,\'\')" id="hourMarketPrice_'+i+'"/></label><br>
		<label>售卖价：<input class="text sellPrice" style="width: 50px;" onkeyup="this.value=this.value.replace(/[^\\d.]/g,\'\')" id="hourSellPrice_'+i+'"/></label><br>
		<label>结算价：<input class="text settlePrice" style="width: 50px;" onkeyup="this.value=this.value.replace(/[^\\d.]/g,\'\')" id="hourSettlePrice_'+i+'"/></label></td>
		<td><input class="text stock" style="width: 50px;" onkeyup="this.value=this.value.replace(/[^\\d]/g,\'\')" id="hourStock_'+i+'" min="0"/></td>
		<td><a href="javascript:;" onclick="$(this).closest(\'tr\').remove()">删除</a></td>
	</tr>'[/@compress]);
	$(target).append(tr);
	if(data) {
		tr.find("#hourBeginHour_"+i).val(data.beginHour);
		tr.find("#hourEndHour_"+i).val(data.endHour);
		tr.find("#hourMarketPrice_"+i).val(data.marketPrice);
		tr.find("#hourSellPrice_"+i).val(data.sellPrice);
		tr.find("#hourSettlePrice_"+i).val(data.distPrice);
		tr.find("#hourStock_"+i).val(data.quantity);
	}
}
[#if product.stockType == 'HOUR']
function tdFillCallBack(td) {
	var value = $(td).data('data');
	//td.attr('marketPrice',value.marketPrice).attr('stockNum',value.quantity).attr('sellPrice',value.sellPrice).attr('childPrice',value.childPrice).attr('oldPrice',value.oldPrice).attr('distPrice',value.distPrice).attr('minBuyNum',value.minimum).attr('maxBuyNum',value.maximum);
	var str = "<p class='price'>在售</p>";
	return str;
}
function tdClickCallBack(o) {
	$("#useDate").val($(o).attr('data-date'));
	$("#showDate").text($(o).attr('data-date'));
	$("#minBuyNum").val('');
	$("#maxBuyNum").val('');
	$("#currentHourPrice .hourPrice").remove();
	var data = $(o).data('data');
	if(data) {
		$("#minBuyNum").val(data.minimum);
		$("#maxBuyNum").val(data.maximum);
		var prices = data.prices;
		for(var i=0;i<prices.length;i++) {
			addHourPrice('#currentHourPrice',prices[i]);
		}
	}
}
[#else]
function tdFillCallBack(td) {
	var value = $(td).data('data');
	//td.attr('marketPrice',value.marketPrice).attr('stockNum',value.quantity).attr('sellPrice',value.sellPrice).attr('childPrice',value.childPrice).attr('oldPrice',value.oldPrice).attr('distPrice',value.distPrice).attr('minBuyNum',value.minimum).attr('maxBuyNum',value.maximum);
	var str = '';
	if(value) {
		str += "<p class='price'>市:￥<em>"+(value.marketPrice?value.marketPrice:'')+"</em></p>";
		str += "<p class='price'>售:￥<em>"+(value.sellPrice?value.sellPrice:'')+"</em></p>";
		str += "<p class='price'>库:<em>"+(value.quantity?value.quantity:'')+"</em></p>";
	}
	return str;
}
function tdClickCallBack(o) {
	$("#useDate").val($(o).attr('data-date'));
	$("#showDate").text($(o).attr('data-date'));
	$("#marketPrice").val('');
	$("#sellPrice").val('');
	$("#childPrice").val('');
	$("#oldPrice").val('');
	$("#distPrice").val('');
	$("#stockNum").val('');
	$("#minBuyNum").val('');
	$("#maxBuyNum").val('');
	var data = $(o).data('data');
	if(data) {
		$("#marketPrice").val(data.marketPrice);
		$("#sellPrice").val(data.sellPrice);
		$("#childPrice").val(data.childPrice);
		$("#oldPrice").val(data.oldPrice);
		$("#distPrice").val(data.distPrice);
		$("#stockNum").val(data.quantity);
		$("#minBuyNum").val(data.minimum);
		$("#maxBuyNum").val(data.maximum);
	}
}
[/#if]
</script>
<script type="text/javascript" src="${base}/resources/admin/js/calendarprice.js?20151223"></script>
</body>
</html>