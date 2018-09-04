<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>绑定邮箱</title>
<#include "/include/header_include_old.ftl">
    <script type="text/javascript">
        $(function () {

            // 令牌
            $(document).ajaxSend(function(event, request, settings) {
                if (!settings.crossDomain && settings.type != null && settings.type.toLowerCase() == "post") {
                    var token = getCookie("token");
                    if (token != null) {
                        request.setRequestHeader("token", token);
                    }
                }
            });

            $("form").submit(function() {
                var $this = $(this);
                if ($this.attr("method") != null && $this.attr("method").toLowerCase() == "post" && $this.find("input[name='token']").size() == 0) {
                    var token = getCookie("token");
                    if (token != null) {
                        $this.append('<input type="hidden" name="token" value="' + token + '" \/>');
                    }
                }
            });

            // 更换验证码
            $("#captchaImage").click(function(){
                $(this).attr("src", "/common/captcha?timestamp=" + (new Date()).valueOf());
            });

            $("#sendCaptcha").click(function () {
                var captcha = $("input[name=captcha]");
                var email = $("input[name=email]");
                var account = $("input[name=account]");
                if(captcha.val() == ''){
                    alert('验证码不能为空');
                    captcha.focus();
                    return;
                }
                if(email.val() == ''){
                    alert('邮箱不能为空');
                    email.focus();
                    return;
                }
                var data = {};
                data.captcha = captcha.val();
                data.email = email.val();
                data.account = account.val();
                $.ajax({
                    url: 'sendBindEmailVerifyCode',
                    type: 'POST',
                    data:data,
                    success: function(respData) {
                        if(respData.errorCode == 0){
                            alert("发送成功");
                        }else{
                            alert(respData.errorMsg);
                        }
                    },
                    error: function(xhr) {
                        console.log('error:' + JSON.stringify(xhr));
                    }
                });
            });
        });
        // 获取Cookie
        function getCookie(name) {
            if (name != null) {
                var value = new RegExp("(?:^|; )" + encodeURIComponent(String(name)) + "=([^;]*)").exec(document.cookie);
                return value ? decodeURIComponent(value[1]) : null;
            }
        }
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        绑定邮箱
    </div>
</div>
<form id="inputForm" action="bindUserEmail" method="post">
    <br/>
    <p>绑定邮箱</p>
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>用户名:
            </th>
            <td>
                ${userInfo.username!}(${userInfo.account!})
                <input name="account" type="hidden" value="${userInfo.account!}"/>
            </td>
        </tr>
        <tr>
            <th>
                绑定邮箱:
            </th>
            <td>
                <input type="text" name="email" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                验证码
            </th>
            <td>
                <img id="captchaImage" src="/common/captcha" style="margin-top:18px;vertical-align: middle;">
                <input name="captcha" type="text" style="width:100px;margin-left:30px;margin-top:20px;vertical-align: middle;" placeholder="输入验证码">
            </td>
        </tr>
        <tr>
            <th>
                邮箱验证码:
            </th>
            <td>
                <input type="text" name="verifyCode" class="text" maxlength="200" />&nbsp;<input id="sendCaptcha" type="button" value="发送邮箱验证码"/>
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