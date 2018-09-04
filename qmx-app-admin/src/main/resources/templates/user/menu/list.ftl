<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>菜单列表</title>
    <#include "/include/header_include_old.ftl">
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        菜单列表
    </div>
</div>
<form id="listForm" action="list" method="get">
    <div class="bar">
        <br/>
        <select name="moduleId">
            <option value="">--选择模块--</option>
            <#list modules as module>
                <option <#if module.id == moduleId>selected</#if> value="${module.id!}">${module.moduleName}</option>
            </#list>
        </select>
        <button type="submit" class="button">查询</button>
        <button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
        <span style="color:green;">${flash_message_attribute_name!}</span>
    </div>
    <div class="bar">
    <@shiro.hasPermission name = "admin:addMenu">
        <a href="add" class="button">
            添加菜单
        </a>
    </@shiro.hasPermission>
    </div>
    <table id="listTable" class="list">
        <tr>
            <th class="check">
                <input type="checkbox" id="selectAll" />
            </th>
            <th>
                <a href="javascript:;" class="sort" name="name">菜单名称</a>
            </th>
            <th>
                <a href="javascript:;" class="sort" name="url">链接地址</a>
            </th>
            <th>
                <a href="javascript:;" class="sort" name="code">权限代码</a>
            </th>
            <th>
                <a href="javascript:;" class="sort" name="order">排序</a>
            </th>
            <th>
                <span>操作</span>
            </th>
        </tr>

        <#macro menuTree menus>
            <#if menus?? && menus?size gt 0>
                <#list menus as menu>
                    <tr>
                        <td>
                            <input type="checkbox" name="ids" value="${menu.id}" />
                        </td>
                        <td>
                <span title="${menu.name!}" style="margin-left: ${menu.leaf * 30}px;[#if menu.leaf == 0] color: #000000;[/#if]">
                ${menu.menuName!}
                </span>
                        </td>
                        <td>
                        ${menu.url!}
                        </td>
                        <td>
                        ${menu.permission!}
                        </td>
                        <td>
                        ${menu.sortNo!}
                        </td>
                        <td>
                            <@shiro.hasPermission name = "admin:updateMenu">
                                <a href="edit?id=${menu.id}">[编辑]</a>
                            </@shiro.hasPermission>
                            <@shiro.hasPermission name = "admin:deleteMenu">
                            <a class="del" url="delete?id=${menu.id}">[删除]</a>
                            </@shiro.hasPermission>
                            <@shiro.hasPermission name = "admin:updateMenuPermission">
                            <a href="../permission/menuPermissionList?menuId=${menu.id}">[编辑权限]</a>
                            </@shiro.hasPermission>
                        </td>
                    </tr>
                <#if menu.menuBeans?? && menu.menuBeans?size gt 0>
                    <@menuTree menus = menu.menuBeans/>
                </#if>
                </#list>
            </#if>
        </#macro>
        <#-- 调用宏 生成递归树 -->
    <@menuTree menus = dto />
    </table>
</form>
</body>
<script type="text/javascript">
    $(function () {
        $(".del").click(function () {
            var flag = window.confirm("确定删除？");
            if(flag == true){
                var url = $(this).attr("url");
                location.href = url;
            }
        });
    })
</script>
</html>