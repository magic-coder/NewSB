<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>二维码</legend>
    </fieldset>

    <div class="layui-form-item" align="center">
        <div class="layui-inline">
            <img src="${dto.qrcodeUrl!}" alt=""/>
        </div>
    </div>
    <div class="layui-form-item" align="center">
        <a class="layui-btn layui-btn-lg layui-btn-normal" lay-submit="" lay-filter="submit" id="downLoad">下载二维码</a>
    <#--<button type="reset" class="layui-btn layui-btn-primary">重置</button>
    <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>-->
    </div>
</form>
<script type="text/javascript">
    //判断浏览器类型
    function myBrowser() {
        var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
        var isOpera = userAgent.indexOf("Opera") > -1;
        if (isOpera) {
            return "Opera"
        }
        //判断是否Opera浏览器
        if (userAgent.indexOf("Firefox") > -1) {
            return "FF";
        } //判断是否Firefox浏览器
        if (userAgent.indexOf("Chrome") > -1) {
            return "Chrome";
        }
        if (userAgent.indexOf("Safari") > -1) {
            return "Safari";
        } //判断是否Safari浏览器
        if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera) {
            return "IE";
        }//判断是否IE浏览器
        if (userAgent.indexOf("Trident") > -1) {
            return "Edge";
        } //判断是否Edge浏览器
    }

    function SaveAs5(imgURL) {
        var oPop = window.open(imgURL, "", "width=1, height=1, top=5000, left=5000");
        for (; oPop.document.readyState != "complete";) {
            if (oPop.document.readyState == "complete")break;
        }
        oPop.document.execCommand("SaveAs");
        oPop.close();
    }

    function oDownLoad(url) {
        myBrowser();
        if (myBrowser() === "IE" || myBrowser() === "Edge") {
            //IE
            odownLoad.href = "#";
            var oImg = document.createElement("img");
            oImg.src = url;
            oImg.id = "downImg";
            var odown = document.getElementById("down");
            odown.appendChild(oImg);
            SaveAs5(document.getElementById('downImg').src)
        } else {
            //!IE
            odownLoad.href = url;
            odownLoad.download = "";
        }
    }

    var odownLoad = document.getElementById("downLoad");
    odownLoad.onclick = function () {
        oDownLoad('${dto.qrcodeUrl!}')
    }
</script>
</body>
</html>