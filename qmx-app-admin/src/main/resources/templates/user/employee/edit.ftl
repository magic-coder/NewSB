<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>提现</title>
</head>
<body>
<form class="layui-form" action="update" style="margin-top: 10px;" method="post">
    <div class="layui-form-item" style="margin-top: 20px;">
        <div class="layui-inline">
            <label class="layui-form-label">登录账号</label>
            <div class="layui-input-inline">
                <input name="id" type="hidden" value="${userInfo.id}"/>
                <input type="hidden" name="areaId" value="${userInfo.areaId!}"/>
            <@shiro.hasRole name="admin">
            <#--管理员-->
                <input type="text" name="account" value="${userInfo.account!}" lay-verify="required" maxlength="20" autocomplete="off" class="layui-input">
            </@shiro.hasRole>
            <@shiro.lacksRole name="admin">
                <label class="layui-form-label">${userInfo.account!}</label>
                <input name="account" type="hidden" value="${userInfo.account}"/>
            </@shiro.lacksRole>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">登录密码</label>
            <div class="layui-input-inline">
                <input type="password" name="password" maxlength="20" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-inline">
                <input type="text"name="username" value="${userInfo.username!}" maxlength="20" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">部门</label>
            <div class="layui-input-inline">
                <select name="deptId">
                    <option value="">--请选择--</option>
                <#if depts??>
                    <#list depts as dept>
                        <option value="${dept.id!}" <#if dept.id = userInfo.deptId>selected</#if> >${dept.deptName!}</option>
                    </#list>
                </#if>
                </select>
            </div>
        </div>
    </div>
<#if userInfo.bindEmail>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">邮箱</label>
            <div class="layui-input-inline">
                <label class="layui-form-label">${userInfo.email!}</label>
            </div>
        </div>
    </div>
</#if>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">手机</label>
            <div class="layui-input-inline">
                <input type="text" name="phone" value="${userInfo.phone!}" lay-verify="phone" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <div id="areaDiv"></div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">是否启用</label>
            <div class="layui-input-inline">
                <label><input type="radio" <#if userInfo.enable>checked</#if> name="enable" title="是" value="true"/></label>
                <label><input type="radio" <#if !userInfo.enable>checked</#if> name="enable" title="否" value="false"/></label>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block" style="margin-top: 10px;">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitUpdate">提交</button>
            </div>
        </div>
    </div>
</form>
<#include "/include/common_header_include.ftl">
<script type="text/javascript" src="${base}/resources/common/js/area-data.js"></script>
<script type="text/javascript" src="${base}/resources/common/js/picker.js"></script>
<script>
    layui.config({
        base: '${base}/resources/common/js/' //你存放新模块的目录，注意，不是layui的模块目录
    }).use('picker'); //加载入口
    layui.use(['picker','form'], function() {
        var picker = layui.picker,form=layui.form;

        //demo2
        var areaDiv = new picker();
        areaDiv.set({
            elem: '#areaDiv',
            data: Areas,
        <#if userInfo.areaId?? && userInfo.areaId != 1>
            codeConfig: {
            ${userInfo.areaId}
            },
        </#if>
            canSearch: true
        }).render();

        //监听提交
        /*form.on('submit(submitUpdate)', function(data){
            var reqData = data.field;
            layer.alert(JSON.stringify(reqData), {
                title: '最终的提交信息'
            });
            return false;
        });*/
    });
</script>
</body>
</html>