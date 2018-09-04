<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8">
    <title>GDS登录</title>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport"/>
    <link rel="icon" href="${base}/favicon.ico" type="image/x-icon"/>
    <!-- CSS -->
    <link rel="stylesheet" href="${base}/resources/assets/layui/css/layui.css">
    <script type="text/javascript" src="${base}/resources/common/js/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="${base}/resources/common/js/common.tools.js"></script>
    <script type="text/javascript" src="${base}/resources/assets/layui/layui.js"></script>
    <style>
        body
        {
            background-image: url(/resources/common/images/login_bg_xx.jpg);
            background-repeat: no-repeat;
            background-size:100%;
        }
    </style>
</head>
<body class="layui-fluid">
<div class="layui-container" style="width: 450px;height:300px;margin-top: 390px;background: #b7c8d9;padding-top: 30px;padding-left: 20px;">
    <form class="layui-form" action="/login/loginVerify" method="post">
        <div class="layui-form-item">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-inline">
                <input type="text" name="account" lay-verify="account" placeholder="请输入用户名" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">密码</label>
            <div class="layui-input-inline">
                <input type="password" name="password" required lay-verify="password" placeholder="请输入密码" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-mid">
                <input type="hidden" name="rememberMe" value="true" checked="">
                <a style="color: red;" href="/login/forgetPassword">忘记密码?</a>
            </div>
        </div>
    <#if needCaptcha?? && needCaptcha>
        <div class="layui-form-item">
            <label class="layui-form-label">验证码</label>
            <div class="layui-input-inline" style="width: 90px;margin-left: 2px;">
                <img src="/common/captcha" style="vertical-align: middle;">
            </div>
            <div class="layui-input-inline" style="width: 90px;">
                <input type="text" name="captcha" maxlength="6" required lay-verify="required" placeholder="验证码" autocomplete="off" class="layui-input">
            </div>
        </div>
    </#if>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal layui-btn-fluid" lay-submit lay-filter="formLogin">
                    登录
                </button>
                <#--<button type="reset" class="layui-btn layui-btn-primary">重置</button>-->
            </div>
        </div>
    </form>
</div>
<script>
    if(top!=self) {
        top.location.href='/';
    }
    layui.use('form', function(){
        var form = layui.form;
    <#if errMsg??>
        layer.msg('${(errMsg)!}');
    </#if>
        //自定义验证规则
        form.verify({
            account: function(value){
                if(value.length <= 0){
                    return '用户名不能为空';
                }
            }
            ,password: function (value) {
                if(value.length <= 0){
                    return '密码不能为空';
                }
            }
        });

        //监听提交
        form.on('submit(formLogin)', function(data){
            var index = layer.load(2, {time: 6*1000}); //设定最长等待10秒
            var $this = $(this);
            var loginText = '<i class=\"layui-icon layui-anim layui-anim-rotate layui-anim-loop\">&#xe63d;</i>&nbsp;登录中...';
            $this.html(loginText);
            //$this.addClass('layui-btn-disabled');
            //layer.msg(JSON.stringify(data.field));
            //return false;
        });
        //回车事件绑定
        document.onkeydown = function (event) {
            var e = event || window.event || arguments.callee.caller.arguments[0];
            if (e && e.keyCode == 13) {
                form.submit();
            }
        };
    });
</script>
</body>
</html>