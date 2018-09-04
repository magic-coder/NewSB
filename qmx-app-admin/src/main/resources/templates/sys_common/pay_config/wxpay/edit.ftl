<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>修改微信支付配置</title>
<#include "/include/header_include_old.ftl">
    <style type="text/css">
        input[type=text]{
            width: 360px;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            var $inputForm = $("#inputForm");
            // 表单验证
            $inputForm.validate({
                rules: {
                    mchId: {
                        required: true
                    },
                    appId: {
                        required: true
                    },
                    key: {
                        required: true
                    }
                }
            });
            jQuery("#uploadBtn").each(function() {
                var $this = $(this);
                uploadComplete($this);
            });
        });
        function uploadComplete($this) {
            var token = getCookie("token");
            new AjaxUpload($this, {
                action : '/file/upload?fileType=certificate&token='+token,
                name : 'file',
                autoSubmit:true,
                responseType: "json",
                onChange: function(file, ext){
                    if (!(ext && /^(p12)$/.test(ext))){
                        alert("证书文件格式错误");
                        return false;
                    }
                },
                onComplete : function(file, response) {
                    console.info(response);
                    if(response.errorCode == 0){
                        var filepath = response.data;
                        $("input[name=certLocalPath]").val(filepath);
                    }else{
                        alert(response.errorMsg)
                    }
                }
            });
        }
        function download() {
            var pathx = $("input[name='certLocalPath']").val();
            var index = pathx.lastIndexOf("\\");
            var xx = pathx.substring(index+1, pathx.length);
            location.href="${base!}/file/upload/certificate/"+xx;
        }
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        修改微信支付配置
    </div>
</div>
<form id="inputForm" action="updateWxPay" method="post">
    <br/>
    <p>修改微信支付配置</p>
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>微信支付商户号:
            </th>
            <td>
				<input type="text" name="mchId" class="text" value="${mchId!}"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span> 开发者ID(AppID):
            </th>
            <td>
                <input type="text" name="appId" value="${appId!}" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>API密钥:
            </th>
            <td>
                <input type="text" name="key" value="${key!}" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                证书地址:
            </th>
            <td>
                <input type="text" name="certLocalPath" class="text" value="${certLocalPath!}" maxlength="200" />
                <input value="上传" type="button" id="uploadBtn"/>
                <input value="下载证书" type="button" onclick="download()"/>
            </td>
        </tr>
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="submit" class="button" value="保存" />
                <input type="button" class="button" value="返回" onclick="history.back();" />
            </td>
        </tr>
    </table>
</form>
</body>
</html>