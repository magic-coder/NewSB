<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>编辑语音导游</title>
    <script charset="utf-8" src="http://map.qq.com/api/js?v=2.exp&libraries=place"></script>
    <link rel="stylesheet" href="${base}/bak/css/wx/wxSystem.css">
    <script type="text/javascript" src="${base}/resources/module/wx/js/operate.js"></script>
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
</head>
<body onload="init()">
	<form class="layui-form" id="inputForm" action="update" method="post">
        <input type="hidden" name="id" value="${(mapVoice.id)!}"/>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>语音导游</legend>
        </fieldset>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">输入地址，自动完成:</label>
                <div class="layui-input-inline" style="width: 30%;">
                    <input id="place" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
                </div>
                <label class="layui-form-label" style="width: 120px;">图片透明度(0-1):</label>
                <div class="layui-input-inline" style="width: 30%;">
                    <input id="opacity" style="display: inline;width: 190px;" lay-verify="required" value="0.7" autocomplete="off" class="layui-input">
                    <input id="setopacity" style="display: inline;width: 100px;" type="button" onclick="location.href='javascript:setopacity();';" class="layui-btn layui-btn-normal layui-btn-sm"
                           value="设置图片透明度"/>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;"></label>
                <div class="layui-input-inline" style="width: 80%;">
                    <input id="swCenter" name="swCenter" style="display: none;"/>
                    <input id="setsw" style="display: inline;" type="button" onclick="location.href='javascript:;';" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}"
                           value="设置图片西南角(左下)坐标"/>
                    <input id="neCenter" name="neCenter" style="display: none;"/>
                    <input id="setne" style="display: inline;" type="button" onclick="location.href='javascript:;';" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}"
                           value="设置图片东北角(右上)坐标"/>
                    <input id="imageurl" name="imageurl" style="display: none;"/>
                    <input id="setimg" style="display: inline;" type="button" class="layui-btn layui-btn-normal layui-btn-sm"
                           value="上传地图"/>
                    <input id="showimg" style="display: inline;" type="button" class="layui-btn layui-btn-normal layui-btn-sm"
                           value="预览地图"/>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">景区名称</label>
                <div class="layui-input-inline" style="width: 80%;">
                    <input id="name" name="name" value="${(mapVoice.name)!}" style="display: inline;width: 190px;" placeholder="景区名称" lay-verify="required" autocomplete="off" class="layui-input">
                    <input id="setopacity" type="button" onclick="location.href='javascript:addjdClick();';" class="layui-btn layui-btn-normal layui-btn-sm"
                           value="添加景点"/>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">景点列表</label>
                <div id="scenic_div" class="layui-input-inline" style="width: 80%;">
                <#--<div  id="scenic_div">
                </div>-->
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;"></label>
                <div class="layui-input-inline" style="width: 80%;">
                    <table class="input">
                        <div style="width:100%;height:500px;" id="container"></div>
                    </table>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
            </div>
        </div>
	</form>
    <script>
        function bindingUpload() {
            jQuery("button.uploadImage").each(function() {
                var $this = $(this);
                layui.use('upload', function(){
                    var upload = layui.upload;
                    //执行实例
                    upload.render({
                        elem: $this //绑定元素
                        ,url: '${base}/file/upload?fileType=image&token='+getCookie("token") //上传接口
                        ,done: function(res){
                            //如果上传失败
                            if(res.code > 0){
                                return layer.msg('上传失败');
                            }
                            //上传成功
                            ($this). prev().val(res.data);
                        }
                        ,error: function(){
                            //请求异常回调
                            alert("异常!!!");
                        }
                    });
                });
            });
            jQuery("button.uploadMp3").each(function() {
                var $this = $(this);
                layui.use('upload', function(){
                    var upload = layui.upload;
                    //执行实例
                    upload.render({
                        elem: $this //绑定元素
                        ,url: '${base}/file/upload?fileType=image&token='+getCookie("token") //上传接口
                        ,accept: 'audio' //音频
                        ,done: function(res){
                            //如果上传失败
                            if(res.code > 0){
                                return layer.msg('上传失败');
                            }
                            //上传成功
                            ($this). prev().val(res.data);
                        }
                        ,error: function(){
                            //请求异常回调
                            alert("异常!!!");
                        }
                    });
                });
            });
        }
        var init = function() {

            var center = new qq.maps.LatLng(36.3859,105.1171875);
            var map = new qq.maps.Map(document.getElementById('container'), {
                center: center,
                zoom: 17,
                //设置控件的地图类型和位置
                mapTypeControlOptions:{mapTypeIds:[]},
            });

            //手绘地图覆盖层
            var groundOverlay = new qq.maps.GroundOverlay({
                //设置显示地面覆盖层的地图
                map: map,
                //设置图片地址
                imageUrl: '${(mapVoice.imageurl)!}',
                //设置覆盖层的透明度
                opacity:0.7,
                //设置地面覆盖层可响应鼠标事件，默认为true
                clickable: true,
            });
            var sw = new qq.maps.LatLng(${(mapVoice.swCenter)!});//西南角坐标
            var ne = new qq.maps.LatLng(${(mapVoice.neCenter)!});//东北角坐标

            $("#imageurl").val(groundOverlay.getImageUrl());
            $("#swCenter").val(sw.toString());
            $("#neCenter").val(ne.toString());

            map.setCenter(new qq.maps.LatLngBounds(sw,ne).extend(sw).getCenter());

            groundOverlay.setBounds(new qq.maps.LatLngBounds(sw,ne));

            //创建一个Marker
            var swmarker = new qq.maps.Marker({
                //设置Marker的位置坐标
                position: sw,
                //设置显示Marker的地图
                map: map,
            });
            var nemarker = new qq.maps.Marker({
                //设置Marker的位置坐标
                position: ne,
                //设置显示Marker的地图
                map: map,
            });

            var mapclick = qq.maps.event.addListener(map, 'click', function(event){});
            //移除绑定事件
            window.removeEvent = function() {
                qq.maps.event.removeListener(mapclick);
            };
            //设置图片透明度
            window.setopacity = function() {
                groundOverlay.setOptions({
                    opacity: parseFloat($("#opacity").val())
                });
            };

            $("#setsw").click(function(){
                removeEvent();
                //绑定单击事件添加参数
                mapclick = qq.maps.event.addListener(map, 'click', function(event) {
                    sw = new qq.maps.LatLng(event.latLng.getLat(),event.latLng.getLng());
                    $("#swCenter").val(sw.toString());
                    swmarker.setPosition(sw);
                    groundOverlay.setImageUrl($("#imageurl").val());
                    groundOverlay.setBounds(new qq.maps.LatLngBounds(sw,ne));
                });
            });
            $("#setne").click(function(){
                removeEvent();
                //绑定单击事件添加参数
                mapclick = qq.maps.event.addListener(map, 'click', function(event) {
                    ne = new qq.maps.LatLng(event.latLng.getLat(),event.latLng.getLng());
                    $("#neCenter").val(ne.toString());
                    nemarker.setPosition(ne);
                    groundOverlay.setImageUrl($("#imageurl").val());
                    groundOverlay.setBounds(new qq.maps.LatLngBounds(sw,ne));
                });
            });

            //坐标
            var index = 0;
            //景点数组
            var markersArray = [];
            //标签数组
            var labelsArray = [];
            var marker = new qq.maps.Marker({
                map: map,
                position: map.getCenter(),
            });
            var info = new qq.maps.InfoWindow({
                map: map,
                content:'<div style="text-align:center;white-space:nowrap;margin:10px;">'+
                '<input id="jdname" style="display: inline;width: 80px;" autocomplete="off" class="layui-input" placeholder="景点名称"/>'+
                '<input id="videoUrl" style="display: inline;width: 80px;" autocomplete="off" class="layui-input" type="text" placeholder="视频链接"/>'+
                '<input id="imgUrl" name="imgUrl" type="text" style="display: none;"/>'+
                '<button id="imgUrlBtn" type="button" class="layui-btn uploadImage"><i class="layui-icon">&#xe67c;</i>上传图片</button>'+
                '<input id="audioUrl" name="audioUrl" type="text" style="display: none;"/>'+
                '<button id="audioUrlBtn" type="button" class="layui-btn uploadMp3"><i class="layui-icon">&#xe67c;</i>上传音频</button>'+
                '<a id="addjd" type="button" class="layui-btn layui-btn-primary" href="javascript:addjdalert();">确定</a>'+
                '</div>',
                position: map.getCenter(),
            });
            info.open();
            window.addjdalert = function() {
                alert("请先点击添加景点按钮");
            };
            window.scenicbrowser = function() {
                /*$("#imgUrlBtn").unbind().browser();
                $("#audioUrlBtn").unbind().browser({type: "media"});*/
            };
            window.deletejdEvent = function(e,i) {
                var parent = $(e).parent();
                parent.remove();
                //设置Marker的可见性，为true时可见,false时不可见，默认属性为true
                markersArray[i].setVisible(false);
                labelsArray[i].setVisible(false);
            };
            //添加景点
            window.addjdEvent = function(event) {
                if($("#jdname").val()==""){
                    alert("请输入景点名称");
                    return;
                }
                if($("#imgUrl").val()==""){
                    alert("请上传图片");
                    return;
                }
                if($("#audioUrl").val()==""){
                    alert("请上传音频");
                    return;
                }
                $("#scenic_div").append(
                        '<p class="mws_row">'+
                        '<input type="hidden" name="scenic_lat" value="'+marker.getPosition().getLat()+'"/>'+
                        '<input type="hidden" name="scenic_lng" value="'+marker.getPosition().getLng()+'"/>'+
                        '<input name="scenic_name" style="display: inline;width: 80px;" lay-verify="required" autocomplete="off" class="layui-input" value="'+$("#jdname").val()+'"/>'+
                        '<input name="scenic_imgUrl" style="display: inline;width: 80px;" lay-verify="required" autocomplete="off" class="layui-input" value="'+$("#imgUrl").val()+'"/>'+
                        '<input name="scenic_audioUrl" style="display: inline;width: 150px;" lay-verify="required" autocomplete="off" class="layui-input" value="'+$("#audioUrl").val()+'"/>'+
                        '<input name="scenic_videoUrl" style="display: inline;width: 150px;" lay-verify="required" autocomplete="off" class="layui-input" value="'+$("#videoUrl").val()+'"/>'+
                        '<em class="mws_icon mws_ico_next" onclick="shiftDown(this);"></em>'+
                        '<em class="mws_icon mws_ico_prev" onclick="shiftUp(this);"></em>'+
                        '<em class="mws_icon mws_ico_delete" onclick="deletejdEvent(this,'+index+');"></em>'+
                        '</p>'
                );

                var scenic = new qq.maps.Marker({
                    map: map,
                    position: marker.getPosition(),
                    icon:new qq.maps.MarkerImage('${base}/bak/images/Ht-iconMarkerAudio.png',null,null,new qq.maps.Point(12, 34),new qq.maps.Size(34,34)),
                });
                markersArray.push(scenic);

                var label = new qq.maps.Label({
                    position: marker.getPosition(),
                    map: map,
                    content: $("#jdname").val()
                });
                labelsArray.push(label);

                $("#jdname").val("");
                $("#imgUrl").val("");
                $("#audioUrl").val("");
                index = index + 1;
            };

            window.addjdClick = function() {
                $("#addjd").attr("href","javascript:addjdEvent(this);");
                scenicbrowser();
                removeEvent();
                marker.setPosition(map.getCenter());
                info.setPosition(map.getCenter());
                info.open();
                bindingUpload();
                //标记Marker点击事件
                mapclick = qq.maps.event.addListener(map, 'click', function(event) {
                    marker.setPosition(new qq.maps.LatLng(event.latLng.getLat(),event.latLng.getLng()));
                    info.setPosition(new qq.maps.LatLng(event.latLng.getLat(),event.latLng.getLng()));
                });
            };

            $("#showimg").click(function () {
                groundOverlay.setImageUrl($("#imageurl").val());
                groundOverlay.setBounds(new qq.maps.LatLngBounds(sw, ne));
            });

            //遍历景点信息
        <#list mapVoiceScenics as scenics>
            $("#scenic_div").append(
                    '<p class="mws_row">'+
                    '<input type="hidden" name="scenic_id" value="${(scenics.id)!}"/>'+
                    '<input type="hidden" name="scenic_lat" value="${(scenics.lat)!}"/>'+
                    '<input type="hidden" name="scenic_lng" value="${(scenics.lng)!}"/>'+
                    '<input name="scenic_name" value="${(scenics.name)!}" style="display: inline;width: 80px;" lay-verify="required" autocomplete="off" class="layui-input" value="'+$("#jdname").val()+'"/>'+
                    '<input name="scenic_imgUrl" value="${(scenics.imgUrl)!}" style="display: inline;width: 80px;" lay-verify="required" autocomplete="off" class="layui-input" value="'+$("#imgUrl").val()+'"/>'+
                    '<input name="scenic_audioUrl" value="${(scenics.audioUrl)!}" style="display: inline;width: 150px;" lay-verify="required" autocomplete="off" class="layui-input" value="'+$("#audioUrl").val()+'"/>'+
                    '<input name="scenic_videoUrl" value="${(scenics.videoUrl)!}" style="display: inline;width: 150px;" lay-verify="required" autocomplete="off" class="layui-input" value="'+$("#videoUrl").val()+'"/>'+
                    '<em class="mws_icon mws_ico_next" onclick="shiftDown(this);"></em>'+
                    '<em class="mws_icon mws_ico_prev" onclick="shiftUp(this);"></em>'+
                    '<em class="mws_icon mws_ico_delete" onclick="deletejdEvent(this,'+index+');"></em>'+
                    '</p>'
            );
            var scenic = new qq.maps.Marker({
                map: map,
                position: new qq.maps.LatLng(${(scenics.lat)!},${(scenics.lng)!}),
                icon: new qq.maps.MarkerImage('${base}/bak/images/Ht-iconMarkerAudio.png', null, null, new qq.maps.Point(12, 34), new qq.maps.Size(34, 34)),
            });
            markersArray.push(scenic);

            var label = new qq.maps.Label({
                position: new qq.maps.LatLng(${(scenics.lat)!},${(scenics.lng)!}),
                map: map,
                content: "${(scenics.name)!}",
            });
            labelsArray.push(label);
            index = index + 1;
        </#list>


            //实例化自动完成
            var ap = new qq.maps.place.Autocomplete(document.getElementById('place'));
            //调用Poi检索类。用于进行本地检索、周边检索等服务。
            var searchService = new qq.maps.SearchService({
                map : map
            });
            //添加监听事件
            qq.maps.event.addListener(ap, "confirm", function(res){
                searchService.search(res.value);
            });
        }
    </script>
</body>
</html>