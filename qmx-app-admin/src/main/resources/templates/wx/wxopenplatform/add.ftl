<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>添加模块</title>
    <link href="${base}/css/common.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${base}/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${base}/js/common.js"></script>
    <script type="text/javascript" src="${base}/js/datePicker/WdatePicker.js"></script>
    <style type="text/css">
        .roles label {
            width: 150px;
            display: block;
            float: left;
            padding-right: 6px;
        }
    </style>

</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        添加模块
    </div>
</div>
<form id="inputForm" action="save.jhtml" method="post">
    <ul id="tab" class="tab">
        <li>
            <input type="button" value="基本信息"/>
        </li>
    </ul>
    <table class="input tabContent">
        <tr>
            <th>
                <span class="requiredField">*</span>授权方appid:
            </th>
            <td>
                <input type="text" name="authorizerAppid" class="text" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>授权方昵称:
            </th>
            <td>
                <input type="text" name="nickName" class="text" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>授权方头像:
            </th>
            <td>
                <input type="text" name="headImg" class="text" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>二维码图片:
            </th>
            <td>
                <input type="text" name="qrcodeUrl" class="text" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>授权方公众号的原始ID:
            </th>
            <td>
                <input type="text" name="userName" class="text" maxlength="20"/>
            </td>
        </tr>
        <!--
        <tr>
            <th>
                <span class="requiredField">*</span>授权方公众号类型:
            </th>
            <td>
                <label><input type="radio" name="serviceTypeInfo" value="0" checked="checked"/>订阅号</label>
                <label><input type="radio" name="serviceTypeInfo" value="1"/>由历史老帐号升级后的订阅号</label>
                <label><input type="radio" name="serviceTypeInfo" value="2"/>服务号</label>
            </td>
        </tr>
        -->
        <!--
        <tr>
            <th>
                <span class="requiredField">*</span>授权方认证类型:
            </th>
            <td>
                <select name="verifyTypeInfo">
                    <option value="-1" selected>未认证</option>
                    <option value="0">微信认证</option>
                    <option value="1">新浪微博认证</option>
                    <option value="2">腾讯微博认证</option>
                    <option value="3">已资质认证通过但还未通过名称认证</option>
                    <option value="4">已资质认证通过、还未通过名称认证，但通过了新浪微博认证</option>
                    <option value="5">已资质认证通过、还未通过名称认证，但通过了腾讯微博认证</option>
                </select>
            </td>
        </tr>
        -->
        <!--
        <tr>
            <th>
                <span class="requiredField">*</span>授权方接口调用凭据:
            </th>
            <td>
                <input type="text" name="authorizerAccessToken" class="text" maxlength="20" />
            </td>
        </tr>
        -->
        <!--
            <tr>
                <th>
                    <span class="requiredField">*</span>调用凭据有效期:
                </th>
                <td>
                    <input class="Wdate" onfocus="WdatePicker({readOnly:true,dateFmt: 'yyyy-MM-dd HH:mm:ss',minDate:'${.now?string('yyyy-MM-dd')}'})" name="expiresIn"/>
                </td>
            </tr>
            -->
        <!--
        <tr>
            <th>
                <span class="requiredField">*</span>接口调用凭据刷新令牌:
            </th>
            <td>
                <input type="text" name="authorizerRefreshToken" class="text" maxlength="20" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>授权方JS临时票据:
            </th>
            <td>
                <input type="text" name="jsapiTicket" class="text" maxlength="20" />
            </td>
        </tr>
        -->
        <!--
        <tr>
            <th>
                <span class="requiredField">*</span>参数接受时间:
            </th>
            <td>
                <input type="text" name="gettime" class="text" maxlength="20" />
            </td>
        </tr>
        -->
        <tr>
            <th>
                <span class="requiredField">*</span>GDS key:
            </th>
            <td>
                <input type="text" name="outappkey" class="text" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>GDS secretKey:
            </th>
            <td>
                <input type="text" name="secretKey" class="text" maxlength="20"/>
            </td>
        </tr>
        <!--
        <tr>
            <th>
                <span class="requiredField">*</span>所属第三方平台ID:
            </th>
            <td>
                <input type="text" name="platformId" class="text" maxlength="20" />
            </td>
        </tr>
        -->

    </table>
    <table class="input">
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="submit" class="button" value="提交"/>
                <input type="button" class="button" value="返回" onclick="history.back();"/>
            </td>
        </tr>
    </table>
</form>
</body>
</html>