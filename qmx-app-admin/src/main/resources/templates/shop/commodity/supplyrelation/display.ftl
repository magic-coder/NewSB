<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>供应商-查看</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/bak/resources/admin/js/ajaxupload.js"></script>
    <script type="text/javascript" src="${base}/bak/resources/admin/js/image.js"></script>
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
<form id="supplierForm" method="post" action="update" class="layui-form">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">供应商名称:</label>
            <div class="layui-input-inline">
            ${dto.supplierName!}
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">营业执照号:</label>
            <div class="layui-input-inline">
            ${dto.license!}
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">营业执照:</label>
            <div class="layui-input-inline">
                <p class="mws_row">
                    <input name="licenseImgUrl" type="hidden" class="bg_white-bor_grey voe_inp_1"
                           value="${dto.licenseImgUrl!}" placeholder="营业执照图片" required="required">
                </p>
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
            ${dto.address!}
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">联系电话:</label>
            <div class="layui-input-inline">
            ${dto.companyTel!}
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">供应商传真:</label>
            <div class="layui-input-inline">
            ${dto.supplierFax!}
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">供应商email:</label>
            <div class="layui-input-inline">
            ${dto.supplierEmail!}
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">供应商开户银行账号:</label>
            <div class="layui-input-inline">
            ${dto.supplierBankAccount!}
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">开户银行:</label>
            <div class="layui-input-inline">
            ${dto.supplierBank!}
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">第一次合作时间:</label>
            <div class="layui-input-inline">
            ${dto.firstCooperationTime!}
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">对接人姓名:</label>
            <div class="layui-input-inline">
            ${dto.jointName!}
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">对接人电话:</label>
            <div class="layui-input-inline">
            ${dto.jointTel!}
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <input type="button" class="layui-btn layui-btn-primary" onclick="history.back();" value="返回"/>
        </div>
    </div>
</form>
</body>
</html>