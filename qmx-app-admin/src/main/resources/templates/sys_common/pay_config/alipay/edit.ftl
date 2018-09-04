<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>修改支付宝配置</title>
<#include "/include/header_include_old.ftl">
    <style type="text/css">
        input[type=text]{
            width: 360px;
        }
    </style>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        修改支付宝配置
    </div>
</div>
<form id="inputForm" action="updateAliPay" method="post">
    <br/>
    <p>修改支付宝配置</p>
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>partner:
            </th>
            <td>
                <input type="text" name="partner" value="${partner!}" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>key:
            </th>
            <td>
                <input type="text" name="key" class="text" value="${key!}" maxlength="200" />
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