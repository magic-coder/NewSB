[#assign shiro=JspTaglibs["/WEB-INF/tld/shiro.tld"] /]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>${message("admin.product.list")}</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
<script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
<style type="text/css">
.promotion {
	color: #cccccc;
}
.synchro_prompt{
	color:#81d8fc;
	border:solid 1px #81d8fc;
	display: inline-block;
}
</style>
<script type="text/javascript">
$().ready(function() {

	var $listForm = $("#listForm");
	var $moreButton = $("#moreButton");
	var $filterSelect = $("#filterSelect");
	var $filterOption = $("#filterOption a");
	
	[@flash_message /]
	
	//编辑
	$(".but").click(function() {
		if($("tr").hasClass("selected") && $(".selected").length == 1){
			var val = $(".selected > td > input").val();
			location.href="edit.jhtml?id="+val;
		}else{
			alert("你还未选中记录或选择了多条记录");
			return false;
		}
	});
	
	//编辑
	$("#copyButton").click(function() {
		if($("tr").hasClass("selected") && $(".selected").length == 1){
			var val = $(".selected > td > input").val();
			$.dialog({
				type: "warn",
				content: "确定要复制选中产品？",
				onOk: function() {
					$.ajax({
						url: "copy.jhtml",
						type: "POST",
						data: {id:val},
						dataType: "json",
						cache: false,
						success: function(message) {
							$.message(message);
							if (message.type == "success") {
								location.reload(true);
							}
						}
					});
				}
			});
		}else{
			$(".but").attr("href","javascript:;");
			alert("您未选或选择了多个！");
		}
	});
	
	// 商品筛选
	$filterSelect.mouseover(function() {
		var $this = $(this);
		var offset = $this.offset();
		var $menuWrap = $this.closest("div.menuWrap");
		var $popupMenu = $menuWrap.children("div.popupMenu");
		$popupMenu.css({left: offset.left, top: offset.top + $this.height() + 2}).show();
		$menuWrap.mouseleave(function() {
			$popupMenu.hide();
		});
	});
	
	// 筛选选项
	$filterOption.click(function() {
		var $this = $(this);
		var $dest = $("#" + $this.attr("name"));
		if ($this.hasClass("checked")) {
			$dest.val("");
		} else {
			$dest.val($this.attr("val"));
		}
		$listForm.submit();
		return false;
	});
	[#--
	$("#addSelect").mouseover(function() {
		var $this = $(this);
		var offset = $this.offset();
		var $menuWrap = $this.closest("div.menuWrap");
		var $popupMenu = $menuWrap.children("div.popupMenu");
		$popupMenu.css({left: offset.left, top: offset.top + $this.height() + 2}).show();
		$menuWrap.mouseleave(function() {
			$popupMenu.hide();
		});
	});
	
	$("#addSelectOption a").click(function() {
		var $this = $(this);
		location.href="add.jhtml?productCategoryId="+$this.attr("val");
		return false;
	});--]

	//上架
	$("#shelvesButton").click(function() {
		if($("tr").hasClass("selected") && $(".selected > td > span").hasClass("falseIcon")){
			//var val = $(".selected > td > input").val();
			var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
			$.dialog({
				type: "warn",
				content: "确定要上架选中产品？",
				onOk: function() {
					$.ajax({
						url: "shelves.jhtml",
						type: "POST",
						data: $checkedIds.serialize(),
						dataType: "json",
						cache: false,
						success: function(message) {
							$.message(message);
							if (message.type == "success") {
								location.reload(true);
							}
						}
					});
				}
			});
			return false;
		}else{
			alert("您未选中记录! / 此产品已上架!");
		}
		
	});
	
	
	//下架
	$("#underButton").click(function() {
		if($("tr").hasClass("selected") && $(".selected > td > span").hasClass("trueIcon")){
			//var val = $(".selected > td > input").val();
			var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
			$.dialog({
				type: "warn",
				content: "确定要下架选中产品？",
				onOk: function() {
					$.ajax({
						url: "under.jhtml",
						type: "POST",
						data: $checkedIds.serialize(),
						dataType: "json",
						cache: false,
						success: function(message) {
							$.message(message);
							if (message.type == "success") {
								location.reload(true);
							}
						}
					});
				}
			});
			return false;
		}else{
			alert("您未选中记录! / 此产品已下架!");
		}
		
	});
	
	//推荐
	$("#recommenButton").click(function() {
		if($("tr").hasClass("selected") && $(".selected > td > span").hasClass("trueIcon")){
			//var val = $(".selected > td > input").val();
			var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
			/* $.ajax({
				url: "../recommen/add.jhtml?"+$checkedIds.serialize(),
				type: "GET",
				cache: false,
				success: function(message) {
					$.dialog({
						title: "推荐",
						content: message,
						width: 500,
						modal: true,
						ok: "${message("admin.dialog.ok")}",
						cancel: "${message("admin.dialog.cancel")}",
						onClose: function() {
							$("#recommenForm").remove();
						},
						onOk: function(){
							$("#recommenForm").submit();
							//return false;
						}
					});
				}
			}); */
			$.dialog({
				type: "warn",
				content: "确定要推荐选中产品？",
				onOk: function() {
					$.ajax({
						url: "../recommen/save.jhtml?"+$checkedIds.serialize(),
						type: "POST",
						success: function(message) {
							alert("成功");
							/* setTimeout(function() {
									location.reload(true);
								}, 1000); */
						}
					});
				}
			});
			return false;
		}else{
			alert("您未选中记录!");
		}
	});
	
	//美团推送产品
	$("#pushLvProductListButton").click(function() {
		if($("tr").hasClass("selected") && $(".selected").length != 0){
			var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
			$.dialog({
				type: "warn",
				content: "确定要推送选中产品？",
				onOk: function() {
					$.ajax({
						url: "../../open/meituan/pushLvProductList.jhtml",
						type: "POST",
						data: $checkedIds.serialize()+"&id=${principal.id}",
						dataType: "json",
						cache: false,
						success: function(message) {
							$.message(message);
							if (message.type == "success") {
								location.reload(true);
							}
						}
					});
				}
			});
			return false;
		}else{
			alert("您未选中记录!");
		}
	});
	
	$("a[name='noticeLvProductChanged']").click(function() {
		var status = $(this).attr("alt"); 
		if($("tr").hasClass("selected") && $(".selected").length != 0){
			var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
			$.dialog({
				type: "warn",
				content: "确定更新美团产品状态？",
				onOk: function() {
					$.ajax({
						url: "../../open/meituan/noticeLvProductChanged.jhtml",
						type: "POST",
						data: $checkedIds.serialize()+"&status="+status+"&id=${principal.id}",
						dataType: "json",
						cache: false,
						success: function(message) {
							$.message(message);
							if (message.type == "success") {
								location.reload(true);
							}
						}
					});
				}
			});
			return false;
		}else{
			alert("您未选中记录!");
		}
	});
	
	[#if principal.id == "106458"]
	$("a[name='newnoticeLvProductChanged']").click(function() {
		var status = $(this).attr("alt"); 
		if($("tr").hasClass("selected") && $(".selected").length != 0){
			var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
			$.dialog({
				type: "warn",
				content: "确定更新美团产品状态？",
				onOk: function() {
					$.ajax({
						url: "../../open/newmeituan/noticeLvProductChanged.jhtml",
						type: "POST",
						data: $checkedIds.serialize()+"&status="+status+"&id=${principal.id}",
						dataType: "json",
						cache: false,
						success: function(message) {
							$.message(message);
							if (message.type == "success") {
								location.reload(true);
							}
						}
					});
				}
			});
			return false;
		}else{
			alert("您未选中记录!");
		}
	});
	[/#if]
	
	<@shiro.hasPermission name = "admin:noticeTuniuUpdatePriceInfo"]
	$("a[name='noticeTuniuUpdatePriceInfo']").click(function() {
		if($("tr").hasClass("selected") && $(".selected").length != 0){
			var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
			$.dialog({
				type: "warn",
				content: "确定更新途牛价格信息？",
				onOk: function() {
					$.ajax({
						url: "../../open/tuniu/updatePriceInfo.do",
						type: "POST",
						data: $checkedIds.serialize()+"&uid=${principal.id}",
						dataType: "json",
						cache: false,
						success: function(message) {
							alert(message.errorMsg);
							if (message.success == true) {
								location.reload(true);
							}
						}
					});
				}
			});
			return false;
		}else{
			alert("您未选中记录!");
		}
	});
	</@shiro.hasPermission>
	<@shiro.hasPermission name = "admin:offLineTuniuPriceInfo"]
	$("a[name='offLineTuniuPriceInfo']").click(function() {
		if($("tr").hasClass("selected") && $(".selected").length != 0){
			var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
			$.dialog({
				type: "warn",
				content: "确定关闭途牛价格信息？",
				onOk: function() {
					$.ajax({
						url: "../../open/tuniu/offLinePriceInfo.do",
						type: "POST",
						data: $checkedIds.serialize()+"&uid=${principal.id}",
						dataType: "json",
						cache: false,
						success: function(message) {
							alert(message.errorMsg);
							if (message.success == true) {
								location.reload(true);
							}
						}
					});
				}
			});
			return false;
		}else{
			alert("您未选中记录!");
		}
	});
	</@shiro.hasPermission>
});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			产品列表
	</div>
	</div>
	<form id="listForm" action="list.jhtml" method="get">
	<input type="hidden" name="f" value="${f}" />
		<div class="bar">
			<input type="text" name="productName" value="${productName}" placeholder="产品名称" style="width: 180px;" />
			<input type="text" name="productSn" value="${productSn}" placeholder="产品ID" />
			<input type="text" name="distName" value="${distName}" placeholder="目的地名称" />
			
			[#--<input type="text" name="supplierName" value="${supplierName}" placeholder="供应商名称" />--]
			<input type="text" name="areaName" placeholder="地区" value="${areaName}" />
			<input type="text" class="text Wdate" name="expire" onclick="WdatePicker()" placeholder="到期时间" value="${expire}"/>
			<input type="text" name="stock" placeholder="库存少于" value="${stock}" />
			<br/>
			<select name="productCategoryId">
				<option value="">--${message("Product.productCategory")}--</option>
				[#list productCategoryTree as productCategory]
					<option value="${productCategory.id}"[#if productCategory.id == productCategoryId] selected="selected"[/#if]>
						[#if productCategory.grade != 0]
							[#list 1..productCategory.grade as i]
								&nbsp;&nbsp;
							[/#list]
						[/#if]
						${productCategory.name}
					</option>
				[/#list]
			</select>
			<select name="isMarketable">
				<option value="">--是否上架--</option>
				<option value="true"[#if isMarketable?? && isMarketable == 'true'] selected[/#if]>已上架</option>
				<option value="false"[#if needReserve?? && isMarketable == 'false'] selected[/#if]>未上架</option>
			</select>
			<select name="needReserve">
				<option value="">--是否需要预定--</option>
				<option value="true"[#if needReserve?? && needReserve == 'true'] selected[/#if]>需要</option>
				<option value="false"[#if needReserve?? && needReserve == 'false'] selected[/#if]>不需要</option>
			</select>
			<select name="smsThemeId">
				<option value="">--发货方式--</option>
				[#list smsTheme as dto]
					<option value="${dto.id}"[#if smsThemeId == dto.id] selected="selected"[/#if]>${dto.title}</option>
				[/#list]
			</select>
			<select name="paymentType">
				<option value="">--支付方式--</option>
				<option value="PREPAY"[#if paymentType == 'PREPAY'] selected="selected"[/#if]>在线支付</option>
				<option value="COLLECTPAY"[#if paymentType == 'COLLECTPAY'] selected="selected"[/#if]>景区支付</option>
			</select>
			<button type="submit" class="button">查询</button>
			<button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
			[#--
			<input type="text" name="startPrice" value="${startPrice}" style="width: 60px;" placeholder="最低价格" /> - 
			<input type="text" name="endPrice" value="${endPrice}" style="width: 60px;" placeholder="最高价格" />
			
		  更多筛选
			<select name="productCategoryId">
				<option value="">${message("Product.productCategory")}</option>
				[#list productCategoryTree as productCategory]
					<option value="${productCategory.id}"[#if productCategory.id == productCategoryId] selected="selected"[/#if]>
						[#if productCategory.grade != 0]
							[#list 1..productCategory.grade as i]
								&nbsp;&nbsp;
							[/#list]
						[/#if]
						${productCategory.name}
					</option>
				[/#list]
			</select>
		--]
		</div>
		[#--
		<input type="hidden" id="productCategoryId" name="productCategoryId" value="${productCategoryId}" />
		<input type="hidden" id="brandId" name="brandId" value="${brandId}" />
		<input type="hidden" id="promotionId" name="promotionId" value="${promotionId}" />
		<input type="hidden" id="tagId" name="tagId" value="${tagId}" />
		--]
		<div class="bar">
			<@shiro.hasPermission name = "admin:addProduct"]
			<div class="menuWrap">
				<a href="add.jhtml?productCategoryId=86" id="addSelect" class="button">
					新建门票
				</a>
			</div>
			</@shiro.hasPermission>
						
			<@shiro.hasPermission name = "admin:deleteProduct"]
			<a href="javascript:;" id="deleteButton" class="button">
				${message("admin.common.delete")}
			</a>
			</@shiro.hasPermission>
			
			<@shiro.hasPermission name = "admin:topProduct"]
			<a href="javascript:;" id="shelvesButton" class="button">
				上架
			</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:underProduct"]
			<a href="javascript:;" id="underButton" class="button">
				下架
			</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:copyProduct"]
			<a href="javascript:;" id="copyButton" class="button">
				复制
			</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:addRecommen"]
			<a href="javascript:;" id="recommenButton" class="button">
				推荐
			</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:meituanPushProduct"]
			<a href="javascript:;" id="pushLvProductListButton" class="button">
				美团推送产品
			</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:meituanNoticeProduct0"]
			<a href="javascript:;" name="noticeLvProductChanged" class="button" alt="0">
				美团下架产品
			</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:meituanNoticeProduct1"]
			<a href="javascript:;" name="noticeLvProductChanged" class="button" alt="1">
				美团上架产品
			</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:meituanNoticeProduct2"]
			<a href="javascript:;" name="noticeLvProductChanged" class="button" alt="2">
				美团更新产品
			</a>
			</@shiro.hasPermission>
			[#if principal.id == "106458"]
				<a href="javascript:;" name="newnoticeLvProductChanged" class="button" alt="5">
					通知美团产品的价格日历变化
				</a>
				<a href="javascript:;" name="newnoticeLvProductChanged" class="button" alt="0">
					美团下架产品
				</a>
					<a href="javascript:;" name="newnoticeLvProductChanged" class="button" alt="1">
					美团上架产品
				</a>
				<a href="javascript:;" name="newnoticeLvProductChanged" class="button" alt="2">
					美团更新产品
				</a>
			[/#if]
			<@shiro.hasPermission name = "admin:noticeTuniuUpdatePriceInfo"]
			<a href="javascript:;" name="noticeTuniuUpdatePriceInfo" class="button" alt="2">
				更新途牛门票价格
			</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:offLineTuniuPriceInfo"]
			<a href="javascript:;" name="offLineTuniuPriceInfo" class="button" alt="2">
				关闭途牛团期
			</a>
			</@shiro.hasPermission>
			
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					<a href="javascript:;" class="sort" name="name">产品名称(产品ID)</a>
				</th>
				<th>
					<span>票型</span>
				</th>
				[@shiro.hasRole name="distributor"]
				<th>
					<span>结算价</span>
				</th>
				[/@shiro.hasRole]
				[@shiro.lacksRole name="distributor"]
				<th>
					<a href="javascript:;" class="sort" name="sales">销量</a>
				</th>
				[/@shiro.lacksRole]
				<th>
					<a href="javascript:;" class="sort" name="company">目的地</a>
				</th>[#--
				<th>
					<a href="javascript:;" class="sort" name="supplier">供应商</a>
				</th>--]
				<th>
					<a href="javascript:;" class="sort" name="isMarketable">${message("Product.isMarketable")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="createDate">${message("admin.common.createDate")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="operator">添加人</a>
				</th>
				<th>
					<span>${message("admin.common.handle")}</span>
				</th>
			</tr>
			[#list page.content as product]
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${product.id}" />
					</td>
					<td>
						[#if product.productSource?? && product.productSource != 'local']
						<span class="synchro_prompt">接口</span>
						[/#if]
						[${product.productCategory.name}]
						
						[#if principal.role == 'distributor']
						<span title="${product.fullName}">
							${abbreviate(product.fullName, 30, "...")}
						</span>
						[#else]
						<a href="view.jhtml?id=${product.id}">
						<span title="${product.fullName}">
							${abbreviate(product.fullName, 30, "...")}
						</span>
						</a>
						[/#if]
						
						[#list product.validPromotions as promotion]
							<span class="promotion">${promotion.name}</span>
						[/#list]
						(${product.id})
						[@shiro.lacksRole name="distributor"]
						[#if product.supplierAuth]
						<span class="synchro_prompt">授</span>
						[/#if]
						[/@shiro.lacksRole]
					</td>
					<td>
					[#if product.companyType??]
						[${product.companyType}]
					[/#if]
					</td>
					[@shiro.hasRole name="distributor"]
					<td>
						[#assign isDist = false]
						[#if product.distributions?size gt 0]
						[#assign distPrice = product.distributions[0].authPrice]
						[#assign isDist = true]
						[#else]
						[#assign distPrice = product.distPrice]
						[/#if]
						[#if distPrice =='']
						-
						[#else]
						${currency(distPrice)}
						[/#if]
					</td>
					[/@shiro.hasRole]
					[@shiro.lacksRole name="distributor"]
					<td>
						<a href="../order/list.jhtml?productSn=${product.id}">${product.sales}</a>
					</td>
					[/@shiro.lacksRole]
					<td>
						${product.company.name}
					</td>
					[#--<td>
						${product.supplier.username}
					</td>--]
					<td>
						<span class="${product.isMarketable?string("true", "false")}Icon">&nbsp;</span>
					</td>
					<td>
						<span title="${product.createDate?string("yyyy-MM-dd HH:mm:ss")}">${product.createDate}</span>
					</td>
					<td>
						${product.operator.username}
					</td>
					<td>
					<@shiro.hasPermission name = "admin:editProduct"]
						<a href="edit.jhtml?id=${product.id}">[${message("admin.common.edit")}]</a>
					</@shiro.hasPermission>
						[#if product.isMarketable]
							<@shiro.hasPermission name="admin:productQrcode"]
							<a href="../product_qrcode/add.jhtml?productId=${product.id}">[二维码]</a>
							</@shiro.hasPermission>
						[/#if]
					</td>
				</tr>
			[/#list]
		</table>
		[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
			[#include "/admin/include/pagination.ftl"]
		[/@pagination]
	</form>
</body>
</html>