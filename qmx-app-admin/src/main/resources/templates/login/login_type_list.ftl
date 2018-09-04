<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--<meta name="viewport" content="width=device-width, initial-scale=1">-->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>登录账号选择</title>
    <!-- Bootstrap -->
    <link href="${base}/resources/assets/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="${base}/resources/common/css/qmx-gds.css" rel="stylesheet" />

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style>
        html,body {
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
    </style>
</head>
<body class="user">
<form id="inputForm" action="submitLogin" method="post">
<div class="gds-bg">
    <div>
        <img src="${base}/resources/module/system/images/user-bg.jpg" />
        <div class="gds-center">
            <h2>选择登录列表</h2>
            <input name="captcha" value="${captcha!}" type="hidden"/>
            <input name="rememberMe" value="${rememberMe?string("true","false")}" type="hidden"/>
            <input id="account" name="account" type="hidden"/>
            <input id="password" name="password" type="hidden"/>
            <div class="user-select">
                <div class="btn-group">
                    <button id="user" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                        选择账号
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="user">
                        <#list userList as dto>
                            <#assign pwd = dto.password/>
                            <#if loginType?? && loginType == 'EMAIL'>
                                <#assign pwd = dto.emailLoginPwd/>
                            <#elseif loginType?? && loginType == 'PHONE'>
                                <#assign pwd = dto.phoneLoginPwd/>
                            </#if>
                        <li role="presentation" account="${dto.account!}" pwd="${pwd!}"><a href="#">[${dto.userType.getName()}]${dto.account!}(${dto.username!})</a></li>
                        </#list>
                    </ul>
                </div>
                <button class="btn btn-default user-btn" id="btnSubmit" type="submit">确认</button>
            </div>
        </div>
    </div>
</div>
</form>
<div class="container-fluid">
</div>
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="${base}/resources/common/js/jquery-3.2.1.min.js"></script>
<script src="${base}/resources/common/js/common.tools.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="${base}/resources/assets/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">
    $('.dropdown-menu').each(function(){
        var _id = $(this).attr('aria-labelledby');
        $(this).find('li').click(function() {
            var _text = $(this).text();
            $('#'+_id).text(_text);
            $('#account').val($(this).attr('account'));
            $('#password').val($(this).attr('pwd'));
        });
    });
</script>
</body>
</html>