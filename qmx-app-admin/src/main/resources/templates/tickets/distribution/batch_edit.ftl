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
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	
	// 表单验证
	$inputForm.validate({
		rules: {
			addPrice: {
				required: true,
				min: 0,
				decimal: {
					integer: 12,
					fraction: 2
				}
			},
			stock: {
				required: true,
				integer: true,
				min: -1
			},
            saleStartTime:{
                required: true
            },
            saleEndTime:{
                required: true
            }
		},
		messages: {
			sn: {
				pattern: "admin.validate.illegal",
				remote: "admin.validate.exist"
			}
		}
	});

	$("input[name=specifyDate]").click(function () {
	    var specify = $(this).val();
	    if(specify == 1){
            $("#validDateTd01").show();
            $("#validDateTd02").hide();
            $("#weekDays").hide();
            $("#saleDate").hide();
            $("#needDate").show();
		}else {
            $("#validDateTd02").show();
            $("#validDateTd01").hide();
            $("#weekDays").show();
            $("#needDate").hide();
            $("#saleDate").show();
		}
    });

    $("#saleStartTime").click(function(){
        WdatePicker({
            minDate:'${.now?string("yyyy-MM-dd HH:mm:ss")}',
            maxDate:'#F{$dp.$D(\'saleEndTime\',{d:-1});}',
            dateFmt:'yyyy-MM-dd HH:mm:ss',
            doubleCalendar:true,
            opposite:true,
            onpicked:function(dp){
            }
        });
    });

    $("#saleEndTime").click(function(){
        WdatePicker({
            minDate: '#F{$dp.$D(\'saleStartTime\',{d:1});}',
            dateFmt:'yyyy-MM-dd HH:mm:ss',
            doubleCalendar:true,
            opposite:true,
            //disabledDates:disabledDates2,
            onpicked:function(dp){
            }
        });
    });

    //触发change事件
    $("input[name=specifyDate]").click();
});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			编辑分销商授权
	    </div>
	</div>
		<form id="inputForm" action="batchUpdateAuthorize" method="post">
			<input type="hidden" id="datePriceData" name="datePriceData" value = '' />
			<#--<input id="totalStock_" name="totalStock" type="hidden" value="-1"/>-->
		<table class="input">
			<tr>
				<th>分销商账号：</th>
				<td>
					${distribution}
				</td>
			</tr>
			<tr>
				<th>
					授权产品:
				</th>
				<td>
					${product.name}（${product.sn}）
				</td>
			</tr>
			<#if !pDistribution??>
				<tr>
					<th>
						<span class="requiredField">*</span>售卖日期:
					</th>
					<td>
						<input type="text" class="text Wdate" id="saleStartTime" name="saleStartTime" readonly maxlength="60"/>
						- <input type="text" class="text Wdate" id="saleEndTime" name="saleEndTime" readonly maxlength="60"/>
						&nbsp;<span class="tips">售卖起始日期</span>
					</td>
				</tr>
			<#else>
                <tr>
                    <th>
                        <span class="requiredField">*</span>售卖日期:
                    </th>
                    <td>
					${(pDistribution.saleStartTime?datetime)} - ${(pDistribution.saleEndTime?datetime)}
                    </td>
                </tr>
			</#if>
            <tr>
                <th>
                    <span class="requiredField">*</span>是否指定游玩日期:
                </th>
				<#if pDistribution??>
                    <td>
						<input type="hidden" name="specifyDate" value="${pDistribution.specifyDate?string("1","0")}" />
                        ${pDistribution.specifyDate?string("是","否")}&nbsp;<span class="tips">（需要指定游玩日期指：游客下单扣除选定日期库存，使用有效期随选定日期决定；不需要指定游玩日期指：游客下单默认扣除购买当天的库存，当日无库存即表示无法购买。）</span>
                    </td>
				<#else>
                    <td>
                        <label><input type="radio" class="required" name="specifyDate" hidefocus="true" value="1" />
                            是
                        </label>
                        <label><input type="radio" class="required" name="specifyDate" hidefocus="true" value="0"/>
                            否
                        </label><span class="tips">（需要指定游玩日期指：游客下单扣除选定日期库存，使用有效期随选定日期决定；不需要指定游玩日期指：游客下单默认扣除购买当天的库存，当日无库存即表示无法购买。）</span>
                    </td>
				</#if>
            </tr>
            <tr>
                <th>
                    使用有效期:
                </th>
			<#if pDistribution??>
				<td>
					<#if pDistribution.specifyDate>
						用户选定当天有效
					<#else>
						${pDistribution.vsdate!}至${pDistribution.vedate!}
					</#if>
				</td>
			<#else>
				<td>
					<label id="validDateTd01">用户选定当天有效</label>
					<label id="validDateTd02">
						固定有效期段
						<input name="beginDate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd',minDate:'${.now?string('yyyy-MM-dd')}'})" class="text Wdate" /> 至
						<input name="endDate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd',minDate:'${.now?string('yyyy-MM-dd')}'})" class="text Wdate" />&nbsp;</label><br/>
				</td>
			</#if>
            </tr>
            <tr id="weekDays">
                <th>
                    使用有效期星期限制:
                </th>
                <td >
					<#if pDistribution??>
                        <#assign x = pDistribution.weeks?split(',')>
                        <input type="checkbox" name="weeks" <#if x?seq_contains('1')>checked</#if> value="1" disabled  />一&nbsp;
                        <input type="checkbox" name="weeks" <#if x?seq_contains('2')>checked</#if> value="2" disabled />二&nbsp;
                        <input type="checkbox" name="weeks" <#if x?seq_contains('3')>checked</#if> value="3" disabled />三&nbsp;
                        <input type="checkbox" name="weeks" <#if x?seq_contains('4')>checked</#if> value="4" disabled />四&nbsp;
                        <input type="checkbox" name="weeks" <#if x?seq_contains('5')>checked</#if> value="5" disabled />五&nbsp;
                        <input type="checkbox" name="weeks" <#if x?seq_contains('6')>checked</#if> value="6" disabled />六&nbsp;
                        <input type="checkbox" name="weeks" <#if x?seq_contains('0')>checked</#if> value="0" disabled />日&nbsp;
					<#else>
                    <input type="checkbox" name="weeks" value="1" checked />一&nbsp;
                    <input type="checkbox" name="weeks" value="2" checked />二&nbsp;
                    <input type="checkbox" name="weeks" value="3" checked />三&nbsp;
                    <input type="checkbox" name="weeks" value="4" checked />四&nbsp;
                    <input type="checkbox" name="weeks" value="5" checked />五&nbsp;
                    <input type="checkbox" name="weeks" value="6" checked />六&nbsp;
                    <input type="checkbox" name="weeks" value="0" checked />日&nbsp;
					</#if>
                    <span class="tips">在门票的使用有效期内，可选择有效期内的星期几能用，勾选表示可使用，默认为全部勾选。常见应用场景如：需要区分平日票、周末票</span><br/>
                </td>
            </tr>
			<#if pDistribution??>
				<#if !pDistribution.specifyDate>
					<tr>
						<th>
							价格库存设置:
						</th>
						<td >
							结算价：<input class="text required" name="authPrice" value="0"/>
							指导售价：<input class="text required" name="suggestPrice" value="0"/>
							<#--总库存：<input class="text required" name="stock" value="-1"/>-->
						</td>
					</tr>
				</#if>
			<#else>
                <tr id="saleDate">
                    <th>
                        价格库存设置:
                    </th>
                    <td >
                        结算价：<input class="text required" name="authPrice" value="0"/>
                        指导售价：<input class="text required" name="suggestPrice" value="0"/>
                        <#--总库存：<input class="text required" name="stock" value="-1"/>-->
                    </td>
                </tr>
			</#if>
			<#assign flagShow = false />
			<#if pDistribution??>
				<#if pDistribution.specifyDate>
					<#assign flagShow = true />
				</#if>
			<#else>
				<#assign flagShow = true />
			</#if>
            <tr>
                <th>总库存:</th>
                <td>
					<input class="text required" style="width: 60px;" name="stock" value="-1"/>
                    <span class="tips">注：设置授权总库存</span></td>
            </tr>
			<#-- 是否展示日历-->
			<#if flagShow>
                <tr class="needdate" id="needDate">
                    <th>设置授权价格
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
                                <span style="color:white;">点击页面下方保存按钮，库存设置才能生效。</span>
                                <input type="button" id="batchset" hidefocus="true" value="批量授权" class="do_btn do_btn_gray"/>
                                <input type="button" id="batchunset" hidefocus="true" value="批量取消" class="do_btn do_btn_gray"/>
                                <input type="button" id="clearall" hidefocus="true" value="全部取消" class="do_btn do_btn_gray"/>
                            </div>
                        </div>
                        <div id="calender-right" class="module_calendar_data" style="display:none;">
                            <div class="data_item">
                                <label class="cap">
                                    日期：</label><span id="showDate"></span>
                                <input id="useDate" type="hidden" />
                            </div>
                            <div class="data_item">
                                <label for="sellPrice" class="cap">
                                    <span class="must_be">*</span>分销商结算价：</label>
                                <input type="text" value="" class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="sellPrice" />
                                <span class="data_unit">元</span></div>
                            <div class="data_item">
                                <label for="distPrice" class="cap">
                                    <span class="must_be">*</span>建议售价：</label>
                                <input type="text" value="" class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="suggestPrice" />
                                <span class="data_unit">元</span>				</div>
                            <div class="data_item">
                                <label for="stockNum" class="cap">当日库存：</label>
                                <input type="text" value="1" class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'-1')" id="stockNum" />
                                <span class="data_unit">张</span>				</div>

                            <div class="data_item_do">
                                <input type="button" id="pricesave" hidefocus="true" value="保存" class="do_btn do_btn_gray"/>
                                <input type="button" id="pricecancel" hidefocus="true" value="取消" class="do_btn do_btn_gray"/>
                            </div>
                        </div>
					</td>
                </tr>
			</#if>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="提交" />
					<input type="button" class="button" value="返回" onclick="history.back()" />
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
	<i class="warn">i</i><span class="error">日授权模式</span></span></div>        	
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
						<td align="right" style="text-align:right;"><label for="sellPrice_1"><span class="must_be">*</span>分销商结算价&nbsp;</label></td>        							
						<td><input type="text" class="input_medium" name="sellPrice_1" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="sellPrice_1"/>&nbsp;元</td>        							
					</tr>        						
					<tr>
						<td align="right">
							<label for="suggestPrice_1"><span class="must_be">*</span>建议售价&nbsp;</label>
						</td>
						<td><input type="text" class="input_medium" name="suggestPrice_1" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="suggestPrice_1"/>&nbsp;元</td>
					</tr>        						
					<tr>        							
						<td align="right" id="settle-label"  style="text-align:right;">
						<label for="stockNum_1"><span class="must_be">*</span>每日库存&nbsp;</label></td>        							
						<td id="settle-input">
						<input type="text" value="-1" class="input_medium" name="stockNum_1" onkeyup="this.value=this.value.replace(/[^\d.]/g,'-1')" id="stockNum_1"/>&nbsp;（-1:不限库存，0:售完）</td>        							
					</tr>
					<#--<tr>
						<td align="right" id="totalStock-label"  style="text-align:right;">
						<label for="totalStockNum_1"><span class="must_be">*</span>总库存&nbsp;</label></td>        							
						<td id="totalStock-input">
						<input type="text" value="-1" class="input_medium" name="totalStockNum_1" onkeyup="this.value=this.value.replace(/[^\d.]/g,'-1')" id="totalStockNum_1"/>&nbsp;（-1:不限库存，0:售完）</td>
					</tr> -->
					<tr>        							
						<td colspan="2">
						<span class="tips">注：设置微信售价及官网售价均在建议售价处设置</span>
						</td>       							
					</tr>        						
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
	<input type="button" style="margin:2px 5px;" class="btn btn_orange" value="确定"/>
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
                            <#--<tr>
                                <td align="right">星期&nbsp;</td>
                                <td>
                                    <div class="idsOfWeek">
                                        <input type="checkbox" name="week" value="1" checked />一&nbsp;
                                        <input type="checkbox" name="week" value="2" checked />二&nbsp;
                                        <input type="checkbox" name="week" value="3" checked />三&nbsp;
                                        <input type="checkbox" name="week" value="4" checked />四&nbsp;
                                        <input type="checkbox" name="week" value="5" checked />五&nbsp;
                                        <input type="checkbox" name="week" value="6" checked />六&nbsp;
                                        <input type="checkbox" name="week" value="0" checked />日
                                    </div>
                                </td>
                            </tr>-->
                            <tr>
                                <td colspan="2">
                                    <table width="100%">
                                        <tbody>
                                        <tr>
                                            <td align="right">
                                                <label for="suggestPrice_2"><span class="must_be">*</span>建议售价&nbsp;</label>
                                            </td>
                                            <td><input type="text" class="input_medium" name="suggestPrice_2" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="suggestPrice_2"/>&nbsp;元</td>
                                            <td align="right" style="text-align:right;"><label for="stockNum_2"><span class="must_be">*</span>整体库存&nbsp;</label></td>
                                            <td><input type="text" value="9999" class="input_medium" name="stockNum_2" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="stockNum_2"/>&nbsp;张</td>        						</tr>
                                        <tr>
                                            <td align="right" style="text-align:right;"><label for="sellPrice_2"><span class="must_be">*</span>售卖价&nbsp;</label></td>
                                            <td><input type="text" class="input_medium" name="sellPrice_2" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="sellPrice_2"/>&nbsp;元</td>
                                        </tr>
                                        <tr>
                                            <td></td><td>
                                            <input type="hidden" name="sellPrice_2" value="0" id="sellPrice_2"/>
                                        </td>
                                            <#--
                                            <td align="right" id="settle-label"  style="text-align:right;">
                                                <label for="distPrice_2"><span class="must_be">*</span>结算价&nbsp;</label></td>
                                            <td id="settle-input">
                                                <input type="text" class="input_medium" name="distPrice_2" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="distPrice_2"/>&nbsp;元</td>
                                            <td align="right" style="text-align:right;" >
                                                <label for="maximum_2"><span class="must_be">*</span>最多购买&nbsp;</label></td>
                                            <td><input type="text" value="999" class="input_medium" name="maximum_2" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="maximum_2"/>&nbsp;张</td>-->          						</tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            </tbody>
                        </table>
						<#--
                        <div class="valid_price_caption"><strong>不可使用日期</strong> <a href="#">清除所有不可用日期</a></div>
                        <div id="cannotUseDateDiv" style="text-align: center;"></div>-->
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
	<div class="valid_price_caption"><strong>时间段设置</strong></div>        	
	<div class="valid_date_price">        		
	<table class="input">        	
		<tbody>
			<tr>        				
			<td align="right">时间段&nbsp;</td>
			<td>
			<div>        						
			<label class="time_limit_unit time_limit_large" for="startDate">
			<i class="i_hour"></i>
			<input type="text" class="Wdate" onfocus="WdatePicker({readOnly:true,minDate:'${.now?string('yyyy-MM-dd')}'})" name="startDate" id="startDate_3"/>&nbsp;至&nbsp;</label>        						
			<label class="time_limit_unit time_limit_large" for="endDate"><i class="i_hour"></i>
			<input type="text" class="Wdate" onfocus="WdatePicker({readOnly:true,minDate:'#F{$dp.$D(\'startDate_3\',{d:0});}'})" name="endDate" id="endDate_3"/></label>        					
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
		str += "<p class='price'>结:￥<em>"+(value.sellPrice?value.sellPrice:'')+"</em></p>";
		str += "<p class='price'>建:￥<em>"+(value.suggestPrice?value.suggestPrice:'')+"</em></p>";
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