<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
    <link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/common.js"></script>
    <script type="text/javascript" src="${base}/bak/js/datePicker/WdatePicker.js"></script>
    <style type="text/css">
        .roles label {
            width: 150px;
            display: block;
            float: left;
            padding-right: 6px;
        }
    </style>
    <script type="text/javascript">
        $().ready(function () {
            var $inputForm = $("#inputForm");
            var $selectAll = $("#inputForm .selectAll");
            var $areaId = $("#areaId");
        [@flash_message /]
        });
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">

    </div>
</div>
<form id="imgForm" method="post" name="imgForm">
    <table class="input tabContent" id="msgTable">
        <tr>
            <input type="hidden" name="imgString" id="imgString"/>
            <input type="hidden" name="hid" id="hid" value="${hid}"/>
        </tr>
        <tr id="addtr">
            <th>
                <span class="requiredField">*</span>图片:
            </th>
            <td>
                <input type="text" name="url" class="text" maxlength="20"/>
            </td>
            <th>
                <span class="requiredField"></span>是否主图:
            </th>
            <td>
                <select name="ismain">
                    <option value="">请选择</option>
                    <option value="true">是</option>
                    <option value="false">不是</option>
                </select>
            </td>
            <th>
                <span class="requiredField"></span>图片属性:
            </th>
            <td>
                <select name="attribute">
                    <option value="">请选择</option>
                    <#list attribute as info>
                        <option value="${info!}">${info.type!}</option>
                    </#list>
                </select>
            </td>
            <th>
                <span class="requiredField"></span>图片类型:
            </th>
            <td>
                <select name="type">
                    <option value="">请选择</option>
                    <#list type as info>
                        <option value="${info!}">${info.type!}</option>
                    </#list>
                </select>
            </td>
        </tr>
        <input type="hidden" id="hidden" name="hidden"/>
    </table>
</form>
<table class="input">
    <tr>
        <td colspan="4" align="center">
            <input type="button" class="button" value="提交" onclick="submitType()"/>
            <input type="button" class="button" value="添加" onclick="appendText()"/>
            <input type="button" class="button" value="删除" onclick="deleteText()"/>
            <input type="button" class="button" value="返回" onclick="history.back();"/>
        </td>
    </tr>
</table>
<script type="text/javascript">
    <!--实现表格选中删除行-->
    function deleteText() {
        $("input[name='delete']:checked").each(function () { // 遍历选中的checkbox
            n = $(this).parents("tr").index();  // 获取checkbox所在行的顺序
            $("table#msgTable").find("tr:eq(" + n + ")").remove();
        })
    }
    //继续添加图片
    function appendText() {
        $.ajax({
            url: "/hotelInfo/ajaxAdd",
            type: 'GET',
            dataType: 'json',
            success: function (result) {
                var data = result.attribute;
                var type = result.type;
                var optionstring1 = "";
                var optionstring2 = "";
                for (var key1 in data) {
                    optionstring1 += "<option value=" + key1 + " >" + data[key1] + "</option>";
                }
                for (var key2 in type) {
                    optionstring2 += "<option value=" + key2 + " >" + type[key2] + "</option>";
                }
                $("#hidden").before('<tr><th>' + '<input name="delete" type="checkbox"/><span class="requiredField">*</span>图片:' + '</th><td>' + ' <input type="text" name="url" class="text" maxlength="20"/> ' +
                        '</td><th><span class="requiredField"></span>是否主图:</th><td>' + '<select name="ismain"><option value="">请选择</option><option value="true">是</option><option value="false">不是</option></select>' +
                        '<th><span class="requiredField"></span>图片属性:</th><td><select name="attribute" class="text"><option>请选择</option>' + optionstring1 + '</select></td><th>' +
                        '<span class="requiredField"></span>图片类型:</th><td><select name="type" class="text"><option>请选择</option>' + optionstring2 + '</select></td></tr>');
            }
        });

    }
    //提交表单
    function submitType() {
        var valArr = new Array;
        var str = "";
        var str1 = "";
        var count = 0;
        $("table#msgTable").find("tr").each(function (i) {
                    $(this).closest('tr').find("input.text,select").each(function () {
                        str = $(this).val() + "-" + str;
                    });
                    str1 = str;
                    valArr[i] = str1;
                    str = "";
                }
        );
        var vals = valArr.join(',');//转换为逗号隔开的字符串
        vals = vals.substring(1);
        var ismain = "";
        $("#imgString").val(vals);
        $("table#msgTable").find("tr").each(function (i) {
                    $(this).closest('tr').find("select[name=ismain]").each(function () {
                        ismain = $(this).val();
                        if (ismain == "true") {
                            count++;
                        }
                    });
                }
        );
        if (count > 1) {
            alert("只能设置一个主图，请重现选择!");
        } else {
            $("form[name='imgForm']").attr('action', '/hotelInfo/saveAllImg');
            $("form[name='imgForm']").submit();
        }

    }
</script>
</body>
</html>