<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>授权产品</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/dropdown/dropdown.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/product.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropdown.js"></script>
<script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropqtable.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>

</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			分销商授权
	    </div>
	</div>
		<input type="hidden" id="datePriceData" name="datePriceData" value='${datePriceData!}' />
		<table class="input">
			<tr class="needdate <#if !distribution.specifyDate>hidden</#if>">
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
						
	</div>
</div>
</td>
			</tr>
            <tr class="dontneeddate <#if distribution.specifyDate>hidden</#if>">
                <th>
                </th>
                <td>
                    <table class="input">
                        <tr><td>建议售价：<span id="marketpricecontainer">${distribution.suggestPrice!}</span></td></tr>
                        <tr><td>授权价格：<span id="stockcontainer">${distribution.authPrice!}</span></td></tr>
                        <tr><td>授权库存：<span id="timecontainer">${distribution.stock!}</span></td></tr>
                        <tr><td>授权期间：<span id="timecontainer">${distribution.vsdate!}到${distribution.vedate!}</span></td></tr>
                    </table>
                </td>
            </tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="button" class="button" value="返回" onclick="history.back()" />
				</td>
			</tr>
		</table>
<script type="text/javascript">
function tdFillCallBack(td) {
	var value = $(td).data('data');
	//td.attr('marketPrice',value.marketPrice).attr('stockNum',value.quantity).attr('sellPrice',value.sellPrice).attr('childPrice',value.childPrice).attr('oldPrice',value.oldPrice).attr('distPrice',value.distPrice).attr('minBuyNum',value.minimum).attr('maxBuyNum',value.maximum);
	var str = '';
	if(value) {
		str += "<p class='price'>授:￥<em>"+(value.sellPrice?value.sellPrice:'')+"</em></p>";
		str += "<p class='price'>库:<em>"+(value.stock?value.stock:'')+"</em></p>";
	}
	return str;
}
function tdClickCallBack(o) {
	$("#useDate").val($(o).attr('data-date'));
	$("#showDate").text($(o).attr('data-date'));
	$("#sellPrice").val('');
	$("#suggestPrice").val('');
	$("#stockNum").val('');
	var data = $(o).data('data');
	if(data) {
		$("#suggestPrice").val(data.suggestPrice);
		$("#sellPrice").val(data.sellPrice);
		//$("#outSettlePrice").val("xx");
		$("#stockNum").val(data.stock);
	}
}
</script>
<script type="text/javascript" src="${base}/resources/admin/js/calendarprice2.js"></script>
</body>
</html>