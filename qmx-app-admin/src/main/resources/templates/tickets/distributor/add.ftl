[#assign shiro=JspTaglibs["/WEB-INF/tld/shiro.tld"] /]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>${message("admin.admin.add")}</title>
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
	padding-right: 6px;
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
			username: {
				required: true,
				pattern: /^[0-9a-z_A-Z]+$/,
				minlength: 2,
				maxlength: 20,
				remote: {
					url: "check_username.jhtml",
					cache: false
				}
			},
			password: {
				required: true,
				pattern: /^[^\s&\"<>]+$/,
				minlength: 4,
				maxlength: 20
			},
			rePassword: {
				required: true,
				equalTo: "#password"
			},
			balance: {
				required: true,
				min: 0,
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
			username: {
				pattern: "${message("admin.validate.usernameillegal")}",
				remote: "${message("admin.validate.exist")}"
			},
			password: {
				pattern: "${message("admin.validate.illegal")}"
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
			添加分销商
	    </div>
	</div>
	<form id="inputForm" action="save.jhtml" method="post">
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
					<span class="requiredField">*</span>${message("Admin.username")}:
				</th>
				<td>
					<input type="hidden" name="authorities" id="distauth" value="xx"/>
					<input type="text" name="username" class="text" maxlength="20" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Admin.password")}:
				</th>
				<td>
					<input type="password" id="password" name="password" class="text" maxlength="20" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.admin.rePassword")}:
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
					<input type="text" name="name" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>手机号码:
				</th>
				<td>
					<input type="text" name="mobile" class="text" maxlength="11" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Admin.email")}:
				</th>
				<td>
					<input type="text" name="email" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th><span class="requiredField">*</span>默认订单来源:</th>
				<td>
					<select name="orderSourceId">
						<option value="">${message("admin.common.choose")}</option>
						[#list orderSources as orderSource]
						<option value="${orderSource.id}">${orderSource.name}</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr>
				<th><span class="requiredField">*</span>默认支付方式:</th>
				<td>
					<select name="paymentMethodId">
						<option value="">${message("admin.common.choose")}</option>
						[#list paymentMethods as paymentMethod]
						[#if paymentMethod.isEnable]
						<option value="${paymentMethod.id}">${paymentMethod.name}</option>
						[/#if]
						[/#list]
					</select>
					<span class="tips">请谨慎选择</span>
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.setting")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isEnabled" value="true" checked="checked" />${message("Admin.isEnabled")}
						<input type="hidden" name="_isEnabled" value="false" />
					</label>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>地区:
				</th>
				<td>
					<span class="fieldSet">
						<input type="hidden" id="areaId" name="areaId" />
					</span>
				</td>
			</tr>
			
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
			[#include "/admin/addauthorities.ftl"]
		</table>
		
		[#include "/admin/addinterface.ftl"]
		
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