<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加支付渠道</title>
<#include "/include/header_include_old.ftl">
    <script type="text/javascript">
        $(function () {
            var $inputForm = $("#inputForm");
            // 表单验证
            $inputForm.validate({
                rules: {
                    payPlat: {
                        required: true
                    },
                    channelNo: {
                        required: true
                    },
                    channelName: {
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
        添加支付渠道
    </div>
</div>
<form id="inputForm" action="save" method="post">
    <br/>
    <p>添加支付渠道</p>
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>payPlat
            </th>
            <td>
                <select name="payPlat">
                    <option value="">请选择</option>
                <#list payPlats as t>
                    <option value="${t!}">${t.getName()!}</option>
                </#list>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                logo:
            </th>
            <td>
                <input type="text" name="logo" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                channelNo:
            </th>
            <td>
                <input type="text" name="channelNo" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                channelName:
            </th>
            <td>
                <input type="text" name="channelName" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                description:
            </th>
            <td>
                <input type="text" name="description" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
        <th>
            plat:
        </th>
        <td>
            <input type="text" name="plat" class="text" maxlength="200" />
        </td>
    </tr>
        <tr>
            <th>
                requestMethod:
            </th>
            <td>
                <input type="text" name="requestMethod" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                author:
            </th>
            <td>
                <input type="text" name="author" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                requestUrl:
            </th>
            <td>
                <input type="text" name="requestUrl" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                returnUrl:
            </th>
            <td>
                <input type="text" name="returnUrl" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                notifyUrl:
            </th>
            <td>
                <input type="text" name="notifyUrl" class="text" maxlength="200" />
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