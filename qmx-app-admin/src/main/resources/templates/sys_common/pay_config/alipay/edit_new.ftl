<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>修改支付宝配置</title>
<#include "/include/header_include_old.ftl">
    <script type="text/javascript">
        $(function () {
            var $inputForm = $("#inputForm");
            // 表单验证
            $inputForm.validate({
                rules: {
                    appid: {
                        required: true
                    },
                    private_key: {
                        required: true
                    },
                    public_key: {
                        required: true
                    }
                }
            });
        });
    </script>
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
                <span class="requiredField">*</span>appid:
            </th>
            <td>
                <input type="text" name="appid" value="${appid!}" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>商户私钥:
            </th>
            <td>
                <textarea rows="8" cols="80" name="private_key">${private_key!}</textarea>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>支付宝公钥:
            </th>
            <td>
                <textarea rows="8" name="public_key" cols="80">${alipay_public_key!}</textarea>
            </td>
        </tr>
        <#--<tr>
            <th>
                <span class="requiredField">*</span>isSandbox:
            </th>
            <td>
                <label>
                    <input type="checkbox" name="isSandbox" <#if isSandbox?? && isSandbox == 1></#if> class="text" value="1" maxlength="200" />是
                </label>
            </td>
        </tr>-->
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