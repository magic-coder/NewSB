<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>关注回复</title>
    <link href="${base}/css/common.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${base}/css/wx/wxSystem.css" />
    <script type="text/javascript" src="${base}/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${base}/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/js/bootstrap-paginator.js"></script>
    <script type="text/javascript" src="${base}/js/list.js"></script>
    <script type="text/javascript" src="${base}/js/common.js"></script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        模块列表
    </div>
</div>
<form id="inputForm" action="savesubscribe.jhtml" method="get">
    <input name="id" type="hidden" value="${(wxReply.id)!}">
    <div class="bar">
        <a class="button" href="subscribe.jhtml?msgTypes=TEXT">文本</a>
        <a class="button" href="subscribe.jhtml?msgTypes=NEWS">图文</a>
        <a class="button" href="subscribe.jhtml?msgTypes=IMAGE">图片</a>
    </div>
    <br/>
    <table class="input tabContent">
    <#if type=="TEXT">

        <input type="hidden" name="msgTypes" value="TEXT"/>
        <tr>
            <th>
                <span class="requiredField">*</span>文本内容：
            </th>
            <td>
                <textarea id="content" class="text" name="content">${(wxReply.content)!}</textarea>
            </td>
        </tr>
    </#if>
    <#if type=="NEWS">
        <input type="hidden" name="msgTypes" value="NEWS"/>
        <tr>
            <th>
                <span class="requiredField">*</span>跳转链接：
            </th>
            <td>
                <input id="url" name="url" type="text" value="${(wxReply.url)!}"><br>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>图文标题：
            </th>
            <td>
                <input id="title" name="title" type="text" value="${(wxReply.title)!}"><br>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>图文描述：
            </th>
            <td>
                <input id="description" name="description" type="text" value="${(wxReply.description)!}"><br>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>多媒体文件ID：
            </th>
            <td>
                <input id="mediaid" name="mediaId" type="text" <#if (wxReply.description)??>value="${(wxReply.mediaId)!}"</#if>>
            </td>
        </tr>
    </#if>
    <#if type=="IMAGE">
        <input type="hidden" name="msgTypes" value="IMAGE"/>
        <tr>
            <th>
                <span class="requiredField">*</span>多媒体文件ID：
            </th>
            <td>
                <input id="mediaid" name="mediaId" type="text" <#if (wxReply.mediaUrl)??>value="${(wxReply.mediaId)!}"</#if>>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>图片链接：
            </th>
            <td>
                <input id="mediaurl" name="mediaUrl" type="text" value="${(wxReply.mediaUrl)!}"><br>
            </td>
        </tr>
    </#if>
    </table>
    <table class="input">
        <tr>
            <td>
                <input type="submit" class="button" value="提交"/>
                <input type="button" class="button" value="返回" onclick="history.back();"/>
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script>
    var Script = function () {
        $("#inputForm").validate({
            rules: {
                content:"required",
                mediaUrl: "required",
                mediaId: "required",
                title: "required",
                description:"required",
                url:"required",
            },
            messages: {
                content:"必填项",
                mediaUrl: "必填项",
                mediaId: "必填项",
                title: "必填项",
                description:"必填项",
                url:"必填项",
            }
        });
    }();
</script>
</body>
</html>