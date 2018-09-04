[#assign shiro=JspTaglibs["/WEB-INF/tld/shiro.tld"] /]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>${message("admin.admin.edit")}</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/dropdown/dropdown.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropdown.js"></script>
<script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropqtable.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<style type="text/css">
.roles label {
	width: 150px;
	display: block;
	float: left;
	padding-right: 5px;
}
</style>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $selectAll = $("#inputForm .selectAll");
	var $areaId = $("#areaId");
	
	[@flash_message /]
	
	// 地区选择
	$areaId.lSelect({
		url: "${base}/admin/common/area.jhtml"
	});
	
	$selectAll.click(function() {
		var $this = $(this);
		var $thisCheckbox = $this.closest("tr").find(":checkbox");
		if ($thisCheckbox.filter(":checked").size() > 0) {
			$thisCheckbox.prop("checked", false);
		} else {
			$thisCheckbox.prop("checked", true);
		}
		return false;
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			password: {
				pattern: /^[^\s&\"<>]+$/,
				minlength: 4,
				maxlength: 20
			},
			rePassword: {
				equalTo: "#password"
			},
			modifyBalance: {
				min: -${admin.balance},
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			},
			/* email: {
				required: true,
				email: true
			}, */
			name: "required",
			role: "required",
			method: "required",
			areaId: {
				required: true
			},
			orderSourceId: {
				required: true
			},
			paymentMethodId: {
				required: true
			},
			supplierId: {
				required: true
			},
			mobile: {
				isMobile: true,
				required: true
			}
		},
		messages: {
			password: {
				pattern: "${message("admin.validate.illegal")}"
			}
		}
	});
	
	$("#supplierName").dropqtable({
		vinputid: "supplierId", //值所存放的区域
		dropwidth: "auto", //下拉层的宽度
		selecteditem: { text: "${admin.supplier.name}", value: "${admin.supplier.id}" }, //默认值
		tableoptions: {
			//autoload: true,
			url: "getSupplier.jhtml", //查询响应的地址
			qtitletext: "请输入供应商名称", //查询框的默认文字  
			textField: 'trueName',
			valueField: 'id',
			colmodel: [
			           { name: "name", displayname: "姓名", width: "100px" }, //表格定义
			           { name: "username", displayname: "账号", width: "150px" }
			],
			onSelect:function(selected){
	        	$("#supplierId").val(selected.id);
	        	$("#supplierName").val(selected.name);
			}
		}
	});
	

	 var dis = ['admin:announcement','admin:productQrcode','admin:product','admin:order','admin:addOrder','admin:editOrder','admin:paymentOrder','admin:viewOrder','admin:refundsOrder','admin:shippingOrder','admin:exportOrder','admin:refunds','admin:eticket','admin:eticketExport','admin:customer','admin:smslog','admin:distributor','admin:addDistributor','admin:editDistributor','admin:rechargeDistributor','admin:authorizeDistributor','admin:addAuthorize','admin:deleteAuthorize','admin:deposit','admin:mydeposit','admin:walletdeposit','admin:statistics','admin:sales','admin:totalsales','admin:distributorStatistics'];
	 var dis_h = ['admin:announcement','admin:productQrcode','admin:product','admin:order','admin:addOrder','admin:editOrder','admin:paymentOrder','admin:viewOrder','admin:refundsOrder','admin:shippingOrder','admin:exportOrder','admin:eticket','admin:eticketExport','admin:customer','admin:smslog','admin:deposit','admin:mydeposit','admin:walletdeposit','admin:statistics','admin:totalsales','admin:sales'];
	 
	 
	 $("input[name='isONE']").click(function(){
		
		$("input[name='isNOT']").removeAttr("checked");
		$("input[name='authorities']").removeAttr("checked");
		$("input[name='authorities']").removeAttr("disabled");
		
		$.each(dis,function(name,value) {  
			$("input[name='authorities']").each(function() {
				if(value == this.value){
					$(this).attr("checked", true);
				}
	   		});
		})
			
		$("input[name='authorities']").each(function() {
			 if (this.checked == false) {
	           $(this).attr("disabled", "disabled");
	       }
		});
	});	
	 
	 $("input[name='isNOT']").click(function(){
		
		$("input[name='isONE']").removeAttr("checked");
		$("input[name='authorities']").removeAttr("checked");
		$("input[name='authorities']").removeAttr("disabled");
		
		$.each(dis_h,function(name,value) {  
			$("input[name='authorities']").each(function() {
				if(value == this.value){
					$(this).attr("checked", true);
				}
	   		});
		})
			
		$("input[name='authorities']").each(function() {
			 if (this.checked == false) {
	           $(this).attr("disabled", "disabled");
	       }
		});
	});	
	  
});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			编辑分销商
	    </div>
	</div>
	<form id="inputForm" action="update.jhtml" method="post">
		<input type="hidden" name="id" value="${admin.id}" />
		<ul id="tab" class="tab">
			<li>
				<input type="button" value="基本信息" />
			</li>
			[@shiro.hasRole name = "manager"]
			<li>
				<input type="button" value="扩展信息" />
			</li>
			[/@shiro.hasRole]
		</ul>
		<table class="input tabContent">
			<tr>
				<th>
					${message("Admin.username")}:
				</th>
				<td>
				<input type="hidden" name="authorities" id="distauth" value="xx"/>
					${admin.username}
				</td>
			</tr>
			<tr>
				<th>
					${message("Admin.password")}:
				</th>
				<td>
					<input type="password" id="password" name="password" class="text" maxlength="20" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.admin.rePassword")}:
				</th>
				<td>
					<input type="password" name="rePassword" class="text" maxlength="20" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Admin.name")}:
				</th>
				<td>
					<input type="text" name="name" class="text" value="${admin.name}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>手机号码:
				</th>
				<td>
					<input type="text" name="mobile" class="text" value="${admin.mobile}" maxlength="11" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Admin.email")}:
				</th>
				<td>
					<input type="text" name="email" class="text" value="${admin.email}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th><span class="requiredField">*</span>默认订单来源:</th>
				<td><select name="orderSourceId">
						<option value="">${message("admin.common.choose")}</option> [#list
						orderSources as orderSource]
						<option value="${orderSource.id}" [#if admin.orderSource==orderSource] selected[/#if]>${orderSource.name}</option>
						[/#list]
				</select></td>
			</tr>
			<input name="apiPlat" type="hidden" value="${admin.apiPlat}"/>
			<tr>
				<th><span class="requiredField">*</span>默认支付方式:</th>
				<td><select name="paymentMethodId">
						<option value="">${message("admin.common.choose")}</option> [#list
						paymentMethods as paymentMethod]
						[#if paymentMethod.isEnable]
						<option value="${paymentMethod.id}" [#if admin.paymentMethod==paymentMethod] selected[/#if]>${paymentMethod.name}</option>
						[/#if]
						[/#list]
				</select> <span class="tips">请谨慎选择</span></td>
			</tr>
			
			<tr>
				<th>
					${message("admin.common.setting")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isEnabled" value="true"[#if admin.isEnabled] checked="checked"[/#if] />${message("Admin.isEnabled")}
						<input type="hidden" name="_isEnabled" value="false" />
					</label>
					[#if admin.isLocked]
						<label>
							<input type="checkbox" name="isLocked" value="true" checked="checked" />${message("Admin.isLocked")}
							<input type="hidden" name="_isLocked" value="false" />
						</label>
					[/#if]
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>地区:
				</th>
				<td>
					<span class="fieldSet">
						<input type="hidden" id="areaId" name="areaId" value="${(admin.area.id)!}" treePath="${(admin.area.treePath)!}" />
					</span>
				</td>
			</tr>
			[#--
			<tr>
				<th>
					<span class="requiredField">*</span>下单支付方式:
				</th>
				<td>
					<select name="method">
						<option value=""></option>
						<option value="deposit"[#if admin.method=='deposit'] selected[/#if]>预存款</option>
					</select>
					<span class="tips">默认已开通钱包支付</span>
				</td>
			</tr>
			--]
			<tr>
				<td colspan="2">
					&nbsp;
				</td>
			</tr>
			
			<tr>
				<th>
					默认权限:
				</th>
			[@shiro.hasRole name="distributor"]
				<td>
					<input type="checkbox" name="isNOT"/>分销商
				</td>
			[/@shiro.hasRole]
			[@shiro.lacksRole name="distributor"]
				<td>
					<input type="checkbox" name="isONE"/>一级分销商
					<input type="checkbox" name="isNOT"/>二级分销商
				</td>
			[/@shiro.lacksRole]
			</tr>
			
			[#include "/admin/editauthorities.ftl"]
		</table>
		
		[#include "/admin/editinterface.ftl"]
		
		<table class="input">
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="${message("admin.common.submit")}" />
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back();" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>