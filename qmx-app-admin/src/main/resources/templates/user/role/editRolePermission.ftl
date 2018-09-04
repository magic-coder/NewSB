<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>编辑权限</title>
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
            // 表单验证
            $inputForm.validate({
                rules: {
                    id: {
                        required: true
                    }
                }
            });
            $(".checkAll").change(function() {
                var $this = $(this);
                var $tr = $this.closest("tr");
                var level = $tr.attr("level");
                if ($this.attr("checked")) {
                    $tr.nextUntil("tr[level="+level+"]").filter(function(index){
                        return parseInt($(this).attr("level")) > parseInt(level);
                    }).find(":checkbox").prop("checked", true);
                    //子菜单
                    if(level > 0){
                        var $label = $this.closest("label");
                        $label.siblings().find(":checkbox").prop("checked", true);
                    }
                } else {
                    $tr.nextUntil("tr[level="+level+"]").filter(function(index){
                        return parseInt($(this).attr("level")) > parseInt(level);
                    }).find(":checkbox").prop("checked", false);
                    ////子菜单
                    if(level > 0){
                        var $label = $this.closest("label");
                        $label.siblings().find(":checkbox").prop("checked", false);
                    }
                }
                return false;
            });
        });
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        编辑角色权限
    </div>
</div>
<form id="inputForm" action="updateRolePermission" method="post">
    <input name="id" type="hidden" value="${roleInfo.id}"/>
    <ul id="tab" class="tab">
        <#if moduleList??>
            <#list moduleList as module>
                <li>
                    <input type="button" value="${module.moduleName!}" />
                </li>
            </#list>
        <#else>
            该用户暂无模块信息
        </#if>
    </ul>
    <#if moduleList??>
        <#list moduleList as module>
            <table class="input tabContent">
                <#--<tr>
                    <th>
                        <span class="requiredField">*</span>角色(编码):
                    </th>
                    <td>
                    ${roleInfo.roleName!}(${roleInfo.code!})
                    </td>
                </tr>-->
                <tr>
                    <th>
                        <span class="requiredField">*</span>(${roleInfo.roleName!})${module.moduleName!}权限:
                    </th>
                    <td>
                        <div>
                            <table width="100%">
                                <#macro menuTree menus>
                                    <#if menus?? && menus?size gt 0>
                                        <#list menus as menu>
                                            <tr level="${(menu.leaf)}">
                                                <td>
                                                    <div style="margin-left: ${(menu.leaf) * 25}px;">
                                                        <label><input type="checkbox" name="menus" value="${menu.id!}" class="checkAll" <#if menuIds?seq_contains(menu.id)> checked="checked"</#if> />${menu.menuName!}</label>
                                                        <#if menu.permissions?? && menu.permissions?size gt 0>
                                                            <#list menu.permissions as perms>
                                                                <label><input type="checkbox" name="authorities" value="${perms.id!}" <#if permissionIds?seq_contains(perms.id)> checked="checked"</#if> />${perms.permissionName!}</label>
                                                            </#list>
                                                        </#if>
                                                    </div>
                                                </td>
                                            </tr>
                                            <#if menu.menuBeans?? && menu.menuBeans?size gt 0>
                                                <@menuTree menus = menu.menuBeans/>
                                            </#if>
                                        </#list>
                                    </#if>
                                </#macro>
                            <#-- 调用宏 生成递归树 -->
                                <@menuTree menus = module.menuDtoList />
                            </table>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </#list>
    </#if>

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