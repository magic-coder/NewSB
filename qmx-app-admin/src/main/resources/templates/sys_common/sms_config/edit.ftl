<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>修改短信配置</title>
<#include "/include/header_include_old.ftl">
    <script type="text/javascript">
        $(function () {
            var $inputForm = $("#inputForm");
            // 表单验证
            $inputForm.validate({
                rules: {
                    smsPlatType: {
                        required: true
                    },
                    smsPlatAccount: {
                        required: true
                    },
                    smsPlatPassword: {
                        required: true
                    },
                    configName: {
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
        修改短信配置
    </div>
</div>
<form id="inputForm" action="update" method="post">
    <br/>
    <p>修改短信配置</p>
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>短信配置名称
            </th>
            <td>
                <input type="text" name="configName" value="${dto.configName!}" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>短信平台
            </th>
            <td>
                <input type="hidden" name="id" value="${dto.id!}"/>
                <select name="smsPlatType">
                    <option value="">请选择</option>
                <#list types as t>
                    <option value="${t!}" <#if dto?? && dto.smsPlatType == t>selected</#if>>${t.getName()!}</option>
                </#list>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                短信服务地址:
            </th>
            <td>
                <input type="text" name="smsPlatUrl" value="${dto.smsPlatUrl!}" class="text" maxlength="200" />
                <span class="tips">如果短信平台选择阿里云，此处不用填</span>
            </td>
        </tr>
        <tr>
            <th>
                集团客户名称:
            </th>
            <td>
                <input type="text" name="ecName" value="${dto.ecName!}" class="text" maxlength="200" />
                <span class="tips">云MAS短信需要</span>
            </td>
        </tr>
        <tr>
            <th>
                用户id:
            </th>
            <td>
                <input type="text" name="userId" value="${dto.userId!}" class="text" maxlength="200" />
                <span class="tips">云掌通短信需要</span>
            </td>
        </tr>
        <tr>
            <th>
                短信账号:
            </th>
            <td>
                <input type="text" name="smsPlatAccount" value="${dto.smsPlatAccount!}" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                短信密码:
            </th>
            <td>
                <input type="text" name="smsPlatPassword" class="text" value="${dto.smsPlatPassword!}" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                regionId:
            </th>
            <td>
                <input type="text" name="regionId" value="${dto.regionId!}" class="text" maxlength="200" />
                <span class="tips">阿里云短信使用（北京：cn_beijng）</span>
            </td>
        </tr>
        <tr>
            <th>
                短信签名编码:
            </th>
            <td>
                <input type="text" name="signCode" value="${dto.signCode!}" class="text" maxlength="200" />
                <span class="tips">云MAS短信使用</span>
            </td>
        </tr>
        <tr>
            <th>
                短信扩展码:
            </th>
            <td>
                <input type="text" name="addSerial" value="${dto.addSerial!}" class="text" maxlength="200" />
                <span class="tips">云MAS短信使用（选填）</span>
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