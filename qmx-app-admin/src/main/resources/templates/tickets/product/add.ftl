[#assign shiro=JspTaglibs["/WEB-INF/tld/shiro.tld"] /]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>${message("admin.product.add")}</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/dropdown/dropdown.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/ext.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/product.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
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
	var productImageIndex = 0;
	
	[@flash_message /]
	
	
	//loadParameter();
	
	$browserButton.browser();
	
	// 会员价
	$isMemberPrice.click(function() {
		if ($(this).prop("checked")) {
			$memberPriceTr.show();
			$memberPrice.prop("disabled", false);
		} else {
			$memberPriceTr.hide();
			$memberPrice.prop("disabled", true);
		}
	});
	
	// 增加商品图片
	/*
	$addProductImage.click(function() {
		[@compress single_line = true]
			var trHtml = 
			'<tr>
				<td>
					<input type="file" name="productImages[' + productImageIndex + '].file" class="productImageFile" \/>
				<\/td>
				<td>
					<input type="text" name="productImages[' + productImageIndex + '].title" class="text" maxlength="200" \/>
				<\/td>
				<td>
					<input type="text" name="productImages[' + productImageIndex + '].order" class="text productImageOrder" maxlength="9" style="width: 50px;" \/>
				<\/td>
				<td>
					<a href="javascript:;" class="deleteProductImage">[${message("admin.common.delete")}]<\/a>
				<\/td>
			<\/tr>';
		[/@compress]
		$productImageTable.append(trHtml);
		productImageIndex ++;
	});
	*/
	
	// 删除商品图片
	$deleteProductImage.live("click", function() {
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "${message("admin.dialog.deleteConfirm")}",
			onOk: function() {
				$this.closest("tr").remove();
			}
		});
	});
	
	// 增加规格商品
	$addSpecificationProduct.click(function() {
		$("#specificationProductTable").append(
			[@compress single_line = true]
				'<tr>
				<td></td>
				<td><input type="text" name="specTitle" class="text productTitle" /></td> 
				<td align="right"><input type="text" name="specPrice" class="text productPrice" maxlength="16" style="width:50px;" value="0" /></td>
				<td align="right"><input type="text" name="specCost" class="text productCost" maxlength="16" style="width:50px;" value="0" /></td>
				<td align="right"><input type="text" name="specStock" class="text productPriceStock" maxlength="9" style="width:50px;" value="0" /></td>
				<td align="right"><a href="javascript:;" class="deleteSpecificationProduct">[${message("admin.common.delete")}]</a></td>
			</tr>'
			[/@compress]
			);
	});
	
	// 删除规格商品
	$deleteSpecificationProduct.live("click", function() {
		var $this = $(this);
		$this.closest("tr").remove();
		/* $.dialog({
			type: "warn",
			content: "${message("admin.dialog.deleteConfirm")}",
			onOk: function() {
				$this.closest("tr").remove();
			}
		}); */
	});
	
	$.validator.addClassRules({
		required: {
			required: true
		},
		memberPrice: {
			min: 0,
			decimal: {
				integer: 12,
				fraction: ${setting.priceScale}
			}
		},
		productTitle : {
			required: true
		},
		productPrice: {
			//required: true,
			min: 0,
			decimal: {
				integer: 12,
				fraction: ${setting.priceScale}
			}
		},
		productCost: {
			//required: true,
			min: 0,
			decimal: {
				integer: 12,
				fraction: ${setting.priceScale}
			}
		},
		productImageFile: {
			required: true,
			extension: "${setting.uploadImageExtension}"
		},
		productImageOrder: {
			digits: true
		}
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: "required",
			sn: {
				pattern: /^[0-9a-zA-Z_-]+$/,
				remote: {
					url: "check_sn.jhtml",
					cache: false
				}
			},
			productCategoryId: {
				required: true
			},
			supplierId: {
				required: true
			},
			smsThemeId: {
				required: true
			},
			companyId: {
				required: true
			},
			paymentType: {
				required: true
			},
			focusimagepath: {
				required: true
			},
			price: {
				required: true,
				min: 0,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			},
			distPrice: {
				required: true,
				min: 0,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			},
			cost: {
				min: 0,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			},
			marketPrice: {
				min: 0,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			},
			stock: "digits",
			point: "digits"
		},
		messages: {
			sn: {
				pattern: "${message("admin.validate.illegal")}",
				remote: "${message("admin.validate.exist")}"
			},
			focusimagepath: {
				required: "至少上传一张图片"
			}
		}
	});
	
	//企业选择下拉
	$("#companyName").dropqtable({
		vinputid: "companyId", //值所存放的区域
		dropwidth: "auto", //下拉层的宽度
		selecteditem: { text: "", value: "" }, //默认值
		tableoptions: {
			//autoload: true,
			url: "company.jhtml", //查询响应的地址
			qtitletext: "请输入目的地名称", //查询框的默认文字  
			textField: 'trueName',
			valueField: 'id',
			colmodel: [
						{ name: "type", displayname: "类型", width: "60px" },
			           { name: "name", displayname: "名称", width: "100px" }, //表格定义
			           { name: "address", displayname: "地址", width: "150px" }
			],
			onSelect:function(selected){
	        	$("#companyId").val(selected.id);
	        	$("#companyName").val(selected.name);
			}
		}
	});
	
	$("#supplierName").dropqtable({
		vinputid: "supplierId", //值所存放的区域
		dropwidth: "auto", //下拉层的宽度
		selecteditem: { text: "", value: "" }, //默认值
		tableoptions: {
			//autoload: true,
			url: "getSupplier.jhtml", //查询响应的地址
			qtitletext: "请输入供应商账号", //查询框的默认文字  
			textField: 'trueName',
			valueField: 'id',
			colmodel: [
			           { name: "name", displayname: "姓名", width: "100px" }, //表格定义
			           { name: "username", displayname: "账号", width: "150px" }
			],
			onSelect:function(selected){
	        	$("#supplierId").val(selected.id);
	        	$("#supplierName").val(selected.username);
			}
		}
	});
	
	$("#selectCheckTicketMember").click(function(){
		var browserFrameId = "browserFrame" + (new Date()).valueOf() + Math.floor(Math.random() * 1000000);
		var $browser = $('<div class="xxBrowser" style="height:290px;"><\/div>');
		$browserFrame = $('<iframe id="' + browserFrameId + '" name="' + browserFrameId + '" src="${base}/admin/product/listMemberInDialog.jhtml" style="width:100%; height:100%;" frameborder="0"><\/iframe>').appendTo($browser);
		var $dialog = $.dialog({
			title: "选择验票人",
			content: $browser,
			width: 670,
			modal: true,
			ok: "确定",
			cancel: "关闭",
			onOk: function(){
				var $checkedIds = $(window.frames[browserFrameId].document).find("input[name='ids']:enabled:checked");
				var html = [];
				$checkedIds.each(function(){
					var id = $(this).val();
					var tr = $(this).parents("tr:eq(0)");
					if($("tr."+id).size() == 0) {
						html.push("<tr class='"+id+"'><td><input type='hidden' name='checkTicketMemberIds' value='"+id+"'/>"+tr.find("td:eq(3)").text()+"</td><td>"+tr.find("td:eq(1)").text()+"</td><td><a href='javascript:;' onclick='$(this).parent().parent().remove()'>删除</a></td></tr>");
					}
				});
				$("#checkTicketMemberTable").append(html.join(''));
				return true;
			}
		});
	});
	
	$("input:radio,input:checkbox").change(function(){
		$("input[name='"+$(this).attr("name")+"']:checked").each(function(){
			$($(this).attr("dest")).attr("disabled", false);
		});
		$("input[name='"+$(this).attr("name")+"']").not(":checked").each(function(){
			$($(this).attr("dest")).attr("disabled", true);
		});
	});
	
	$("#passengerInfoPerNumInput").keyup(function(){
		if(isNaN($(this).val())) {
			$(this).val(0);
		}
		$("#passengerInfoPerNum").val(parseInt($(this).val()));
	});
	$("input[name=name]").keyup(function(){
		var val = $(this).val();
		$("#nametip").text(val.length+"/30字");
	});
});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			添加${productCategory.name}
	    </div>
	</div>
	<form id="inputForm" action="save.jhtml" method="post" enctype="multipart/form-data">
		<input type="hidden" name="productCategoryId" value="${productCategory.id}" />
		<input type="hidden" name="ticketType" value="S_CODE" />
		<input type="hidden" id="datePriceData" name="datePriceData" />
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
					<span class="requiredField">*</span>${productCategory.name}名称:
				</th>
				<td>
					<input type="text" name="name" class="text" maxlength="30" style="width:300px;"/>&nbsp;<span id="nametip">0/30字</span>&nbsp;<span class="tips">2-30字</span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>选择目的地:
				</th>
				<td>
					<input id="companyName" type="text" class="text" readonly maxlength="300" />
					<input id="companyId" name="companyId" type="hidden" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>选择供应商:
				</th>
				<td>
					[@shiro.hasRole name="supplier"]
					${admin.username}
					<input name="supplierId" type="hidden" value="${admin.id}" />
					[/@shiro.hasRole]
					[@shiro.lacksRole name="supplier"]
					<input id="supplierName" type="text" class="text" readonly maxlength="300" />
					<input id="supplierId" name="supplierId" type="hidden" />
					[/@shiro.lacksRole]
				</td>
			</tr>
			<tr>
				<th>
					选择验票人:
				</th>
				<td>
					<label><input type="checkbox" name="isSupplierCheck" value="1"/>供应商可验票</label>
					<button type="button" id="selectCheckTicketMember" class="button">其他验票人</button>
					<table id="checkTicketMemberTable" width="100%">
						<tr class="title">
							<td>验票人姓名</td>
							<td>验票人用户名</td>
							<td>操作</td>
						</tr>
					</table>
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
									<li>
										<div class="productImageBox">
											<div class="productImagePreview png">暂无图片</div>
											<input type="hidden" name="focusimagepath" value="" validate="{required:true,messages:{required:'请至少上传一张产品导图'}}">
											<div class="productImageOperate">
												<a class="left" href="javascript: void(0);" alt="左移" hidefocus="true"></a>
												<a class="right" href="javascript: void(0);" title="右移" hidefocus="true"></a>
												<a class="delete" href="javascript: void(0);" title="删除" hidefocus="true"></a>
											</div>
											<a class="productImageUploadButton" href="javascript:;">
												<div>上传新图片</div>
											</a>
										</div>
									</li>
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
					我要分销:
				</th>
				<td>
					<label>
						<input type="checkbox" name="openDist" value="true" />
						<input type="hidden" name="_openDist" value="false" />
						允许分销商申请分销该产品
					</label>
				</td>
			</tr>
			<tr>
				<th>
					是否展示在网页:
				</th>
				<td>
					<label><input type="radio" name="isShow" value="1" checked/>是</label>
					<label><input type="radio" name="isShow" value="0"/>否</label>
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
					支付方式:
				</th>
				<td>
					<label><input type="radio" name="paymentType" value="PREPAY" checked/>在线支付（预付）</label>
					<label><input type="radio" name="paymentType" value="COLLECTPAY"/>到店支付（现付）</label>
				</td>
			</tr>
			<tr>
				<th>
					取消设置:
				</th>
				<td>
					<input type="text" name="autoCancelTime" class="text digits" min="1" value="120" style="width: 80px;" /> 分钟后不支付自动取消 <span class="tips">默认2×60，最短5分钟，最大值不可超过21600分钟</span>
				</td>
			</tr>
			<tr>
				<th>
					联系人信息:
				</th>
				<td>
					<label><input type="hidden" name="needContactInfo" value="phone" /><input type="checkbox" name="needContactInfo" value="phone" checked disabled /> 手机号</label>
					<label><input type="hidden" name="needContactInfo" value="name" /><input type="checkbox" name="needContactInfo" value="name" checked disabled /> 姓名</label>
					<label><input type="checkbox" name="needContactInfo" value="pinyin" /> 拼音</label>
					[#--
					<label><input type="checkbox" name="needContactInfo" value="email" /> Email</label>
					<label><input type="checkbox" name="needContactInfo" value="postal" /> 地址/邮编</label>
					--]
				</td>
			</tr>
			<tr>
				<th>
					<input type="checkbox" name="needPassengerInfoCheck" dest="input[name=passengerInfoPerNum],input[name=needPassengerInfo],input[name=needPassengerInfoOther_Check],#passengerInfoPerNumInput" /> 客人信息:
				</th>
				<td>
					<span class="radioGroup">
					<label><input type="radio" name="passengerInfoPerNum" value="1" checked disabled />需要每个客人的信息</label>
					[#--<label><input id="passengerInfoPerNum" type="radio" name="passengerInfoPerNum" dest="#passengerInfoPerNumInput" value="0" disabled />每 <input id="passengerInfoPerNumInput" type="text" class="text digits required" min="1" value="1" style="width: 80px;" disabled /> 个客人共享一个客人信息</label>--]
					<label><input type="radio" name="passengerInfoPerNum" value="9999" disabled />仅需要一位客人信息</label>
					</span>
					<br/>
					<div style="background: #f5f5f5; margin: 5px; padding: 5px;">
						<label><input type="checkbox" checked disabled /><input type="hidden" name="needPassengerInfo" value="name" /> 姓名</label>
						<label><input type="checkbox" name="needPassengerInfo" value="pinyin" disabled /> 拼音</label>
						<label><input type="checkbox" name="needPassengerInfo" value="mobile" disabled /> 手机号码</label>
						<br/>
						<label><input type="checkbox" name="needPassengerInfo" value="Idcard" disabled /> 身份证</label>
						<label><input type="checkbox" name="needPassengerInfo" value="Passport" disabled /> 护照</label>
						<label><input type="checkbox" name="needPassengerInfo" value="TaiwanPermit" disabled /> 台胞证</label>
						<label><input type="checkbox" name="needPassengerInfo" value="HKAndMacauPermit" disabled /> 港澳通行证</label>
						<span class="tips">若勾选多个，客人只需填写一个</span>
						<br/>
						<label><input type="checkbox" name="needPassengerInfoOther_Check" dest="input[name=needPassengerInfoOther1]" disabled /><input type="text" name="needPassengerInfoOther1" class="text required" placeholder="其他1" style="width: 80px;" disabled /></label>
						<label><input type="checkbox" name="needPassengerInfoOther_Check" dest="input[name=needPassengerInfoOther2]" disabled /><input type="text" name="needPassengerInfoOther2" class="text required" placeholder="其他2" style="width: 80px;" disabled /></label>
						<span class="tips">您可以自定义客人信息，如航班号等</span>
					</div>
				</td>
			</tr>
			<tr>
				<th>
					预定限制:
				</th>
				<td>
					<label>
						<input type="radio" name="enterSightLimitType" class="required" checked value="NO_LIMIT"/>
						无预订时间限制
					</label><br/>
					<label>
						<input type="radio" name="enterSightLimitType" dest="input[id=ADVANCE_BOOK_TIME]" class="required" value="ADVANCE_BOOK_TIME"/>
						提前 <input id="ADVANCE_BOOK_TIME" type="text" name="enterSightAdvanceDay" class="text digits required" value="0" style="width: 30px;" disabled/> 天的 <input id="ADVANCE_BOOK_TIME" type="text" name="enterSightAdvanceHour" class="text digits required" max="23" value="23" style="width: 30px;" disabled/> : <input id="ADVANCE_BOOK_TIME" type="text" name="enterSightAdvanceMinute" class="text digits required" max="59" value="59" style="width: 30px;" disabled/> 点之前预定
					</label><br/>
					<label>
						<input type="radio" name="enterSightLimitType" dest="input[id=DELAY_BOOK_HOURS]" class="required" value="DELAY_BOOK_HOURS"/>
						预订后 <input id="DELAY_BOOK_HOURS" type="text" name="enterSightDelayBookHour" class="text digits required" value="" style="width: 30px;" disabled/> 小时才能入园
					</label><br/>
				</td>
			</tr>
			<tr>
				<th>
					<input type="checkbox" name="perPhoneMaxNumCheck" dest="input[name=perPhoneMaxNum]" /> 手机限制:
				</th>
				<td>
					同一手机号每天最多预订 <input type="text" name="perPhoneMaxNum" class="text digits required" style="width: 80px;" disabled /> 数量
				</td>
			</tr>
			[#--
			<tr>
				<th>
					<input type="checkbox" name="perIdcardMaxNumCheck" dest="input[name=perIdcardMaxNum]" /> 身份证号预定限制:
				</th>
				<td>
					同一身份证号最多只能预订 <input type="text" name="perIdcardMaxNum" class="text digits required" style="width: 80px;" disabled /> 张门票
				</td>
			</tr>
			--]
			<tr>
				<th>
					是否预约:
				</th>
				<td>
					<label><input type="radio" name="needReserve" value="true"/>是</label>
					<label><input type="radio" name="needReserve" value="false" checked/>否</label>
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
					<label><input type="radio" class="required" name="exchangeVoucherType" value="SMS" /> 确认短信</label>
					<label><input type="radio" class="required" name="exchangeVoucherType" value="IDCARD" /> 身份证</label>
					<label><input type="radio" class="required" name="exchangeVoucherType" value="SMS_AND_IDCARD" /> 短信和身份证</label>
					<label><input type="radio" class="required" name="exchangeVoucherType" value="EMAIL" /> 电子邮件确认单</label>
					[#--<label><input type="radio" class="required" name="exchangeVoucherType" value="ENTITY" /> 供应商寄送的实物</label>--]
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>入园方式:
				</th>
				<td>
					<label><input type="radio" class="required" name="passType" value="VIRTUAL" /> 凭兑换凭证直接入园</label>
					<label><input type="radio" class="required" name="passType" value="ENTITY" /> 凭兑换凭证换票</label>
				</td>
			</tr>
			[#--
			<tr>
				<th>
					<span class="requiredField">*</span>发码时间:
				</th>
				<td>
					<label><input type="radio" class="required" name="sendVoucherTimeType" value="IMMEDIATELY" /> 用户支付完成后一分钟内发送入园码</label><br/>
					<label><input type="radio" class="required" name="sendVoucherTimeType" dest="input[name=delaySendVoucherMinutes]" value="DELAY" /> 用户支付完成后 <input type="text" name="delaySendVoucherMinutes" class="text digits required" style="width: 40px;" disabled /> 分钟内发送入园码</label><br/>
					<label><input type="radio" class="required" name="sendVoucherTimeType" dest="input[name=customSendVoucherTime]" value="CUSTOM" /> 自定义发送入园码时间 <input type="text" name="customSendVoucherTime" class="text digits required" style="width: 40px;" disabled /></label>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>电子票类型:
				</th>
				<td>
					<label><input type="radio" class="required" name="ticketType" value="S_CODE" /> 平台系统提供的串码作为电子票</label><br/>
					<label><input type="radio" class="required" name="ticketType" value="O_CODE" /> OTA提供的串码作为电子票</label><br/>
					<label><input type="radio" class="required" name="ticketType" value="S_STRING" /> 平台系统提供的入园凭证文案</label><br/>
					<label><input type="radio" class="required" name="ticketType" value="S_PIC" /> 平台系统提供的入园凭证图片url地址</label><br/>
					<label><input type="radio" class="required" name="ticketType" value="NO_CODE" /> 无串码提供</label>
				</td>
			</tr>
			--]
			<tr>
				<th>
					<span class="requiredField">*</span>发货方式:
				</th>
				<td>
					<select name="smsThemeId">
						<option value="">${message("admin.common.choose")}</option>
						[#list themes as theme]
							<option value="${theme.id}">${theme.title}</option>
						[/#list]
					</select>
				</td>
			</tr>
			[#--
			<tr>
				<th>
					<span class="requiredField">*</span>发送方式:
				</th>
				<td>
					<label><input type="radio" class="required" name="sendType" value="ORDER" checked /> 1单1码</label><br/>
					<label><input type="radio" class="required" name="sendType" value="PERSON" /> 1人1码</label>
				</td>
			</tr>
			--]
			<tr>
				<th>
					<span class="requiredField">*</span>入园地址:
				</th>
				<td>
					<input type="text" name="passAddress" class="text required" placeholder="请详细填写客人进入园区的地址" style="width: 300px;" />
				</td>
			</tr>
			<tr>
				<th>
					门票类型:
				</th>
				<td>
					<label><input name="productType" type="radio" value="SINGLE_TICKET"/>单次票</label>&nbsp;
					<label><input name="productType" type="radio" value="REPEATEDLYDLY_TICKETS"/>多次票</label>&nbsp;
				</td>
			</tr>
			<tr>
				<th>
					<input type="checkbox" name="limitUseTimeRange" dest="input[name=useTimeRangeStart],input[name=useTimeRangeEnd]" value="true" />使用时间:
				</th>
				<td>
					<input type="text" class="text required" name="useTimeRangeStart" value="0:00" style="width: 40px;" disabled /> - <input type="text" class="text required" name="useTimeRangeEnd" value="23:59" style="width: 40px;" disabled />
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
			<tr>
				<th>
					<span class="requiredField">*</span>分销价:
				</th>
				<td>
					<input type="text" name="distPrice" class="text" />
				</td>
			</tr>
			[#--
			<tr>
				<th>
					<span class="requiredField">*</span>是否指定使用日期:
				</th>
				<td>
					<label><input type="radio" class="required" name="isSpecifyDate" dest="#needdate_useEffectiveDay" hidefocus="true" value="true" />
					需用户指定使用日期，用户选定的使用日期起
					<input type="text" id="needdate_useEffectiveDay" name="useEffectiveDay" class="text required digits" min="1" style="width:40px;" title="当天开始算起，当天就是1" value="1" disabled/> 天内有效
					</label><br/>
					<label><input type="radio" class="required" name="isSpecifyDate" dest="#dontneeddate_useEffectiveDay" hidefocus="true" value="false" />
					无需用户指定使用日期，用户购买的日期起
					<input type="text" id="dontneeddate_useEffectiveDay" name="useEffectiveDay" class="text required digits" min="1" style="width:40px;" title="当天开始算起，当天就是1" value="1" disabled/> 天内有效
					</label>
				</td>
			</tr>
			--]
			<tr>
				<th>
					<span class="requiredField">*</span>价格库存:
				</th>
				<td>
					<label><input type="radio" class="required" name="stockType" hidefocus="true" value="DAY" onclick="$('.needdate').show();$('.dontneeddate').hide();" checked />
					需要客人指定使用日期
					</label>
					<label><input type="radio" class="required" name="stockType" hidefocus="true" value="TOTAL" onclick="$('.needdate').hide();$('.dontneeddate').show();" />
					不需要客人指定使用日期
					</label>
				</td>
			</tr>
			<tr class="dontneeddate hidden">
				<th>
				</th>
				<td>
					<input type="button" class="button" id="modifyprice" value="编辑价格" />
					<table class="input">
						<tr><td>票面价：<span id="marketpricecontainer"></span></td></tr>
						<tr><td>售卖价：<span id="pricecontainer"></span></td></tr>
						<tr><td>结算价：<span id="distpricecontainer"></span></td></tr>
						<tr><td>总库存：<span id="stockcontainer"></span></td></tr>
						<tr><td>有效期：<span id="timecontainer"></span></td></tr>
					</table>
				</td>
			</tr>
			<tr class="needdate ">
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
	<div class="module_calendar_do">
		<span class="tips">请在页面下方点击保存按钮，报价才能生效。</span>
		<input type="button" id="batchset" hidefocus="true" value="批量上架" class="do_btn do_btn_gray"/>
		<input type="button" id="batchunset" hidefocus="true" value="批量下架" class="do_btn do_btn_gray"/>						
		<input type="button" id="clearall" hidefocus="true" value="全部下架" class="do_btn do_btn_gray"/>					
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
		<input type="text" value="" class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="marketPrice" />	
		<span class="data_unit">元</span></div>
		<div class="data_item">
		<label for="sellPrice" class="cap">
		<span class="must_be">*</span>售卖价：</label>
		<input type="text" value="" class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="sellPrice" />					
		<span class="data_unit">元</span></div>						
		<div class="data_item">
		<label for="distPrice" class="cap">
		<span class="must_be">*</span>结算价：</label>
		<input type="text" value="" class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="distPrice" />					
		<span class="data_unit">元</span>				</div>
		<div class="data_item">					
		<label for="stockNum" class="cap">当日库存：</label>					
		<input type="text" value="1" class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="stockNum" />					
		<span class="data_unit">张</span>				</div>				
		<div class="data_item">					
		<label for="minBuyNum" class="cap">最少购买：</label>					
		<input type="text" value="1" class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="minBuyNum"/>					
		<span class="data_unit">张</span>				</div>				
		<div class="data_item">					
		<label for="maxBuyNum" class="cap">最多购买：</label>					
		<input type="text" value="999" class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="maxBuyNum"/>					
		<span class="data_unit">张</span>				</div>				
		<div class="data_item_do">					
		<input type="button" id="pricesave" hidefocus="true" value="上架" class="do_btn do_btn_gray"/>					
		<input type="button" id="pricecancel" hidefocus="true" value="取消" class="do_btn do_btn_gray"/>				
		</div>	
</div>
				</td>
			</tr>
			[#--
			<tr>
				<th>
					商品规格:
				</th>
				<td>
					<div id="specificationTableDiv">
						<table id="specificationProductTable" class="input">
							<tr class="title">
								<td><input id="addSpecificationProduct" type="button" class="button" value="添加" /></td>
								<td>规格标题</td>
								<td style="text-align: right;">市场价格 <input type="text" name="productPrice" class="text" maxlength="16" style="width:50px;" onchange="$('.productPrice').val($(this).val())" /></td>
								<td style="text-align: right;">成本价格 <input type="text" name="productCost" class="text" maxlength="16" style="width:50px;" onchange="$('.productCost').val($(this).val())" /></td>
								<td style="text-align: right;">数量 <input type="text" name="productPriceStock" class="text" maxlength="9" style="width:50px;" onchange="$('.productPriceStock').val($(this).val())" /></td>
								<td style="text-align: right;">${message("admin.common.handle")}</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
			--]
			<tr>
				<th>
					出售时间:
				</th>
				<td>
					<label><input type="radio" name="displayWay" value="NOW" checked/>立刻上架出售，过期自动下架</label><br/>
					<label><input type="radio" name="displayWay" dest="input[name=saleStartTime],input[name=saleEndTime]" value="CLOCKING"/>设定出售时间 <input id="saleStartTime" name="saleStartTime" class="text Wdate required" onfocus="WdatePicker({readOnly:true,minDate:'${.now?string('yyyy-MM-dd')}'})" disabled /> 至  <input name="saleEndTime" class="text Wdate required" onfocus="WdatePicker({readOnly:true,minDate:'#F{$dp.$D(\'saleStartTime\',{d:0});}'})" disabled /></label><br/>
					<label><input type="radio" name="displayWay" value="WAREHOUSE"/>放入仓库（下架）</label>
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
					<label><input type="radio" name="canRefund" value="true" checked />可以退款</label>
					<label><input type="radio" name="canRefund" value="false" />不可退款</label>
					<span class="tips">请务必保证退款设置与退款说明的内容一致</span>
				</td>
			</tr>
			<tr>
				<th>
					退款审核:
				</th>
				<td>
					<label><input type="radio" name="refundNeedAudit" value="true" />需要审核</label>
					<label><input type="radio" name="refundNeedAudit" value="false" checked />不需要审核</label>
				</td>
			</tr>
			[#--
			<tr>
				<th>
					<input type="checkbox" name="" dest="input[name=refundAdvanceDay],input[name=refundAdvanceHour]" /> 最晚退款日期:
				</th>
				<td>
					有效期截止前 <input type="text" name="refundAdvanceDay" class="text required" style="width: 40px;" disabled /> 的 <input type="text" name="refundAdvanceHour" class="text required" style="width: 40px;" disabled /> 前可以申请退款
				</td>
			</tr>
			<tr>
				<th>
					退款手续费:
				</th>
				<td>
					<select name="refundChargeType">
						<option value="TICKET">每张票需要手续费</option>
						<option value="ORDER">每笔订单需要手续费</option>
					</select>
					<input type="text" name="refundCharge" class="text" style="width: 40px;" /> 元
				</td>
			</tr>
			--]
			<tr>
				<th>
					<span class="requiredField">*</span>退款说明:
				</th>
				<td>
					<textarea name="refundInfo" class="text required" maxlength="500"></textarea>
					<div class="blank"></div>
					<span class="tips">必须包含以下内容：【客人申请退款的时间及方式】【是否支持改期】  500字以内。</span>
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
					<span class="requiredField">*</span>费用包含:
				</th>
				<td>
					<textarea name="feeInfo" class="text required" maxlength="500"></textarea>
					<div class="blank"></div>
					<span class="tips">500字以内。</span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>费用不包含:
				</th>
				<td>
					<textarea name="feeExclude" class="text " maxlength="500"></textarea>
					<div class="blank"></div>
					<span class="tips">500字以内。</span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>使用说明:
				</th>
				<td>
					<textarea name="remind" class="text required" maxlength="1000"></textarea>
					<div class="blank"></div>
					<span class="tips">必须包含以下内容：【入园凭证】【入园凭证发送时间及方式】【入园/换票时间及地址】  1000字以内。</span>
				</td>
			</tr>
		</table>
		[#--
		<table class="input tabContent">
			<tr>
				<th>
					产品特色:
				</th>
				<td>
					<textarea name="introduction" class="text"></textarea>
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
							<td>
								${message("ProductImage.file")}
							</td>
							<td>
								${message("ProductImage.title")}
							</td>
							<td>
								${message("admin.common.order")}
							</td>
							<td>
								${message("admin.common.delete")}
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.memberPrice")}:
				</th>
				<td>
					<label>
						<input type="checkbox" id="isMemberPrice" name="isMemberPrice" value="true" />${message("admin.product.isMemberPrice")}
					</label>
				</td>
			</tr>
			<tr id="memberPriceTr" class="hidden">
				<th>
					&nbsp;
				</th>
				<td>
					[#list memberRanks as memberRank]
						${memberRank.name}: <input type="text" name="memberPrice_${memberRank.id}" class="text memberPrice" maxlength="16" style="width: 60px; margin-right: 6px;" disabled="disabled" />
					[/#list]
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.point")}:
				</th>
				<td>
					<input type="text" name="point" class="text" maxlength="9" title="${message("admin.product.pointTitle")}" />
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
							<option value="${brand.id}">
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
							<input type="checkbox" name="tagIds" value="${tag.id}" />${tag.name}
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
						<input type="checkbox" name="isList" value="true" checked="checked" />${message("Product.isList")}
						<input type="hidden" name="_isList" value="false" />
					</label>
					<label>
						<input type="checkbox" name="isTop" value="true" />${message("Product.isTop")}
						<input type="hidden" name="_isTop" value="false" />
					</label>
					<label>
						<input type="checkbox" name="isGift" value="true" />${message("Product.isGift")}
						<input type="hidden" name="_isGift" value="false" />
					</label>
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.memo")}:
				</th>
				<td>
					<input type="text" name="memo" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.keyword")}:
				</th>
				<td>
					<input type="text" name="keyword" class="text" maxlength="200" title="${message("admin.product.keywordTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.seoTitle")}:
				</th>
				<td>
					<input type="text" name="seoTitle" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.seoKeywords")}:
				</th>
				<td>
					<input type="text" name="seoKeywords" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Product.seoDescription")}:
				</th>
				<td>
					<input type="text" name="seoDescription" class="text" maxlength="200" />
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
					<input type="submit" class="button" value="${message("admin.common.submit")}" />
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back()" />
				</td>
			</tr>
		</table>
	</form>

<div id="dateStock" class="allBox">
	<div class="allMask"></div>
<div class="dialog_box" style="display: block; position: fixed; left: 50%; top: 30%; margin-left:-255px; margin-top:-122.5px;">	
	<div class="dialog_close" title="关闭">×</div>
	<div class="dialog_caption"></div>	
	<div class="dialog_content" style="overflow: visible; height: auto;">
	<div class="dialog_form_mid">	
	<div class="valid_price_caption"><strong>价格时间段设置</strong>
	<span class="form_new_notes form_error_notes" style="right:30px;">
	<i class="warn">i</i><span class="error">日库存模式</span></span></div>        	
	<div class="valid_date_price">        		
	<table class="input">        	
		<tbody>
			<tr>        				
			<td align="right">时间段&nbsp;</td>
			<td>
			<div>        						
			<label class="time_limit_unit time_limit_large" for="startDate_1">
			<i class="i_hour"></i>
			<input type="text" class="Wdate" onfocus="WdatePicker({readOnly:true,minDate:'${.now?string('yyyy-MM-dd')}'})" name="startDate" id="startDate_1"/>&nbsp;至&nbsp;</label>        						
			<label class="time_limit_unit time_limit_large" for="endDate_1"><i class="i_hour"></i>
			<input type="text" class="Wdate" onfocus="WdatePicker({readOnly:true,minDate:'#F{$dp.$D(\'startDate_1\',{d:0});}'})" name="endDate" id="endDate_1"/></label>        					
			</div>        				
			</td>        			
			</tr>        			
			<tr>        				
				<td align="right">星期&nbsp;</td>
				<td>
					<div class="idsOfWeek">
					<input type="checkbox" name="weeks" value="1" checked />一&nbsp;
					<input type="checkbox" name="weeks" value="2" checked />二&nbsp;
					<input type="checkbox" name="weeks" value="3" checked />三&nbsp;
					<input type="checkbox" name="weeks" value="4" checked />四&nbsp;
					<input type="checkbox" name="weeks" value="5" checked />五&nbsp;
					<input type="checkbox" name="weeks" value="6" checked />六&nbsp;
					<input type="checkbox" name="weeks" value="0" checked />七
					</div>
				</td>
			</tr>
			<tr>
			<td colspan="2">
			<table width="100%">        						
				<tbody>
					<tr>
						<td align="right">
							<label for="marketPrice_1"><span class="must_be">*</span>票面价&nbsp;</label>
						</td>        							
						<td><input type="text" class="input_medium" name="marketPrice_1" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="marketPrice_1"/>&nbsp;元</td>        							
						<td align="right" style="text-align:right;"><label for="stockNum_1"><span class="must_be">*</span>每日库存&nbsp;</label></td>        							
						<td><input type="text" value="9999" class="input_medium" name="stockNum_1" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="stockNum_1"/>&nbsp;张</td>        						</tr>        						
					<tr>        							
						<td align="right" style="text-align:right;"><label for="sellPrice_1"><span class="must_be">*</span>售卖价&nbsp;</label></td>        							
						<td><input type="text" class="input_medium" name="sellPrice_1" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="sellPrice_1"/>&nbsp;元</td>        							
						<td align="right" style="text-align:right;">
						<label for="minimum_1"><span class="must_be">*</span>最少购买&nbsp;</label></td>        							
						<td><input type="text" value="1" class="input_medium" name="minimum_1" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="minimum_1"/>&nbsp;张</td>        						</tr>        						
					<tr>        							
						<td align="right" id="settle-label"  style="text-align:right;">
						<label for="distPrice_1"><span class="must_be">*</span>结算价&nbsp;</label></td>        							
						<td id="settle-input">
						<input type="text" class="input_medium" name="distPrice_1" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="distPrice_1"/>&nbsp;元</td>        							
						<td align="right" style="text-align:right;" >
						<label for="maximum_1"><span class="must_be">*</span>最多购买&nbsp;</label></td>        							
						<td><input type="text" value="999" class="input_medium" name="maximum_1" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="maximum_1"/>&nbsp;张</td>        						</tr>
				</tbody>
			</table>        				
			</td>        			
			</tr>        		
		</tbody>
	</table>        	
	</div>
	</div>
	</div>
	<div class="dialog_do">
	<input type="button" style="margin:2px 5px;" class="btn btn_orange" value="保存"/>
	<input type="button" style="margin:2px 5px;" class="btn btn_gray" value="取消" /></div>
	</div>
	</div>
	
<div id="totalStock" class="allBox">
	<div class="allMask"></div>
<div class="dialog_box" style="display: block; position: fixed; left: 50%; top: 30%; margin-left:-255px; margin-top:-122.5px;">	
	<div class="dialog_close" title="关闭">×</div>
	<div class="dialog_caption"></div>	
	<div class="dialog_content" style="overflow: visible; height: auto;">
	<div class="dialog_form_mid">	
	<div class="valid_price_caption"><strong>价格时间段设置</strong>
	<span class="form_new_notes form_error_notes" style="right:30px;">
	<i class="warn">i</i><span class="error">总库存模式</span></span></div>        	
	<div class="valid_date_price">        		
	<table class="input">        	
		<tbody>
			<tr>        				
			<td align="right">时间段&nbsp;</td>
			<td>
			<div>        						
			<label class="time_limit_unit time_limit_large" for="startDate">
			<i class="i_hour"></i>
			<input type="text" class="Wdate" onfocus="WdatePicker({readOnly:true,minDate:'${.now?string('yyyy-MM-dd')}'})" name="startDate" id="startDate_2"/>&nbsp;至&nbsp;</label>        						
			<label class="time_limit_unit time_limit_large" for="endDate"><i class="i_hour"></i>
			<input type="text" class="Wdate" onfocus="WdatePicker({readOnly:true,minDate:'#F{$dp.$D(\'startDate_2\',{d:0});}'})" name="endDate" id="endDate_2"/></label>        					
			</div>        				
			</td>        			
			</tr>       
			<!-- 		
			<tr>        				
				<td align="right">星期&nbsp;</td>
				<td>
					<div class="idsOfWeek">        						
					<input type="checkbox" name="weeks" value="1" checked />一&nbsp;
					<input type="checkbox" name="weeks" value="2" checked />二&nbsp;
					<input type="checkbox" name="weeks" value="3" checked />三&nbsp;
					<input type="checkbox" name="weeks" value="4" checked />四&nbsp;
					<input type="checkbox" name="weeks" value="5" checked />五&nbsp;
					<input type="checkbox" name="weeks" value="6" checked />六&nbsp;
					<input type="checkbox" name="weeks" value="0" checked />七     					
					</div>        				
				</td>        			
			</tr>
			 --> 	
			<tr>        	
			<td colspan="2">        					
			<table width="100%">        						
				<tbody>
					<tr>
						<td align="right">
							<label for="marketPrice_2"><span class="must_be">*</span>票面价&nbsp;</label>
						</td>        							
						<td><input type="text" class="input_medium" name="marketPrice_2" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="marketPrice_2"/>&nbsp;元</td>        							
						<td align="right" style="text-align:right;"><label for="stockNum_2"><span class="must_be">*</span>整体库存&nbsp;</label></td>        							
						<td><input type="text" value="9999" class="input_medium" name="stockNum_2" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="stockNum_2"/>&nbsp;张</td>        						</tr>        						
					<tr>        							
						<td align="right" style="text-align:right;"><label for="sellPrice_2"><span class="must_be">*</span>售卖价&nbsp;</label></td>        							
						<td><input type="text" class="input_medium" name="sellPrice_2" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="sellPrice_2"/>&nbsp;元</td>        							
						<td align="right" style="text-align:right;">
						<label for="minimum_2"><span class="must_be">*</span>最少购买&nbsp;</label></td>        							
						<td><input type="text" value="1" class="input_medium" name="minimum_2" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="minimum_2"/>&nbsp;张</td>        						</tr>        						
					<tr>        							
						<td align="right" id="settle-label"  style="text-align:right;">
						<label for="distPrice_2"><span class="must_be">*</span>结算价&nbsp;</label></td>        							
						<td id="settle-input">
						<input type="text" class="input_medium" name="distPrice_2" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="distPrice_2"/>&nbsp;元</td>       							
						<td align="right" style="text-align:right;" >
						<label for="maximum_2"><span class="must_be">*</span>最多购买&nbsp;</label></td>        							
						<td><input type="text" value="999" class="input_medium" name="maximum_2" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="maximum_2"/>&nbsp;张</td>        						</tr>
				</tbody>
			</table>        				
			</td>        			
			</tr>        		
		</tbody>
	</table>    
	[#--
	<div class="valid_price_caption"><strong>不可使用日期</strong> <a href="#">清除所有不可用日期</a></div>
	<div id="cannotUseDateDiv" style="text-align: center;"></div>
	--]
	</div>
	</div>
	</div>
	<div class="dialog_do">
	<input type="button" style="margin:2px 5px;" class="btn btn_orange" value="保存"/>
	<input type="button" style="margin:2px 5px;" class="btn btn_gray" value="取消" /></div>
	</div>
</div>

<div id="unstock" class="allBox">
	<div class="allMask"></div>
<div class="dialog_box" style="display: block; position: fixed; left: 50%; top: 30%; margin-left:-255px; margin-top:-122.5px;">	
	<div class="dialog_close" title="关闭">×</div>
	<div class="dialog_caption"></div>	
	<div class="dialog_content" style="overflow: visible; height: auto;">
	<div class="dialog_form_mid">	
	<div class="valid_price_caption"><strong>下架时间段设置</strong></div>        	
	<div class="valid_date_price">        		
	<table class="input">        	
		<tbody>
			<tr>        				
			<td align="right">时间段&nbsp;</td>
			<td>
			<div>        						
			<label class="time_limit_unit time_limit_large" for="startDate">
			<i class="i_hour"></i>
			<input type="text" class="Wdate" onfocus="WdatePicker({readOnly:true})" name="startDate" id="startDate_3"/>&nbsp;至&nbsp;</label>        						
			<label class="time_limit_unit time_limit_large" for="endDate"><i class="i_hour"></i>
			<input type="text" class="Wdate" onfocus="WdatePicker({readOnly:true,minDate:'#F{$dp.$D(\'startDate_2\',{d:0});}'})" name="endDate" id="endDate_3"/></label>        					
			</div>        				
			</td>        			
			</tr>
			<tr>        				
				<td align="right">星期&nbsp;</td>
				<td>
					<div class="idsOfWeek">        						
					<input type="checkbox" name="weeks" value="1" checked />一&nbsp;
					<input type="checkbox" name="weeks" value="2" checked />二&nbsp;
					<input type="checkbox" name="weeks" value="3" checked />三&nbsp;
					<input type="checkbox" name="weeks" value="4" checked />四&nbsp;
					<input type="checkbox" name="weeks" value="5" checked />五&nbsp;
					<input type="checkbox" name="weeks" value="6" checked />六&nbsp;
					<input type="checkbox" name="weeks" value="0" checked />七     					
					</div>        				
				</td>        			
			</tr>
		</tbody>
	</table>    
	</div>
	</div>
	</div>
	<div class="dialog_do">
	<input type="button" style="margin:2px 5px;" class="btn btn_orange" value="确定"/>
	<input type="button" style="margin:2px 5px;" class="btn btn_gray" value="取消" /></div>
	</div>
</div>
<script type="text/javascript">
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
</script>
<script type="text/javascript" src="${base}/resources/admin/js/calendarprice.js?20151223"></script>
</body>
</html>