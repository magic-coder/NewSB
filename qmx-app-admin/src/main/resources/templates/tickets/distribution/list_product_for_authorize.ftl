<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>${message("admin.product.list")}</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
<style type="text/css">
.moreTable th {
	width: 80px;
	line-height: 25px;
	padding: 5px 10px 5px 0px;
	text-align: right;
	font-weight: normal;
	color: #333333;
	background-color: #f8fbff;
}

.moreTable td {
	line-height: 25px;
	padding: 5px;
	color: #666666;
}

.promotion {
	color: #cccccc;
}
</style>
<script type="text/javascript">
$().ready(function() {

	var $listForm = $("#listForm");
	var $moreButton = $("#moreButton");
	var $filterSelect = $("#filterSelect");
	var $filterOption = $("#filterOption a");
	
	[@flash_message /]
	
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

});
</script>
</head>
<body>
	<form id="listForm" method="get">
		<div class="bar">
			<select name="productCategoryId" class="text">
				<option value="">${message("admin.common.choose")}</option>
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
			<div class="menuWrap">
				<select name="searchProperty">
					<option value="name"[#if page.searchProperty == "name"] selected[/#if]>${message("Product.name")}</option>
					<option value="id"[#if page.searchProperty == "id"] selected[/#if]>产品ID</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" style="width: 140px" value="${page.searchValue}" maxlength="200" />
			</div>
			<button type="submit" class="button">查询</button>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					<a href="javascript:;" class="sort" name="name">${message("Product.name")}</a>
				</th>
				<th><a href="javascript:;" class="sort" name="company">目的地</a></th>
			</tr>
			[#list page.content as product]
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${product.id}" />
					</td>
					<td>
						<span title="${product.fullName}">
							${abbreviate(product.fullName, 40, "...")}
							[#if product.isGift]
								<span class="gray">[${message("admin.product.gifts")}]</span>
							[/#if]
							(${product.id})
						</span>
						[#list product.validPromotions as promotion]
							<span class="promotion">${promotion.name}</span>
						[/#list]
					</td>
					<td>${product.company.name}</td>
				</tr>
			[/#list]
		</table>
		[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
			[#include "/admin/include/pagination.ftl"]
		[/@pagination]
	</form>
</body>
</html>