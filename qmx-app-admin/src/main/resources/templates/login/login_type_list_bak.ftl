<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>选择登录列表</title>
<#include "/include/header_include_old.ftl">
    <script type="text/javascript">
        $(function () {
            // 令牌
            $("form").submit(function() {
                var $this = $(this);
                if ($this.attr("method") != null && $this.attr("method").toLowerCase() == "post" && $this.find("input[name='token']").size() == 0) {
                    var token = getCookie("token");
                    if (token != null) {
                        $this.append('<input type="hidden" name="token" value="' + token + '" \/>');
                    }
                }
                /*$("select[name=account]").change(function(){
                    console.log($(this).val());
                });*/
                var $account = $('select[name=account] option:selected');
                var pwd = $account.attr("pwd");
                var $from = $("#inputForm");
                $from.append('<input type="hidden" name="password" value="' + pwd + '" \/>');
            });

            $("select[name=account]").change(function(){
                console.log($(this).val());
            });
        });
        // 获取Cookie
        function getCookie(name) {
            if (name != null) {
                var value = new RegExp("(?:^|; )" + encodeURIComponent(String(name)) + "=([^;]*)").exec(document.cookie);
                return value ? decodeURIComponent(value[1]) : null;
            }
        }
        function setPwd(pwd) {
            var $from = $("#inputForm");
            $from.append('<input type="hidden" name="password" value="' + pwd + '" \/>');
        }
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        选择登录列表
    </div>
</div>
<form id="inputForm" action="submitLogin" method="post">
    <br/>
    <p>选择登录列表</p>
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>选择账号:
                <input name="captcha" value="${captcha!}" type="hidden"/>
                <input name="rememberMe" value="${rememberMe?string("true","false")}" type="hidden"/>
            </th>
            <td>
                <select name="account">
                    <#list userList as dto>
                        <option value="${dto.account!}" pwd="${dto.password!}">${dto.account!}</option>
                    </#list>
                </select>
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