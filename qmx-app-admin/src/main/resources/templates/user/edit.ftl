<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>修改用户</title>
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

            var $inputForm = $("#inputForm");
            var $selectAll = $("#inputForm .selectAll");
            var $areaId = $("#areaId");
        });
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        修改用户
    </div>
</div>
<form id="inputForm" action="update" method="post">
    <ul id="tab" class="tab">
        <li>
            <input type="button" value="基本信息" />
        </li>
    </ul>
    <table class="input tabContent">
        <tr>
            <th>
				<input name="id" type="hidden" value="${userInfo.id}"/>
                <span class="requiredField">*</span>登录账号:
            </th>
            <td>
                <input type="text" name="account" value="${userInfo.account!}" class="text" maxlength="20" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>登录密码:
            </th>
            <td>
                <input type="password" name="password" class="text" maxlength="20" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>名称:
            </th>
            <td>
                <input type="text" name="username" value="${userInfo.username!}" class="text" maxlength="20" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>地区:
            </th>
            <td>
                <input type="text" name="areaId" value="${userInfo.areaId!}" class="text" maxlength="20" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>所属部门:
            </th>
            <td>
                <input type="text" name="deptId" value="${userInfo.deptId!}" class="text" maxlength="20" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>邮箱:
            </th>
            <td>
                <input type="text" name="email" class="text" value="${userInfo.email!}" maxlength="20" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>手机:
            </th>
            <td>
                <input type="text" name="phone" value="${userInfo.phone!}" class="text" maxlength="20" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>职业:
            </th>
            <td>
                <input type="text" name="position" value="${userInfo.position!}" class="text" maxlength="20" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>性别:
            </th>
            <td>
                <input type="text" name="sex" value="${userInfo.sex!}" class="text" maxlength="20" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>是否启用:
            </th>
            <td>
                <label><input type="radio" <#if userInfo.enable>checked</#if> name="enable" value="true"/>是</label>
                <label><input type="radio" <#if !userInfo.enable>checked</#if> name="enable" value="false"/>否</label>
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