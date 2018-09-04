﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加角色</title>
<#include "/include/header_include_old.ftl">
    <script type="text/javascript">
        $(function () {
            var $inputForm = $("#inputForm");
            // 表单验证
            $inputForm.validate({
                rules: {
                    roleName: {
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
        添加角色
    </div>
</div>
<form id="inputForm" action="save" method="post">
    <br/>
    <p>添加角色</p>
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>角色名称:
            </th>
            <td>
                <input type="text" name="roleName" class="text" maxlength="200" />
            </td>
        </tr>
        <#if currentMember.userType == 'admin'>
            <tr>
                <th>
                    角色编码:
                </th>
                <td>
                    <input readonly type="text" name="code" class="text" maxlength="200" />
                </td>
            </tr>
            <tr>
                <th>
                    关联用户类型:
                </th>
                <td>
                    <select name="userType">
                        <option value="">-请选择-</option>
                        <#list userTypes as t>
                            <option value="${t!}">${t.getName()!}</option>
                        </#list>
                    </select>
                    <span class="tips">为哪种用户类型设置角色权限</span>
                </td>
            </tr>
            <tr>
                <th>
                    推荐给供应商:
                </th>
                <td>
                    <label><input type="radio" name="recommend" value="true"/>是</label>
                    <label><input type="radio" name="recommend" checked value="false"/>否</label>
                    <span class="tips">选择是时，供应商设置员工权限时展示此角色</span>
                </td>
            </tr>
            <tr>
                <th>
                    供应商推荐权限:
                </th>
                <td>
                    <label><input type="radio" name="supplierRecommend" value="true"/>是</label>
                    <label><input type="radio" name="supplierRecommend" checked value="false"/>否</label>
                    <span class="tips">选择是时，在设置供应商权限时展示此权限</span>
                </td>
            </tr>
            <tr>
                <th>
                    系统内置:
                </th>
                <td>
                    <label><input type="radio" name="sys" value="true"/>是</label>
                    <label><input type="radio" name="sys" checked value="false"/>否</label>
                    <span class="tips">添加管理员员工角色时，选择:否，其他都选择:是</span>
                </td>
            </tr>
        </#if>
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