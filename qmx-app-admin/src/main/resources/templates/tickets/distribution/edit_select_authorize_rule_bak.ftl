<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>产品授权分销商</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/dropdown/dropdown.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/ext.css" rel="stylesheet" type="text/css" />
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

    //预定规则选择下拉
    $("#bookRuleName").dropqtable({
        vinputid: "bookRuleId", //值所存放的区域
        dropwidth: "auto", //下拉层的宽度
        selecteditem: {text: "${dto.defaultBookRule.name}", value: "${dto.defaultBookRule.id}"}, //默认值
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
        selecteditem: {text: "${dto.defaultConsumeRule.name!}", value: "${dto.defaultConsumeRule.id}"}, //默认值
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
        selecteditem: {text: "${dto.defaultRefundRule.name!}", value: "${dto.defaultRefundRule.id!}"}, //默认值
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
	

	
	$.validator.addClassRules({
		distributor: {
			required: true
		},
		productId: {
			required: true,
			integer: true
		}
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			productId: "required",
			distributor: "required"
		},
		messages: {
			sn: {
				pattern: "admin.validate.illegal",
				remote: "admin.validate.exist"
			}
		}
	});
});

</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			添加产品授权
	    </div>
	</div>
		<form id="inputForm" action="batchEditAuthorize" method="post">
		<table class="input">
			<tr>
				<th><span class="requiredField">*</span>选择授权规则：</th>
				<td>

				</td>
			</tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>默认预定规则:
                </th>
                <td>
                    <input id="bookRuleName" type="text" class="text" readonly maxlength="300"/>
                    <input id="bookRuleId" name="defaultBookRuleId" type="hidden"/>
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>默认检票规则s:
                </th>
                <td>
                    <input id="consumeRuleName" type="text" class="text" readonly maxlength="300"/>
                    <input id="consumeRuleId" name="defaultConsumeRuleId" type="hidden"/>
                    <span class="tips">
                        xxx
                    </span>
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>默认退款规则:
                </th>
                <td>
                    <input id="refundRuleName" type="text" class="text" readonly maxlength="300"/>
                    <input id="refundRuleId" name="defaultRefundRuleId" type="hidden"/>
                </td>
            </tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="下一步" />
					<input type="button" class="button" value="返回" onclick="history.back()" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>