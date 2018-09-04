<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>添加</title>

<#include "/include/common_header_include.ftl">

</head>
<body>
<form class="layui-form" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <label class="layui-form-label">活动名称</label>
        <div class="layui-input-inline">
            <input name="name" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
    </div>
    <input type="hidden" name="state" value="true"/>
    <input type="hidden" name="subscribe" value="true"/>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label">参于次数</label>
            <div class="layui-input-inline" style="width: auto;">
                <input name="number" value="1" title="一人一次" checked="" type="radio">
                <input name="number" value="2" title="一天一次" type="radio">
                <input name="number" value="3" title="一天两次" type="radio">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label">分享</label>
            <div class="layui-input-inline" style="width: auto;">
                <input name="share" value="0" title="不增加" checked="" type="radio">
                <input name="share" value="1" title="永久一次" type="radio">
                <input name="share" value="2" title="每天一次" type="radio">
            </div>
            <div class="layui-form-mid">增加机会</div>
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label">奖品名称</label>
        <div class="layui-input-inline" style="width: 150px;">
            <input name="prizeName" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label" style="width: 40px;">库存</label>
        <div class="layui-input-inline" style="width: 60px;">
            <input name="prizeAmount" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <input type="hidden" name="prizeWeight" value="1"/>
        <input type="checkbox" name="win_1" value="1" lay-skin="switch" lay-text="奖品|鼓励" checked>
        <label class="layui-form-label">选择奖品</label>
        <div class="layui-input-inline" style="width: 300px;">
            <input id="productName_1" name="productName" style="display: inline;width: 190px;" class="layui-input" readonly>
            <input type="hidden" id="productId_1" name="product"/>
            <input type="button" class="layui-btn" onclick="selectProduct(1);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品名称</label>
        <div class="layui-input-inline" style="width: 150px;">
            <input name="prizeName" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label" style="width: 40px;">库存</label>
        <div class="layui-input-inline" style="width: 60px;">
            <input name="prizeAmount" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <input type="hidden" name="prizeWeight" value="2"/>
        <input type="checkbox" name="win_2" value="2" lay-skin="switch" lay-text="奖品|鼓励" checked>
        <label class="layui-form-label">选择奖品</label>
        <div class="layui-input-inline" style="width: 300px;">
            <input id="productName_2" name="productName" style="display: inline;width: 190px;" class="layui-input" readonly>
            <input type="hidden" id="productId_2" name="product"/>
            <input type="button" class="layui-btn" onclick="selectProduct(2);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品名称</label>
        <div class="layui-input-inline" style="width: 150px;">
            <input name="prizeName" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label" style="width: 40px;">库存</label>
        <div class="layui-input-inline" style="width: 60px;">
            <input name="prizeAmount" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <input type="hidden" name="prizeWeight" value="3"/>
        <input type="checkbox" name="win_3" value="3" lay-skin="switch" lay-text="奖品|鼓励" checked>
        <label class="layui-form-label">选择奖品</label>
        <div class="layui-input-inline" style="width: 300px;">
            <input id="productName_3" name="productName" style="display: inline;width: 190px;" class="layui-input" readonly>
            <input type="hidden" id="productId_3" name="product"/>
            <input type="button" class="layui-btn" onclick="selectProduct(3);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品名称</label>
        <div class="layui-input-inline" style="width: 150px;">
            <input name="prizeName" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label" style="width: 40px;">库存</label>
        <div class="layui-input-inline" style="width: 60px;">
            <input name="prizeAmount" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <input type="hidden" name="prizeWeight" value="4"/>
        <input type="checkbox" name="win_4" value="4" lay-skin="switch" lay-text="奖品|鼓励" checked>
        <label class="layui-form-label">选择奖品</label>
        <div class="layui-input-inline" style="width: 300px;">
            <input id="productName_4" name="productName" style="display: inline;width: 190px;" class="layui-input" readonly>
            <input type="hidden" id="productId_4" name="product"/>
            <input type="button" class="layui-btn" onclick="selectProduct(4);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品名称</label>
        <div class="layui-input-inline" style="width: 150px;">
            <input name="prizeName" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label" style="width: 40px;">库存</label>
        <div class="layui-input-inline" style="width: 60px;">
            <input name="prizeAmount" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <input type="hidden" name="prizeWeight" value="5"/>
        <input type="checkbox" name="win_5" value="5" lay-skin="switch" lay-text="奖品|鼓励" checked>
        <label class="layui-form-label">选择奖品</label>
        <div class="layui-input-inline" style="width: 300px;">
            <input id="productName_5" name="productName" style="display: inline;width: 190px;" class="layui-input" readonly>
            <input type="hidden" id="productId_5" name="product"/>
            <input type="button" class="layui-btn" onclick="selectProduct(5);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品名称</label>
        <div class="layui-input-inline" style="width: 150px;">
            <input name="prizeName" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label" style="width: 40px;">库存</label>
        <div class="layui-input-inline" style="width: 60px;">
            <input name="prizeAmount" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <input type="hidden" name="prizeWeight" value="6"/>
        <input type="checkbox" name="win_6" value="6" lay-skin="switch" lay-text="奖品|鼓励">
        <label class="layui-form-label">选择奖品</label>
        <div class="layui-input-inline" style="width: 300px;">
            <input id="productName_6" name="productName" style="display: inline;width: 190px;" class="layui-input" readonly>
            <input type="hidden" id="productId_6" name="product"/>
            <input type="button" class="layui-btn" onclick="selectProduct(6);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品名称</label>
        <div class="layui-input-inline" style="width: 150px;">
            <input name="prizeName" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label" style="width: 40px;">库存</label>
        <div class="layui-input-inline" style="width: 60px;">
            <input name="prizeAmount" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <input type="hidden" name="prizeWeight" value="7"/>
        <input type="checkbox" name="win_7" value="7" lay-skin="switch" lay-text="奖品|鼓励">
        <label class="layui-form-label">选择奖品</label>
        <div class="layui-input-inline" style="width: 300px;">
            <input id="productName_7" name="productName" style="display: inline;width: 190px;" class="layui-input" readonly>
            <input type="hidden" id="productId_7" name="product"/>
            <input type="button" class="layui-btn" onclick="selectProduct(7);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品名称</label>
        <div class="layui-input-inline" style="width: 150px;">
            <input name="prizeName" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label" style="width: 40px;">库存</label>
        <div class="layui-input-inline" style="width: 60px;">
            <input name="prizeAmount" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <input type="hidden" name="prizeWeight" value="8"/>
        <input type="checkbox" name="win_8" value="8" lay-skin="switch" lay-text="奖品|鼓励">
        <label class="layui-form-label">选择奖品</label>
        <div class="layui-input-inline" style="width: 300px;">
            <input id="productName_8" name="productName" style="display: inline;width: 190px;" class="layui-input" readonly>
            <input type="hidden" id="productId_8" name="product"/>
            <input type="button" class="layui-btn" onclick="selectProduct(8);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品名称</label>
        <div class="layui-input-inline" style="width: 150px;">
            <input name="prizeName" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label" style="width: 40px;">库存</label>
        <div class="layui-input-inline" style="width: 60px;">
            <input name="prizeAmount" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <input type="hidden" name="prizeWeight" value="9"/>
        <input type="checkbox" name="win_9" value="9" lay-skin="switch" lay-text="奖品|鼓励">
        <label class="layui-form-label">选择奖品</label>
        <div class="layui-input-inline" style="width: 300px;">
            <input id="productName_9" name="productName" style="display: inline;width: 190px;" class="layui-input" readonly>
            <input type="hidden" id="productId_9" name="product"/>
            <input type="button" class="layui-btn" onclick="selectProduct(9);" value="选择优惠券">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">分享标题</label>
        <div class="layui-input-inline">
            <input name="title" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label">分享链接</label>
        <div class="layui-input-inline">
            <input name="link" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">分享描述</label>
        <div class="layui-input-inline">
            <input name="descval" autocomplete="off" class="layui-input">
        </div>
        <label class="layui-form-label">分享图标</label>
        <div class="layui-input-inline" style="width: 400px;">
            <input id="imgurl" name="imgurl" style="width: 190px;display: inline;" autocomplete="off" class="layui-input">
            <input id="uploadImage" type="button" style="margin-top: -3px;" class="layui-btn" value="上传图片">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">活动时间</label>
        <div class="layui-input-inline">
            <input id="beginDate" name="beginDate" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <div class="layui-form-mid">-</div>
        <div class="layui-input-inline">
            <input id="endDate" name="endDate" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品有效期</label>
        <div class="layui-input-inline">
            <input id="prizeBeginDate" name="prizeBeginDate" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
        <div class="layui-form-mid">-</div>
        <div class="layui-input-inline">
            <input id="prizeEndDate" name="prizeEndDate" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">使用说明</label>
        <div class="layui-input-block">
            <textarea id="demo"  style="display: none;"></textarea>
            <input id="content" name="content" type="hidden" value=""/>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
<script>
    var layedit;
    layui.use(['form', 'table', 'laydate','layedit','upload'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
        var upload = layui.upload;

        laydate.render({elem: "#beginDate"});
        laydate.render({elem: "#endDate"});
        laydate.render({elem: "#prizeBeginDate"});
        laydate.render({elem: "#prizeEndDate"});

        layedit = layui.layedit;
        layedit.set({
            uploadImage: {
                url: '${base}/file/upload?fileType=image&token='+getCookie("token") //接口url
                ,type: 'post' //默认post
            }
        });
        index = layedit.build('demo'); //建立编辑器
        form = layui.form;
        form.on('submit(submit)', function(data){
            $("#content").val(layedit.getContent(index));
            console.log(data.elem); //被执行事件的元素DOM对象，一般为button对象
            console.log(data.form); //被执行提交的form对象，一般在存在form标签时才会返回
            console.log(data.field); //当前容器的全部表单字段，名值对形式：{name: value}
            //return false;
        });
        upload.render({
            elem: '#uploadImage',
            url: '${base}/file/upload?fileType=image&token=' + getCookie("token"),
            done: function (res) {
                //如果上传失败
                if (res.code > 0) {
                    return layer.msg('上传失败');
                }
                //上传成功
                $("#imgurl").val(res.data);
            },
            error: function () {
                //请求异常回调
                alert("异常!!!");
            }
        });
    });
    function selectProduct(e){
        var index = layer.open({
            type: 2,
            title: '选择产品',
            area: ['60%', '80%'], //宽高
            fix: true, //固定
            content: 'couponlist?num='+e
        });
    }
</script>
</body>
</html>