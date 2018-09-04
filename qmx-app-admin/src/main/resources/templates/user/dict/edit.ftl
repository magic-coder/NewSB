<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>编辑字典</title>
<#include "/include/header_include_old.ftl">
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: {
				required: true
			},
			code: {
				required: true
			}
		},
		messages: {

		}
	});

});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			编辑字典
	    </div>
	</div>
	<form id="inputForm" action="update" method="post">
		<input type="hidden" name="id" value="${dto.id}" />
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>名称:
				</th>
				<td>
					<input type="text" name="codeText" class="text" value="${dto.codeText!}" maxlength="300" />
				</td>
			</tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>字典类型:
                </th>
                <td>
                    <input type="text" name="type" class="text" value="${dto.type!}" maxlength="300" />
                </td>
            </tr>
			<tr>
				<th>
					<span class="requiredField">*</span>字典代码:
				</th>
				<td>
					<input type="text" name="code" class="text" value="${dto.code!}" maxlength="300" />
				</td>
			</tr>
			<tr>
				<th>
					是否可编辑:
				</th>
				<td>
					<label>
						<input type="checkbox" name="editable" value="true"<#if dto.editable> checked="checked"</#if> />
						<input type="hidden" name="_editable" value="false" />
					</label>
				</td>
			</tr>
			<tr>
				<th>
					排序:
				</th>
				<td>
					<input type="text" name="sortNo" class="text" value="${dto.sortNo!}" maxlength="3" />
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