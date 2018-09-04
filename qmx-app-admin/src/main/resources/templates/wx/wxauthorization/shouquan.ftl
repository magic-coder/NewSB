<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--<meta name="viewport" content="width=device-width, initial-scale=1">-->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>授权</title>

    <!-- Bootstrap -->
    <!--<link href="node_modules/bootstrap/dist/css/bootstrap.css" rel="stylesheet" />-->
    <!--<link href="css/bootstrap.min.css" rel="stylesheet" />-->
    <link href="${base}/resources/module/wx/css/bind.css" rel="stylesheet" />

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="${base}/resources/module/wx/js/html5shiv.min.js"></script>
    <script src="${base}/resources/module/wx/js/respond.min.js"></script>
    <![endif]-->
</head>
<body class="bind">
<div class="bind-box">
    <h2>首次使用<br />请先绑定微信公众号</h2>
    <div class="bind-step">
        <p>1、仅支持已认证通过的微信服务号；</p>
        <p>2、绑定需要微信服务号的管理员扫码授权并确认；</p>
        <p>3、售票功能需开通微信支付。</p>
    </div>
    <a href="${componentloginpage!}" class="bind-btn">立即绑定</a>
</div>
</body>
</html>
