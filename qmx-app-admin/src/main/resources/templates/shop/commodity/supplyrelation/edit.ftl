<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>供应商-编辑</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/bak/resources/admin/js/ajaxupload.js"></script>
    <script type="text/javascript" src="${base}/bak/resources/admin/js/image.js"></script>
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            laydate.render({
                elem: '#date' //指定元素
            });

        });

    </script>
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
    <script type="text/javascript">
        $().ready(function () {
            jQuery("input.mws_bg_box2").each(function () {
                var $this = $(this);
                uploadCompletes($this);
            });
        });

        function uploadCompletes($this) {
            var token = getCookie("token");
            new AjaxUpload($this, {
                action: '${base}/file/upload?fileType=image&token=' + getCookie("token"),
                name: 'file',
                autoSubmit: true,
                responseType: "json",
                onChange: function (file, ext) {
                    if (!(ext && /^(jpg|png|gif|jpeg|bmp)$/.test(ext))) {
                        alert("上传文件格式错误");
                        return false;
                    }
                },
                onSubmit: function (file, ext) {

                },
                onComplete: function (file, response) {
                    if (response.errorCode == 0) {
                        var filepath = response.data;
                        alert(filepath);
                        $this.prev().val(filepath);
                        $("#imgId").attr('src', filepath);
                    } else {
                        alert(response.errorMsg);
                    }
                }
            });
        }
    </script>
</head>
<body>
<form id="supplierForm" method="post" action="update" class="layui-form">
    <input type="hidden" name="id" value="${dto.id!}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">供应商名称:</label>
            <div class="layui-input-inline">
                <input name="supplierName" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.supplierName!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">营业执照号:</label>
            <div class="layui-input-inline">
                <input name="license" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.license!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">营业执照图片上传:</label>
            <div class="layui-input-inline">
                <p class="mws_row">
                    <input name="licenseImgUrl" type="hidden" class="bg_white-bor_grey voe_inp_1"
                           value="${dto.licenseImgUrl!}" placeholder="营业执照图片" required="required">
                    <input class="mws_bg_box2" value="选择文件" type="button">
                </p>
                <span style="color:red;">（图片尺寸建议：200像素*200像素）</span>
                <div class="imageStyle">
                    <img src="${dto.licenseImgUrl!}" id="imgId" class="imageStyleImg" alt="" height="200" width="200"/>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">地址:</label>
            <div class="layui-input-inline">
                <input name="address" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.address!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">联系电话:</label>
            <div class="layui-input-inline">
                <input name="companyTel" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.companyTel!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">供应商传真:</label>
            <div class="layui-input-inline">
                <input name="supplierFax" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.supplierFax!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">供应商email:</label>
            <div class="layui-input-inline">
                <input name="supplierEmail" lay-verify="email" autocomplete="off" class="layui-input"
                       value="${dto.supplierEmail!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">供应商开户银行账号:</label>
            <div class="layui-input-inline">
                <input name="supplierBankAccount" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.supplierBankAccount!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">开户银行:</label>
            <div class="layui-input-inline">
                <input name="supplierBank" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.supplierBank!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">第一次合作时间:</label>
            <div class="layui-input-inline">
                <input name="firstCooperationTime" id="date" lay-verify="date" autocomplete="off"
                       class="layui-input" placeholder="yyyy-MM-dd"
                       value="${dto.firstCooperationTime!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">对接人姓名:</label>
            <div class="layui-input-inline">
                <input name="jointName" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.jointName!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">对接人电话:</label>
            <div class="layui-input-inline">
                <input name="jointTel" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.jointTel!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <input type="button" class="layui-btn layui-btn-primary" onclick="history.back();" value="返回"/>
        </div>
    </div>
</form>
</body>
<script type="text/javascript">
    laydate.render({
        elem: '#date'
    });
</script>

</html>