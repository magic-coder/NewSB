<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>供应商-新增</title>
<#include "/include/common_header_include.ftl">
    <link href="${base}/bak/js/dropdown/dropdown.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${base}/bak/resources/admin/js/ajaxupload.js"></script>
    <script type="text/javascript" src="${base}/bak/resources/admin/js/image.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery.lSelect.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropdown.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropqtable.js"></script>
    <script src="${base}/resources/common/js/jquery-migrate-1.2.1.js"></script>
    <script>
        layui.use(['form', 'table', 'laydate', 'jquery'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.$;
            laydate.render({
                elem: '#firstCooperationTime' //指定元素
            });

            $("#account1").dropqtable({
                vinputid: "supplierFlag", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                selecteditem: {text: "", value: ""}, //默认值
                editable: false,
                tableoptions: {
                    autoload: true,
                    url: "/commodity/supplyrelation/getSpecialSupplier", //查询响应的地址
                    qtitletext: "请输入供应商名称", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        // {name: "id", displayname: "员工id", width: "150px"},
                        {name: "account", displayname: "供应商账号", width: "100px"},
                        {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                    ],
                    onSelect: function (supplier) {
                        $("#supplierFlag").val(supplier.id);
                        $("#username").val(supplier.username);
                        $("#account1").val(supplier.account);
                    }
                }
            });
            $("#account2").dropqtable({
                vinputid: "supplierId", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                selecteditem: {text: "", value: ""}, //默认值
                editable: false,
                tableoptions: {
                    autoload: true,
                    url: "/commodity/supplyrelation/getSupplier", //查询响应的地址
                    qtitletext: "请输入供应商名称", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        // {name: "id", displayname: "员工id", width: "150px"},
                        {name: "account", displayname: "供应商账号", width: "100px"},
                        {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                    ],
                    onSelect: function (supplier) {
                        $("#supplierId").val(supplier.id);
                        $("#username").val(supplier.username);
                        $("#account2").val(supplier.account);
                    }
                }
            });
            $("#account3").dropqtable({
                vinputid: "supplierId", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                selecteditem: {text: "", value: ""}, //默认值
                editable: false,
                tableoptions: {
                    autoload: true,
                    url: "/commodity/supplyrelation/getSupplier", //查询响应的地址
                    qtitletext: "请输入供应商名称", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        // {name: "id", displayname: "员工id", width: "150px"},
                        {name: "account", displayname: "供应商账号", width: "100px"},
                        {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                    ],
                    onSelect: function (supplier) {
                        $("#supplierId").val(supplier.id);
                        $("#username").val(supplier.username);
                        $("#account3").val(supplier.account);
                    }
                }
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
<form id="supplierForm" method="post" class="layui-form" action="save">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">供应商名称:</label>
            <div class="layui-input-inline">
                <input name="supplierName" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">营业执照号:</label>
            <div class="layui-input-inline">
                <input name="license" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
<@shiro.hasPermission name="selectSupplierFlag">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">选择供应商:</label>
            <div class="layui-input-inline">
                <input type="hidden" id="supplierFlag" name="supplierFlag"/>
                <input type="hidden" id="username" name="username"/>
                <input name="account" id="account1" lay-verify="required" autocomplete="off" class="layui-input"
                       placeholder="选择主供应商">
            </div>
            <div class="layui-input-inline">
                <input type="hidden" id="supplierId" name="supplierId"/>
                <input type="hidden" id="username" class="text" name="username"/>
                <input name="account" id="account2" lay-verify="required" autocomplete="off" class="layui-input"
                       placeholder="选择关联供应商">
            </div>
        </div>
    </div>
</@shiro.hasPermission>
<@shiro.hasPermission name="selectSupplier">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">选择供应商:</label>
            <div class="layui-input-inline">
                <input type="hidden" id="supplierId" name="supplierId"/>
                <input type="hidden" id="username" class="text" name="username"/>
                <input name="account" id="account3" lay-verify="required" autocomplete="off" class="layui-input"
                       placeholder="选择关联供应商">
            </div>
        </div>
    </div>
</@shiro.hasPermission>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">营业执照图片上传:</label>
            <div class="layui-input-inline">
                <p class="mws_row">
                    <input name="licenseImgUrl" type="hidden" class="bg_white-bor_grey voe_inp_1" value=""
                           placeholder="营业执照图片"
                           required="required">
                    <input class="mws_bg_box2" value="选择文件" type="button">
                </p>
                <span style="color:red;">（图片尺寸建议：200像素*200像素）</span>
                <div class="imageStyle">
                    <img src="" id="imgId" class="imageStyleImg" alt="" height="200" width="200"/>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">地址:</label>
            <div class="layui-input-inline">
                <input name="address" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">联系电话:</label>
            <div class="layui-input-inline">
                <input name="companyTel" lay-verify="required|phone" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">供应商传真:</label>
            <div class="layui-input-inline">
                <input name="supplierFax" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">供应商email:</label>
            <div class="layui-input-inline">
                <input name="supplierEmail" lay-verify="email" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">供应商开户银行账号:</label>
            <div class="layui-input-inline">
                <input name="supplierBankAccount" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">开户银行:</label>
            <div class="layui-input-inline">
                <input name="supplierBank" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">第一次合作时间:</label>
            <div class="layui-input-inline">
                <input name="firstCooperationTime" id="firstCooperationTime" lay-verify="date" placeholder="yyyy-MM-dd"
                       autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">对接人姓名:</label>
            <div class="layui-input-inline">
                <input name="jointName" lay-verify="required" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">对接人电话:</label>
            <div class="layui-input-inline">
                <input name="jointTel" lay-verify="required" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">提交</button>
            <input type="button" class="layui-btn layui-btn-primary" onclick="history.back();" value="返回"/>
        </div>
    </div>
</form>
</body>
</html>