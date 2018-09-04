<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>添加模块</title>
<#include "/include/header_include_old.ftl">
<style type="text/css">
.roles label {
	width: 150px;
	display: block;
	float: left;
	padding-right: 6px;
}
</style>
<script type="text/javascript">
$().ready(function() {
	var $selectAll = $("#inputForm .selectAll");
	var $areaId = $("#areaId");
    var $inputForm = $("#inputForm");
    // 表单验证
    $inputForm.validate({
        rules: {
            moduleName: {
                required: true
            },
            basic: {
                required: true
            },
            enable: {
                required: true
            },
            appKey: {
                required: true
            },
            appSecret: {
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
			添加模块
	    </div>
	</div>
	<form id="inputForm" action="save" method="post">
		<ul id="tab" class="tab">
			<li>
				<input type="button" value="基本信息" />
			</li>
		</ul>
		<table class="input tabContent">
			<tr>
				<th>
					<span class="requiredField">*</span>模块名称:
				</th>
				<td>
					<input type="text" name="moduleName" class="text" maxlength="20" />
				</td>
			</tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>类名称:
                </th>
                <td>
                    <input type="text" name="className" class="text" maxlength="20" />
                </td>
            </tr>
			<tr>
				<th>
					<span class="requiredField">*</span>appKey:
				</th>
				<td>
					<input type="text" id="appKey" name="appKey" class="text" maxlength="20" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>appSecret:
				</th>
				<td>
					<input type="text" name="appSecret" class="text" maxlength="20" />
				</td>
			</tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>排序:
                </th>
                <td>
                    <input type="text" name="sortNo" class="text" maxlength="20" />
                </td>
            </tr>
            <tr>
                <th>
                    <span class="requiredField">*</span>是否基本模块:
                </th>
                <td>
                    <label><input type="radio" name="basic" value="true"/>是</label>
                    <label><input type="radio" name="basic" value="false"/>否</label>
                </td>
            </tr>
			<tr>
				<th>
					<span class="requiredField">*</span>是否启用:
				</th>
				<td>
					<label><input type="radio" name="enable" value="true"/>是</label>
                    <label><input type="radio" name="enable" value="false"/>否</label>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					&nbsp;
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