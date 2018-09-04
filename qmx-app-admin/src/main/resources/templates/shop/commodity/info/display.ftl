<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>商品-查看</title>
<#include "/include/common_header_include.ftl">

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
            <div class="layui-form-mid">
            ${dto.name!}
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">产地</label>
        <div class="layui-input-inline" style="width: auto">
            <div class="layui-input-inline">
                <select name="province" lay-filter="province" lay-verify="required" disabled>
                    <option value="">请选择</option>
                </select>
            </div>
            <div class="layui-input-inline" style="display: none;">
                <select name="city" lay-filter="city" disabled>
                </select>
            </div>
            <div class="layui-input-inline" style="display: none;">
                <select name="county" lay-filter="area" disabled>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">计量单位:</label>
            <div class="layui-form-mid">
            ${dto.meteringUntis!}
            </div>
        </div>
    </div>
    <div class="layui-form-item">
    <#-- <div class="layui-inline">
         <label class="layui-form-label">成本价:</label>
         <div class="layui-input-inline">
         ${dto.costPrice!}
         </div>
     </div>-->
        <div class="layui-inline">
            <label class="layui-form-label">库存:</label>
            <div class="layui-form-mid">
            ${dto.sumStock!}
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">库存预警量:</label>
            <div class="layui-form-mid">
            ${dto.warningStock!}
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <input class="layui-btn layui-btn-primary" onclick="history.back();" style="width: 150px" value="返回"/>
        </div>
    </div>
</form>
</body>
<script type="text/javascript" src="${base}/resources/common/js/area.js"></script>
<script>
    layui.use(['form', 'table', 'laydate', 'jquery'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;


        loadArea();
        //var area = JSON.parse('${dto.area!}');
        bindArea(${dto.placeOrigin!});
        form.render();
    });
</script>
</html>