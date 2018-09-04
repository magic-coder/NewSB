<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>添加库存信息</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript">
    $().ready(function() {
        var $inputForm = $("#inputForm");
        // 表单验证
        $inputForm.validate({
            rules: {
                skuName: {
                    required: true
                },
                stockNum: {
                    required: true
                }
            }
        });

    });
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			添加库存信息
	    </div>
	</div>
	<form id="inputForm" action="save" method="post">
		<table class="input">
            <tr>
                <th>
                    &nbsp;
                </th>
                <td>
                    <span class="tips">添加库存信息</span>
                </td>
            </tr>
			<tr>
				<th>
					<span class="requiredField">*</span>库存名称:
				</th>
				<td>
					<input type="text" name="skuName" class="text" maxlength="300" style="width: 300px;" />
                    <span class="tips">建议命名规则：景区名称+票型+产品名称</span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>库存数量:
				</th>
				<td>
					<input type="text" min="0" name="stockNum" max="9999" class="text" maxlength="200" />
                    <span class="tips">如果产品是需要指定日期，库存数表示游客选定日期库存数量，如果不需要指定日期，库存数表示当天库存数量</span>
				</td>
			</tr>
		</table>
		<table class="input">
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="提交" />
					<input type="button" class="button" value="返回" onclick="history.back();" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>