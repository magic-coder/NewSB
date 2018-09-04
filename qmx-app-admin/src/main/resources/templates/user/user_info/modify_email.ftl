<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--<meta name="viewport" content="width=device-width, initial-scale=1">-->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>修改邮箱</title>

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

            // 令牌
            $(document).ajaxSend(function(event, request, settings) {
                if (!settings.crossDomain && settings.type != null && settings.type.toLowerCase() == "post") {
                    var token = getCookie("token");
                    if (token != null) {
                        request.setRequestHeader("token", token);
                    }
                }
            });

            $("#btnModifyUserEmailVerify").click(function () {

                var $this = $("form");

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
                $(this).attr("src", "/common/captcha?timestamp=" + (new Date()).valueOf());
            });

            $("#sendCaptcha").click(function () {

                var captcha = $("input[name=captcha]");
                if(captcha.val() == ''){
                    alert('验证码不能为空');
                    captcha.focus();
                    return;
                }
                var data = {};
                data.captcha = captcha.val();
                $.ajax({
                    url: '/login/sendModifyEmailVerifyCode',
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
<body class="container gds-pull">
<form id="inputForm" action="modifyUserEmailVerify" method="post" autocomplete="off">
<div class="gds-pull-index">
    <div class="gds-half-box" style="min-width: 760px;">
        <div class="gds-address">
            <a href="/homePage">首页</a><a>></a><span>修改绑定邮箱</span>
        </div>
        <div class="gds-form gds-form-change">
            <div class="row">
                <label class="col-xs-6">验证码：</label>
                <input name="captcha" type="text" class="col-xs-8" placeholder="请输入右侧验证码" />
                <div class="col-xs-6" style="padding-top: 1px;">
                    <img id="captchaImage" class="gds-form-code" src="/common/captcha" width="108" height="26" />
                </div>
            </div>
            <div class="row">
                <label class="col-xs-6">邮箱验证码：</label>
                <input type="text" name="verifyCode" type="text" class="col-xs-8" placeholder="请输入邮箱收到的验证码" />
                <div class="col-xs-6">
                    <span id="sendCaptcha" class="gds-btn-3">发送验证码</span>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-14 col-md-offset-6 gds-from-btn">
                    <span class="gds-btn-3" id="btnModifyUserEmailVerify">下一步</span>
                    <#--<span class="gds-btn-3 pull-right">返回</span>-->
                </div>
            </div>
        </div>
    </div>
</div>
</form>
</body>
</html>