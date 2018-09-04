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
    <style type="text/css">
        #signupForm label.error {
            color: Red;
        }
    </style>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        模块列表
    </div>
</div>
<form action="add" method="get" class="form" id="signupForm">
    <table class="input">
        <tr>
            <td>
                <input type="hidden" name="hid" value="${hid}"/>
            </td>
        </tr>
        <tr>
            <th><span class="requiredField">*</span>选择需要授权给分销商的产品：</th>
            <td>
                <select name="productId" id="productId">
                    <option value="">请选择</option>
                <#list data as info>
                    <option value="${info.id}">${info.name!}</option>
                </#list>
                </select>
            </td>
        </tr>
        <tr>
            <th><span class="requiredField">*</span>选择要授权的分销商:</th>
            <td>
            <#list list as info>
                <input type="checkbox" name="distributor" id="distributor" value="${info!}"/>${info!}
            </#list>
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
                productId: 'required',
                distributor: 'required'
                /* bedSize: 'number',
                 floor: 'required',
                 area: 'number'*/
            },
            messages: {
                productId: '必填',
                distributor: '必填'
                /* bedSize: '请输入正确的床宽',
                 floor: "楼层信息不能为空",
                 area: '请输入正确的面积'*/
            }
        });
    }();
</script>
</body>
</html>