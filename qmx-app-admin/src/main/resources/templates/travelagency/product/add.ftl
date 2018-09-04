<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'laydate'], function () {
            var form = layui.form;
            var laydate = layui.laydate;
            laydate.render({
                elem: '#stime'
            });
            laydate.render({
                elem: '#etime'
            });

            form.verify({
                positiveInteger: [
                    /^([1-9]\d*|[0]{1,1})$/
                    , '请输入正确的库存!'
                ]
            });
            form.render();
        });
    </script>
    <style>
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">产品名称</label>
            <div class="layui-input-inline">
                <input name="name" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    <#-- <div class="layui-inline">
         <label class="layui-form-label">日库存</label>
         <div class="layui-input-inline">
             <input name="dayStock" lay-verify="required|positiveInteger" autocomplete="off" class="layui-input">
         </div>
     </div>-->
        <div class="layui-inline">
            <label class="layui-form-label">总库存</label>
            <div class="layui-input-inline">
                <input name="totalStock" lay-verify="required|positiveInteger" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">可预订起始日期</label>
            <div class="layui-input-inline">
                <input id="stime" name="stime" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">可预订结束日期</label>
            <div class="layui-input-inline">
                <input id="etime" name="etime" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>

    <#--<div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">提前</label>
            <div class="layui-input-inline">
                <select name="hour" lay-verify="required">
                <#list 0..24 as a>
                    <option value="${a!}">${a!}</option>
                </#list>
                </select>
            </div>
            <div class="layui-form-mid">几小时预订</div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">可使用时间</label>
            <div class="layui-input-inline">
                <select name="shour" lay-verify="required">
                <#list 0..24 as a>
                    <option value="${a!}">${a!}:00</option>
                </#list>
                </select>
            </div>
            <div class="layui-form-mid">-</div>
            <div class="layui-input-inline">
                <select name="ehour" lay-verify="required">
                <#list 0..24 as a>
                    <option value="${a!}">${a!}:00</option>
                </#list>
                </select>
            </div>
        </div>
    </div>-->

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">出票模式</label>
            <div class="layui-input-inline" style="width:auto;">
            <#list outTickets as outTicket>
                <input name="outTicket" value="${outTicket}" title="${outTicket.title}" type="radio" checked>
            </#list>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">使用模式</label>
            <div class="layui-input-inline" style="width:auto;">
            <#list useTickets as useTicket>
                <input name="useTicket" value="${useTicket}" title="${useTicket.title}" type="radio" checked>
            </#list>
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