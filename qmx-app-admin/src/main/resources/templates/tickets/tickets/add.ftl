<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>添加门票</title>
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
    <script src="${base}/resources/assets/layer/layer.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
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

	//loadParameter();

	$.validator.addClassRules({
		required: {
			required: true
		},
		memberPrice: {
			min: 0,
			decimal: {
				integer: 12,
				fraction: 2
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
				fraction: 2
			}
		},
		productCost: {
			//required: true,
			min: 0,
			decimal: {
				integer: 12,
				fraction: 2
			}
		},
		productImageOrder: {
			digits: true
		}
	});

	// 表单验证
	$inputForm.validate({
		rules: {
			name: "required",
			smsTemplateId: {
				required: true
			},
			sightId: {
				required: true
			},
            stockId:{
                required: true
			},
			price: {
				required: true,
				min: 0,
				decimal: {
					integer: 12,
					fraction: 2
				}
			},
			cost: {
				min: 0,
				decimal: {
					integer: 12,
					fraction: 2
				}
			},
			marketPrice: {
                required: true,
				min: 0,
				decimal: {
					integer: 12,
					fraction: 2
				}
			},
			stock: "digits",
			point: "digits"
		},
		messages: {
			sn: {
				pattern: "admin.validate.illegal",
				remote: "admin.validate.exist"
			},
			focusimagepath: {
				required: "至少上传一张图片"
			}
		}
	});

	$("input:radio,input:checkbox").change(function(){
		$("input[name='"+$(this).attr("name")+"']:checked").each(function(){
			$($(this).attr("dest")).attr("disabled", false);
		});
		$("input[name='"+$(this).attr("name")+"']").not(":checked").each(function(){
			$($(this).attr("dest")).attr("disabled", true);
		});
	});


	$("input[name=name]").keyup(function(){
		var val = $(this).val();
		$("#nametip").text(val.length+"/30字");
	});

	$("input[name=validStartDate]").click(function(){
		WdatePicker({
			minDate: '#F{$dp.$D(\'hdstartDate\',{d:1});}',
			dateFmt:'yyyy-MM-dd',
			opposite:true,
			isShowClear:false,
			onpicked:function(dp){
				var pickDate = parseDate(dp.cal.getDateStr());
				var endDate = $("input[name=validEndDate]").val();
				$("#hdendDate").val(pickDate);
				if(endDate != ''){
					var endDate2 = parseDate(endDate);
					if(pickDate.DateDiff('d', endDate2) <0){
						alert('所选日期有误，开始日期不能大于结束日期：'+endDate2);
						$("input[name=validStartDate]").val('');
					}
				}
			}
		});
	});
	$("input[name=validEndDate]").click(function(){
		WdatePicker({
			minDate: '#F{$dp.$D(\'hdendDate\',{d:0});}',
			dateFmt:'yyyy-MM-dd',
			opposite:true,
			onpicked:function(dp){
				//var startDate  = $dp.$('hdstartDate').value;
				//var endDate = parseDate(dp.cal.getDateStr());
			}
		});
	});

    //预定规则选择下拉
    $("#bookRuleName").dropqtable({
        vinputid: "bookRuleId", //值所存放的区域
        dropwidth: "auto", //下拉层的宽度
        selecteditem: {text: "", value: ""}, //默认值
        tableoptions: {
            //autoload: true,
            url: "../bookRule/listForJson", //查询响应的地址
            qtitletext: "请输入规则名称", //查询框的默认文字
            textField: 'trueName',
            valueField: 'id',
            colmodel: [
                {name: "sn", displayname: "sn", width: "100px"}, //表格定义
                {name: "name", displayname: "名称", width: "150px"}
            ],
            onSelect: function (selected) {
                $("#bookRuleId").val(selected.id);
                $("#bookRuleName").val(selected.name);
            }
        }
    });

    //检票规则下拉
    $("#consumeRuleName").dropqtable({
        vinputid: "consumeRuleId", //值所存放的区域
        dropwidth: "auto", //下拉层的宽度
        selecteditem: {text: "", value: ""}, //默认值
        tableoptions: {
            //autoload: true,
            url: "../consumeRule/listForJson", //查询响应的地址
            qtitletext: "请输入规则名称", //查询框的默认文字
            textField: 'trueName',
            valueField: 'id',
            colmodel: [
                {name: "sn", displayname: "sn", width: "100px"}, //表格定义
                {name: "name", displayname: "名称", width: "150px"}
            ],
            onSelect: function (selected) {
                $("#consumeRuleId").val(selected.id);
                $("#consumeRuleName").val(selected.name);
            }
        }
    });

    $("#refundRuleName").dropqtable({
        vinputid: "refundRuleId", //值所存放的区域
        dropwidth: "auto", //下拉层的宽度
        selecteditem: {text: "", value: ""}, //默认值
        tableoptions: {
            //autoload: true,
            url: "../refundRule/listForJson", //查询响应的地址
            qtitletext: "请输入规则名称", //查询框的默认文字
            textField: 'trueName',
            valueField: 'id',
            colmodel: [
                {name: "sn", displayname: "sn", width: "100px"}, //表格定义
                {name: "name", displayname: "名称", width: "150px"}
            ],
            onSelect: function (selected) {
                $("#refundRuleId").val(selected.id);
                $("#refundRuleName").val(selected.name);
            }
        }
    });
    $("#viewBookRule").click(function () {
        var data = $("#bookRuleId").val();
        if(data == ''){
            alert('请先选择规则');
            return;
		}
        layer.open({
            type: 2,
            title: '预览',
            area: ['680px', '450px'], //宽高
            fix: true, //固定
            content: '../bookRule/view?id='+data
        });
    });
    $("#viewConsumeRule").click(function () {
        var data = $("#consumeRuleId").val();
        if(data == ''){
            alert('请先选择规则');
            return;
        }
        layer.open({
            type: 2,
            title: '预览',
            area: ['720px', '450px'], //宽高
            fix: true, //固定
            content: '../consumeRule/view?id='+data
        });
    });
    $("#viewRefundRule").click(function () {
        var data = $("#refundRuleId").val();
        if(data == ''){
            alert('请先选择规则');
            return;
        }
        layer.open({
            type: 2,
            title: '预览',
            area: ['680px', '450px'], //宽高
            fix: true, //固定
            content: '../refundRule/view?id='+data
        });
    });
});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			添加门票
	    </div>
	</div>
	<form id="inputForm" action="saveTickets" method="post">
		<ul id="tab" class="tab">
			<li>
				<input type="button" value="基本设置" />
			</li>
			<#--<li>
				<input type="button" value="扩展设置" />
			</li>-->
		</ul>
		<table class="input tabContent">
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
					<span class="requiredField">*</span>门票名称:
				</th>
				<td>
					<input type="text" name="name" class="text" maxlength="30" style="width:300px;"/>&nbsp;<span id="nametip">0/30字</span>&nbsp;<span class="tips">2-30字(注：产品名称不能包含营销、中奖、抽奖等相关营销类关键字)</span>
				</td>
			</tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>选择票型:
                </th>
                <td>
					<select name="ticketTypeId">
						<option value="">-请选择-</option>
						<#list ticketsTypeList as tp>
							<option value="${tp.id!}">${tp.sightName!}---${tp.name!}</option>
						</#list>
					</select>
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>短信模板:
                </th>
                <td>
                    <select name="smsTemplateId">
                        <option value="">请选择</option>
					<#list smsTemplates as st>
                        <option value="${st.id!}">${st.name!}</option>
					</#list>
                    </select>
                    &nbsp;短信扩展内容:<input name="smsExt" class="text" style="width:200px;" maxlength="100"/>
                    <span class="tips">短信通知中需要额外提示客人的文字内容,需结合带"扩展"字样的指定短信模板使用</span>
                </td>
            </tr>

            <tr>
                <th>
                    是否预约:
                </th>
                <td>
                    <label><input type="radio" name="needReserve" value="true"/>是</label>
                    <label><input type="radio" name="needReserve" value="false" checked/>否</label>
                </td>
            </tr>
            <tr>
                <th>
                    是否是赠票:
                </th>
                <td>
                    <label><input type="radio" name="gift" value="true"/>是</label>
                    <label><input type="radio" name="gift" value="false" checked/>否</label>
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>默认预定规则:
                </th>
                <td>
                    <input id="bookRuleName" type="text" class="text" readonly maxlength="300"/>
                    <input id="bookRuleId" name="defaultBookRuleId" type="hidden"/>
                    <input type="button" value="预览" id="viewBookRule"/>
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>默认检票规则:
                </th>
                <td>
                    <input id="consumeRuleName" type="text" class="text" readonly maxlength="300"/>
                    <input id="consumeRuleId" name="defaultConsumeRuleId" type="hidden"/>
                    <input type="button" value="预览" id="viewConsumeRule"/>
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>默认退款规则:
                </th>
                <td>
                    <input id="refundRuleName" type="text" class="text" readonly maxlength="300"/>
                    <input id="refundRuleId" name="defaultRefundRuleId" type="hidden"/>
                    <input type="button" value="预览" id="viewRefundRule"/>
                </td>
            </tr>
			<tr>
				<th>
                    <span class="requiredField">*</span>票面价（门市价）：
				</th>
				<td>
					<input type="text" name="marketPrice" class="text" />
				</td>
			</tr>
            <tr>
                <th>
                    <label><input type="checkbox" value="true" name="limitQrPrice" dest="input[name=qrPrice]" />统一二维码售价:</label>
                </th>
                <td>
                    二维码售价:<input type="text" name="qrPrice" value="0" class="text productQrPrice required" style="width: 60px;" disabled />&nbsp;<span class="tips">设置后所有二维码分销均按此价售卖</span>
                </td>
            </tr>
            <@shiro.hasPermission name = "admin:updateLimitStock">
            <tr>
                <th>
                    <label><input type="checkbox" name="limitStock" dest="select[name=stockId]" />共享库存:</label>
                </th>
                <td>
					<select name="stockId" disabled>
                        <option value="">-请选择库存-</option>
						<#if ticketStocks??>
							<#list ticketStocks as ts>
                                <option value="${ts.skuId!}">${ts.skuName!}</option>
							</#list>
						</#if>
					</select>
                </td>
            </tr>
        </@shiro.hasPermission>
        <@shiro.lacksPermission name = "admin:updateLimitStock">
            <input type="hidden" name="limitStock" value="false"/>
        </@shiro.lacksPermission>

		<@shiro.hasPermission name = "admin:updateRebateType">
            <tr>
                <th>
                    <span class="requiredField">*</span>钱包分佣设置:
                </th>
                <td>
                    <label><input type="radio" class="required" name="payAfterTheRebate" hidefocus="true" value="false" />
                        支付后返佣
                    </label>
                    <label><input type="radio" class="required" name="payAfterTheRebate" hidefocus="true" value="true" checked/>
                        消费后返佣
                    </label>
                </td>
            </tr>
		</@shiro.hasPermission>
		<@shiro.lacksPermission name = "admin:updateRebateType">
            <input type="hidden" name="payAfterTheRebate" value="false"/>
		</@shiro.lacksPermission>
            <tr>
                <th>
                    <span class="requiredField">*</span>费用包含:
                </th>
                <td>
                    <textarea name="feeInfo" class="text required" maxlength="500">费用包含</textarea>
                    <div class="blank"></div>
                    <span class="tips">500字以内。</span>
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>费用不包含:
                </th>
                <td>
                    <textarea name="feeExclude" class="text " maxlength="500">费用不包含</textarea>
                    <div class="blank"></div>
                    <span class="tips">500字以内。</span>
                </td>
            </tr>
		</table>

		<table class="input">
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="保存" />
					<input type="button" class="button" value="返回" onclick="history.back()" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>