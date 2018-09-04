<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>评论管理</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" action="save" method="post">
    <input type="hidden" name="id" value="${(wxComment.id)!}"/>
    <input type="hidden" name="userId" value="${(wxComment.userId)!}"/>
    <input type="hidden" name="authorizationId" value="${(wxComment.authorizationId)!}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>评论管理</legend>
        <legend>与【<span>${(wxComment.nickname)!}</span>】的聊天记录</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">回复评论</label>
            <div class="layui-input-inline">
                <textarea id="content" name="content" placeholder="请输入内容" class="layui-textarea"></textarea>
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
    <div class="layui-form-item">
        <div class="layui-inline">
            <div class="layui-input-inline">
                <ul>
                <#list wxComments as dto>
                    <li class="message_item reply">
                        <div class="message_content">
                            <div class="reply_left">
                                <img src="" style="width: 64px;height: 64px;"/>
                            </div>
                            <#if (dto.isUserMessage)?? && dto.isUserMessage==true >
                                <div class="reply_right">
                                    <p>
                                        <span>投诉人姓名：</span>
                                    ${(dto.name)!}
                                    </p>
                                    <p>
                                        <span>投诉人电话：</span>
                                    ${(dto.phone)!}
                                    </p>
                                    <p>
                                        <span>投诉内容：</span>
                                    ${(dto.content)!}
                                    </p>
                                    <p>
                                        <span>投诉图片：</span>
                                        <#list urls[dto_index] as url>
                                            <a href="${url!'javascript:void(0);'}" target="_blank"><img src="${url!}" style="width: 32px;height: 32px;"/></a>
                                        </#list>
                                    </p>
                                </div>
                            <#else >
                                <div class="reply_right">
                                    <p>
                                        <span>回复内容：</span>
                                    ${(dto.content)!}
                                    </p>
                                </div>
                            </#if>
                        </div>
                    </li>
                </#list>
                </ul>
            </div>
        </div>
    </div>
	</form>

    <script>
        var Script = function () {
            $("#inputForm").validate({
                rules: {
                    keyvalue: "required",
                    content: "required",
                },
                messages: {
                    keyvalue: "必填项",
                    content:"必填项",
                }
            });
        }();
    </script>
</body>
</html>