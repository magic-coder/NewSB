<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加权限</title>
<#include "/include/header_include_old.ftl">
    <script type="text/javascript">
        $(function () {
            var $inputForm = $("#inputForm");
            // 表单验证
            $inputForm.validate({
                rules: {
                    permissionName: {
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
        添加权限
    </div>
</div>
<form id="inputForm" action="save" method="post">
    <br/>
    <p>添加权限</p>
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>权限编码:
            </th>
            <td>
                <input type="text" name="permission" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>权限名称:
            </th>
            <td>
                <input type="text" name="permissionName" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>标签id:
            </th>
            <td>
                <input type="text" name="labelId" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>权限类型:
            </th>
            <td>
                <label>
                    <input type="radio" name="permissionType" value="0"/>列表权限
                </label>
                <label>
                    <input type="radio" name="permissionType" value="1" />单个操作权限
                </label>
            </td>
        </tr>
        <tr>
            <th>
                所属菜单菜单:
                <input type="hidden" name="menuId" value="${menuInfo.id!}"/>
            </th>
            <td>
                ${menuInfo.menuName!}
            </td>
        </tr>
        <tr>
            <th>
                用户类型:
            </th>
            <td>
            <#list userTypes as t>
                <label>
                    <input type="checkbox" name="userTypes" value="${t!}" />${t.getName()!}
                </label>
            </#list>
            </td>
        </tr>
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
                排序:
            </th>
            <td>
                <input type="text" name="sortNo" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                备注:
            </th>
            <td>
                <textarea rows="10" cols="60" name="remark"></textarea>
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