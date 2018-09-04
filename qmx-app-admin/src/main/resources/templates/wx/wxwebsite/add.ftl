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
        function deleteBg(t){
            $(t).parents('.mws_row').remove();
        }
        $().ready(function() {
            jQuery("button.test1").each(function() {
                var $this = $(this);
                uploadCompletes1($this);
            });
            jQuery("button.test2").each(function() {
                var $this = $(this);
                uploadCompletes2($this);
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
        function uploadCompletes2($this) {
            //多图片上传
            layui.use('upload', function(){
                var upload = layui.upload;
                //执行实例
                upload.render({
                    elem: $this
                    ,url: '${base}/file/upload?fileType=image&token='+getCookie("token")
                    ,multiple: true
                    ,done: function(res){
                        //上传完毕
                        //如果上传失败
                        if(res.code > 0){
                            return layer.msg('上传失败');
                        }
                        var image = res.data;
                        var $count = "<div class='mws_row' style='width: 180px;height: 120px;display: inline;'><div class='mws_bg_box' style='width: 180px;height: 120px;display: inline;'>"+
                                "<input name='url' required='required' style='width: 171px;' />"+
                                "<input type='hidden'  name='imagesurl' value='"+image+"' />"+
                                "<img src='"+image+"' style='width: 175px;height: 110px;' />"+
                                "<em class='mws_bg_delete' onclick='deleteBg(this);'></em>"+
                                "</div></div>";
                        $('.showImg').append($count);
                        /*$('#demo2').append('<img src="'+ res.data +'" alt="'+ res.data +'" class="layui-upload-img">')*/
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
<form class="layui-form" id="inputForm" <#if template="wxwebsite_three"> action="saveIntroduce" <#elseif template=="wxwebsite_four"> action="saveWebsiteFour" <#else> action="save" </#if> method="post">
    <input name="template" type="hidden" value="${template!}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <#if template="wxwebsite_one">
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 100%;">
                <label class="layui-form-label" style="width: 120px;">微官网名称:</label>
                <div class="layui-input-inline">
                    <input name="name" lay-verify="required" autocomplete="off" class="layui-input">
                </div>
                <label class="layui-form-label" style="width: 120px;">微官网LOGO:</label>
                <div class="layui-input-inline" style="width: 50%;">
                    <input id="imageurl" name="imageurl" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input">
                    <button type="button" class="layui-btn test1">
                        <i class="layui-icon">&#xe67c;</i>上传图片
                    </button>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 900px;">
                <label class="layui-form-label" style="width: 120px;">导航按钮:</label>
                <div class="layui-input-inline" style="width: 700px;">
                    <span style="color:red;"></span>
                    <p>
                        <input name="butname" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="导航名称">
                        <input name="buturl" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="网页地址">
                        <em class="mws_icon mws_ico_add" onclick="addElement(this,1);"></em>
                        <em class="mws_icon mws_ico_next" onclick="shiftDown(this);"></em>
                        <em class="mws_icon mws_ico_prev" onclick="shiftUp(this);"></em>
                        <em class="mws_icon mws_ico_delete" onclick="deleteParent(this);"></em>
                    </p>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 900px;">
                <label class="layui-form-label" style="width: 120px;">首页背景图:</label>
                <div class="layui-upload">
                    <button type="button" class="layui-btn test2">多图片上传</button>
                </div>
            </div>
        <div class="layui-inline" style="width: 1100px;">
            <label class="layui-form-label" style="width: 120px;">预览图:</label>
            <div class="layui-upload showImg" style="width:930px;margin-left: 200px;">

            </div>
        </div>
        </div>
    <#elseif  template="wxwebsite_two">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 120px;">微官网名称:</label>
                <div class="layui-input-inline">
                    <input name="name" lay-verify="required" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 900px;">
                <label class="layui-form-label" style="width: 120px;">导航按钮:</label>
                <div class="layui-input-inline" style="width: 700px;">
                    <span style="color:red;"></span>
                    <p>
                        <input name="butname" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="导航名称">
                        <input name="buturl" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="网页地址">
                        <input name="buticon" type="hidden" value="mic_nav_no"/>
                        <em class="icon ico_choice nav_defaults" onclick="ico_choice(this);"></em>
                        <em class="mws_icon mws_ico_add" onclick="addElement(this,1);"></em>
                        <em class="mws_icon mws_ico_next" onclick="shiftDown(this);"></em>
                        <em class="mws_icon mws_ico_prev" onclick="shiftUp(this);"></em>
                        <em class="mws_icon mws_ico_delete" onclick="deleteParent(this);"></em>
                    </p>
                    <!-- 图标列表 -->
                    <div class="icon_box">
                        <div id="iconBag" style="right: 77px;">
                            <em onclick="icon_click(this);" title="mic_nav_no" class="icon mic_nav_no">无图标</em>
                            <em onclick="icon_click(this);" title="mic_nav_tick" class="icon mic_nav_tick"></em>
                            <em onclick="icon_click(this);" title="mic_nav_hotel" class="icon mic_nav_hotel"></em>
                            <em onclick="icon_click(this);" title="mic_nav_food" class="icon mic_nav_food"></em>
                            <em onclick="icon_click(this);" title="mic_nav_specialties" class="icon mic_nav_specialties"></em>
                            <em onclick="icon_click(this);" title="mic_nav_traffic" class="icon mic_nav_traffic"></em>
                            <em onclick="icon_click(this);" title="mic_nav_line" class="icon mic_nav_line"></em>
                            <em onclick="icon_click(this);" title="mic_nav_activity" class="icon mic_nav_activity"></em>
                            <em onclick="icon_click(this);" title="mic_nav_car" class="icon mic_nav_car"></em>
                            <em onclick="icon_click(this);" title="mic_nav_phone" class="icon mic_nav_phone"></em>
                            <em onclick="icon_click(this);" title="mic_nav_navigation" class="icon mic_nav_navigation"></em>
                            <em onclick="icon_click(this);" title="mic_nav_weather" class="icon mic_nav_weather"></em>
                            <em onclick="icon_click(this);" title="mic_nav_ticket" class="icon mic_nav_ticket"></em>
                        </div>
                    </div>
                    <!-- 图标列表END -->
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 900px;">
                <label class="layui-form-label" style="width: 120px;">首页背景图:</label>
                <div class="layui-upload">
                    <button type="button" class="layui-btn test2">多图片上传</button>
                    <#--<blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
                        预览图：
                        <div class="layui-upload-list" id="demo2"></div>
                    </blockquote>-->
                </div>
            </div>
            <div class="layui-inline" style="width: 1100px;">
                <label class="layui-form-label" style="width: 120px;">预览图:</label>
                <div class="layui-upload showImg" style="width:930px;margin-left: 200px;">

                </div>
            </div>
        </div>
    <#elseif  template="wxwebsite_three">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 120px;">微官网名称:</label>
                <div class="layui-input-inline">
                    <input name="name" lay-verify="required" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 900px;">
                <label class="layui-form-label" style="width: 120px;">首页轮播图:</label>
                <div class="layui-upload">
                    <button type="button" class="layui-btn test2">多图片上传</button>
                    <#--<blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
                        预览图：
                        <div class="layui-upload-list" id="demo2"></div>
                    </blockquote>-->
                </div>
            </div>
            <div class="layui-inline" style="width: 1100px;">
                <label class="layui-form-label" style="width: 120px;">预览图:</label>
                <div class="layui-upload showImg" style="width:930px;margin-left: 200px;">

                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 120px;">公司简介链接地址:</label>
                <div class="layui-input-inline">
                    <input name="companyProfileUrl" lay-verify="required" autocomplete="off" class="layui-input">
                </div>
                <label class="layui-form-label" style="width: 120px;">服务指南链接地址:</label>
                <div class="layui-input-inline">
                    <input name="serviceGuideUrl" lay-verify="required" autocomplete="off" class="layui-input">
                </div>
                <label class="layui-form-label" style="width: 120px;">联系电话:</label>
                <div class="layui-input-inline">
                    <input name="phone" lay-verify="required|number" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 1100px;">
                <label class="layui-form-label" style="width: 120px;">添加设备介绍:</label>
                <div class="layui-input-inline" style="width: 900px;">
                    <span style="color:red;"></span>
                    <p>
                        <input name="SBname" style="width: 100px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="导航名称">
                        <input name="SBurl" style="width: 130px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="设备地址">
                        <input name="SBdescribe" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="设备描述">
                        <input name="SBpicture" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="设备图片">
                        <button type="button" class="layui-btn test1">
                            <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
                        </button>
                        <em class="mws_icon mws_ico_add" onclick="addElement(this,1);addpic(this)"></em>
                        <em class="mws_icon mws_ico_next" onclick="shiftDown(this);"></em>
                        <em class="mws_icon mws_ico_prev" onclick="shiftUp(this);"></em>
                        <em class="mws_icon mws_ico_delete" onclick="deleteParent(this);"></em>
                    </p>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 1100px;">
                <label class="layui-form-label" style="width: 120px;">添加项目介绍:</label>
                <div class="layui-input-inline" style="width: 900px;">
                    <span style="color:red;"></span>
                    <p>
                        <input name="XMname" style="width: 100px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="项目名称">
                        <input name="XMurl" style="width: 130px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="项目地址">
                        <input name="XMpicture" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="项目图片">
                        <button type="button" class="layui-btn test1">
                            <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
                        </button>
                        <em class="mws_icon mws_ico_add" onclick="addElement(this,1);addpic(this)"></em>
                        <em class="mws_icon mws_ico_next" onclick="shiftDown(this);"></em>
                        <em class="mws_icon mws_ico_prev" onclick="shiftUp(this);"></em>
                        <em class="mws_icon mws_ico_delete" onclick="deleteParent(this);"></em>
                    </p>
                </div>
            </div>
        </div>
    <#elseif  template="wxwebsite_four">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 120px;">微官网名称:</label>
                <div class="layui-input-inline">
                    <input name="name" lay-verify="required" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 900px;">
                <label class="layui-form-label" style="width: 120px;">首页轮播图:</label>
                <div class="layui-upload">
                    <button type="button" class="layui-btn test2">多图片上传</button>
                    <#--<blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
                        预览图：
                        <div class="layui-upload-list" id="demo2"></div>
                    </blockquote>-->
                </div>
            </div>
            <div class="layui-inline" style="width: 1100px;">
                <label class="layui-form-label" style="width: 120px;">预览图:</label>
                <div class="layui-upload showImg" style="width:930px;margin-left: 200px;">

                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 1100px;">
                <label class="layui-form-label" style="width: 120px;">导航按钮:</label>
                <div class="layui-input-inline" style="width: 900px;">
                    <span style="color:red;"></span>
                    <p>
                        <input name="butname" style="width: 100px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="导航名称">
                        <input name="tzurl" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="跳转链接">
                        <input name="buturl" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="按钮图标">
                        <button type="button" class="layui-btn test1">
                            <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
                        </button>
                        <em class="mws_icon mws_ico_add" onclick="addElement(this,1);addpic(this)"></em>
                        <em class="mws_icon mws_ico_next" onclick="shiftDown(this);"></em>
                        <em class="mws_icon mws_ico_prev" onclick="shiftUp(this);"></em>
                        <em class="mws_icon mws_ico_delete" onclick="deleteParent(this);"></em>
                    </p>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 120px;">城市天气:</label>
                <div class="layui-input-inline">
                    <input name="cityName" lay-verify="required" autocomplete="off" class="layui-input" placeholder="城市名称">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 1100px;">
                <label class="layui-form-label" style="width: 120px;">热门专题:</label>
                <div class="layui-input-inline" style="width: 900px;">
                    <span style="color:red;">（图片尺寸建议：694像素*218像素）</span>
                    <p>
                        <input name="rmztTitle" style="width: 100px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="名称">
                        <input name="rmztUrl" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="链接">
                        <input name="rmztPicture" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="图片">
                        <button type="button" class="layui-btn test1">
                            <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
                        </button>
                        <em class="mws_icon mws_ico_add" onclick="addElement(this,1);addpic(this)"></em>
                        <em class="mws_icon mws_ico_next" onclick="shiftDown(this);"></em>
                        <em class="mws_icon mws_ico_prev" onclick="shiftUp(this);"></em>
                        <em class="mws_icon mws_ico_delete" onclick="deleteParent(this);"></em>
                    </p>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 1100px;">
                <label class="layui-form-label" style="width: 120px;">推荐景点:</label>
                <div class="layui-input-inline" style="width: 900px;">
                    <span style="color:red;">（图片尺寸建议：340像素*190像素）</span>
                    <p>
                        <input name="tjjdTitle" style="width: 100px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="景点名称">
                        <input name="tjjdUrl" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="链接">
                        <input name="tjjdPicture" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="图片">
                        <button type="button" lay-filter="button" class="layui-btn test1">
                            <i class="layui-icon">&#xe67c;</i>上传图片
                        </button>
                        <em class="mws_icon mws_ico_add" onclick="addElement(this,1);addpic(this)"></em>
                        <em class="mws_icon mws_ico_next" onclick="shiftDown(this);"></em>
                        <em class="mws_icon mws_ico_prev" onclick="shiftUp(this);"></em>
                        <em class="mws_icon mws_ico_delete" onclick="deleteParent(this);"></em>
                    </p>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 120px;">底部按钮:</label>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 1100px;">
                <label class="layui-form-label" style="width: 120px;">左边按钮:</label>
                <div class="layui-input-inline" style="width: 900px;">
                    <input name="zbTitle" style="width: 100px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="名称">
                    <input name="zbUrl" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="链接">
                    <input name="zbPicture" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="图片">
                    <button type="button" class="layui-btn test1">
                        <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
                    </button>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 1100px;">
                <label class="layui-form-label" style="width: 120px;">中间按钮:</label>
                <div class="layui-input-inline" style="width: 900px;">
                    <input name="zjTitle" style="width: 100px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="名称">
                    <input name="zjUrl" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="链接">
                    <input name="zjPicture" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="图片">
                    <button type="button" class="layui-btn test1">
                        <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
                    </button>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 1100px;">
                <label class="layui-form-label" style="width: 120px;">右边按钮:</label>
                <div class="layui-input-inline" style="width: 900px;">
                    <input name="ybTitle" style="width: 100px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="名称">
                    <input name="ybUrl" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="链接">
                    <input name="ybPicture" style="width: 190px;display: inline" lay-verify="required" autocomplete="off" class="layui-input" placeholder="图片">
                    <button type="button" class="layui-btn test1">
                        <i class="layui-icon mws_bg_box2">&#xe67c;</i>上传图片
                    </button>
                </div>
            </div>
        </div>
    </#if>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
<script type="text/javascript">
    function ico_choice(e){
        $('div[id="iconBag"]:gt(0)').remove();
        var ib = $('#iconBag');
        if(ib.attr('class')){
            ib.removeClass('show');
        }else{
            $(e).after(ib);
            ib.addClass('show');
        }
    }
    function icon_click(e){
        $(e).parent().removeClass('show');
        if($(e).attr("class") == "icon mic_nav_no"){
            $(e).parent().prev().removeClass().addClass("icon ico_choice nav_defaults");
        }else{
            $(e).parent().prev().removeClass().addClass($(e).attr("class"));
        }
        $(e).parent().prev().prev().val($(e).attr("title"));
    }
</script>
</body>
</html>