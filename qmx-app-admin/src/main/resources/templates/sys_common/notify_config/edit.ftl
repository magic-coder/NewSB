<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>修改</title>
<#include "/include/header_include_old.ftl">
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        修改
    </div>
</div>
<form id="inputForm" action="update" method="post">
    <br/>
    <p>修改</p>
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>通知类型：
                <input name="id" type="hidden" value="${dto.id!}"/>
            </th>
            <td>
            <#if dto.notifyType??>${dto.notifyType.getName()}</#if>
            </td>
        </tr>
        <tr>
            <th>
                通知级别：
            </th>
            <td>
            <#if dto.notifyLevel??>${dto.notifyLevel.getName()}</#if>
            </td>
        </tr>
        <tr>
            <th>
                到期前多少天通知:
            </th>
            <td>
                <input type="text" name="advanceDays" value="${dto.advanceDays!}" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                通知金额:
            </th>
            <td>
                <input type="text" name="notifyAmount" value="${dto.notifyAmount!}" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                是否邮件通知:
            </th>
            <td>
                <label><input type="radio" <#if dto.emailNotify>checked</#if> name="emailNotify" value="true"/>是</label>
                <label><input type="radio" <#if !dto.emailNotify>checked</#if> name="emailNotify" value="false"/>否</label>
            </td>
        </tr>
        <tr>
            <th>
                邮件每天通知次数:
            </th>
            <td>
                <input type="text" name="emailNotifyCount" value="${dto.emailNotifyCount!}" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                是否短信通知:
            </th>
            <td>
                <label><input type="radio" <#if dto.smsNotify>checked</#if> name="smsNotify" value="true"/>是</label>
                <label><input type="radio" <#if !dto.smsNotify>checked</#if> name="smsNotify" value="false"/>否</label>
            </td>
        </tr>
        <tr>
            <th>
                短信每天通知次数:
            </th>
            <td>
                <input type="text" name="smsNotifyCount" value="${dto.smsNotifyCount}" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                是否站点通知:
            </th>
            <td>
                <label><input type="radio" <#if dto.siteNotify>checked</#if> name="siteNotify" value="true"/>是</label>
                <label><input type="radio" <#if !dto.siteNotify>checked</#if> name="siteNotify" value="false"/>否</label>
            </td>
        </tr>
        <tr>
            <th>
                站点消息每天通知次数:
            </th>
            <td>
                <input type="text" name="siteNotifyCount" value="${dto.siteNotifyCount!}" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                通知邮件:
            </th>
            <td>
                <textarea rows="6" name="email" cols="60">${dto.email!}</textarea>
                <span class="tips">多个用","分割</span>
            </td>
        </tr>
        <tr>
            <th>
                通知手机:
            </th>
            <td>
                <textarea rows="6" name="phone" cols="60">${dto.phone!}</textarea>
                <span class="tips">多个用","分割</span>
            </td>
        </tr>
        <tr>
            <th>
                通知账号:
            </th>
            <td>
                <textarea rows="6" name="notifyAccount" cols="60">${dto.notifyAccount!}</textarea>
                <span class="tips">多个用","分割</span>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>是否启用:
            </th>
            <td>
                <label><input type="radio" <#if dto.enable>checked</#if> name="enable" value="true"/>是</label>
                <label><input type="radio" <#if !dto.enable>checked</#if> name="enable" value="false"/>否</label>
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