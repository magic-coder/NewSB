<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>修改部门</title>
<#include "/include/header_include_old.ftl">
    <script type="text/javascript">
        $(function () {
            var $inputForm = $("#inputForm");
            // 表单验证
            $inputForm.validate({
                rules: {
                    deptName: {
                        required: true
                    },
                    enable: {
                        required: true
                    }
                }
            });
        })
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        修改部门
    </div>
</div>
<form id="inputForm" action="update" method="post">
    <br/>
    <p>修改部门</p>
    <table class="input">
        <tr>
            <th>
                <input type="hidden" name="id" value="${deptInfo.id}"/>
                <span class="requiredField">*</span>部门名称:
            </th>
            <td>
                <input type="text" name="deptName" value="${deptInfo.deptName!}" class="text" maxlength="200" />
            </td>
        </tr>
        <#--
        <tr>
            <th>
                上级部门:
            </th>
            <td>
                <input type="hidden" name="parentId" class="text" maxlength="200" />
            </td>
        </tr>-->
        <tr>
            <th>
                <span class="requiredField">*</span>是否启用:
            </th>
            <td>
                <label><input type="radio" <#if deptInfo.enable>checked</#if> name="enable" value="true"/>是</label>
                <label><input type="radio" <#if !deptInfo.enable>checked</#if> name="enable" value="false"/>否</label>
            </td>
        </tr>
        <tr>
            <th>
                排序:
            </th>
            <td>
                <input type="text" name="sortNo" value="${deptInfo.sortNo!}" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                备注:
            </th>
            <td>
                <textarea rows="10" cols="60" name="remark">${deptInfo.remark!}</textarea>
            </td>
        </tr>
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="submit" class="button" value="保存" />
                <input type="button" class="button" value="返回" onclick="history.back();" />
            </td>
        </tr>
    </table>
</form>
</body>
</html>