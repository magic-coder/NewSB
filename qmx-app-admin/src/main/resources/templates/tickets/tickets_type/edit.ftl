<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>编辑</title>
    <link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/resources/admin/dropdown/dropdown.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/resources/admin/css/ext.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/resources/admin/css/product.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropdown.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropqtable.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/editor/kindeditor.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/json2.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/ajaxupload.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/image.js"></script>
    <script type="text/javascript">
        $().ready(function () {

            var $inputForm = $("#inputForm");
            var $productCategoryId = $("#productCategoryId");
            var $isMemberPrice = $("#isMemberPrice");
            var $memberPriceTr = $("#memberPriceTr");
            var $memberPrice = $("#memberPriceTr input");
            var $browserButton = $("#browserButton");
            var $productImageTable = $("#productImageTable");
            var $addProductImage = $("#addProductImage");
            var $deleteProductImage = $("a.deleteProductImage");
            var $parameterTable = $("#parameterTable");
            var $attributeTable = $("#attributeTable");
            var $specificationProductTable = $("#specificationProductTable");
            var $addSpecificationProduct = $("#addSpecificationProduct");
            var $deleteSpecificationProduct = $("a.deleteSpecificationProduct");
            var productImageIndex = 0;

            $browserButton.browser();


            $.validator.addClassRules({
                required: {
                    required: true
                },
                memberPrice: {
                    min: 0,
                    decimal: {
                        integer: 12,
                        fraction: 2
                    }
                },
                productTitle: {
                    required: true
                },
                productPrice: {
                    //required: true,
                    min: 0,
                    decimal: {
                        integer: 12,
                        fraction: 2
                    }
                },
                productCost: {
                    //required: true,
                    min: 0,
                    decimal: {
                        integer: 12,
                        fraction: 2
                    }
                },
                productImageOrder: {
                    digits: true
                }
            });

            // 表单验证
            $inputForm.validate({
                rules: {
                    name: "required",
                    sn: {
                        pattern: /^[0-9a-zA-Z_-]+$/,
                        remote: {
                            url: "check_sn.jhtml",
                            cache: false
                        }
                    },
                    supplierId: {
                        required: true
                    },
                    smsThemeId: {
                        required: true
                    },
                    companyId: {
                        required: true
                    },
                    cost: {
                        min: 0,
                        decimal: {
                            integer: 12,
                            fraction: 2
                        }
                    },
                    point: "digits"
                },
                messages: {
                    sn: {
                        pattern: "admin.validate.illegal",
                        remote: "admin.validate.exist"
                    },
                    focusimagepath: {
                        required: "至少上传一张图片"
                    }
                }
            });

            //选择下拉
            $("#sightName").dropqtable({
                vinputid: "sightId", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                selecteditem: { text: "${dto.sight.sightName}", value: "${dto.sight.id}" }, //默认值
                tableoptions: {
                    //autoload: true,
                    url: "../sight/listForJson", //查询响应的地址
                    qtitletext: "请输入目的地名称", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        {name: "sightName", displayname: "名称", width: "100px"}, //表格定义
                        {name: "address", displayname: "地址", width: "150px"}
                    ],
                    onSelect: function (selected) {
                        $("#sightId").val(selected.id);
                        $("#sightName").val(selected.sightName);
                    }
                }
            });

            $("#supplierName").dropqtable({
                vinputid: "supplierId", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                selecteditem: { text: "${dto.supplierAccount!}", value: "${dto.supplierId!}" }, //默认值
                tableoptions: {
                    //autoload: true,
                    url: "../../supplier/listForJson", //查询响应的地址
                    qtitletext: "请输入供应商账号", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        {name: "name", displayname: "姓名", width: "100px"}, //表格定义
                        {name: "username", displayname: "账号", width: "150px"}
                    ],
                    onSelect: function (selected) {
                        $("#supplierId").val(selected.id);
                        $("#supplierName").val(selected.username);
                    }
                }
            });

            $("#supplier2Name").dropqtable({
                vinputid: "supplier2Id", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                <#if dto.supplier2??>
                    selecteditem: { text: "${dto.supplier2.username}", value: "${dto.supplier2.id}" }, //默认值
                <#else>
                        selecteditem: { text: "", value: "" }, //默认值
                </#if>
                tableoptions: {
                    //autoload: true,
                    url: "../../supplier/listSpecialForJson", //查询响应的地址
                    qtitletext: "请输入供应商账号", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        {name: "name", displayname: "姓名", width: "100px"}, //表格定义
                        {name: "username", displayname: "账号", width: "150px"}
                    ],
                    onSelect: function (selected) {
                        $("#supplier2Id").val(selected.id);
                        $("#supplier2Name").val(selected.username);
                    }
                }
            });


            $("input:radio,input:checkbox").change(function () {
                $("input[name='" + $(this).attr("name") + "']:checked").each(function () {
                    $($(this).attr("dest")).attr("disabled", false);
                });
                $("input[name='" + $(this).attr("name") + "']").not(":checked").each(function () {
                    $($(this).attr("dest")).attr("disabled", true);
                });
            });

            $("input[name=name]").keyup(function () {
                var val = $(this).val();
                $("#nametip").text(val.length + "/30字");
            });
        });
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        编辑票型
    </div>
</div>
<form id="inputForm" action="updateTicketsType" method="post">
    <ul id="tab" class="tab">
        <li>
            <input type="button" value="基本设置"/>
            <input type="hidden" name="id" value="${dto.id!}"/>
        </li>
    </ul>
    <table class="input tabContent">
        <tr id="jbxx">
            <td style="text-align: right; padding-right: 10px;">
                <strong>基本信息:</strong>
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>票型名称:
            </th>
            <td>
                <input type="text" name="name" class="text" value="${dto.name!}" maxlength="30" style="width:300px;"/>&nbsp;<span
                    id="nametip">0/30字</span>&nbsp;<span class="tips">2-30字(注：产品名称不能包含营销、中奖、抽奖等相关营销类关键字)</span>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>选择景区:
            </th>
            <td>
                <input id="sightName" type="text" class="text" readonly maxlength="300"/>
                <input id="sightId" name="sightId" type="hidden"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>选择供应商:
            </th>
            <td>
            <#if currentMember.userType == 'supplier'>
            ${currentMember.username}
                <input name="supplierId" type="hidden" value="${currentMember.id}"/>
                <#if currentMember.specialSupplier?? && currentMember.specialSupplier>
                    <input id="supplier2Name" type="text" class="text" readonly maxlength="300"/>
                    <input id="supplier2Id" name="supplier2Id" type="hidden"/>
                </#if>
            <#elseif currentMember.userType == 'admin'>
                <input id="supplierName" type="text" class="text" readonly maxlength="300"/>
                <input id="supplierId" name="supplierId" type="hidden"/><span class="tips">选择主供应商</span><br/>
                <input id="supplier2Name" type="text" class="text" readonly maxlength="300"/>
                <input id="supplier2Id" name="supplier2Id" type="hidden"/><span class="tips">选择关联供应商</span>
            </#if>
            </td>
        </tr>
    </table>
    <table class="input">
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="submit" class="button" value="提交"/>
                <input type="button" class="button" value="返回" onclick="history.back()"/>
            </td>
        </tr>
    </table>
</form>
</body>
</html>