<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate', 'upload'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var upload = layui.upload;

            $(document).on("click", "#affirm", function () {
                $("#affirm").attr("disabled", "disabled");
                $.ajax({
                    url: "save",
                    type: "POST",
                    data: $('#noteForm').serialize(),
                    dataType: 'json',
                    success: function (result) {
                        if (result.state == 'success') {
                            // $("#onteId").val(result.onteId);
                            layer.msg(result.msg);
                            setTimeout(function () {
                                location.reload(true);
                            }, 500);
                        } else {
                            layer.msg(result.msg);
                        }
                    }
                });
            });

        });


    </script>
</head>
<body>
<form class="layui-form" id="noteForm" method="post">
    <input name="id" id="onteId" <#if dto??>value="${dto.id!}" </#if> type="hidden"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">客户经理</label>
            <div class="layui-input-inline">
                <select name="managerNoteId" lay-verify="required">
                    <option value="">请选择</option>
                <#list smsTemplates as info>
                    <option value="${info.id!}"
                            <#if dto?? && dto.managerNoteId?? &&dto.managerNoteId==info.id>selected</#if>>${info.name!}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">旅行社联系人</label>
            <div class="layui-input-inline">
                <select name="contactsNoteId" lay-verify="required">
                    <option value="">请选择</option>
                <#list smsTemplates as info>
                    <option value="${info.id!}"
                            <#if dto?? && dto.contactsNoteId?? &&dto.contactsNoteId==info.id>selected</#if>>${info.name!}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">导游/领队</label>
            <div class="layui-input-inline">
                <select name="guideNoteId" lay-verify="required">
                    <option value="">请选择</option>
                <#list smsTemplates as info>
                    <option value="${info.id!}"
                            <#if dto?? && dto.guideNoteId?? &&dto.guideNoteId==info.id>selected</#if>>${info.name!}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">司机</label>
            <div class="layui-input-inline">
                <select name="driverNoteId" lay-verify="required">
                    <option value="">请选择</option>
                <#list smsTemplates as info>
                    <option value="${info.id!}"
                            <#if dto??&&dto.driverNoteId?? &&dto.driverNoteId==info.id!>selected</#if>>${info.name!}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item">
    <div class="layui-input-block">
        <button class="layui-btn layui-btn-normal" id="affirm">立即提交</button>
        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
    </div>
</div>
</body>
</html>