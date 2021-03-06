<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>添加订单来源</title>
<#include "/include/header_include_old.ftl">
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $type = $("#type");
	var $contentTr = $("#contentTr");
	var $pathTr = $("#pathTr");
	var $path = $("#path");
	var $browserButton = $("#browserButton");
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: "required",
			order: "digits"
		}
	});
	
});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			添加订单来源
	    </div>
	</div>
	<form id="inputForm" action="save" method="post">
		<table class="input">
            <tr>
                <th>
                    所属模块:
                </th>
                <td>
                    <select name="moduleId">
					<#list moduleList as module>
                        <option value="${module.id}">${module.moduleName!}</option>
					</#list>
                    </select>
                </td>
            </tr>
			<tr>
				<th>
					<span class="requiredField">*</span>订单来源名称:
				</th>
				<td>
					<input type="text" name="name" class="text" maxlength="200" />
				</td>
			</tr>
		<@shiro.hasRole name = 'admin'>
            <tr>
                <th>
                    <span class="requiredField">*</span>订单来源CODE:
                </th>
                <td>
                    <input type="text" name="code" class="text" maxlength="200" />
                </td>
            </tr>
            <tr>
                <th>
                    OTA:
                </th>
                <td>
                    <label>
                        <input type="checkbox" name="otaFlag" value="true" />是否OTA订单来源
                    </label>
                </td>
            </tr>
			<tr>
				<th>
					系统内置:
				</th>
				<td>
					<label>
						<input type="checkbox" name="sys" value="true" checked="checked" />是否系统内置
						<input type="hidden" name="_sys" value="false" />
					</label>
				</td>
			</tr>
			</@shiro.hasRole>
            <tr>
                <th>
                    <span class="requiredField">*</span>是否启用:
                </th>
                <td>
                    <label><input type="radio" name="enable" checked value="true"/>是</label>
                    <label><input type="radio" name="enable" value="false"/>否</label>
                </td>
            </tr>
			<tr>
				<th>
					备注:
				</th>
				<td>
					<textarea class="text" name="remark"></textarea>
				</td>
			</tr>
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