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

            form.verify({
                distributorId: [/[\S]+/, "请选择分销商"]
            });
            upload.render({
                elem: '#licenseBtn',
                url: '${base}/file/upload?fileType=image&token=' + getCookie("token"),
                done: function (res) {
                    //如果上传失败
                    if (res.code > 0) {
                        return layer.msg('上传失败');
                    }
                    //上传成功
                    $("#license").val(res.data);
                },
                error: function () {
                    //请求异常回调
                    alert("异常!!!");
                }
            });
            upload.render({
                elem: '#materialBtn',
                url: '${base}/file/upload?fileType=image&token=' + getCookie("token"),
                done: function (res) {
                    //如果上传失败
                    if (res.code > 0) {
                        return layer.msg('上传失败');
                    }
                    //上传成功
                    $("#material").val(res.data);
                },
                error: function () {
                    //请求异常回调
                    alert("异常!!!");
                }
            });
        });
        //关联旅行社
        $(document).on("click", "#userIdBtn", function () {
            var index = layer.open({
                type: 2,
                title: '关联旅行社',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getUser?type=1'
            });
        });
        //选择销售经理
        $(document).on("click", "#managerBtn", function () {
            var index = layer.open({
                type: 2,
                title: '选择销售经理',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getUser?type=2'
            });
        });
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
            <label class="layui-form-label">关联分销商</label>
            <div class="layui-input-inline">
                <input id="userId" name="userId" type="hidden" lay-verify="distributorId" autocomplete="off"
                       class="layui-input" value="${dto.userId!}">
                <div id="userIdName" class="layui-form-mid">${dto.userName}</div>
            </div>
        <#--<div class="layui-input-inline">
            <button id="userIdBtn" type="button" class="layui-btn">
                选择
            </button>
        </div>-->
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">销售经理</label>
            <div class="layui-input-inline">
                <input id="manager" name="manager" type="hidden" lay-verify="required" autocomplete="off"
                       class="layui-input" value="${dto.manager!}">
                <div id="managerName" class="layui-form-mid">${dto.managerName}</div>
            </div>
            <div class="layui-input-inline">
                <button id="managerBtn" type="button" class="layui-btn">
                    选择
                </button>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">旅行社名称</label>
            <div class="layui-input-inline">
                <input name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.name!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">旅行社等级</label>
            <div class="layui-input-inline">
                <select name="level" lay-verify="required">
                    <option value=""></option>
                <#list levels as level>
                    <option value="${level}" <#if level==dto.level>selected</#if>>${level.title}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">联系人姓名</label>
            <div class="layui-input-inline">
                <input name="contactsName" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.contactsName!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">联系人电话</label>
            <div class="layui-input-inline">
                <input name="contactsMobile" lay-verify="required|phone" autocomplete="off" class="layui-input"
                       value="${dto.contactsMobile!}">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">营业执照</label>
            <div class="layui-input-inline">
                <input id="license" name="license" autocomplete="off" class="layui-input"
                       value="${dto.license!}">
            </div>
            <div class="layui-input-inline">
                <button id="licenseBtn" type="button" class="layui-btn">
                    <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
                </button>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">辅助材料</label>
            <div class="layui-input-inline">
                <input id="material" name="material" autocomplete="off" class="layui-input"
                       value="${dto.material!}">
            </div>
            <div class="layui-input-inline">
                <button id="materialBtn" type="button" class="layui-btn">
                    <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
                </button>
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