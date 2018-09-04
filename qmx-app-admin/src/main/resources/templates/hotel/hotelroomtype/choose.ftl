<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
    <link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/bak/css/bootstrap.min.css"/>
    <script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/bootstrap-paginator.js"></script>
    <#--<style type="text/css">
        #signupForm label.error {
            color: Red;
        }
    </style>-->
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        模块列表
    </div>
</div>
<form action="getList" method="get" class="form" id="signupForm">
    <table class="input">
        <tr>
            <th><span class="requiredField">*</span>选择要查看房型的所属酒店：</th>
            <td>
                <select name="hid" id="hid">
                    <option value="">请选择</option>
                <#list dto as info>
                    <option value="${info.id}">${info.name!}</option>
                </#list>
                </select>
            </td>
        </tr>
        <tr>
            <th></th>
            <td>
                <input type="submit" class="button" value="确定"/>
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript" src="${base}/bak/js/jquery.validate.min.js"></script>
<script type="text/javascript">
    //验证
    var Script = function () {
        $("#signupForm").validate({
            rules: {
                hid: 'required'
            },
            messages: {
                hid: '必填'
            }
        });
    }();
</script>
</body>
</html>