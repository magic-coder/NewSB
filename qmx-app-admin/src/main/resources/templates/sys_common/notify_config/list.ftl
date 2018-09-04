<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>列表</title>
<#include "/include/header_include_old.ftl">
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        列表
    </div>
</div>
<form id="listForm" action="list" method="get">
    <div class="bar">
        <br/>
        通知类型
        <select name="notifyType">
            <option value="">--选择通知类型--</option>
            <#list notifyTypes as notifyType>
                <option <#if queryDto.notifyType?? && notifyType == queryDto.notifyType>selected</#if> value="${notifyType!}">${notifyType.getName()}</option>
            </#list>
        </select>
        通知级别：
        <select name="notifyLevel">
            <option value="">--选择通知级别--</option>
        <#list notifyLevels as notifyLevel>
            <option <#if queryDto.notifyLevel?? && notifyLevel == queryDto.notifyLevel>selected</#if> value="${notifyLevel!}">${notifyLevel.getName()}</option>
        </#list>
        </select>
        <button type="submit" class="button">查询</button>
        <button type="button" class="button" onclick="location.href='list';">重置</button>
    </div>
    <div class="bar">
    <@shiro.hasPermission name = "admin:addNotifyConfig">
        <a href="add" class="button">
            添加
        </a>
    </@shiro.hasPermission>
    </div>
    <table id="listTable" class="list">
        <tr>
            <th class="check">
                <input type="checkbox" id="selectAll" />
            </th>
            <th>通知类型</th>
            <th>通知级别</th>
            <th>提前通知天数</th>
            <th>通知金额</th>
            <th>是否邮件通知</th>
            <th>邮件通知次数</th>
            <th>是否短信通知</th>
            <th>短信通知次数</th>
            <th>是否站内信通知</th>
            <th>站内信通知次数</th>
            <th>是否启用</th>
            <th>修改时间</th>
            <th>
                <span>操作</span>
            </th>
        </tr>
    <#list page.records as dto>
        <tr>
            <td>
                <input type="checkbox" name="ids" value="${dto.id}" />
            </td>
            <td>
                ${dto.notifyTypeName!'-'}(${dto.notifyType!'-'})
            </td>
            <td>
            ${dto.notifyLevel!'-'}
                <#if dto.notifyLevel??>(${dto.notifyLevel.getName()!'-'})</#if>
            </td>
            <td>${dto.advanceDays!'-'}</td>
            <td>${dto.notifyAmount!'-'}</td>
            <td><span class="${dto.emailNotify?string("true", "false")}Icon">&nbsp;</span></td>
            <td>${dto.emailNotifyCount!'-'}</td>
            <td><span class="${dto.smsNotify?string("true", "false")}Icon">&nbsp;</span></td>
            <td>${dto.smsNotifyCount!'-'}</td>
            <td><span class="${dto.siteNotify?string("true", "false")}Icon">&nbsp;</span></td>
            <td>${dto.siteNotifyCount!'-'}</td>
            <td><span class="${dto.enable?string("true", "false")}Icon">&nbsp;</span></td>
            <td>${dto.updateTime?string("yyyy-MM-dd HH:mm:ss")}</td>
            <td>
                <@shiro.hasPermission name = "admin:updateNotifyConfig">
                    <a href="edit?id=${dto.id}">[编辑]</a>
                </@shiro.hasPermission>

            </td>
        </tr>
    </#list>
    </table>
<#include "/include/pagination.ftl">
</form>
</body>
</html>