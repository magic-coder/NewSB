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
                    <span class="requiredField">*</span>通知tag:
                </th>
                <td>
                    <select name="tag">
					<#list tags as tag>
                        <option value="${tag!}" <#if tag == dto.tag>selected</#if>>${tag.getName()!}</option>
					</#list>
                    </select>
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>通知地址:
                </th>
                <td>
                    <input type="text" name="url" style="width: 500px;" value="${dto.url!}" class="text" maxlength="300" />
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