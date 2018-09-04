<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--<meta name="viewport" content="width=device-width, initial-scale=1">-->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>绑定邮箱</title>

    <!-- Bootstrap -->
    <link href="${base}/resources/assets/bootstrap/css/bootstrap-modify.css" rel="stylesheet" />
    <!--<link href="css/bootstrap.min.css" rel="stylesheet" />-->
    <link href="${base}/resources/module/system/css/gds.css" rel="stylesheet" />
    <script src="${base}/resources/common/js/jquery-3.2.1.min.js"></script>
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style>
        html, body {
            width: 100%;
            height: 100%;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            var $pwd = $("input[name=newPwd]");
            // 令牌
            $(document).ajaxSend(function(event, request, settings) {
                if (!settings.crossDomain && settings.type != null && settings.type.toLowerCase() == "post") {
                    var token = getCookie("token");
                    if (token != null) {
                        request.setRequestHeader("token", token);
                    }
                }
            });

            $("#btnDoUpdate").click(function () {

                var $this = $("form");
                var email = $("input[name=email]");
                var captcha = $("input[name=captcha]");
                var verifyCode = $("input[name=verifyCode]");
                //var newPwd = $("input[name=newPwd]");
                if(email.val() == ''){
                    alert('邮箱不能为空');
                    email.focus();
                    return;
                }
                if(captcha.val() == ''){
                    alert('验证码不能为空');
                    captcha.focus();
                    return;
                }
                if(verifyCode.val() == ''){
                    alert('邮箱验证码不能为空');
                    verifyCode.focus();
                    return;
                }
                if($pwd.attr("needPwd") == "1"){
                    if($pwd.val() == ''){
                        alert('邮箱密码不能为空');
                        $pwd.focus();
                        return;
                    }
                }
                if ($this.attr("method") != null && $this.attr("method").toLowerCase() == "post" && $this.find("input[name='token']").length == 0) {
                    var token = getCookie("token");
                    if (token != null) {
                        $this.append('<input type="hidden" name="token" value="' + token + '" \/>');
                    }
                }
                //提交
                $("form").submit();
            });

            // 更换验证码
            $("#captchaImage").click(function(){
                $(this).attr("src", "/common/captcha?timestamp=" + new Date());
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
                            var flag = respData.data;
                            if(flag){
                                $pwd.attr("needPwd","1");
                                $("#emailPwd").show();
                            }else{
                                $pwd.attr("needPwd","0");
                                $("#emailPwd").hide();
                            }
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
<body class="container gds-pull">
<form id="inputForm" action="bindUserEmail" method="post" autocomplete="off">
    <div class="gds-pull-index">

        <div class="gds-half-box" style="min-width: 760px;">
            <div class="gds-address">
               <span>绑定邮箱</span>
            </div>
            <div class="gds-form gds-form-change">
                <div class="row">
                    <label class="col-xs-6">用户名：</label>
                    <div class="col-xs-6" style="padding-top: 1px;">
                    ${userInfo.username!}(${userInfo.account!})
                        <input name="account" type="hidden" value="${userInfo.account!}"/>
                    </div>
                </div>
                <div class="row">
                    <label class="col-xs-6">验证码：</label>
                    <input name="captcha" type="text" class="col-xs-8" placeholder="请输入右侧验证码" />
                    <div class="col-xs-6" style="padding-top: 1px;">
                        <img id="captchaImage" class="gds-form-code" src="/common/captcha" width="108" height="26" />
                    </div>
                </div>
                <div class="row">
                    <label class="col-xs-6">绑定邮箱：</label>
                    <input type="text" name="email" class="col-xs-14" placeholder="请输入要绑定的邮箱" />
                </div>
                <div class="row">
                    <label class="col-xs-6">邮箱验证码：</label>
                    <input type="text" name="verifyCode" class="col-xs-8" placeholder="请输入邮箱收到的验证码" />
                    <div class="col-xs-6">
                        <span id="sendCaptcha" class="gds-btn-3">发送验证码</span>
                    </div>
                </div>
                <div id="emailPwd" class="row" style="display: none">
                    <label class="col-xs-6">设置邮箱登录密码：</label>
                    <input type="password" name="newPwd" class="col-xs-14" placeholder="请输入密码" />
                <#--<span class="text-danger col-md-offset-6">*输入的密码</span>-->
                </div>
                <div class="row">
                    <div class="col-xs-14 col-md-offset-6 gds-from-btn">
                        <span class="gds-btn-3" id="btnDoUpdate">确认修改</span>
                    <#--<span class="gds-btn-3 pull-right">返回</span>-->
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>