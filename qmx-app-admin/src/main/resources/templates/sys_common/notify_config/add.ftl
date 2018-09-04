<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加</title>
<#include "/include/header_include_old.ftl">
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        添加
    </div>
</div>
<form id="inputForm" action="save" method="post">
    <br/>
    <p>添加</p>
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>通知类型：
            </th>
            <td>
                <select name="notifyType">
                    <option value="">--选择通知类型--</option>
                <#list notifyTypes as notifyType>
                    <option value="${notifyType!}">${notifyType.getName()}</option>
                </#list>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                通知级别：
            </th>
            <td>
                <select name="notifyLevel">
                    <option value="">--选择通知级别--</option>
                <#list notifyLevels as notifyLevel>
                    <option value="${notifyLevel!}">${notifyLevel.getName()}</option>
                </#list>
            </td>
        </tr>
        <tr>
            <th>
                提前多少天通知:
            </th>
            <td>
                <input type="text" name="advanceDays" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                通知金额:
            </th>
            <td>
                <input type="text" name="notifyAmount" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                是否邮件通知:
            </th>
            <td>
                <label><input type="radio" name="emailNotify" value="true"/>是</label>
                <label><input type="radio" checked name="emailNotify" value="false"/>否</label>
            </td>
        </tr>
        <tr>
        <th>
            邮件每天通知次数:
        </th>
        <td>
            <input type="text" name="emailNotifyCount" class="text" maxlength="200" />
        </td>
    </tr>
        <tr>
            <th>
                是否短信通知:
            </th>
            <td>
                <label><input type="radio" name="smsNotify" value="true"/>是</label>
                <label><input type="radio" checked name="smsNotify" value="false"/>否</label>
            </td>
        </tr>
        <tr>
            <th>
                短信每天通知次数:
            </th>
            <td>
                <input type="text" name="smsNotifyCount" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                是否站点消息通知:
            </th>
            <td>
                <label><input type="radio" name="siteNotify" value="true"/>是</label>
                <label><input type="radio" checked name="siteNotify" value="false"/>否</label>
            </td>
        </tr>
        <tr>
            <th>
                站点消息每天通知次数:
            </th>
            <td>
                <input type="text" name="siteNotifyCount" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                通知邮件:
            </th>
            <td>
                <textarea rows="6" name="email" cols="60"></textarea>
                <span class="tips">多个用","分割</span>
            </td>
        </tr>
        <tr>
            <th>
                通知手机:
            </th>
            <td>
                <textarea rows="6" name="phone" cols="60"></textarea>
                <span class="tips">多个用","分割</span>
            </td>
        </tr>
        <tr>
            <th>
                通知账号:
            </th>
            <td>
                <textarea rows="6" name="notifyAccount" cols="60"></textarea>
                <span class="tips">多个用","分割</span>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>是否启用:
            </th>
            <td>
                <label><input type="radio" checked name="enable" value="true"/>是</label>
                <label><input type="radio" name="enable" value="false"/>否</label>
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