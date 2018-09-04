<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>天气预报</title>
<#include "/include/common_header_include.ftl">
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
    <script charset="utf-8" src="http://map.qq.com/api/js?v=2.exp&libraries=place"></script>
</head>
<body onload="init()">
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>天气预报</legend>
</fieldset>
<form class="layui-form" id="inputForm" action="saveweather" method="post">
    <input id="wxMapMarkerid" type="hidden" name="id" class="input_1"
    <#if wxMapMarker?? && wxMapMarker.id??>
           value="${wxMapMarker.id!?c}"
    <#else>
           value=""
    </#if>/>
    <input type="hidden" name="latitude" class="input_1" id="lat"/>
    <input type="hidden" name="longitude" class="input_1" id="lng"/>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">输入景区:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input id="place" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 120px;"></label>
            <div class="layui-input-inline" style="width: 30%;">
                <button id="copy" class="layui-btn layui-btn-normal" title="${siteUrl!}/wxweather?id=${(aid)!}">复制链接
                </button>
                <input id="addButton" type="button" class="layui-btn layui-btn-normal" onclick="return submitForm();"
                       value="保存">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 40%;"><p>操作流程：①地图中标注景区所在地址，②填写景区名称，③保存</p></label>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">地图:</label>
            <div class="layui-input-inline" style="width: 80%;">
                <table class="input">
                ${msg!}
                    <div style="width:100%;height:500px;" id="container"></div>
                </table>
            </div>
        </div>
    </div>
</form>
<script>
    function init() {
    <#if wxMapMarker??>
        var center = new qq.maps.LatLng(${(wxMapMarker.latitude)!},${(wxMapMarker.longitude)!});
        var map = new qq.maps.Map(document.getElementById("container"), {
            // 地图的中心地理坐标。
            center: center,
            zoom: 13
        });
    <#else>
        var center = new qq.maps.LatLng(36.3859, 105.1171875);
        var map = new qq.maps.Map(document.getElementById("container"), {
            // 地图的中心地理坐标。
            center: center,
        });
    </#if>


        var marker = new qq.maps.Marker({
            position: center,
            draggable: true,
            map: map
        });

        var info = new qq.maps.InfoWindow({
            map: map
        });

    <#if wxMapMarker??>
        var label = new qq.maps.Label({
            position: center,
            map: map,
            content: '${(wxMapMarker.name)!}'
        });
        marker.setDraggable(false);
    </#if>

        var listener = qq.maps.event.addListener(map, 'click',
                function (event) {
                    $("#lat").val(event.latLng.getLat());
                    $("#lng").val(event.latLng.getLng());

                    center = new qq.maps.LatLng(event.latLng.getLat(), event.latLng.getLng());
                    marker.setPosition(center);

                    info.open();
                    info.setContent('<div style="text-align:center;white-space:nowrap;' +
                            'margin:10px;"><input id="name" name="name" type="text"/></div>');
                    info.setPosition(center);
                }
        );
        //实例化自动完成
        var ap = new qq.maps.place.Autocomplete(document.getElementById('place'));
        //调用Poi检索类。用于进行本地检索、周边检索等服务。
        var searchService = new qq.maps.SearchService({
            map: map
        });
        //添加监听事件
        qq.maps.event.addListener(ap, "confirm", function (res) {
            searchService.search(res.value);
        });
    }

    function submitForm() {
        var lat = $("#lat").val();
        var lng = $("#lng").val();
        var name = $("#name").val();
        if (lat == "") {
            alert("请点击地图选择标注！");
            return;
        }
        if (lng == "") {
            alert("请点击地图选择标注！");
            return;
        }
        if (name == "") {
            alert("设置目的地名称");
            return;
        }
        $("#inputForm").submit();
    }
</script>
<script type="text/javascript" src="${base}/bak/js/ZeroClipboard.js"></script>
<script type="text/javascript">
    $(function () {
        var wxMapMarkerid = $("#wxMapMarkerid").val();
        if (wxMapMarkerid == "") {
            $("#copy").hide();
        } else {
            $("#copy").show();
            $("#copy").each(function () {
                var Zero = ZeroClipboard;
                Zero.moviePath = "${base}/resources/module/shop/swf/ZeroClipboard.swf";

                var clip = new ZeroClipboard.Client();
                clip.setHandCursor(true);
                var obj = $(this);
                var id = $(this).attr("id");
                clip.glue(id);

                var txt = $("#" + id).attr("title");//设置文本框中的内容

                //鼠标移上时改变按钮的样式
                clip.addEventListener("mouseOver", function (client) {
                    obj.css("color", "#000000");
                    clip.setText(txt);
                });
                //鼠标移除时改变按钮的样式
                clip.addEventListener("mouseOut", function (client) {
                    obj.css("color", "");
                });
                //这个是复制成功后的提示
                clip.addEventListener("complete", function () {
                    alert("已经复制到剪切板！\n" + txt);
                });
            });
        }
    });
</script>
</body>
</html>