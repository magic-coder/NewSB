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
            var $ = layui.jquery;
            laydate.render({
                elem: '#validity'
            });
            /*var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
            form.on('submit(submit)', function () {
                $.ajax({
                    url: 'settlement',
                    type: 'POST',
                    data: $("#billTable").serialize(),
                    dataType: 'json',
                    success: function (data) {
                        if (data.state == 'success') {
                            layer.msg(data.msg);
                            parent.layer.close(index);
                            form.render();
                        } else {
                            layer.msg(data.msg);
                        }
                    }
                })
            })*/
        });

    </script>
    <script type="text/javascript">
        //注意：parent 是 JS 自带的全局对象，可用于操作父页面
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        //关闭iframe
        $(document).on("click", "#closeIframe", function () {
            parent.layer.close(index);
        });
        //提交iframe
        $(document).on("click", "#submitIframe", function () {
            $.ajax({
                url: 'settlement',
                type: 'POST',
                data: $("#billTable").serialize(),
                dataType: 'json',
                success: function (data) {
                    if (data.state == 'success') {
                        layer.msg(data.msg, {
                            time: 1000 //1秒关闭（如果不配置，默认是3秒）
                        }, function () {
                            parent.layer.close(index);
                            window.parent.location.reload(true);
                        });
                    } else {
                        layer.msg(data.msg);
                    }
                }
            })
        });
    </script>
</head>
<body>
<form class="layui-form" id="billTable">
    <input type="hidden" name="ids" value="${ids!}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <input name="sn" type="hidden" value="${dto.sn!}">
        <input name="amount" type="hidden" value="${dto.amount!}">
        <input name="memberId" type="hidden" value="${dto.memberId!}"/>
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">账单编号</label>
            <div class="layui-form-mid">${dto.sn!}</div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">总金额</label>
            <div class="layui-form-mid">${dto.amount!}</div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">支付方式</label>
            <div class="layui-input-inline">
                <select name="channelNo" lay-verify="required">
                    <option value=""></option>
                <#list type as info>
                    <option value="${info}">${info.title}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">备注</label>
            <div class="layui-input-inline">
                <textarea placeholder="请输入内容" class="layui-textarea" name="remark"></textarea>
            </div>

        </div>
    </div>
<#--<div class="layui-form-item">
    <div class="layui-input-block">
        <button class="layui-btn layui-btn-normal" lay-submit="submit" lay-filter="submit">立即提交
        </button>
        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
    </div>
</div>-->
</form>
<div class="layui-form-item">
    <div class="layui-input-block">
        <input id="submitIframe" type="button" class="layui-btn layui-btn-normal" value="立即提交"/>
        <input id="closeIframe" type="button" class="layui-btn layui-btn-primary" value="取消"/>
    </div>
</div>
</body>
</html>