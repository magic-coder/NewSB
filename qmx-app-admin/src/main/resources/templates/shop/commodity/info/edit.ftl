<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>商品-编辑</title>
    <#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/resources/common/js/area.js"></script>
    <script>
        //初始数据
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            loadArea();
            //var area = JSON.parse('${dto.area!}');
            bindArea(${dto.placeOrigin!});

            form.verify({
                warningStock:[/^\d+$/,"请填写正确的预警库存量！"]
            });
        });

    </script>
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form id="commodityForm" method="post" name="imgForm" action="update" class="layui-form">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">商品名称:</label>
            <div class="layui-input-inline">
                <input name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.name!}">
                <input name="id" autocomplete="off" class="layui-input" value="${dto.id!}" type="hidden">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">产地</label>
        <div class="layui-input-inline" style="width: auto">
            <div class="layui-input-inline">
                <select name="province" lay-filter="province" lay-verify="required">
                    <option value="">请选择</option>
                </select>
            </div>
            <div class="layui-input-inline" style="display: none;">
                <select name="city" lay-filter="city">
                </select>
            </div>
            <div class="layui-input-inline" style="display: none;">
                <select name="county" lay-filter="area">
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">计量单位:</label>
            <div class="layui-input-inline">
                <input name="meteringUntis" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.meteringUntis!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
<#--        <div class="layui-inline">
            <label class="layui-form-label">成本价:</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${dto.costPrice?string("0.00")!}</div>
            </div>
        </div>-->
        <div class="layui-inline">
            <label class="layui-form-label">库存:</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${dto.sumStock!}</div>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">库存预警量:</label>
            <div class="layui-input-inline">
                <input name="warningStock" lay-verify="warningStock" autocomplete="off" class="layui-input" value="${dto.warningStock!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">确认</button>
            <input type="button" class="layui-btn layui-btn-primary" onclick="history.back();" value="返回"/>
        </div>
    </div>
</form>
</body>
</html>