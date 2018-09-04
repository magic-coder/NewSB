<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form'], function () {
            var form = layui.form;

            form.verify({
                deduct: [/^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/, '请输入正确的提成比例!']
            });
        });

        function render() {
            layui.use(['form'], function () {
                var form = layui.form;
                form.render(); //更新全部
            });
        }
    </script>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">提成方式</label>
            <div class="layui-input-inline">
                <select name="type">
                    <option value="money" <#if dto.type == "money">selected</#if>>金额</option>
                    <option value="amount" <#if dto.type == "amount">selected</#if>>数量</option>
                </select>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">提成比例</label>
            <div class="layui-input-inline">
                <input name="number" lay-verify="required|deduct" autocomplete="off" class="layui-input"
                       value="${dto.number!}">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
</body>
</html>