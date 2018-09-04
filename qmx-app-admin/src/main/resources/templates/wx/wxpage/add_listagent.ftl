<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加模块</title>
    <link rel="stylesheet" href="${base}/bak/css/wx/wxSystem.css">
    <script type="text/javascript" src="${base}/resources/module/wx/js/operate.js"></script>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        function addpic($this) {
            var $button = $($this).parent("p").parent("div").find("p:last").find("button");
            var upload = layui.upload;
            upload.render({
                elem: $button
                ,url: '${base}/file/upload?fileType=image&token='+getCookie("token") //上传接口
                ,done: function(res){
                    //如果上传失败
                    if(res.code > 0){
                        return layer.msg('上传失败');
                    }
                    //上传成功
                    $button. prev().val(res.data);
                }
                ,error: function(){
                    //请求异常回调
                    alert("异常!!!");
                }
            });
        }

        $().ready(function() {
            jQuery("button.test1").each(function() {
                var $this = $(this);
                uploadCompletes1($this);
            });
        });
        function uploadCompletes1($this) {
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
        }
    </script>
</head>
<body class="magenta microWebsiteSetup">
<form class="layui-form" id="inputForm" action="save" method="post">
    <input name="id" type="hidden" value="${(dto.id)!}"/>
    <input name="template" type="hidden" value="${(template)!}"/>
    <input name="token" type="hidden" value="${(token)!}" />
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">页面标题:</label>
            <div class="layui-input-inline" style="width: 50%;">
                <input id="title" name="title" value="${(dto.title)!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">背景图片:</label>
            <div class="layui-input-inline" style="width: 50%;">
                <span style="color:red;"></span>
            <#if (params.img_urls)??>
                <#list (params.img_urls) as img_url>
                    <p class="">
                        <input id="img_title" name="img_title" value="${(params.img_titles[img_url_index])!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input" placeholder="图片标题">
                        <textarea id="info" name="info" style="height:100px;width:286px;" class="bg_white-bor_grey mws_inp_1" placeholder="简介">${params.info[img_url_index]!}</textarea><br><br>
                        <input id="url" name="url" value="${params.url[img_url_index]!}" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="跳转链接" />
                        <input id="img_url" name="img_url" value="${img_url!}" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="图片路径">
                        <button type="button" class="layui-btn test1">
                            <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
                        </button>
                        <em class="mws_icon mws_ico_add" onclick="addElement(this,1);addpic(this);"></em>
                        <em class="mws_icon mws_ico_next" onclick="shiftDown(this);"></em>
                        <em class="mws_icon mws_ico_prev" onclick="shiftUp(this);"></em>
                        <em class="mws_icon mws_ico_delete" onclick="deleteParent(this);"></em>
                    </p>
                </#list>
            <#else>
                <p class="">
                    <input id="img_title" name="img_title" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input" placeholder="图片标题">
                    <textarea id="info" name="info" style="height:100px;width:286px;" class="bg_white-bor_grey mws_inp_1" placeholder="简介"></textarea><br><br>
                    <input id="url" name="url"  style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="跳转链接" />
                    <input id="img_url" name="img_url" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="图片路径">
                    <button type="button" class="layui-btn test1">
                        <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
                    </button>
                    <em class="mws_icon mws_ico_add" onclick="addElement(this,1);addpic(this);"></em>
                    <em class="mws_icon mws_ico_next" onclick="shiftDown(this);"></em>
                    <em class="mws_icon mws_ico_prev" onclick="shiftUp(this);"></em>
                    <em class="mws_icon mws_ico_delete" onclick="deleteParent(this);"></em>
                </p>
            </#if>
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
</body>
</html>