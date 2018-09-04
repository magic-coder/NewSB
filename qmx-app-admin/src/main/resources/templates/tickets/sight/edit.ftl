<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>编辑景区</title>
<#include "/include/common_header_include.ftl">
</head>
<body>
<form class="layui-form" action="update" style="margin-top: 10px;" method="post">
    <div class="layui-form-item" style="margin-top: 20px;">
        <div class="layui-inline">
            <label class="layui-form-label">景区名称</label>
            <div class="layui-input-inline">
                <input type="hidden" name="areaId" value="${sightInfo.areaId!}"/>
                <input type="hidden" name="id" value="${sightInfo.id}" />
                <input type="hidden" name="code" value="${sightInfo.code!}" />
                <input type="text" name="sightName" value="${sightInfo.sightName}" lay-verify="required" maxlength="20" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
<@shiro.hasRole name = "admin">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">业态标识</label>
            <div class="layui-input-inline">
                <input type="text" name="sightType" value="${sightInfo.sightType!}" maxlength="20" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
</@shiro.hasRole>
    <div class="layui-form-item">
        <div class="layui-inline">
            <div id="areaDiv"></div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">详细地址</label>
            <div class="layui-input-inline">
                <input type="text" name="address" value="${sightInfo.address}" lay-verify="required" maxlength="20" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">景区级别</label>
            <div class="layui-input-inline">
                <select name="sightLevel">
                    <option <#if sightInfo.sightLevel?? && sightInfo.sightLevel == '0'>selected</#if> value="0"/>无</option>
                    <option <#if sightInfo.sightLevel?? && sightInfo.sightLevel == '1'>selected</#if> value="1"/>A</option>
                    <option <#if sightInfo.sightLevel?? && sightInfo.sightLevel == '2'>selected</#if> value="2"/>AA</option>
                    <option <#if sightInfo.sightLevel?? && sightInfo.sightLevel == '3'>selected</#if> value="3"/>AAA</option>
                    <option <#if sightInfo.sightLevel?? && sightInfo.sightLevel == '4'>selected</#if> value="4"/>AAAA</option>
                    <option <#if sightInfo.sightLevel?? && sightInfo.sightLevel == '5'>selected</#if> value="5"/>AAAAA</option>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">经度</label>
            <div class="layui-input-inline">
                <input type="text" value="${sightInfo.longitude}" name="longitude" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
            <input onclick="layUIlookMap(${sightInfo.longitude!0},${sightInfo.latitude!0})" type="button" class="layui-btn layui-btn-normal" value="标注"/>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">纬度</label>
            <div class="layui-input-inline">
                <input type="text" value="${sightInfo.latitude}" name="latitude" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">营业时间</label>
            <div class="layui-input-inline">
                <input type="text" value="${sightInfo.bizHours}" name="bizHours" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">预定电话</label>
            <div class="layui-input-inline">
                <input type="text" value="${sightInfo.orderPhone}" name="orderPhone" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">咨询电话</label>
            <div class="layui-input-inline">
                <input type="text" value="${sightInfo.consultPhone}" name="consultPhone" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">描述</label>
            <div class="layui-input-inline">
                <textarea name="description" class="editor">${sightInfo.description!}</textarea>
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
<script type="text/javascript" src="${base}/resources/common/js/area-data.js"></script>
<script type="text/javascript" src="${base}/resources/common/js/picker.js"></script>
<script type="text/javascript" src="${base}/resources/admin/editor/kindeditor.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/openMap.js"></script>
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
            codeConfig: {
                code: ${(sightInfo.areaId)!}
            }
            canSearch: true
        }).render();
    });
</script>
</body>
</html>